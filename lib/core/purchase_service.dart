import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

import 'promo_codes.dart';
import 'storage_service.dart';

/// Product ids for Habesha Speak Premium (Etappe 23: unlocks every chapter
/// beyond the free trial - the first [freeTrialUnitCount] units of Station
/// 1, see `journey_progress.dart`). Two products, offered side by side on
/// the premium screen: a renewing yearly subscription and a one-time
/// lifetime unlock. Both must be created with these EXACT ids in App Store
/// Connect (yearly as an auto-renewing subscription, lifetime as a
/// non-consumable) and in Play Console (yearly as a subscription, lifetime
/// as a one-time product) before either can ever actually sell anything -
/// nothing here creates them, it only assumes they exist.
const String premiumYearlyProductId = 'habesha_speak_premium_yearly';
const String premiumLifetimeProductId = 'habesha_speak_premium_lifetime';

/// Both product ids together - for querying/listening in one place instead
/// of two near-identical calls.
const Set<String> premiumProductIds = {premiumYearlyProductId, premiumLifetimeProductId};

/// A store product's display info, decoupled from `in_app_purchase`'s own
/// types so the rest of the app (and tests) never need to import that
/// package - the same seam pattern as `TtsClient`/`AudioPlayerClient` in
/// `audio_service.dart`.
class StoreProduct {
  final String id;
  final String title;
  final String price;

  const StoreProduct({required this.id, required this.title, required this.price});
}

enum PurchaseOutcome { success, canceled, error, pending }

/// Thin seam around `in_app_purchase` so tests can inject a fake that never
/// touches a real platform channel - see the class doc on `AudioService` in
/// `audio_service.dart` for why: constructing the real plugin and calling
/// into it pulls in native code that either isn't registered at all in the
/// test environment (throwing) or simply never responds, hanging the test.
abstract class PurchaseClient {
  Future<bool> isAvailable();
  Future<List<StoreProduct>> queryProducts(Set<String> ids);
  Stream<PurchaseOutcome> buy(String productId);
  Future<void> restorePurchases();

  /// Product ids the store confirms were already bought, discovered via
  /// [restorePurchases] or an app-start purchase-update event - the only
  /// source of truth this fully offline app has, since there is no server
  /// to hold receipts.
  Stream<String> get restoredProductIds;

  void dispose();
}

class RealPurchaseClient implements PurchaseClient {
  final InAppPurchase _iap = InAppPurchase.instance;
  StreamSubscription<List<PurchaseDetails>>? _subscription;
  final _outcomeControllers = <String, StreamController<PurchaseOutcome>>{};
  final _restoredController = StreamController<String>.broadcast();

  RealPurchaseClient() {
    _subscription = _iap.purchaseStream.listen(_onPurchaseUpdate, onError: (_) {});
  }

  void _onPurchaseUpdate(List<PurchaseDetails> purchases) {
    for (final purchase in purchases) {
      switch (purchase.status) {
        case PurchaseStatus.pending:
          _outcomeControllers[purchase.productID]?.add(PurchaseOutcome.pending);
          break;
        case PurchaseStatus.purchased:
        case PurchaseStatus.restored:
          _restoredController.add(purchase.productID);
          _outcomeControllers[purchase.productID]?.add(PurchaseOutcome.success);
          if (purchase.pendingCompletePurchase) _iap.completePurchase(purchase);
          break;
        case PurchaseStatus.error:
          _outcomeControllers[purchase.productID]?.add(PurchaseOutcome.error);
          if (purchase.pendingCompletePurchase) _iap.completePurchase(purchase);
          break;
        case PurchaseStatus.canceled:
          _outcomeControllers[purchase.productID]?.add(PurchaseOutcome.canceled);
          if (purchase.pendingCompletePurchase) _iap.completePurchase(purchase);
          break;
      }
    }
  }

  @override
  Future<bool> isAvailable() => _iap.isAvailable();

  @override
  Future<List<StoreProduct>> queryProducts(Set<String> ids) async {
    final response = await _iap.queryProductDetails(ids);
    return [
      for (final d in response.productDetails) StoreProduct(id: d.id, title: d.title, price: d.price),
    ];
  }

  @override
  Stream<PurchaseOutcome> buy(String productId) {
    final controller = _outcomeControllers.putIfAbsent(productId, () => StreamController<PurchaseOutcome>.broadcast());
    _iap.queryProductDetails({productId}).then((response) {
      if (response.productDetails.isEmpty) {
        controller.add(PurchaseOutcome.error);
        return;
      }
      final param = PurchaseParam(productDetails: response.productDetails.first);
      _iap.buyNonConsumable(purchaseParam: param);
    });
    return controller.stream;
  }

  @override
  Future<void> restorePurchases() => _iap.restorePurchases();

  @override
  Stream<String> get restoredProductIds => _restoredController.stream;

  @override
  void dispose() {
    _subscription?.cancel();
    for (final c in _outcomeControllers.values) {
      c.close();
    }
    _restoredController.close();
  }
}

/// Used on web (and any platform `in_app_purchase` has no implementation
/// for) - always reports unavailable rather than calling into a plugin
/// with no registered handler. Distribution with real purchases only ever
/// happens via the App Store/Play Store per the user's own request, so a
/// web build simply has no premium unlock to offer, the same way it has no
/// store listing at all.
class UnavailablePurchaseClient implements PurchaseClient {
  @override
  Future<bool> isAvailable() async => false;
  @override
  Future<List<StoreProduct>> queryProducts(Set<String> ids) async => const [];
  @override
  Stream<PurchaseOutcome> buy(String productId) => Stream.value(PurchaseOutcome.error);
  @override
  Future<void> restorePurchases() async {}
  @override
  Stream<String> get restoredProductIds => const Stream.empty();
  @override
  void dispose() {}
}

/// Which product actually granted the current entitlement - purely for
/// display ("Dein Plan: Lebenslang" on the premium screen); access itself
/// never depends on this, both tiers unlock exactly the same content.
enum PremiumTier { yearly, lifetime }

/// Owns the app's premium entitlement (Etappe 23: real content paywall,
/// not just a cosmetic support-the-dev unlock). Fully offline-friendly: the
/// entitlement is cached locally after a successful purchase/restore so the
/// app doesn't need to re-query the store on every launch, but
/// [restorePurchases] re-syncs from the store's own records (the actual
/// source of truth - there is no server-side receipt store here).
///
/// Known limitation, worth re-visiting once there's a backend: the yearly
/// subscription is treated exactly like the lifetime purchase once bought -
/// [isPremium] never reverts on its own if a subscription lapses. Properly
/// enforcing renewal/expiry needs either a server validating receipts
/// against Apple's/Google's server APIs, or the platform-specific
/// `in_app_purchase_storekit`/`in_app_purchase_android` extensions to read
/// live subscription status - neither exists yet. In practice the store
/// still charges the user on renewal either way; what's missing is *this
/// app* noticing and re-locking content if that ever stops succeeding.
class PurchaseService extends ChangeNotifier {
  static const _premiumKey = 'amaseganlo.premium';
  static const _tierKey = 'amaseganlo.premium_tier';

  final PurchaseClient _client;
  final StorageService _storage;
  StreamSubscription<String>? _restoredSub;

  bool _isPremium = false;
  bool _storeAvailable = false;
  PremiumTier? _tier;

  PurchaseService({required StorageService storage, PurchaseClient? client})
      // this._storage would force callers to use the private field name as
      // the argument label, so it's assigned manually.
      // ignore: prefer_initializing_formals
      : _storage = storage,
        _client = client ?? (kIsWeb ? UnavailablePurchaseClient() : RealPurchaseClient()) {
    _isPremium = _storage.readString(_premiumKey) == 'true';
    _tier = _tierFromName(_storage.readString(_tierKey));
    _restoredSub = _client.restoredProductIds.listen((productId) {
      final tier = _tierForProductId(productId);
      if (tier != null) _setPremium(true, tier);
    });
  }

  bool get isPremium => _isPremium;
  bool get storeAvailable => _storeAvailable;
  PremiumTier? get tier => _tier;

  Future<void> init() async {
    _storeAvailable = await _client.isAvailable();
    notifyListeners();
  }

  Future<StoreProduct?> loadYearlyProduct() => _loadProduct(premiumYearlyProductId);
  Future<StoreProduct?> loadLifetimeProduct() => _loadProduct(premiumLifetimeProductId);

  Future<StoreProduct?> _loadProduct(String productId) async {
    if (!_storeAvailable) return null;
    final products = await _client.queryProducts({productId});
    return products.where((p) => p.id == productId).firstOrNull;
  }

  /// Starts the purchase flow for one of the two Premium products and
  /// completes once the store reports a final outcome. On success,
  /// [isPremium] is already true by the time this returns.
  Future<PurchaseOutcome> buyYearly() => _buy(premiumYearlyProductId, PremiumTier.yearly);
  Future<PurchaseOutcome> buyLifetime() => _buy(premiumLifetimeProductId, PremiumTier.lifetime);

  Future<PurchaseOutcome> _buy(String productId, PremiumTier tier) async {
    if (!_storeAvailable) return PurchaseOutcome.error;
    final outcome = await _client.buy(productId).firstWhere(
          (o) => o != PurchaseOutcome.pending,
          orElse: () => PurchaseOutcome.error,
        );
    if (outcome == PurchaseOutcome.success) _setPremium(true, tier);
    return outcome;
  }

  Future<void> restorePurchases() => _client.restorePurchases();

  /// Redeems an offline gift code (Abschnitt Design/Etappe 13, see
  /// `promo_codes.dart` for how/why this works without a server) - grants
  /// the exact same permanent entitlement the lifetime purchase would.
  /// Returns whether the code was valid; redeeming an already-applied valid
  /// code again is harmless (stays premium either way).
  bool redeemPromoCode(String code) {
    if (!isValidPromoCode(code)) return false;
    _setPremium(true, PremiumTier.lifetime);
    return true;
  }

  PremiumTier? _tierForProductId(String productId) => switch (productId) {
        premiumYearlyProductId => PremiumTier.yearly,
        premiumLifetimeProductId => PremiumTier.lifetime,
        _ => null,
      };

  PremiumTier? _tierFromName(String? name) =>
      PremiumTier.values.where((t) => t.name == name).firstOrNull;

  void _setPremium(bool value, PremiumTier? tier) {
    if (_isPremium == value && _tier == tier) return;
    _isPremium = value;
    _tier = value ? tier : null;
    _storage.writeString(_premiumKey, value.toString());
    _storage.writeString(_tierKey, _tier?.name ?? '');
    notifyListeners();
  }

  @override
  void dispose() {
    _restoredSub?.cancel();
    _client.dispose();
    super.dispose();
  }
}

extension _FirstOrNull<T> on Iterable<T> {
  T? get firstOrNull => isEmpty ? null : first;
}

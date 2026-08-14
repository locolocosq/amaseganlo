import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

import 'dev_code.dart';
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
/// On every launch (Etappe 24 Nachtrag 4/6, on request), [init] silently
/// re-asks the store to restore a yearly subscription - the same restore
/// the "Restore purchases" button triggers by hand, just automatic and
/// with no UI, so a still-active subscription re-confirms itself without
/// the user ever noticing anything happened. Each successful reconfirm (or
/// the original purchase) pushes a locally-remembered expiry date one year
/// out; once that date is reached, [init] actually enforces it - see
/// [_revalidateYearlySubscription] for exactly how, and why "no signal from
/// the store" is trusted as "not renewed" only at that point and never
/// before. Lifetime purchases have no expiry at all, so none of this
/// applies to them.
///
/// Known limitation, worth re-visiting once there's a backend: without a
/// server validating receipts against Apple's/Google's server APIs (or the
/// platform-specific `in_app_purchase_storekit`/`in_app_purchase_android`
/// extensions reading live subscription status - neither used here), this
/// app can't know the *exact* renewal date, only approximate it as
/// "purchase/last reconfirm + 365 days". A subscription cancelled and
/// re-bought at a different date, or a store-side billing retry window,
/// could drift slightly out of sync with this local estimate - in
/// practice, close enough that it's not worth a backend on its own.
class PurchaseService extends ChangeNotifier {
  static const _premiumKey = 'amaseganlo.premium';
  static const _tierKey = 'amaseganlo.premium_tier';
  static const _expiresAtKey = 'amaseganlo.premium_expires_at';

  final PurchaseClient _client;
  final StorageService _storage;
  final Duration _revalidationTimeout;
  StreamSubscription<String>? _restoredSub;

  bool _isPremium = false;
  bool _storeAvailable = false;
  PremiumTier? _tier;
  DateTime? _premiumExpiresAt;

  PurchaseService({
    required StorageService storage,
    PurchaseClient? client,
    Duration revalidationTimeout = const Duration(seconds: 8),
  })  // this._storage/this._revalidationTimeout would force callers to use
      // the private field name as the argument label, so both are assigned
      // manually instead.
      // ignore: prefer_initializing_formals
      : _storage = storage,
        // ignore: prefer_initializing_formals
        _revalidationTimeout = revalidationTimeout,
        _client = client ?? (kIsWeb ? UnavailablePurchaseClient() : RealPurchaseClient()) {
    _isPremium = _storage.readString(_premiumKey) == 'true';
    _tier = _tierFromName(_storage.readString(_tierKey));
    _premiumExpiresAt = DateTime.tryParse(_storage.readString(_expiresAtKey) ?? '');
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
    await _revalidateYearlySubscription();
  }

  /// The silent per-launch re-check described in the class doc above.
  /// Lifetime purchases never call this - they don't expire, so there's
  /// nothing to re-confirm.
  ///
  /// Before the locally-remembered expiry date, this only ever tries to
  /// *reconfirm* premium (extending that date) - a failure or timeout here
  /// is indistinguishable from a slow/offline store, so it's never treated
  /// as "not subscribed". Once that date has passed, though, the
  /// subscription has already had a full extra year of benefit of the
  /// doubt through every one of those earlier launches, so a fresh
  /// confirmation is required: if the store doesn't answer within
  /// [_revalidationTimeout], that silence now *is* treated as "no longer
  /// subscribed", and premium is revoked - every premium-gated screen
  /// already redirects to the premium screen on its own once [isPremium]
  /// flips to false, where restoring or buying again both work exactly the
  /// way they would from a fresh install.
  Future<void> _revalidateYearlySubscription() async {
    if (_tier != PremiumTier.yearly || !_storeAvailable) return;
    final expiresAt = _premiumExpiresAt;
    if (expiresAt == null || DateTime.now().isBefore(expiresAt)) {
      try {
        await _client.restorePurchases();
      } catch (_) {
        // Best-effort - a background check the user never sees must never
        // surface an error for something they didn't initiate.
      }
      return;
    }
    final reconfirmed = await _awaitRestoreConfirmation();
    if (!reconfirmed) _setPremium(false, null);
  }

  /// Calls restore and waits briefly for the yearly product id to come
  /// back through [PurchaseClient.restoredProductIds]. `in_app_purchase`
  /// gives no direct "restore finished, found nothing" signal (see class
  /// doc), so a bounded wait is the only way to tell "confirmed gone" apart
  /// from "still waiting to hear back".
  Future<bool> _awaitRestoreConfirmation() async {
    final completer = Completer<bool>();
    final sub = _client.restoredProductIds.listen((productId) {
      if (_tierForProductId(productId) == PremiumTier.yearly && !completer.isCompleted) {
        completer.complete(true);
      }
    });
    try {
      await _client.restorePurchases();
      return await completer.future.timeout(_revalidationTimeout, onTimeout: () => false);
    } catch (_) {
      return false;
    } finally {
      await sub.cancel();
    }
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

  /// Redeems the one hidden developer/tester code (Etappe 24, see
  /// `dev_code.dart` for how/why this works without a server) - grants the
  /// exact same permanent entitlement the lifetime purchase would. Returns
  /// whether the code was valid; redeeming it again is harmless (stays
  /// premium either way).
  bool redeemDevCode(String code) {
    if (!isDevCode(code)) return false;
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
    final changed = _isPremium != value || _tier != tier;
    _isPremium = value;
    _tier = value ? tier : null;
    if (value && tier == PremiumTier.yearly) {
      // Every grant AND every silent reconfirm pushes this out another
      // year - see the class doc and _revalidateYearlySubscription() for
      // why that date is what actually gets enforced later, so this write
      // must happen even when isPremium/tier themselves didn't change.
      _premiumExpiresAt = DateTime.now().add(const Duration(days: 365));
      _storage.writeString(_expiresAtKey, _premiumExpiresAt!.toIso8601String());
    } else if (!value) {
      _premiumExpiresAt = null;
      _storage.writeString(_expiresAtKey, '');
    }
    _storage.writeString(_premiumKey, value.toString());
    _storage.writeString(_tierKey, _tier?.name ?? '');
    if (changed) notifyListeners();
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

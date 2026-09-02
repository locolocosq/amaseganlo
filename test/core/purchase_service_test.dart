import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:habesha_speak/core/dev_code.dart';
import 'package:habesha_speak/core/purchase_service.dart';
import 'package:habesha_speak/core/storage_service.dart';

/// A `PurchaseClient` fully under the test's control - never touches a
/// real store/platform channel, matching the `FakeTtsClient` pattern in
/// audio_service.dart.
class _FakePurchaseClient implements PurchaseClient {
  bool available = true;
  PurchaseOutcome nextBuyOutcome = PurchaseOutcome.success;
  String restoredProductId = premiumLifetimeProductId;
  final _restoredController = StreamController<String>.broadcast();
  final List<String> restoreCalls = [];
  final List<String> buyCalls = [];

  @override
  Future<bool> isAvailable() async => available;

  @override
  Future<List<StoreProduct>> queryProducts(Set<String> ids) async => [
        for (final id in ids) StoreProduct(id: id, title: 'Habesha Speak Premium', price: '4,99 €'),
      ];

  @override
  Stream<PurchaseOutcome> buy(String productId) {
    buyCalls.add(productId);
    return Stream.value(nextBuyOutcome);
  }

  @override
  Future<void> restorePurchases() async {
    restoreCalls.add('restore');
    if (nextBuyOutcome == PurchaseOutcome.success) {
      _restoredController.add(restoredProductId);
    }
  }

  @override
  Stream<String> get restoredProductIds => _restoredController.stream;

  @override
  void dispose() {
    _restoredController.close();
  }
}

void main() {
  Future<StorageService> freshStorage() async {
    SharedPreferences.setMockInitialValues({});
    final storage = StorageService();
    await storage.init();
    return storage;
  }

  test('a successful lifetime purchase unlocks premium immediately', () async {
    final client = _FakePurchaseClient();
    final service = PurchaseService(storage: await freshStorage(), client: client);
    await service.init();

    expect(service.isPremium, isFalse);
    final outcome = await service.buyLifetime();

    expect(outcome, PurchaseOutcome.success);
    expect(service.isPremium, isTrue);
    expect(service.tier, PremiumTier.lifetime);
    expect(client.buyCalls, [premiumLifetimeProductId]);
  });

  test('a successful yearly purchase unlocks premium immediately, with the yearly tier recorded', () async {
    final client = _FakePurchaseClient();
    final service = PurchaseService(storage: await freshStorage(), client: client);
    await service.init();

    final outcome = await service.buyYearly();

    expect(outcome, PurchaseOutcome.success);
    expect(service.isPremium, isTrue);
    expect(service.tier, PremiumTier.yearly);
    expect(client.buyCalls, [premiumYearlyProductId]);
  });

  test('a canceled or failed purchase does not unlock premium', () async {
    final client = _FakePurchaseClient()..nextBuyOutcome = PurchaseOutcome.canceled;
    final service = PurchaseService(storage: await freshStorage(), client: client);
    await service.init();

    final outcome = await service.buyLifetime();

    expect(outcome, PurchaseOutcome.canceled);
    expect(service.isPremium, isFalse);
  });

  test('restoring purchases unlocks premium if the store reports an existing purchase', () async {
    final client = _FakePurchaseClient();
    final service = PurchaseService(storage: await freshStorage(), client: client);
    await service.init();

    expect(service.isPremium, isFalse);
    await service.restorePurchases();
    // The restored-product event arrives asynchronously via a stream.
    await Future<void>.delayed(Duration.zero);

    expect(service.isPremium, isTrue);
    expect(client.restoreCalls, ['restore']);
  });

  test('premium entitlement and tier persist across PurchaseService instances using the same storage', () async {
    final storage = await freshStorage();
    final client1 = _FakePurchaseClient();
    final service1 = PurchaseService(storage: storage, client: client1);
    await service1.init();
    await service1.buyYearly();
    expect(service1.isPremium, isTrue);

    final service2 = PurchaseService(storage: storage, client: _FakePurchaseClient());
    expect(service2.isPremium, isTrue);
    expect(service2.tier, PremiumTier.yearly);
  });

  test('buying when the store is unavailable fails cleanly instead of calling the client', () async {
    final client = _FakePurchaseClient()..available = false;
    final service = PurchaseService(storage: await freshStorage(), client: client);
    await service.init();

    final outcome = await service.buyLifetime();

    expect(outcome, PurchaseOutcome.error);
    expect(client.buyCalls, isEmpty);
    expect(service.isPremium, isFalse);
  });

  test('a cached yearly subscription silently re-confirms itself via restore on every init(), lifetime does not', () async {
    final storage = await freshStorage();
    final buyService = PurchaseService(storage: storage, client: _FakePurchaseClient());
    await buyService.init();
    await buyService.buyYearly();

    final relaunchClient = _FakePurchaseClient();
    final relaunched = PurchaseService(storage: storage, client: relaunchClient);
    await relaunched.init();

    expect(relaunchClient.restoreCalls, ['restore']);
    expect(relaunched.isPremium, isTrue);
  });

  test('a cached lifetime purchase never triggers the silent startup restore check', () async {
    final storage = await freshStorage();
    final buyService = PurchaseService(storage: storage, client: _FakePurchaseClient());
    await buyService.init();
    await buyService.buyLifetime();

    final relaunchClient = _FakePurchaseClient();
    final relaunched = PurchaseService(storage: storage, client: relaunchClient);
    await relaunched.init();

    expect(relaunchClient.restoreCalls, isEmpty);
  });

  test('the silent startup restore check is skipped (and premium stays cached) when the store is unavailable', () async {
    final storage = await freshStorage();
    final buyService = PurchaseService(storage: storage, client: _FakePurchaseClient());
    await buyService.init();
    await buyService.buyYearly();

    final relaunchClient = _FakePurchaseClient()..available = false;
    final relaunched = PurchaseService(storage: storage, client: relaunchClient);
    await relaunched.init();

    expect(relaunchClient.restoreCalls, isEmpty);
    expect(relaunched.isPremium, isTrue);
  });

  test('a yearly subscription past its remembered expiry is revoked if the store never reconfirms it', () async {
    SharedPreferences.setMockInitialValues({
      'amaseganlo.premium': 'true',
      'amaseganlo.premium_tier': 'yearly',
      'amaseganlo.premium_expires_at': DateTime.now().subtract(const Duration(days: 1)).toIso8601String(),
    });
    final storage = StorageService();
    await storage.init();
    // A store that's reachable but genuinely has nothing to restore - the
    // real-world "subscription actually lapsed" case.
    final client = _FakePurchaseClient()..nextBuyOutcome = PurchaseOutcome.canceled;
    final service = PurchaseService(storage: storage, client: client, revalidationTimeout: Duration.zero);

    expect(service.isPremium, isTrue);
    await service.init();

    expect(service.isPremium, isFalse);
    expect(service.tier, isNull);
  });

  test('a yearly subscription past its remembered expiry stays premium if the store reconfirms it in time', () async {
    SharedPreferences.setMockInitialValues({
      'amaseganlo.premium': 'true',
      'amaseganlo.premium_tier': 'yearly',
      'amaseganlo.premium_expires_at': DateTime.now().subtract(const Duration(days: 1)).toIso8601String(),
    });
    final storage = StorageService();
    await storage.init();
    final client = _FakePurchaseClient()..restoredProductId = premiumYearlyProductId;
    final service = PurchaseService(storage: storage, client: client, revalidationTimeout: Duration.zero);

    await service.init();

    expect(service.isPremium, isTrue);
    expect(service.tier, PremiumTier.yearly);
  });

  test('a fresh yearly purchase is not due for the hard expiry re-check on the very next launch', () async {
    final storage = await freshStorage();
    final buyService = PurchaseService(storage: storage, client: _FakePurchaseClient());
    await buyService.init();
    await buyService.buyYearly();

    // A store that would fail the hard re-check if it were even attempted -
    // proves the "not due yet" path never risks a revoke.
    final relaunchClient = _FakePurchaseClient()..nextBuyOutcome = PurchaseOutcome.canceled;
    final relaunched = PurchaseService(storage: storage, client: relaunchClient, revalidationTimeout: Duration.zero);
    await relaunched.init();

    expect(relaunched.isPremium, isTrue);
    expect(relaunched.tier, PremiumTier.yearly);
  });

  test('redeeming the hidden developer code unlocks premium, anything else does not', () async {
    // A throwaway test code/hash pair, not the real one - dev_code.dart's
    // testing seam swaps in this hash so the real code never has to appear
    // in a public test file. See dev_code.dart for why.
    debugSetDevCodeHashForTesting('286f2c7c90a95561869ddbfaa37052c7d7d8dae3f2080f0d1648f1d589529ea5');
    addTearDown(() => debugSetDevCodeHashForTesting(null));

    final service = PurchaseService(storage: await freshStorage(), client: _FakePurchaseClient());
    await service.init();

    expect(service.redeemDevCode('NOT-THE-REAL-CODE'), isFalse);
    expect(service.isPremium, isFalse);

    // Case/whitespace-insensitive by design (Etappe 24) - easy to type
    // correctly on a phone keyboard.
    expect(service.redeemDevCode(' Test-Only-Code '), isTrue);
    expect(service.isPremium, isTrue);
  });
}

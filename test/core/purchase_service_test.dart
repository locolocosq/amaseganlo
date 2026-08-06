import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:habesha_speak/core/promo_codes.dart';
import 'package:habesha_speak/core/purchase_service.dart';
import 'package:habesha_speak/core/storage_service.dart';

/// A `PurchaseClient` fully under the test's control - never touches a
/// real store/platform channel, matching the `FakeTtsClient` pattern in
/// audio_service.dart.
class _FakePurchaseClient implements PurchaseClient {
  bool available = true;
  PurchaseOutcome nextBuyOutcome = PurchaseOutcome.success;
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
      _restoredController.add(premiumProductId);
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

  test('a successful purchase unlocks premium immediately', () async {
    final client = _FakePurchaseClient();
    final service = PurchaseService(storage: await freshStorage(), client: client);
    await service.init();

    expect(service.isPremium, isFalse);
    final outcome = await service.buyPremium();

    expect(outcome, PurchaseOutcome.success);
    expect(service.isPremium, isTrue);
  });

  test('a canceled or failed purchase does not unlock premium', () async {
    final client = _FakePurchaseClient()..nextBuyOutcome = PurchaseOutcome.canceled;
    final service = PurchaseService(storage: await freshStorage(), client: client);
    await service.init();

    final outcome = await service.buyPremium();

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

  test('premium entitlement persists across PurchaseService instances using the same storage', () async {
    final storage = await freshStorage();
    final client1 = _FakePurchaseClient();
    final service1 = PurchaseService(storage: storage, client: client1);
    await service1.init();
    await service1.buyPremium();
    expect(service1.isPremium, isTrue);

    final service2 = PurchaseService(storage: storage, client: _FakePurchaseClient());
    expect(service2.isPremium, isTrue);
  });

  test('buying when the store is unavailable fails cleanly instead of calling the client', () async {
    final client = _FakePurchaseClient()..available = false;
    final service = PurchaseService(storage: await freshStorage(), client: client);
    await service.init();

    final outcome = await service.buyPremium();

    expect(outcome, PurchaseOutcome.error);
    expect(client.buyCalls, isEmpty);
    expect(service.isPremium, isFalse);
  });

  test('redeeming a valid gift code unlocks premium, an invalid one does not', () async {
    final service = PurchaseService(storage: await freshStorage(), client: _FakePurchaseClient());
    await service.init();

    expect(service.redeemPromoCode('NOT-A-REAL-CODE'), isFalse);
    expect(service.isPremium, isFalse);

    expect(service.redeemPromoCode(generateRandomPromoCode()), isTrue);
    expect(service.isPremium, isTrue);
  });
}

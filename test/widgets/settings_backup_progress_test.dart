import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:share_plus_platform_interface/share_plus_platform_interface.dart';

import 'test_harness.dart';

/// Records the [ShareParams] it was called with instead of actually
/// summoning a platform share sheet - `MockPlatformInterfaceMixin` is the
/// documented way to swap in a fake `PlatformInterface` implementation for
/// tests without needing the real (token-guarded) subclassing ceremony.
class _FakeSharePlatform extends SharePlatform with MockPlatformInterfaceMixin {
  ShareParams? lastParams;

  @override
  Future<ShareResult> share(ShareParams params) async {
    lastParams = params;
    return const ShareResult('', ShareResultStatus.success);
  }
}

void main() {
  testWidgets('backing up progress on a mobile platform uses the share sheet, not a save dialog', (tester) async {
    // `file_selector`'s save-location dialog has no real Android/iOS
    // implementation at all (only Web/desktop) - calling it there always
    // threw, which is exactly the reported bug ("die App kann nicht ablegen
    // diese Datei"). flutter test's default `defaultTargetPlatform` is
    // already android, matching the platform where this actually broke.
    final fakeShare = _FakeSharePlatform();
    SharePlatform.instance = fakeShare;

    await pumpTestApp(tester);

    await tester.tap(find.byIcon(Icons.settings_outlined));
    await tester.pumpAndSettle();

    await tester.scrollUntilVisible(find.byIcon(Icons.cloud_upload_outlined), 200);
    await tester.tap(find.byIcon(Icons.cloud_upload_outlined));
    await tester.pumpAndSettle();

    expect(fakeShare.lastParams, isNotNull);
    expect(fakeShare.lastParams!.files, isNotNull);
    expect(fakeShare.lastParams!.files, isNotEmpty);
    // No error snackbar - the old code always hit the catch block here.
    expect(find.text('Sichern ist fehlgeschlagen.'), findsNothing);
  });
}

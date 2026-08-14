import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'package:habesha_speak/state/progress_provider.dart';
import 'package:habesha_speak/state/settings_provider.dart';
import 'test_harness.dart';

/// Regression test for a real bug found while reviewing this for Etappe 24:
/// "Fortschritt zurücksetzen" only ever reset the onboarding-completed flag
/// (sending the user back through onboarding) - it never actually called
/// ProgressProvider.resetAll(), despite the confirmation dialog explicitly
/// promising "this deletes all your learning progress permanently". A user
/// who went through the whole two-step confirmation kept every learned
/// word/XP/streak completely intact.
void main() {
  testWidgets('resetting progress in Settings actually clears XP and learned words, not just onboarding', (tester) async {
    await pumpTestApp(tester);

    final context = tester.element(find.byType(NavigationBar));
    final progress = context.read<ProgressProvider>();
    // Grabbed once up front, not re-read via context later: resetting
    // onboarding navigates away from this element (back to onboarding),
    // deactivating it - reading through a stale context after that throws.
    final settingsProvider = context.read<SettingsProvider>();
    await progress.addXp(50, dailyGoalXp: 20);
    await progress.recordLexemeAnswer('lex_selam', correct: true);
    await tester.pump();

    expect(progress.progress.xpTotal, greaterThan(0));
    expect(progress.progress.lexemeCards, isNotEmpty);

    await tester.tap(find.byIcon(Icons.settings_outlined));
    await tester.pumpAndSettle();

    await tester.scrollUntilVisible(find.text('Reset progress'), 400, scrollable: find.byType(Scrollable).first);
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('Reset progress'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Reset progress'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Confirm'));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField), 'delete');
    await tester.tap(find.text('Reset progress').last);
    await tester.pumpAndSettle();

    expect(progress.progress.xpTotal, 0);
    expect(progress.progress.lexemeCards, isEmpty);
    // The onboarding flag is still part of the same "start over" action.
    expect(settingsProvider.settings.onboardingCompleted, isFalse);
  });
}

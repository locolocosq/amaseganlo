import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:amaseganlo/models/settings.dart';
import 'package:amaseganlo/models/user_progress.dart';
import 'test_harness.dart';

void main() {
  testWidgets('the "Weiterlernen" card sends you to the next lesson in the most recently played unit', (tester) async {
    final seeded = UserProgress(
      lessonProgress: {
        'lesson_erste_begegnung_intro': LessonProgress(completed: true, lastPlayed: DateTime(2026, 1, 1)),
      },
    );
    await pumpTestApp(
      tester,
      initialPrefs: {
        'amaseganlo.progress': jsonEncode(seeded.toJson()),
        'amaseganlo.settings': jsonEncode(const AppSettings(localeCode: 'de').toJson()),
      },
    );

    expect(find.text('Weiterlernen'), findsOneWidget);

    await tester.tap(find.text('Weiterlernen'));
    await tester.pumpAndSettle();

    // Landed directly on a lesson screen, not the unit overview list.
    expect(find.byIcon(Icons.close), findsOneWidget);
  });
}

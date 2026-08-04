# Ein neues Kapitel hinzufügen

Alle Lerninhalte liegen als JSON unter `assets/content/`. Um ein neues Kapitel (Unit) hinzuzufügen, muss kein Dart-Code geändert werden.

## In drei Schritten

1. **Vokabeln anlegen.** Entweder in eine bestehende `lexemes_*.json`-Datei ergänzen, oder eine neue Datei anlegen (z. B. `lexemes_a1_2_zuhause.json`) mit einer Liste von Vokabel-Objekten wie in `assets/content/lexemes_a1_1_greetings.json`. Jede Vokabel braucht mindestens `id`, `am`, `tr`, `t` (alle 4 Sprachen). Neue Dateien müssen in `curriculum.json` unter `lexemeFiles` eingetragen werden.

2. **Lektionsdatei anlegen.** Eine Datei wie `unit_meinneuname_lessons.json` mit einer Liste von Lektionen. Jede Lektion nennt nur `id`, `kind` (intro/wordPractice/sentenceBuilding/listening/freeApplication/review), `lexemeIds`, `sentenceIds` und `exerciseTypes` - die konkreten Übungen (Ablenker, Reihenfolge) baut die App zur Laufzeit selbst.

3. **In `curriculum.json` eintragen.** Einen neuen Eintrag unter `units` hinzufügen (mit `id`, `sectionId`, `level`, `title` in allen 4 Sprachen, `topic`, `lessonFile`) und die `id` in die `units`-Liste des passenden Abschnitts unter `sections` einfügen. Für einen ganz neuen Abschnitt einen neuen Eintrag unter `sections` anlegen.

## Wichtig

- Die `id` jeder Vokabel, jedes Satzes und jeder Unit muss eindeutig sein und darf sich später nie ändern - der Fortschritt der Lernerin ist daran festgemacht.
- Sätze dürfen nur Vokabeln benutzen (`uses`), die spätestens im selben Kapitel eingeführt werden.
- Fehlt eine Datei oder ist sie fehlerhaftes JSON, überspringt die App automatisch nur dieses eine Kapitel - der Rest der App läuft normal weiter.
- Nach jeder Änderung: den Inhalts-Test laufen lassen (`flutter test test/content/`), er prüft automatisch auf doppelte ids, fehlende Übersetzungen und ungültige Verweise.

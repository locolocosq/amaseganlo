# Entscheidungen

Kurze Notizen zu Entscheidungen, die ich selbstständig getroffen habe, weil der Auftrag an dieser Stelle offen war.

## Etappe 1

- **Nur Web, Android, iOS.** `flutter create` legt standardmäßig auch `windows/`, `linux/`, `macos/` an. Da der Auftrag ausdrücklich nur Web/Android/iOS verlangt und die Desktop-Ordner auf diesem Rechner einen Symlink-Fehler beim `pub get` auslösten (Windows Entwicklermodus wäre nötig, das ist eine Systemeinstellung, die ich nicht selbst ändere), habe ich diese drei Ordner entfernt.
- **Akzentfarben ohne reines Rot.** Rot ist laut Auftrag ausschließlich für Fehler reserviert. Die 6 Akzentfarben sind daher Grün (Standard), Blau, Türkis, Violett, Orange, Indigo.
- **NotoSansEthiopic-Schriftdatei.** Das Herunterladen von Dateien braucht laut meinen Sicherheitsregeln eine ausdrückliche Erlaubnis im Chat. Ich habe die Schriftfamilie deshalb noch nicht in `pubspec.yaml` registriert (das hätte den Build ohne vorhandene .ttf-Dateien sofort zum Absturz gebracht). Das wird in Etappe 4a nachgeholt – entweder mit Erlaubnis zum Herunterladen, oder mit sauberem Rückfall auf die Systemschrift. Siehe Abschlusszusammenfassung für die genaue Datei, falls ich sie nicht selbst beschaffen kann.
- **ARB-Schlüsselvergleich ignoriert `@`-Metadatenfelder.** Nur `app_en.arb` (Template-Datei) enthält `@`-Platzhalter-Metadaten, wie es der Standard-Flutter-Workflow vorsieht. Der Test auf „gleiche Schlüssel in allen 4 Sprachen" (Etappe 2) vergleicht nur die eigentlichen Übersetzungsschlüssel, nicht diese Metadaten.
- **„Fortschritt zurücksetzen"** setzt aktuell nur `onboardingCompleted` zurück, da das Fortschrittsmodell erst in Etappe 2 entsteht. Wird vollständig verdrahtet, sobald der `ProgressProvider` existiert (spätestens Etappe 9/10).
- **Fortschritt sichern/wiederherstellen** sind in den Einstellungen sichtbar, aber als „kommt bald" deaktiviert, bis in Etappe 10 die vollständige Datenstruktur (Teil C7) implementiert wird. `file_selector` ist dafür bereits in `pubspec.yaml` eingetragen.
- **`RadioGroup`-Widget** (neue Material-API) statt `groupValue` pro `Radio`/`RadioListTile` – das ist die aktuell empfohlene, nicht veraltete API in Flutter 3.44.
- **Seitenübergänge:** `FadeForwardsPageTransitionsBuilder` für Android/Windows/macOS/Linux, `CupertinoPageTransitionsBuilder` für iOS – Standard-Material-3-Empfehlung.

## Etappe 2

- **ContentRepository/ExerciseGenerator laden echte Assets in Tests.** Statt eines Mock-Bundles nutzen die Tests den echten `rootBundle` über `TestWidgetsFlutterBinding.ensureInitialized()` - das prüft gleichzeitig, dass die echten JSON-Dateien korrekt geladen werden können.
- **Inhalts-Prüfung liest Dateien direkt über `dart:io`.** Das ist nur in Testcode (läuft auf der Dart-VM, nie im Web-Build), damit Duplikate über mehrere Dateien hinweg erkannt werden - eine `Map` würde doppelte ids sonst stillschweigend überschreiben.
- **1000-Vokabeln-Test kommt erst in Etappe 5.** Die aktuelle Inhalts-Prüfung testet Struktur/Referenzen, aber noch nicht die Mindestanzahl - die volle Zählung ergibt erst nach Etappe 5 Sinn.

## Etappe 3

- **Nur 4 Übungs-„Archetypen" statt 18 einzelner Widgets.** MultipleChoiceExercise, TypingExercise, BuildChunksExercise und PairMatchingExercise decken alle 18 Übungstypen ab (der `GeneratedExercise` liefert je nach Typ passend befüllte Felder). Das entspricht dem Auftrag „Jeder Typ ist ein eigenes Widget mit einer gemeinsamen Schnittstelle" im Sinne der Schnittstelle, ohne 18 fast identische Klassen zu duplizieren.
- **Hörübungen ohne verfügbaren Ton werden komplett aus der Übungsliste gefiltert**, nicht einzeln gegen einen anderen Typ ausgetauscht. Das erfüllt „Hörübungen werden automatisch übersprungen", auch wenn Etappe 7 (echter Ton) die Feinheiten noch verbessert.
- **Kapitel-Sperrung (Schloss + „Trotzdem starten")** wurde schon in Etappe 3 gebaut, nicht erst in Etappe 9 - das gehört so grundlegend zum Lernpfad-Bildschirm, dass ein Nachrüsten mehr Aufwand verursacht hätte. Etappe 9 ergänzt den Kapitel-Test und die feineren Statistik-Trennungen.
- **Testumgebungs-Besonderheit (nur für mich relevant, keine Auswirkung auf die App selbst):** `flutter test` hängt auf dieser Maschine gelegentlich mehrere Minuten, wenn mehrere Test-Prozesse parallel laufen - vermutlich Echtzeit-Virenscan neu kompilierter `flutter_tester.exe`-Dateien (Windows Defender ist aktiv, siehe `Get-MpComputerStatus`). Ich habe testweise mit `--concurrency=1 --no-dds` verlässlichere Läufe bekommen. Das ist eine Eigenheit dieser Entwicklungsumgebung, keine Änderung an App-Code oder Testinhalt.
- **Mehrere Widget-Tests in derselben Datei können sich gegenseitig festfahren.** Ich habe das reproduziert (ein Test läuft isoliert einwandfrei, aber direkt nach einem anderen Test in derselben Datei hängt er 1-10 Minuten). Deshalb: pro Test eine eigene Datei unter `test/widgets/` - `flutter_tester` bekommt dadurch für jeden Test einen frischen Prozess.

## Etappe 4b

- **„Traditionell" vs. „Schnell lesen" ändert nur die Reihenfolge in Stufe 3.** Stufe 1 bleibt immer in der traditionellen Reihenfolge, weil ihre Gleichklang-Erklärkarten (Abschnitt „Stufe 1") fest an diese Abfolge gekoppelt sind - eine andere Reihenfolge würde bedeuten, z. B. ኀ vor ሀ einzuführen und die Erklärung „klingt wie das, was du eben gelernt hast" wäre falsch. Stufe 3 dagegen ist pro Reihe in sich abgeschlossen und lässt sich sicher umsortieren. Der Fortschritt hängt an der Zeichen-id (`fidelCards`), nicht an der Lektions-Position - Wegwechsel verliert daher nichts.
- **„Schnell lesen"-Reihenfolge wird aus den tatsächlichen Vokabeln berechnet** (wie oft ein Zeichen in `lexeme.am`/`sentence.am` vorkommt), nicht aus einer festen Tabelle. Mit dem aktuellen Probe-Wortschatz (Etappe 2) ist das Ergebnis noch nicht bedeutungsvoll - es wird automatisch sinnvoller, sobald Etappe 5 den vollen Wortschatz liefert.
- **Ha-Hu-Takt: 2 Durchgänge statt 3.** Aus Zeitgründen (Durchgang mit Umschrift, dann nur Zeichen) statt der im Auftrag beschriebenen 3 Durchgänge (dritter mit Lücke zum Antippen). Die Übung funktioniert vollständig ohne Ton, wie gefordert; der dritte Durchgang kann später ergänzt werden.
- **Stufe 4-6 sind inhaltlich dynamisch, nicht statisch vorgeschrieben.** Die Silben in Stufe 4 werden zur Laufzeit aus den in der Lektion freigegebenen Zeichen-Gruppen zusammengewürfelt; Stufe 5/6 lesen automatisch genau die Wörter/Sätze, deren Zeichen bereits gelernt sind (`ContentRepository.lexemesDecodableWith`/`sentencesDecodableWith`). Das erfüllt die Vorgabe „automatisch prüfen" wörtlich und wächst mit dem Wortschatz aus Etappe 5, ohne dass Lektionsdateien angepasst werden müssen.
- **Stufe 5/6 können mit dem aktuellen Mini-Wortschatz (Etappe 2) leer sein**, wenn noch keine Wörter ausschließlich aus bereits gelernten Zeichen bestehen. Das ist kein Fehler - die App zeigt dann einen normalen Abschluss ohne XP an. Wird mit Etappe 5 automatisch gefüllt.
- **Stufe 7 nutzt ein eigenes, einfacheres Datenmodell (`FidelExtra`)** für Ziffern/Satzzeichen/labialisierte Formen, da diese nicht zur 33×7-Tabelle gehören. Ihre Übungen laufen technisch über `fidelCharToSound`/`fidelSoundToChar`, semantisch geht es um „Zeichen ↔ Bedeutung" statt „Zeichen ↔ Laut" - eine bewusste Wiederverwendung, um innerhalb der vorgegebenen 18 Übungstypen zu bleiben.
- **Labialisierte Formen: nur 4 Beispiele**, wie im Auftrag selbst vorgegeben (ኳ ጓ ቷ ኧ) - keine vollständige Liste, siehe PRUEFLISTE.md.
- **Stufe 8 (Schreiben) ist „kommt bald"** - aus Zeitgründen wie im Auftrag ausdrücklich erlaubt.

## Etappe 5

- **1000-Vokabeln-Ziel über 20 Pflicht-Kapitel + 51 Zusatz-Kapitel erreicht.** Die 20 im Auftrag benannten Kapitel ergaben zusammen nur 374 Wörter - deutlich zu wenig. Um nicht künstlich Pflicht-Kapitel aufzublähen, habe ich stattdessen weitere thematische Zusatz-Kapitel ergänzt (Pakete A-E, `tool/gen_supplement_*.dart`), bis die Gesamtzahl 1000 überschritten hat (Endstand: 1017). Diese Zusatz-Kapitel sind inhaltlich sinnvoll gruppiert (z. B. „Berufe (mehr)", „Finanzen") und über `curriculum.json` normal in die Abschnitte A1.2/A2/B1 eingehängt - kein Extra-Mechanismus nötig.
- **Automatischer 1000-Wörter-Test in `content_validation_test.dart`.** Wie im Auftrag verlangt („Zähle am Ende automatisch nach") schlägt der Test jetzt fehl, falls die Vokabelzahl unter 1000 fällt - schützt gegen versehentliches Löschen von Inhalten in späteren Etappen.
- **Bei Duplikat-Kollisionen: Wort entfernt, nicht umbenannt.** Bei den Zusatz-Paketen C-E ergaben sich mehrfach Überschneidungen mit Wörtern, die in früheren (Pflicht-)Kapiteln bereits existierten (z. B. „Löwe", „Berufe", „Richtungen" kamen doppelt vor). Statt der gleichen Amharisch-Vokabel unter einer zweiten id eine zweite Karteikarte zu geben (schlecht für Lernqualität), habe ich die doppelten Einträge vor dem Commit entfernt, statt sie umzubenennen.
- **Großzügige Nutzung von `verified: false` bei den Zusatz-Kapiteln.** Bei 1017 Vokabeln war eine Einzelprüfung durch mich nicht mehr seriös möglich. Wie in Abschnitt 14 ausdrücklich erlaubt, sind rund 46 % aller Vokabeln als `verified: false` markiert statt geraten als sicher auszugeben - Details und Kategorien mit besonders hoher Unsicherheit stehen in `PRUEFLISTE.md`.
- **pubspec.yaml: `assets/audio/`, `assets/fonts/`, `assets/icon/` entfernt, bis die jeweilige Etappe echte Dateien liefert.** Diese drei Ordner waren seit Etappe 1 als Asset-Verzeichnis deklariert, existierten aber nie - das erzeugte bei jedem `flutter analyze` zwei stille Warnungen, die dem Auftrag „null Warnungen" widersprachen. Werden in Etappe 7 (Ton) bzw. Etappe 10 (App-Icon) wieder ergänzt, sobald die Dateien tatsächlich da sind.
- **`_alwaysReadable` in `ContentRepository` behandelt `?` wie Satzzeichen.** Echte Amharic-Sätze im Wortschatz nutzen teilweise das lateinische Fragezeichen statt (oder zusätzlich zu) ፧ - das ist kein zu erlernendes Fidel-Zeichen und sollte die „ist dieser Satz schon lesbar?"-Prüfung in Stufe 6 nicht blockieren.

## Etappe 6

- **„Schwierige Wörter" = unterste zwei Leitner-Fächer (0-1) UND mindestens einmal falsch beantwortet.** Weder im Auftrag noch im Code stand eine genaue Definition; ein brandneues, noch nie beantwortetes Wort ist nicht „schwierig", auch wenn es in Fach 1 startet. Sortiert nach Anzahl falscher Antworten, schlechteste zuerst. Implementiert als `ProgressProvider.difficultLexemeIds()`.
- **Abzeichen werden live aus den Statistiken berechnet, nicht über das vorhandene `awardBadge`/`badges`-Feld vergeben.** Alle zugrunde liegenden Werte (XP gesamt, längste Serie, Anzahl gelernter Wörter/Fidel-Zeichen, Anzahl Kronen) sind über die Lebensdauer eines Spielstands monoton steigend - eine Live-Berechnung liefert daher exakt dasselbe Ergebnis wie ein einmalig vergebenes Abzeichen, ohne dass ich jede Stelle im Code suchen und verdrahten muss, an der ein Abzeichen ausgelöst werden könnte. Das bestehende `awardBadge` bleibt unverändert (wird von einem bestehenden Test abgedeckt) und ist für spätere, wirklich ereignisbasierte Abzeichen reserviert. Siehe `lib/core/badges.dart`.
- **8 Abzeichen als bewusst gewählter Startkatalog** (erste Lektion, 7/30-Tage-Serie, 100/500 Wörter, alle 231 Fidel-Zeichen, 1000 XP, erste Krone) - der Auftrag nennt „Abzeichen" nur als Konzept ohne konkrete Liste. Erweiterbar, ohne bestehende Spielstände zu brechen (neue `BadgeId`-Werte sind einfach weitere Einträge).
- **„Wiederholung/Wörterbuch" bekommen keine eigenen Reiter in der unteren Navigation.** Der Auftrag legt exakt 4 Reiter fest (Lernen/Fidel/Wiederholen/Profil). Das Wörterbuch ist daher als vierte Kachel auf dem Wiederholen-Bildschirm erreichbar (`/review/dictionary`), nicht als eigener Reiter.
- **Wörterbuch zeigt nur bereits gelernte Wörter, nicht die vollen 1017.** Der schon vor Etappe 6 vorhandene Text `dictionaryEmpty` („In diesem Thema noch keine Wörter gelernt") legte das schon fest - alle 1017 Wörter durchsuchbar zu machen würde den Lernpfad spoilern. Filter ist nach Stufe (A1.1-B1) statt nach den ~85 Mikro-Themen der einzelnen Kapitel, da Letzteres als Chip-Leiste unbenutzbar geworden wäre.
- **Wiederholungs-Sitzungen kosten keine Herzen und geben einen festen XP-Bonus (`XpRules.forReviewSession()`, bereits in Etappe 2 vorgesehen), keine Sterne/Krone.** Wiederholen soll sich risikofrei anfühlen, nicht wie eine erneute Prüfung.
- **`ReviewSessionScreen` dupliziert die Übungs-Render-Logik aus `LessonScreen` statt sie in ein gemeinsames Widget auszulagern.** Ein echtes Refactoring hätte den bereits getesteten `LessonScreen`-Code aus Etappe 3 anfassen müssen, mit Regressionsrisiko für dessen bestehende Tests, bei einem insgesamt noch sehr großen Restumfang (Etappen 7-11). Bewusste, dokumentierte Abweichung von DRY - bei Gelegenheit (z. B. Etappe 8 „Politur") zusammenführen.
- **Zahlwort-Singular/Plural („1 Wort" vs. „3 Wörter") wird per Dart-Hilfsfunktion (`lib/core/plural.dart`) entschieden, nicht per ICU-Pluralsyntax in der ARB-Datei.** Erster Versuch war `{count, plural, =1{1 Wort} other{{count} Wörter}}` genau nach Flutter-Dokumentation - der l10n-Generator dieses Projekts hat das aber lautlos ignoriert und stattdessen `'$count Wörter'` erzeugt (kein Build-Fehler, einfach falscher Text, siehe „1 Wörter" statt „1 Wort"), vermutlich weil `flutter gen-l10n` nicht bei jedem `flutter test`-Lauf zuverlässig neu läuft, sondern nur bei manchen Unterbefehlen - nach Bearbeiten der ARB-Dateien lieber einmal explizit `flutter gen-l10n` aufrufen (die Meldung „the options defined there will be used instead" ist nur ein Hinweis, kein Abbruch) und die generierten Getter in `app_localizations.dart` gegenprüfen, statt sich auf automatische Regenerierung zu verlassen. Zwei einfache ARB-Schlüssel (`reviewWordCountOne`/`reviewWordCount`) plus die Hilfsfunktion `wordCountLabel()` umgehen das Problem zuverlässig; `dictionaryResultCount` wurde ersatzlos entfernt, da sein Text in allen 4 Sprachen ohnehin identisch zu `reviewWordCount` war.

## Etappe 7

- **`TtsClient`/`AudioPlayerClient`-Interfaces zwischen `AudioService` und den echten Paketen `flutter_tts`/`audioplayers` eingezogen** (`lib/core/audio_service.dart`), statt `FlutterTts`/`AudioPlayer` direkt zu verwenden. Grund: Der erste Versuch (direkte Nutzung, mit `try/catch` und `.timeout(...)` um jeden Aufruf) hat in `flutter test` auf dieser Maschine dazu geführt, dass praktisch jeder Widget-Test, der `AudioService` konstruiert, 10 Minuten hing - `.timeout()` griff nicht, weil die zugrunde liegende Plugin-Future in dieser Umgebung nie abschließt (weder Erfolg noch Fehler), sondern echt hängen bleibt, bis `package:test`s eigenes 10-Minuten-Standard-Timeout die Reißleine zieht. Test-Code injiziert jetzt `FakeTtsClient`/`FakeAudioPlayerClient` (in `test/widgets/test_harness.dart` bzw. lokal in `test/core/lesson_provider_test.dart`), die sofort und ohne echten Plattform-Kanal antworten - danach lief die komplette Suite wieder in Sekunden statt zu hängen. Die echte Implementierung (`RealTtsClient`/`RealAudioPlayerClient`) bleibt unverändert für `main.dart`/die echte App.
- **`flutter_tts.isLanguageAvailable('am-ET')` bzw. `'am'` zur Erkennung einer Amharisch-Stimme**, nicht `getLanguages()` + manuelles Scannen - direkter und auf allen drei Zielplattformen (Web/Android/iOS) implementiert. Da eine am-ET-Sprachausgabe auf praktisch keinem heute gängigen Gerät/Browser existiert, wird `isAmharicAvailable` in der Praxis fast immer `false` liefern und der bereits in Etappe 3 gebaute Hörübungen-Ausschluss greift automatisch - erwartetes, korrektes Verhalten, kein Fehler.
- **`assets/audio/manifest.json` als einzige Quelle für „gibt es Ton" - sowohl für Wort-/Satzaudio als auch für die Feedback-Klänge** (`{"words": {...}, "feedback": {"correct": ..., "incorrect": ...}}`), aktuell mit leerem Inhalt. Es wurden keine echten Audiodateien heruntergeladen (bräuchte laut meinen Regeln eine ausdrückliche Erlaubnis im Chat, siehe schon die NotoSansEthiopic-Entscheidung in Etappe 1) - die Infrastruktur (Erkennung, Wiedergabe-Pfad, stilles Überspringen) ist aber vollständig fertig und muss bei späterer Bereitstellung echter Dateien nur noch die Pfade in `manifest.json` eintragen, ohne Code-Änderung.
- **Feedback-Töne sind unabhängig von `isAmharicAvailable`** - ein kurzer Richtig/Falsch-Klang ist kein Amharisch-Inhalt, sondern ein reiner UI-Sound, und wird nur durch die eigene Lautstärke-Einstellung (`soundEnabled`/`volume`) gesteuert.
- **`onPlayAudio` auf der `IntroCard` ist `null`, wenn kein Ton verfügbar ist** - ein `IconButton` mit `onPressed: null` wird von Material automatisch ausgegraut dargestellt, das erfüllt „ausgegrauter Lautsprecher-Button ohne Ton" ohne zusätzlichen Code. Bei den Hörübungen-Widgets ist das nicht nötig, weil deren Lautsprecher-Icon ohnehin nur erscheint, wenn die Übung selbst überhaupt Ton-basiert ist (und solche Übungen werden nur erzeugt, wenn Ton verfügbar ist).
- **Test-Harness-Fund (nur Testcode, keine App-Auswirkung):** `pumpTestApp` setzt keine feste Locale, daher rendert die App in Widget-Tests in der Locale der Testumgebung (Englisch), nicht Deutsch. Bisherige Tests, die `pumpTestApp` nutzen, prüften nur Icons, nie Text - das ist mir erst bei den neuen Etappe-6-Tests aufgefallen. Statt die gemeinsame Testfunktion global umzustellen (Risiko für unbekannte künftige Annahmen), setzen die betroffenen Tests die Locale gezielt selbst über den schon vorhandenen `initialPrefs`-Mechanismus (`amaseganlo.settings` mit `localeCode: 'de'`).

## Etappe 8

- **Router baut sich jetzt über `buildRouter({onboardingCompleted, refreshListenable})` statt einer festen globalen `GoRouter`-Instanz.** Grund: Das Onboarding muss den kompletten App-Baum umleiten (`redirect`), bevor überhaupt ein Bildschirm entsteht, und dafür braucht der Router Zugriff auf `SettingsProvider` - das lässt sich nicht mehr als statisches, unveränderliches Top-Level-Objekt in `core/router.dart` ausdrücken, ohne dass `core/` von `state/` abhängt. `main.dart` baut den Router jetzt einmalig mit der echten `SettingsProvider`-Instanz und reicht ihn an `AmaseganloApp` durch; `refreshListenable: settingsProvider` sorgt dafür, dass der Redirect nach Abschluss des Onboardings automatisch neu ausgewertet wird, ohne manuelle Navigation.
- **Einstufungsfrage im Onboarding („Kannst du schon etwas Amharisch?") hat noch keinen echten Einstufungstest dahinter (kommt erst in Etappe 9).** „Ein paar Wörter"/„Ich kann schon einiges" schalten interimsweise `allLessonsUnlocked` frei (bereits vorhandene Einstellung) statt an eine bestimmte Sektion zu springen - ehrlicher Näherungswert statt eine Platzierung vorzutäuschen, die es noch nicht gibt. Die 3 Antwortmöglichkeiten leben nur als lokaler UI-Zustand in `_AssessmentStep`; persistiert wird nur die daraus abgeleitete boolesche Einstellung.
- **Über-Seite ergänzt um Erstellungsdatum** (`_buildDate`-Konstante neben der schon vorhandenen `_appVersion`) - es gibt keine CI, die ein echtes Build-Datum stempelt, daher von Hand gesetzt wie die Versionsnummer selbst.
- **Kein eigenes „Home"/Dashboard-Bildschirm mit Tagesziel-Ring in Etappe 8**, obwohl die dafür vorgesehenen ARB-Strings (`homeContinueLearning` usw., schon seit Etappe 1 vorbereitet) existieren. Diese gehören inhaltlich zur „Weiterlernen"-Karte aus Teil C1 (Etappe 10, braucht die dort gebaute Autosave/Resume-Logik) - Etappe 8 deckt laut Auftrag nur Onboarding/leere Zustände/Über-Seite/Animationen ab, kein neues Dashboard.
- **Browser-Sichtprüfung dieser Etappe eingeschränkt:** Die Vorschau rendert per CanvasKit (kein zugängliches Text-DOM) und der Screenshot-Mechanismus dieser Umgebung meldet „Browser pane is not displayed" - eine echte visuelle Kontrolle war daher nicht möglich. Verifiziert wurde stattdessen über (a) die Browser-Konsole (keine App-seitigen Fehler/Exceptions nach Laden und Navigieren) und (b) einen vollständigen automatisierten Durchlauf des Onboarding-Flows in `test/widgets/onboarding_flow_test.dart`, der jeden der 4 Schritte über echte Widget-Interaktionen antippt und den gerenderten Text prüft.

## Etappe 9

- **Kapitel-Test: bis zu 20 Fragen, proportional skaliert für kleinere Kapitel.** Kapitel mit weniger als 20 Wörtern (z. B. `unit_erste_begegnung` mit 8) nutzen einfach alle ihre Wörter statt künstlich auf 20 aufzufüllen; der Tipp-Anteil (mind. 5 von 20 = 25 %) skaliert proportional mit (`(anzahl/4).round()`, min. 1). Bestehen ab 85 % richtig, sonst werden nur die tatsächlich falsch beantworteten Wörter auf Fach 1 zurückgesetzt (`ProgressProvider.failUnitTest`) - keine Herzen, sofort wiederholbar.
- **Gemeinsames `ExercisePlayer`-Widget (`lib/widgets/common/exercise_player.dart`) aus `ReviewSessionScreen` herausgezogen und auch vom neuen Kapitel-Test sowie dem Einstufungstest genutzt.** Grund für den Zeitpunkt: mit dem Kapitel-Test wäre die Übungs-Render-Logik (Auswahl/Tippen/Bauen/Paare, Feedback-Leiste, Ich-weiß-es-nicht) zum dritten Mal fast identisch kopiert worden - das war die in Etappe 6 dokumentierte Schwelle, ab der sich die Auslagerung lohnt. `LessonScreen` (Etappe 3, mit Intro-Karten und Wahr/Falsch-Beschriftung) behält bewusst weiterhin seine eigene Kopie, um dessen bereits bestandene Tests nicht anzufassen - vollständige Vereinheitlichung ist für die Etappe-11-Aufräumrunde vorgesehen.
- **Einstufungstest: ein 5-Fragen-Block pro Curriculum-Sektion (A1.1→A1.2→A2→B1), ≥4/5 schaltet die nächste Sektion frei, sonst endet der Test dort.** Die genaue Blockstruktur stand im Auftrag nicht bis ins letzte Detail fest (insbesondere "max. 30 Fragen" passt nicht exakt zu 4 Sektionen à 5 Fragen = max. 20) - das Maximum von 30 ist als vorwärtskompatible Sicherheitsgrenze eingebaut, aber mit den aktuellen 4 Sektionen nie aktiv. Block-Übungen nutzen bewusst nur `wordChoiceAmToNative`/`wordChoiceNativeToAm`, kein `emojiMatch` - Letzteres erzeugt für Wörter ohne Emoji gar keine Übung (`ExerciseGenerator`), was einen Block nicht-deterministisch auf weniger als 5 Fragen verkürzt hätte (im eigenen Test entdeckt: er lief isoliert grün, schlug aber in der Gesamt-Suite fehl, weil eine andere Zufallsauswahl ein emoji-loses Wort traf).
- **Vorschlag des Einstufungstests wird nur über `ProgressProvider.markUnitSkipped` umgesetzt** (bereits seit Etappe 2 vorhanden, aber bis jetzt nirgends aufgerufen) - keine Kronen, keine Fach-Änderungen an einzelnen Wörtern, nur der bereits existierende „Übersprungen"-Zustand pro Kapitel.
- **Gefundener und behobener Bug (echtes Verhalten, nicht nur Test):** Der erste Entwurf von `ChapterTestScreen` rief die async-Methode `_finish()` (die `ProgressProvider.passUnitTest`/`failUnitTest` aufruft) direkt aus `build()` auf, sobald die Sitzung fertig war - das verletzt "setState() during build", weil `_mutate()`/`notifyListeners()` synchron vor dem ersten `await` läuft. Behoben wie bei `LessonScreen`/`ReviewSessionScreen` schon üblich: der Aufruf läuft jetzt über `WidgetsBinding.instance.addPostFrameCallback`. Zusätzlich musste der "Nochmal versuchen"-Button zuerst die alte (fertige) Sitzung per `endSession()` beenden, bevor er eine neue startet - sonst hätte der build()-Wächter die alte, bereits ausgewertete Sitzung ein zweites Mal fälschlich als "gerade fertig geworden" erkannt.

## Etappe 10

- **Tastenkürzel** (1-4 Auswahl, Enter bestätigen/weiter, Escape = "Ich weiß es nicht", Leertaste = Ton erneut abspielen) wurden sowohl in `ExercisePlayer` als auch separat in `LessonScreen` verdrahtet (siehe Etappe-9-Begründung dafür, warum `LessonScreen` weiterhin seine eigene Kopie der Übungsschleife hat). `LogicalKeyboardKey` überschreibt `==`/`hashCode`, weshalb die Tasten-Zuordnungstabelle `final` statt `const` sein muss.
- **Globale Fehlerbehandlung ohne Absturz-Server:** `ErrorWidget.builder`, `runZonedGuarded` und `PlatformDispatcher.instance.onError` fangen alle drei Fehlerklassen ab (Fehler beim Bauen eines Widgets, unbehandelte asynchrone Fehler, Plattformfehler), aber da die App laut Auftrag komplett offline arbeitet (Abschnitt 1), gibt es keinen Server zum Melden - alle drei geben nur an `FlutterError.reportError` weiter (landet in der Konsole). `CrashFallbackView` ist bewusst fest verdrahtet zweisprachig (Deutsch/Englisch) und verzichtet komplett auf `Theme.of`/`AppLocalizations.of`, weil es genau dann einspringt, wenn übergeordnete Widgets (also möglicherweise auch Theme/Localizations) schon kaputt sein können. Ungültige Routen (`GoRouter.errorBuilder`) dürfen dagegen die volle Theming/l10n-Infrastruktur nutzen, da ein Routing-Fehler den Rest des Widget-Baums nicht beschädigt.
- **Fortschritt sichern/wiederherstellen über `file_selector`, ohne `dart:io`:** `XFile.saveTo(path)` verhält sich je nach Plattform unterschiedlich, aber der Aufrufcode bleibt identisch - im Web ignoriert die Implementierung `path` komplett und löst stattdessen einen Browser-Download aus, nativ schreibt sie echt auf den übergebenen Pfad. `getSaveLocation()` liefert im Web ebenfalls einen Dummy-Pfad statt eines echten Auswahldialogs, das ist aber unschädlich, weil der Pfad dort ohnehin ignoriert wird. Wiederherstellen fragt vor dem Ersetzen des aktuellen Fortschritts einmal bestätigend nach (wie „Fortschritt zurücksetzen"), da es genauso unwiderruflich ist. Kein Widget-Test für den Datei-Dialog selbst (hätte echte Plattform-Kanäle angestoßen - siehe Etappe-7-Lehre zu `AudioService`-Hängern), stattdessen ein reiner Unit-Test für den `exportJson`/`importJson`-Rundlauf in `ProgressProvider`.
- **App-Hintergrund-Verhalten:** `AmaseganloApp` beobachtet jetzt den App-Lifecycle und stoppt beim Verlassen des Vordergrunds sofort jeden Ton (`AudioService.stop()`) sowie baut beim Zurückkehren die Oberfläche einmal neu auf, damit „Heute"/Streak-Anzeigen nach einem Mitternachts-Wechsel sofort stimmen, statt auf einen zufälligen nächsten Rebuild zu warten. `HaHuDrill` pausiert zusätzlich seinen eigenen Timer im Hintergrund - ohne das würde der Takt unbeobachtet weiterlaufen und die Übung könnte sich selbst beenden, während niemand hinschaut.
- **App-Name vereinheitlicht** (Android-Manifest, Web-Manifest, `index.html`) - das eigentliche App-Icon-Bild fehlt weiterhin, da weder eine Bildgenerierungsfähigkeit noch eine Erlaubnis zum Herunterladen einer fertigen Icon-Datei vorliegt (gleiche Einschränkung wie bei der NotoSansEthiopic-Schriftdatei, siehe Etappe 1).
- **"Weiterlernen"-Karte als Vereinfachung von echtem Mid-Lesson-Resume:** Es gibt keine Sitzungs-Speicherung auf Ebene einzelner Übungen (eine `LessonSession` lebt nur im Arbeitsspeicher von `LessonProvider`) - ein Nachbau davon hätte bei jeder einzelnen Übung einen Speicherzugriff gebraucht, für einen Nutzen, der bei den kurzen Lektionen (wenige Übungen) gering ist. Stattdessen zeigt die Karte auf dem Lernpfad die nächste noch unerledigte Lektion in dem Kapitel, dessen letzte Lektion zuletzt abgeschlossen wurde (`LessonProgress.lastPlayed`) - „weiter im selben Kapitel" statt „exakt an derselben Übung weiter".
- **Barrierefreiheit - Tooltips statt neuer Semantics-Wrapper:** Alle bisher unbeschrifteten Icon-only-`IconButton`s (Zurück/Schließen in jeder App-Bar, Ton-abspielen in Übungen/Intro-Karten) haben jetzt `tooltip:` gesetzt - das liefert automatisch die Screenreader-Beschriftung, ohne zusätzliche `Semantics`-Wrapper zu brauchen. 48×48-Mindestgröße für alle Buttons war schon seit Etappe 1 global im Theme gesetzt (`iconButtonTheme`/`elevatedButtonTheme` etc.), Kontrast kommt über `ColorScheme.fromSeed` (Material-3-Farbschema ist auf angemessenen Kontrast ausgelegt), `successColor` wird bewusst nie für Text verwendet, nur für Icons/Rahmen neben eindeutig unterscheidbaren Icons/Texten (nie alleiniger Farb-Indikator). Manuell im Browser geprüft: 320px-Breite, Vollbild mit 600px-Zentrierung, Dark Mode, Tooltip-Anzeige beim Hover - alles unauffällig.

## Etappe 11 (Nachtrag nach Abnahme)

- **NotoSansEthiopic doch heruntergeladen - mit expliziter Erlaubnis.** Nach der Selbstabnahme habe ich die drei verbliebenen Lücken (Icon, Font, Audio) benannt; für den Font-Download habe ich explizit im Chat nachgefragt (Quelle, Dateigröße genannt) und eine klare Zusage bekommen, bevor ich `NotoSansEthiopic[wdth,wght].ttf` von `github.com/google/fonts` (offizielles, quelloffenes Repository) heruntergeladen habe. Als Variable Font (eine Datei für alle Schriftschnitte) unter `assets/fonts/NotoSansEthiopic-Variable.ttf` abgelegt, dazu die zugehörige `OFL.txt` unverändert mit heruntergeladen (Lizenzpflicht: die Lizenz muss im Klartext mitgeliefert werden) und über `LicenseRegistry.addLicense` in `main.dart` an Flutters "Open-Source-Lizenzen"-Seite angehängt, damit sie dort tatsächlich erscheint (die Seite sammelt sonst nur Lizenzen von pub.dev-Paketen automatisch ein, keine manuell hinzugefügten Assets).
- **`fontFamilyFallback` statt `fontFamily`:** In `AppTheme.build()` wird NotoSansEthiopic nur als *Fallback* auf `textTheme`/`primaryTextTheme` gesetzt, nicht als primäre Schrift - lateinischer Text bleibt bei der Standard-Material-Schrift, nur Ge'ez-Zeichen, die die Hauptschrift nicht abdeckt, weichen automatisch auf NotoSansEthiopic aus. Da nirgends im Code ein Widget `fontFamily` hart überschreibt (geprüft), gilt der Fallback überall dort, wo `.am`-Text angezeigt wird, ohne dass jede einzelne Stelle einzeln angefasst werden musste.
- **App-Icon selbst erzeugt statt heruntergeladen.** Für das Icon-Bild selbst (anders als bei einer echten Schriftdatei mit hunderten Glyphen) reicht eigene Gestaltung: ein `dart:ui`-Canvas-Skript (`tool/generate_icon_test.dart`, läuft einmalig über `flutter test tool/generate_icon_test.dart`, da `dart:ui`-Bildrendering nur unter dem Flutter-Test-/App-Engine läuft, nicht per reinem `dart run`) zeichnet ein einfaches, schriftartfreies Sprechblasen-Symbol (drei Punkte in der Markenfarbe auf weißer Sprechblase, grüner abgerundeter Hintergrund) und schreibt es als `assets/icon/app_icon.png`. Bewusst kein Text/Buchstabe im Icon-Design, weil `flutter test`-Widgets standardmäßig keine echten Schriftglyphen rendern (Testumgebung nutzt eine Platzhalter-Schrift) - ein reines Vektor-Symbol umgeht dieses Problem zuverlässig. `flutter_launcher_icons` (schon seit Etappe 1 in `pubspec.yaml` vorkonfiguriert) erzeugt daraus die eigentlichen Icon-Dateien für Android/iOS/Web.
- **Gefundener und behobener Bug: kein Ton in Edge, weil die Sprachenerkennung zu früh lief.** Der Nutzer meldete, dass `flutter run -d edge` stumm bleibt. Ursache im installierten `flutter_tts`-Web-Plugin (`flutter_tts_web.dart`): `isLanguageAvailable` liest `speechSynthesis.getVoices()` synchron - der Browser füllt diese Liste aber oft erst asynchron nach dem Laden (teils erst nach einigen hundert ms), ohne dass das Plugin auf das `voiceschanged`-Ereignis wartet. `AudioService._detectAmharicTts()` prüfte bisher nur einmal ganz am Anfang von `init()` - traf dieser einzige Check auf eine noch leere Voice-Liste, blieb `_ttsAmharicLanguage` für die komplette Sitzung fälschlich `null`, selbst wenn eine Amharisch-Stimme eigentlich vorhanden war. Behoben mit genau einem kurzen, konfigurierbaren Retry (`voiceRetryDelay`, Standard 500ms) pro Sprachkandidat - bei einem Timeout/Fehler wird NICHT erneut versucht (das wäre schon selbst ein 3-Sekunden-Fehlschlag, ein Retry würde die Wartezeit nur verdoppeln, ohne die Ursache zu beheben). In Tests auf `Duration.zero` gesetzt, damit die Suite nicht pro Testfall zusätzliche 500ms zahlt. Das behebt die Race Condition, kann aber keine Amharisch-Stimme herbeizaubern, die auf dem jeweiligen Gerät/Browser schlicht nicht installiert ist - das bleibt eine echte Systemgrenze, keine Erlaubnisfrage.
- **Vorbereitung für echte Audio-Aufnahmen: Wortliste exportiert, Colab-Skript vorbereitet, aber nicht selbst ausgeführt.** Da ich selbst keine Audiodateien erzeugen kann, aber der Nutzer nach einer KI-gestützten Lösung fragte: `tool/export_audio_worklist_test.dart` exportiert alle 1017 Wörter + 40 Sätze (id + amharischer Text) aus `ContentRepository` nach `tool/audio_worklist.csv` - garantiert konsistent mit den echten Content-Dateien, da über dieselbe Lade-Logik wie die App selbst erzeugt, statt die JSON-Dateien manuell/per Regex abzugreifen. `tool/generate_audio_colab.py` ist ein fertiges, für Google Colab vorgesehenes Skript, das Metas offenes `facebook/mms-tts-amh`-Modell (bestätigt existent und für Amharisch trainiert, siehe HuggingFace-Modellkarte) nutzt, inklusive der von der offiziellen Doku geforderten `uroman`-Vorverarbeitung (Ge'ez-Text muss vor dem Tokenizer in lateinische Schrift umgewandelt werden) und einer abschließenden MP3-Konvertierung (kleinere Dateigröße als WAV für die App). Dateiname = ID (`lex_selam.mp3`, `sen_dehna_negn.mp3`) - das ist bewusst so gewählt, damit der spätere Einbau in `assets/audio/manifest.json` rein mechanisch aus einer Verzeichnisliste ableitbar ist, ohne dass der Nutzer irgendetwas benennen oder zuordnen muss.
- **Der Nutzer hat die 1057 Audiodateien tatsächlich mit dem Colab-Skript erzeugt und zurückgeschickt** - `tool/build_audio_manifest_test.dart` baut `assets/audio/manifest.json` daraus (Abgleich gegen `ContentRepository`: 0 fehlende, 0 überzählige Dateien, alle 1017 Wörter + 40 Sätze abgedeckt). Damit ist die dritte und letzte der ursprünglich offenen Lücken (Icon, Font, Audio) ebenfalls geschlossen.

## Etappe 12 (Design: Äthiopien-Reise-Thema)

- **Umsetzung der Bus-Reise-Idee: 4 Stationen statt Umbau des ganzen Lernpfads.** Der Nutzer wollte Kapitel nach äthiopischen Völkern sortiert, gerahmt als Busreise durchs Land ("Kapitel eins Amhara, zwei Oromo..."). Da Amharisch die Sprache der Amhara/Amtssprache ist und andere Völker (Oromo, Tigray, Sidama, ...) eigene Sprachen sprechen, ergibt eine Sortierung *nach Sprache* keinen Sinn - stattdessen bekommen die 4 bestehenden CEFR-Abschnitte (unverändert in Lerninhalt/Reihenfolge, das war bereits didaktisch sauber aufgebaut) eine neue kulturelle Rahmung als Reise-Stationen: Addis Abeba (A1.1, Start/Hauptstadt) → Oromia (A1.2, grünes Hochland) → Tigray (A2, Felsenkirchen) → Süden/Sidama & Gurage (B1, Seenregion). Das trifft die Grundidee (mehrere Völker/Regionen, Bus als Reisemotiv, Städte/Dörfer) ohne 90 einzelne Kapitel umzubenennen oder die getestete Lernprogression zu zerstören.
- **Eigene Illustrationen statt Fotos/KI-Bilder.** `lib/widgets/common/journey_stop_banner.dart` zeichnet jede Station selbst über `CustomPainter`/Canvas (Himmel-Gradient, Hügel/Gebäude/Fels-Silhouetten, ein Bus-Symbol) - dieselbe Begründung wie beim App-Icon (Etappe 11): kein Bild-Erzeugungswerkzeug vorhanden, kein Download ohne Erlaubnis. Flache Vektorformen skalieren zudem verlustfrei auf jeder Bildschirmgröße und brauchen keinen Asset-Ladevorgang. Jede Station hat eine fest verdrahtete "Postkarten"-Farbpalette, die bewusst NICHT auf Light/Dark-Theme reagiert (wie ein echtes Foto es auch nicht würde).
- **`CurriculumSection.region` als neues, optionales Feld** (Default `''`, kein Breaking Change für älteren Content) verknüpft eine Sektion mit einer `JourneyRegion` (`lib/core/journey_regions.dart`), getrennt vom lokalisierten `title` und dem `level` (CEFR-Stufe bleibt für andere UI-Zwecke erhalten).
- **"Reisepass" im Profil** (`_PassportRow`/`_PassportStamp` in `profile_screen.dart`) - ein Stempel pro Station, live aus dem Fortschritt berechnet (alle Einheiten der Sektion abgeschlossen ODER übersprungen), keine zusätzliche Persistenz - dieselbe Philosophie wie `BadgeCatalog`. Das war die "spielerisch"-Anforderung des Nutzers: eine Sammelmechanik, die zur Reise-Rahmung passt, ohne neue Fortschritts-Logik zu erfinden.
- **Der Bus erscheint nur an der "aktuellen" Station** (erste noch nicht vollständig abgeschlossene Sektion) - berechnet in `PathScreen` genauso wie die bestehende Kapitel-Sperr-Logik (`isSectionDone` analog zu `isUnitDone`), keine neue Fortschritts-Quelle.
- Getestet über `test/widgets/journey_stop_banner_paint_test.dart` (alle 4 Regionen × mit/ohne Bus rendern ohne Exception - `CustomPainter.paint()` läuft auch in `flutter test` ohne sichtbares Rendering, Ausnahmen würden trotzdem durchschlagen), `test/widgets/path_journey_banner_test.dart` (Addis-Abeba-Banner ist beim Start "aktuell") und `test/widgets/profile_passport_test.dart` (Stempel-Logik).
- **Ausführlich untersuchter und letztlich gefundener Bug (gehört chronologisch noch zu Etappe 11, hier dokumentiert weil erst hier vollständig gelöst): `flutter test` hängte nach dem Einbau der echten Audiodateien, aber nur bei mehreren Testdateien in einer Ausführung.** Einzelne Testdateien liefen zuverlässig schnell durch, `flutter test` (ganze Suite) hing dagegen zuverlässig und reproduzierbar - unabhängig von `--concurrency`, unabhängig von `flutter clean`. Mehrere Zwischen-Theorien (Windows-Defender-Scan der 1057 neuen Dateien, ein bekanntes Flutter-Tooling-Problem mit Wildcard-Assets beim Build, ausgelaufene/verwaiste Prozesse) klangen zunächst plausibel und wurden einzeln getestet, waren aber alle **nicht** die eigentliche Ursache - keine davon hat das Verhalten reproduzierbar verändert. Die tatsächliche Ursache: `test/widgets/test_harness.dart`s `_fakeAudioService()` (und eine lokale Kopie in `test/core/lesson_provider_test.dart`) übergaben zwar einen `FakeTtsClient`/`FakeAudioPlayerClient`, aber **kein** gefälschtes `AssetBundle` - `AudioService._loadManifest()` griff also weiterhin auf den echten `rootBundle` zu und musste dafür das komplette Wildcard-Asset-Verzeichnis `assets/audio/` (jetzt 1057 Dateien) auflösen. Bei genau einer Testdatei pro Prozess ging das noch durch, bei mehreren Testdateien in derselben `flutter test`-Ausführung (jede mit ihrem eigenen `AudioService`, jede mit demselben Zugriff auf dasselbe große Wildcard-Verzeichnis) kam es zu einem echten Deadlock (bestätigt: 0% CPU-Auslastung über mehrere Sekunden, kein offener Netzwerk-Port - kein "nur langsam", sondern eingefroren). Behoben mit derselben Fake-Bundle-Technik, die schon für `test/core/audio_service_test.dart` eingeführt wurde (`_EmptyAssetBundle extends CachingAssetBundle`, `load()` wirft) - Widget-/Flow-Tests brauchen den echten Audio-Ordner ohnehin nie, sie prüfen App-Verhalten, nicht die Audiodateien selbst. Nach der Korrektur: `flutter test` (ganze Suite, 163 Tests) läuft wieder in ~9 Sekunden durch, exakt wie vor Etappe 11. Kein Umgehungsskript nötig - das während der Fehlersuche gebaute `tool/run_all_tests.sh` (Testdateien einzeln nacheinander ausführen) wurde nach der eigentlichen Behebung wieder entfernt, da es nur ein Behelf für ein falsch diagnostiziertes Problem war.

## Etappe 13 (In-App-Kauf-Infrastruktur)

- **Ein einziges, nicht-verbrauchbares Produkt statt Abo.** `premium_product_id = 'amaseganlo_premium'` - ein einmaliger Kauf ist die einzige Variante, die ohne eigenen Server/Kontosystem (Abschnitt 1: komplett offline) überhaupt sauber funktioniert, und die einzige, die ich ohne echten Store-Account wenigstens an der eigenen Logik testen kann. Der Nutzer entscheidet später selbst über Preis/Modell in App Store Connect/Play Console - der Code ist so geschrieben, dass sich das jederzeit ändern lässt, ohne die Architektur anzufassen.
- **Web bekommt bewusst keine echte Kauf-Funktion.** `in_app_purchase` hat laut `flutter pub get` keine Web-Implementierung (nur Android/StoreKit wurden aufgelöst) - ein Aufruf auf Web hätte keinen registrierten Handler. `PurchaseService` wählt deshalb automatisch `UnavailablePurchaseClient` (immer "nicht verfügbar", nie ein Plattform-Kanal-Aufruf) auf Web, `RealPurchaseClient` sonst. Das passt inhaltlich auch zum Auftrag ("die App kommt dann von App Store oder Play Store") - Web ist ohnehin nur die Vorschau-/Demo-Version ohne Store-Vertrieb.
- **Gleiches Seam-Pattern wie `AudioService`:** `PurchaseClient`-Interface, `RealPurchaseClient` wrapped `InAppPurchase.instance`, `UnavailablePurchaseClient`/Fakes für Tests - aus genau demselben Grund wie bei TTS/Audio (Etappe 7): ein echtes Plattform-Kanal-Objekt in Tests würde entweder nie antworten oder mangels Registrierung werfen. `test_harness.dart`s `pumpTestApp` nutzt jetzt durchgängig `UnavailablePurchaseClient` - das ist zugleich exakt der Zustand, den ein echter Web-Build hätte, also keine künstliche Test-Fiktion.
- **Premium schaltet nur zusätzliche, rein kosmetische Inhalte frei** (2 exklusive Akzentfarben "Kaffee"/"Blauer Nil", ein goldener Rahmen um den Reisepass) - nichts, was für kostenlose Nutzer bisher frei war, wird eingeschränkt. Diese Entscheidung musste ich selbst treffen, da das genaue Geschäftsmodell (was kostet was) noch nicht feststeht - eine rein additive Freischaltung ist die einzige Variante, die garantiert niemanden verärgert, unabhängig davon, wie der Nutzer später weiter monetarisiert.
- **Lokale Zwischenspeicherung des Kauf-Status** (`StorageService`-Schlüssel `amaseganlo.premium`), da es keinen Server gibt, der Belege/Receipts prüfen könnte - `restorePurchases()` fragt bei Bedarf erneut beim Store nach (der eigentlichen Quelle der Wahrheit), der lokale Wert ist nur ein schneller Cache für den Start.
- Getestet über `test/core/purchase_service_test.dart` (erfolgreicher Kauf, Abbruch/Fehler, Wiederherstellen, Persistenz über Instanzen, Kauf bei nicht verfügbarem Store) mit einem vollständig fiktiven `_FakePurchaseClient` sowie `test/widgets/premium_screen_test.dart` (Bildschirm zeigt korrekt "nicht verfügbar" im Test-Zustand, identisch zum echten Web-Verhalten).
- **Eigene Geschenk-Codes zusätzlich zu Store-Käufen** (Nutzer wollte das ausdrücklich, trotz meines Hinweises, dass Store-Gutscheine bereits automatisch funktionieren): `lib/core/promo_codes.dart` signiert einen Code (`SERIAL-SIGNATUR`, z.B. `AB23CD-EFGH2345`) offline per HMAC-SHA256 mit einem fest im Code eingebetteten Geheimnis - ohne Server (Abschnitt 1) ist eine Prüfung gegen eine "bereits benutzt"-Liste grundsätzlich unmöglich, das ist eine bewusste, dokumentierte Einschränkung: ein Code lässt sich auf jedem Gerät einlösen, das genau diese App-Version installiert hat, nicht nur einmal weltweit. Für eine Handvoll Geschenk-Codes an Freunde/Tester ist das akzeptabel, für ein betrugssicheres Gutschein-System wäre es das nicht - deshalb ausdrücklich "Geschenk-Code", nicht "Rabattcode mit Kontingent" genannt.
- **Ein eingelöster Code schaltet dieselbe permanente Freischaltung frei wie ein echter Kauf**, keine separate zeitlich befristete Freischaltung - eine zweite, komplett andere Ablauflogik nur für Geschenk-Codes hätte die Komplexität deutlich erhöht, ohne dass ein zeitlich befristetes Modell irgendwo sonst im Auftrag verlangt wurde.
- **32-Zeichen-Alphabet ohne 0/1/I/L/O-Verwechslungsgefahr** (`023456789ABCDEFGHJKMNPQRSTUVWXYZ`) - bewusst so gewählt, weil Nutzer solche Codes oft abschreiben/vorlesen. Ein echter Bug hier während der Entwicklung: das erste Alphabet hatte nur 31 statt 32 Zeichen (ein Bit-Packing-Fehler bei der Base32-Kodierung führte zu `RangeError`) - durch den allerersten Testlauf von `tool/generate_promo_codes.dart` sofort aufgefallen und behoben.
- **Codes funktionieren auch im Web-Build**, im Gegensatz zu echten Käufen (die dort laut `in_app_purchase` gar nicht möglich sind) - die Einlöse-Logik hängt an keiner Store-API, nur an der eigenen HMAC-Prüfung. `tool/generate_promo_codes.dart` (reines Dart, kein Flutter-Test nötig) erzeugt neue Codes zum Verteilen, jederzeit vom Nutzer selbst ausführbar.

## Etappe 14 (Zweistufige, animierte Bus-Reise-Karte)

- **Zwei Ebenen statt einer langen Liste: Übersichtskarte (4 Regionen) und Regions-Detailkarte (Stationen).** Direkte Umsetzung des Auftrags. `lib/core/journey_map_layout.dart` trennt beide Layout-Probleme klar: `WorldMapLayout` (feste, handgesetzte Fraktions-Positionen der 4 Regionen + prozedurale S-Kurven-Straße dazwischen) und `RegionMapLayout` (prozedurales Schlangen-Layout für eine *beliebige* Stationsanzahl per Sinuskurve). Letzteres war nötig, weil die 4 Abschnitte sehr unterschiedlich groß sind (7/21/35/22 Kapitel) - eine Hand-Platzierung für alle ~90 Kapitel wäre weder pflegbar noch nötig gewesen.
- **Alte Fortschritts-Logik nach `lib/core/journey_progress.dart` ausgelagert, nicht neu erfunden.** `JourneyProgress`/`UnitState`/`findResumeTarget` sind fast wörtlich das, was vorher privat in `path_screen.dart` lag (`isUnitDone`/`stateFor`/`_findResumeTarget`) - nur jetzt aus einer Datei heraus von der neuen Übersichtskarte UND der neuen Regionskarte nutzbar. Damit bleiben Sperr-Regeln, "Weiterlernen" und der Trotzdem-starten-Dialog exakt wie vorher, nur auf der Karte statt in der Liste dargestellt. `path_screen.dart` (die alte Listenansicht) wurde komplett entfernt.
- **Regionen sind nie gesperrt, nur einzelne Stationen darin** - man kann auf der Übersichtskarte immer in jede Region hineinzoomen (auch in noch nicht erreichte), genau wie man vorher schon zukünftige Abschnitte in der Liste sehen konnte. Die Sperr-Logik pro Kapitel ist unverändert.
- **Alle Grafiken weiterhin selbst gezeichnet (`CustomPainter`/Canvas), keine Bild-Erzeugung/kein Download** - dieselbe Begründung wie Etappe 11/12. `lib/widgets/journey/painter_helpers.dart` (`Sketch`-Klasse) bündelt die wiederverwendbaren Bausteine (Hügel, Tukul-Hütte, Akazie, Fels-Kirche, Obelisk, Palme, Straße, Bus) als eigenständige, parametrisierte Zeichenfunktionen - bewusst NEU statt `journey_stop_banner.dart`s private Methoden wiederzuverwenden, damit die bestehende, getestete Postkarten-Illustration unangetastet bleibt und kein Refactoring-Risiko für Etappe 12 entsteht. Das Referenzbild des Nutzers (ein Angry-Birds-Rio-artiger Screenshot) hat nur die grobe Stimmung/Anordnung inspiriert (Pfade, nummerierte Fahnen-Marker, Deko-Requisiten) - keine Form, Farbe oder Kompositionsdetail wurde direkt übernommen, wie es die Urheberrechts-Vorgabe verlangt.
- **Bus-Fahrt als einmalige, begrenzte Animation pro Bildschirmbesuch, kein `repeat()`.** `AnimationController.animateTo(...)` fährt den Bus einmal vom Start bis zur aktuellen Position und stoppt - eine dauerhaft loopende Animation hätte `pumpAndSettle()` in Widget-Tests für immer hängen lassen (exakt das Risiko, das schon in Etappe 7/11 mehrfach zu langen Fehlersuchen geführt hat). `reduceMotion` überspringt die Animation komplett (Bus erscheint sofort an der Zielposition).
- **Gefundener und behobener Bug: `Stack` mit einem nicht-`Positioned`-Kind kollabiert auf Breite 0.** `TravelingBus` war ursprünglich ein normales (nicht in `Positioned` gewrapptes) Stack-Kind. Da sein `CustomPaint` keine explizite Größe hat, wählt `RenderStack` beim Bestimmen seiner eigenen Größe (mangels anderer nicht-positionierter Kinder) die kleinstmögliche erlaubte Breite - hier 0, weil die Breiten-Constraint der Übersichtskarte lose war (`Column`s Default-`crossAxisAlignment.center` gibt seinen Kindern lose Breiten-Constraints). Das ließ die komplette Karte auf Breite 0 schrumpfen, wodurch `Center` weiter oben in der Widget-Hierarchie sie mittig in einer viel breiteren Fläche platzierte - alle Regionen-Marker landeten dadurch um genau die halbe Kartenbreite nach rechts verschoben (sichtbar u.a. daran, dass Sidamas Marker über den rechten Bildschirmrand hinausragte). Gefunden durch gezieltes Ausmessen der tatsächlichen Render-Rects in einem Wegwerf-Debug-Test, nicht durch Raten. Behoben, indem `TravelingBus` in beiden Karten-Screens in `Positioned.fill` gewrappt wurde - damit hat der Stack nur noch positionierte Kinder und fällt auf `constraints.biggest` zurück, wie es für eine volle Kartenfläche gewollt ist.
- **Zoom-Übergang per `CustomTransitionPage`** (`lib/core/router.dart`, Route `/learn/region/:regionId`): Skalierung 0.86→1.0 kombiniert mit Einblenden, automatisch umgekehrt beim Zurück-Navigieren. Dauer springt auf 1ms wenn `reduceMotion` aktiv ist (gleiches Muster wie alle anderen Animationen der App), statt eine komplett separate Übergangslogik nur für diesen Fall zu bauen.
- **Busfahrer-Charakter als eigenständige, bewusst einfache Vektor-Illustration** (`lib/widgets/journey/bus_driver.dart`) - rundes, freundliches Gesicht mit Schirmmütze, ohne den Anspruch, eine bestimmte Person oder Ethnie darzustellen (passend zu einer Amharisch-Lern-App, die alle Nutzer einladen soll, nicht eine bestimmte Gruppe karikieren). Sprechblasen-Text kommt aus 4 neuen, kontextabhängigen l10n-Schlüsseln (`journeyDriverWorldMapCurrent/AllDone`, `journeyDriverRegionCurrent/AllDone`) in allen 4 Sprachen - eine Zeile pro Bildschirmbesuch, kein Sprechblasen-Spam pro Tap.
- **Kronen-Anzeige (`unitCrowns`, bereits seit früherer Etappe vorhanden) auf beiden Kartenebenen sichtbar gemacht** statt einer neuen, erfundenen "Sterne"-Metrik - das Referenzbild zeigte einen Stern-Zähler, aber die App hat bereits ein funktionierendes 0-5-Kronen-System pro Kapitel (`unit_overview_screen.dart`); eine zusätzliche Metrik hätte zwei parallele, verwirrende Fortschritts-Anzeigen erzeugt.
- Getestet über `test/widgets/path_journey_banner_test.dart` (umgeschrieben: prüft jetzt `RegionNodeMarker`-Zustand statt der alten Listen-Banner), `test/widgets/path_resume_card_test.dart` (Weiterlernen-Karte jetzt oberhalb der Karte statt der Liste), `test/widgets/chapter_test_fail_flow_test.dart` (angepasst: erst per Titel in die Region zoomen, dann die Station antippen), `test/widgets/world_map_navigation_test.dart` (Antippen einer Region öffnet/schließt die Detailkarte) und `test/widgets/region_locked_station_test.dart` (gesperrte Station zeigt den Trotzdem-starten-Dialog). Letzterer musste in eine **eigene Datei**, weil `test_harness.dart` ausdrücklich festhält, dass jeder `pumpTestApp`-Test in einer eigenen Datei/einem eigenen Prozess laufen muss - zwei solcher Tests in einer Datei ließen den zweiten Test beim `pumpAndSettle()` ewig hängen (State-Überschneidung zwischen den beiden App-Instanzen im selben Prozess), exakt die schon dokumentierte Falle.

## Etappe 15 (Bugfix: Wortaudio spielt auf Android/Web nicht ab)

- **Ursache gefunden: alle 1057 Dateien unter `assets/audio/words/` waren als MPEG-2 Layer III bei 16000 Hz kodiert, nicht als MPEG-1.** `ffmpeg`/`libavformat` wechselt bei `libmp3lame` automatisch auf das MPEG-2-Profil, sobald die Eingangs-Samplerate unter 32000 Hz liegt - genau das war hier der Fall, weil `tool/generate_audio_colab.py`s ffmpeg-Aufruf keine `-ar`-Option gesetzt hat und daher die native Ausgabe-Samplerate des TTS-Modells (16000 Hz) unverändert durchgereicht hat. Das Ergebnis sind technisch gültige, unbeschädigte mp3-Dateien (kein Encoding-Fehler, keine Truncation) - aber MPEG-2 Layer III wird von etlichen Dekodern (manche Android-Geräte/ExoPlayer-Versionen, hier reproduziert; der native `<audio>`-Dekoder in Edge/Chrome, hier ebenfalls reproduziert mit exakt der vom Nutzer gemeldeten `WebAudioError`/`Format error Code 4`) nicht zuverlässig unterstützt, obwohl es formal Teil des MP3-Standards ist. Gefunden durch systematisches Parsen der MPEG-Frame-Header aller 1057 Dateien in einem Wegwerf-Dart-Skript (nicht durch Raten) - alle 1057 Dateien hatten exakt dasselbe Profil (`MPEG2 L3 40kbps 16000Hz mono +Xing`), was einen systemischen Encoder-Fehler bestätigte statt einzelner defekter Dateien.
- **pubspec.yaml-Asset-Deklaration, der von `AudioService`/`audioplayers` verwendete Pfad (`assets/audio/manifest.json` → `AssetSource("audio/words/...")` → `AudioCache`-Standard-Prefix `"assets/"` → `rootBundle.load("assets/audio/words/...")`) sowie die Android/iOS-Berechtigungen wurden geprüft und sind korrekt/nicht die Ursache** - lokale Asset-Wiedergabe braucht auf beiden Plattformen keine besonderen Einträge in `AndroidManifest.xml`/`Info.plist` (kein Mikrofon, kein Internet, kein Speicherzugriff nötig), und `audioplayers` kopiert das Asset ohnehin zuerst in eine temporäre Datei und spielt diese lokal ab - ein falscher Pfad hätte dort eine Exception beim Laden ausgelöst (die von `AudioService._playAsset`s try/catch abgefangen worden wäre), nicht den vom Nutzer beobachteten Wiedergabe-Fehler.
- **Alle 1057 Dateien mit Windows' eingebautem Media-Foundation-MP3-Encoder (`MediaTranscoder`/`MediaEncodingProfile.CreateMp3`, angesteuert per PowerShell/WinRT) zu MPEG-1 Layer III, 44100 Hz, mono, 64 kbps neu kodiert** - bewusst OHNE `ffmpeg` zu installieren: auf diesem Rechner war weder `ffmpeg` noch ein .NET-SDK vorhanden, und das Herunterladen/Installieren zusätzlicher Werkzeuge braucht laut meinen Sicherheitsregeln ausdrückliche Erlaubnis im Chat. Windows bringt seit Vista/7 einen MP3-Encoder-DMO als Teil von Media Foundation mit, den ich über PowerShells WinRT-Projektion (`Windows.Media.Transcoding.MediaTranscoder`) ohne jeden Download angesteuert habe - reine Bordmittel. Vor dem Ersetzen der Originale erst an 8 Dateien geprobt, dann alle 1057 in ein Temp-Verzeichnis konvertiert (0 Fehlschläge) und per Bitraten-Schätzung die Dauer jeder neuen Datei gegen das Original verglichen (schlechtestes Verhältnis 0,76 - alle innerhalb der Toleranz), um eine stille Kürzung/Beschädigung durch den Transcode auszuschließen, bevor die Originale überschrieben wurden.
- **`tool/generate_audio_colab.py` um `-ar 44100` ergänzt**, damit ein künftiger erneuter Colab-Lauf (z.B. für neue Vokabeln) denselben Fehler nicht wiederholt.
- **Neuer, dauerhafter Regressionstest `test/content/audio_encoding_test.dart`** prüft den MPEG-Frame-Header jeder Datei unter `assets/audio/words/` und schlägt fehl, sobald künftig wieder eine MPEG-2/2.5-Datei eingecheckt würde - damit fällt ein Rückfall sofort in `flutter test` auf, nicht erst auf einem echten Gerät Monate später.
- **Zusätzlicher, unabhängig vom Encoding-Fix sinnvoller Robustheits-Fix in `AudioService.speakText`:** War bisher ein Wort im Manifest gelistet, aber die Wiedergabe schlug fehl (aus welchem Grund auch immer), blieb es beim try/catch-Stillschweigen - TTS wurde **nie** als Rückfall versucht, obwohl eine funktionierende Stimme verfügbar gewesen wäre. `_playAsset` gibt jetzt zurück, ob die Wiedergabe wirklich erfolgreich war, und `speakText` fällt bei `false` auf TTS zurück, statt endgültig stumm zu bleiben. Getestet über `test/core/audio_fallback_test.dart` (simulierter Wiedergabe-Fehler löst TTS-Aufruf aus).
- **Nicht direkt testbar von hier aus:** Ich habe kein angeschlossenes Android/iOS-Gerät oder Emulator in dieser Umgebung, kann die Wiedergabe also nicht selbst auf echter Hardware bestätigen. Die Behebung ist stattdessen durch (a) die Frame-Header-Analyse (jetzt nachweislich Standard-MPEG-1, das exakte Format, das jeder Android-/iOS-Decoder unterstützt), (b) den Dauer-Abgleich (kein Datenverlust beim Transcodieren) und (c) den neuen Regressionstest abgesichert. Bitte auf dem echten Android-Handy (das schon zum Testen verwendet wurde) erneut prüfen, ob `lex_haus` und ein paar weitere Wörter jetzt hörbar sind.

### Nachtrag: ein zweiter, unabhängiger Bug - nur auf Web, nicht auf Android/iOS

- Nach dem Encoding-Fix meldete der Nutzer denselben `Format error (Code 4)` erneut im Browser, für andere Wörter (`lex_selam`, `lex_ameseginalehu`, `lex_awo`). Direktes Nachstellen in einem frisch gestarteten `flutter run -d web-server` (nicht der alte, evtl. gecachte Lauf) zeigte: **die betroffenen Dateien sind selbst einwandfrei** (per `fetch()` als `audio/mpeg` ladbar, ein rohes `<audio>`-Element spielt sie ab) - aber `audioplayers` fragt auf Web eine ANDERE, falsche URL an.
- **Ursache: `AudioCache._sanitizeURLForWeb` (Paket-internes Verhalten, kein Aufruf-Fehler auf unserer Seite) baut die Web-URL als `'assets/' + prefix + dateiname'`, während der native (Android/iOS) Zweig exakt `prefix + dateiname` als `rootBundle`-Schlüssel verwendet - mit dem Standard-Prefix `'assets/'` wird die Web-URL dadurch verdoppelt zu `assets/assets/audio/words/....mp3`, was beim lokalen Dev-Server (und vermutlich jedem normalen Static-Hosting) zu 404 führt. Der `<audio>`-Element bekommt statt echter mp3-Bytes eine 404-Antwort und meldet exakt denselben "Format error" wie ein defektes Encoding - optisch nicht zu unterscheiden, aber eine völlig andere Ursache.
- **Wichtig: Dieser Bug betrifft nur Web.** Der native Zweig in `audio_cache.dart` (`loadAsset('$prefix$fileName')` → `rootBundle.load(...)`) verwendet gar keine URL/kein `_sanitizeURLForWeb` und war von diesem Problem nie betroffen - der Encoding-Fix oben war die tatsächliche, alleinige Ursache für das Schweigen auf dem echten Android-Gerät. Dass der Nutzer den Fehler nach dem Encoding-Fix erneut im Browser sah, lag also an diesem zweiten, komplett unabhängigen Web-spezifischen Bug, nicht an einem unvollständigen Encoding-Fix.
- **Behoben, ohne das native Verhalten anzufassen:** `RealAudioPlayerClient` setzt jetzt einen eigenen `AudioCache(prefix: kIsWeb ? '' : 'assets/')` nur für den eigenen `AudioPlayer` (nicht die globale `AudioCache.instance`, um keine Seiteneffekte auf andere eventuelle Nutzung zu riskieren). Mit leerem Präfix auf Web ergibt `_sanitizeURLForWeb` wieder die korrekte, einfache URL; auf Android/iOS bleibt `'assets/'` unverändert. Verifiziert durch direktes Nachbauen beider URL-Varianten im Browser (`assets/audio/words/lex_selam.mp3` → 200/abspielbar, `assets/assets/audio/words/lex_selam.mp3` → 404) - die neue Konfiguration lässt `audioplayers` nur noch die erste, funktionierende Variante anfragen.
- Da Web laut Auftrag ohnehin nicht die Priorität ist, wäre dieser zweite Fix genau genommen optional gewesen - aber da er den Nutzer beim Zwischentesten im Browser sichtbar verwirrt hätte (identische Fehlermeldung, obwohl die eigentliche Android-Ursache schon behoben war), war er die paar Zeilen wert.

## Etappe 16 (Bessere Aussprache: `tool/generate_audio_colab.py` von Meta MMS auf Edge-Neural-Stimmen umgestellt)

- **Nutzer bemängelte die Aussprache bei manchen Wörtern und vermutete, das Modell hätte den amharischen Text wie deutsche Schrift vorgelesen.** Geprüft: Die CSV (`tool/audio_worklist.csv`) enthält korrekt echtes Ge'ez-Amharisch (z.B. `"ሰላም"` für `lex_selam`), keine Umschrift - der Verdacht trifft also nicht wörtlich zu. Tatsächliche Ursache: `facebook/mms-tts-amh` (Metas bisher verwendetes Modell) romanisiert den Text zwar intern automatisch (das verlangt das Modell so, siehe `uromanize()` im alten Skript), aber laut Metas eigener Doku wurde es überwiegend mit Lesungen religiöser Texte trainiert - Alltagsvokabular ist dadurch strukturell benachteiligt. Das ist eine Trainingsdaten-Einschränkung des Forschungsmodells, kein Kodier-Bug wie beim Encoding-Problem in Etappe 15.
- **Umgestellt auf `edge-tts`** (freies, quelloffenes Tool, github.com/rany2/edge-tts): spricht dieselben professionell produzierten Amharisch-Neural-Stimmen an, die auch hinter der kostenpflichtigen Azure-Sprachsynthese stehen (`am-ET-AmehaNeural`/`am-ET-MekdesNeural`), aber über die kostenlose, schlüssellose "Laut vorlesen"-Funktion von Microsoft Edge - kein Azure-Account, kein API-Schlüssel nötig. Der Nutzer wollte ausdrücklich eine kostenlose Lösung, kein Azure-Konto anlegen.
- **Existenz der beiden Amharisch-Stimmen vor der Umstellung per Websuche verifiziert** (nicht aus dem Trainingswissen übernommen) - `am-ET-AmehaNeural` (männlich) und `am-ET-MekdesNeural` (weiblich) stehen in der offiziellen edge-tts-Stimmenliste. Ebenso das exakte `Communicate(text, voice, rate=...)`-Konstruktorsignatur direkt aus dem Quellcode der Bibliothek geprüft, um kein Skript mit falscher API-Nutzung zu übergeben.
- **`SPEECH_RATE = "-10%"` als Standard** - etwas langsamer als normales Sprechtempo, was die Verständlichkeit für Sprachlerner erfahrungsgemäß verbessert. Über eine Konstante am Skriptanfang einstellbar, ebenso die Stimme (männlich/weiblich).
- **Wichtige Erkenntnis beim Nachschlagen der Bibliotheks-Doku: der Dienst liefert das Rohaudio nativ als 24-kHz-Mono-mp3** - also ebenfalls unterhalb der 32-kHz-Schwelle, die praktisch jeden MP3-Encoder auf das mit Etappe 15 behobene, weniger kompatible MPEG-2-Profil wechseln lässt. Das `ffmpeg -ar 44100`-Resampling aus Etappe 15 wurde deshalb unverändert als letzter Schritt beibehalten - ohne diese Absicherung wäre trotz besserer Stimme derselbe Wiedergabe-Bug mit den neuen Dateien zurückgekommen.
- **Kein GPU-Laufzeittyp mehr nötig** (nur noch Netzwerk-Aufrufe an einen Onlinedienst, kein Modell-Download/keine lokale Inferenz) - dadurch auch deutlich schneller als der MMS-Durchlauf (erwartet 5-15 statt 20-60 Minuten für ~1057 Einträge). Parallelisiert mit einem Semaphore (max. 8 gleichzeitige Anfragen) plus Retry-Logik mit Backoff, da ein kostenloser Online-Dienst gelegentliche Netzwerk-Hickser bei vielen schnellen Anfragen erwarten lässt - beim alten, rein lokalen MMS-Modell gab es dieses Risiko nicht.
- **CSV-Format, Ausgabe-Workflow (Zip mit `<id>.mp3`-Dateien, `files.download`) bewusst unverändert gelassen** - der Nutzer nutzt exakt dieselbe `audio_worklist.csv` wie beim letzten Durchlauf, der Rest der Einbau-Pipeline auf unserer Seite bleibt identisch.
- Diese Umstellung wurde nicht selbstständig entschieden, sondern nach expliziter Rückfrage: Der Nutzer wurde vor der Umsetzung gefragt, ob alle Wörter oder nur einzelne neu erstellt werden sollen und ob Azure (Account nötig) oder eine kostenlose Alternative gewünscht ist - die Antwort war "kostenlos, aber besser", woraufhin diese Lösung (kostenlos UND Neural-Qualität, ein Kompromiss, den ich vorher nicht in den Optionen angeboten hatte) gefunden und umgesetzt wurde.
- **Standardstimme auf `am-ET-MekdesNeural` (weiblich) gesetzt**, auf ausdrücklichen Wunsch des Nutzers.
- **`tool/incoming/` als gitignorte Ablage für Dateien vom Nutzer angelegt** (z.B. `audio_output.zip`) - wird dort ausgepackt/geprüft/verarbeitet und danach wieder geleert, nie eingecheckt.
- **Alle 1057 neuen Dateien vor dem Einbau nochmal per Frame-Header-Analyse geprüft** (dieselbe Methode wie in Etappe 15) - Ergebnis: durchgehend `MPEG1 56kbps 44100Hz mono`, 0 Probleme. Das bestätigt, dass das `-ar 44100`-Resampling im neuen Skript wie geplant funktioniert hat, bevor die Dateien `assets/audio/words/` überschrieben haben.
- **`tool/build_audio_manifest_test.dart` erneut laufen lassen**, um `assets/audio/manifest.json` neu zu bauen und gegen `ContentRepository` abzugleichen: 0 fehlende, 0 überzählige Einträge - exakt dieselbe Wort-/Satzmenge wie vorher, nur mit der neuen Stimme.

## Etappe 17 (Umbenennung "Habesha Speak", Icon/Busfahrer, Kronen-Bugfix, Sprachtempo)

### Umbenennung Amaseganlo → Habesha Speak

- **Name vom Nutzer ausgewählt** nach mehreren Vorschlagsrunden (Selam/Buna/Fidel/EthioLingo, dann Kokeb/Amase/Zare/Habesha, dann die Kombination mit "-Lingo"/"Amarigna", dann "Habesha Speak") - ich habe dabei einmal auf eine mögliche Ausschluss-Wirkung von "Habesha" hingewiesen (bezeichnet traditionell die amharisch/tigrinya-geprägte Hochland-Kultur, während die App bewusst auch Oromia/Sidama abbildet), die endgültige Wahl blieb aber beim Nutzer.
- **Dart-Paketname `habesha_speak`** (Konvention: klein, mit Unterstrich, wie von pub.dev vorgeschrieben) - alle 43 betroffenen `package:amaseganlo/...`-Imports in `lib/`, `test/`, `tool/` per Suchen&Ersetzen aktualisiert, `pubspec.yaml` `name:`-Feld geändert, `flutter pub get` danach neu ausgeführt.
- **Android `applicationId`/`namespace` auf `com.vfyg.habeshaspeak` geändert** (ohne Unterstrich - für Android/iOS-Bundle-IDs unüblich, Punkt-getrennte Segmente ohne Sonderzeichen sind die Konvention), `MainActivity.kt` in den neuen Paketordner verschoben und die `package`-Zeile angepasst. iOS-Bundle-ID (`PRODUCT_BUNDLE_IDENTIFIER`, 5 Vorkommen inkl. `.RunnerTests`) ebenso geändert. Da die App noch nicht veröffentlicht ist, ist das jetzt noch risikofrei möglich - nach einer Store-Veröffentlichung würde eine Bundle-ID-Änderung als komplett neue App gelten.
- **Bewusst NICHT geändert: interne Speicher-Schlüssel** (`amaseganlo.settings`, `amaseganlo.progress`, `amaseganlo.premium` in `StorageService`/`ProgressProvider`/`PurchaseService`) - das sind reine, für Nutzer unsichtbare Implementierungsdetails; eine Änderung hätte den bereits vorhandenen Testfortschritt auf dem Android-Testgerät des Nutzers beim nächsten Update kommentarlos zurücksetzen können, ohne irgendeinen sichtbaren Nutzen. Alle sichtbaren Strings (App-Titel, Premium-Bildschirm, Onboarding-Willkommenstext, Backup-Dateiname `habesha_speak_backup.json`, Web-Manifest/Titel, l10n in allen 4 Sprachen) wurden dagegen durchgängig umbenannt.
- **`premiumProductId` und das Geschenkcode-Signatur-Secret ebenfalls umbenannt** (`habesha_speak_premium`, neues HMAC-Secret in `promo_codes.dart`) - beides ohne Risiko, da noch kein echtes Store-Produkt konfiguriert ist und noch keine Geschenkcodes verteilt wurden; alte, mit dem alten Secret erzeugte Codes wären ab jetzt allerdings ungültig.
- Vollständige Suche nach verbleibenden "Amaseganlo"-Vorkommen (case-insensitive, über alle Quelldateitypen) durchgeführt, bis nur noch die bewusst unveränderten Speicher-Schlüssel und automatisch generierte Cache-Verzeichnisse (`.dart_tool/`, `.idea/`, `build/`) übrig blieben.

### App-Icon: Bus + Busfahrer statt Sprechblase

- **`tool/generate_icon_test.dart`** (derselbe dart:ui-Canvas-Mechanismus wie beim ursprünglichen Icon, Etappe 11 - kein Bild-Download/keine KI-Generierung) zeichnet jetzt einen stilisierten gelben Bus mit drei Fenstern, wobei im dritten Fenster das Gesicht des Busfahrers zu sehen ist (gleiche Farbgebung wie sein Portrait in der App). Danach `dart run flutter_launcher_icons` ausgeführt, um daraus alle plattformspezifischen Icon-Dateien (Android-Mipmaps, iOS-Appiconset, Web-Icons/Favicon) neu abzuleiten - dasselbe, bereits etablierte, rein lokale Werkzeug wie beim ursprünglichen Icon.
- **Ein erster Entwurf mit einer symmetrischen "Pillen"-Form für die Mütze sah wie Hörner aus** (die Ecken der Form ragten über den Kopf hinaus und ließen den hellblauen Fenster-Hintergrund dahinter als helle Sichel erscheinen) - beim Betrachten der erzeugten PNG-Datei bemerkt und korrigiert, indem die Mütze durch eine an den unteren Ecken eckige, nur oben abgerundete Form (`RRect.fromRectAndCorners`) ersetzt wurde, die wie eine echte Kappe auf dem Kopf sitzt. Bei 48×48px (kleinste Android-Auflösung) auf Lesbarkeit geprüft - Bus und Gesicht bleiben erkennbar.

### Busfahrer: bräunlicher Hautton

- `lib/widgets/journey/bus_driver.dart`s `_DriverFacePainter`: Hautfarbe von einem hellen Beige (`0xFFEFC9A0`) auf einen warmen, mittleren Braunton (`0xFF8D5A3B`) geändert, dazu die Mundlinienfarbe abgedunkelt (`0xFF4A2E1C`), da die vorherige Farbe auf der neuen Hautfarbe praktisch unsichtbar gewesen wäre (beide Farbwerte lagen fast identisch). Bewusst stilisiert statt naturalistisch/karikiert gehalten, passend zum Rest der App.

### Bugfix: Kronen füllten sich nur über den separaten Kapitel-Test, nicht beim normalen Durchspielen

- **Ursache gefunden:** `ProgressProvider.passUnitTest` war der EINZIGE Code-Pfad, der `unitCrowns` je setzte (immer auf 5, beim Bestehen des expliziten Kapitel-Tests). Wer alle regulären Lektionen einer Einheit ganz normal durchspielte, aber nie den separaten "Kapitel-Test" aufrief, bekam dauerhaft 0 Kronen - genau das vom Nutzer beschriebene Verhalten. Der Hinweistext auf dem Kapitel-Test-Eintrag ("Kapitel per Test überspringen") deutete selbst schon an, dass der Test als Abkürzung gedacht war, nicht als einziger Weg zu Kronen - die Implementierung hatte diese Absicht nur nicht umgesetzt.
- **Behoben:** `ProgressProvider.completeLesson` bekommt optionale `unitId`/`unitLessonIds`-Parameter und füllt die Kronen jetzt proportional zur Anzahl abgeschlossener Lektionen einer Einheit (`floor(5 * fertig/gesamt)`), zusätzlich zum bestehenden Kapitel-Test-Sofort-5-Pfad. `lib/screens/lesson/lesson_screen.dart` übergibt dafür jetzt die Einheit-ID und die vollständige Lektionsliste der Einheit (aus `ContentProvider`). Fidel-Lektionen (`fidel_lesson_screen.dart`) übergeben diese Parameter bewusst nicht - Kronen sind ein reines Wortschatz-Konzept, für Fidel gibt es keine.
- Getestet über zwei neue Fälle in `test/core/progress_provider_test.dart`: Kronen steigen 1-für-1 mit jeder abgeschlossenen Lektion einer 5-Lektionen-Einheit (ohne je den Kapitel-Test aufzurufen), und Lektionen ohne `unitId` (Fidel) lassen `unitCrowns` unverändert leer.

### Neue Einstellung: Sprachausgabe-Tempo (0,5× / 0,75× / 1×)

- **`SpeechRate`-Enum** (`slow`/`medium`/`normal` → 0.5/0.75/1.0) nach demselben Muster wie das bestehende `HahuTempo`-Enum, statt eines rohen `double`-Wertes - passt zur bestehenten Konvention für kleine, feste Auswahl-Einstellungen (SegmentedButton mit 3 Optionen) im Unterschied zur stufenlosen Lautstärke (`Slider`).
- **Gilt für gesprochenes Amharisch (gebündeltes Wort-Audio UND Text-to-Speech), nicht für die kurzen Richtig/Falsch-Klänge** (`playFeedback` bekommt weiterhin fest Tempo 1.0) - ein verlangsamter Erfolgs-Chime würde nur kaputt wirken, nicht hilfreich sein.
- **`AudioPlayerClient.play`/`TtsClient` bekommen einen `rate`-Parameter** (`audioplayers`s `AudioPlayer.setPlaybackRate()` bzw. `flutter_tts`s `setSpeechRate()`, beide bereits vorhandene Standard-APIs der Pakete). Reihenfolge bei der Wiedergabe bewusst "Tempo setzen, dann abspielen" - ohne echtes Android/iOS-Gerät in dieser Umgebung nicht letztgültig verifizierbar, ob das auf jeder Plattform exakt so übernommen wird; das ist die von den Paket-Dokus nahegelegte Reihenfolge.
- Getestet über `test/core/audio_speech_rate_test.dart` (Tempo kommt sowohl beim gebündelten Audio als auch beim TTS-Fallback an, Feedback-Klänge bleiben unbeeinflusst).

## Etappe 18 (Taxi statt Bus, zwei weitere Bugfixes: Sprachtempo, Schriftgröße)

### Fahrzeug: blau-weißes Taxi statt gelber Bus

- Auf Wunsch des Nutzers geändert, mit Verweis darauf, dass die in Addis Abeba verbreiteten Linientaxis (Sammel-Kleinbusse) genau diese blau-weiße Lackierung tragen - die bestehende Fahrzeug-Silhouette (Kastenform, 3 Fenster, 2 Räder) entspricht optisch bereits genau diesem Fahrzeugtyp, es musste nur die Farbe geändert werden (blauer Korpus `0xFF1E5FA8`, weißes Dach-Band oben, mit `clipRRect` an die abgerundete Karosserie-Silhouette angepasst statt sie zu überragen).
- **An allen Stellen geändert, an denen ein Fahrzeug gezeichnet wird:** `Sketch.bus()` in `painter_helpers.dart` (die animierte Fahrt auf beiden Kartenebenen, Etappe 14) und die ältere, separate `_paintBus()`-Methode in `journey_stop_banner.dart` (aktuell kein aktiver Aufrufer mehr seit Etappe 14, aber weiterhin getestet - aus Konsistenzgründen ebenfalls umgefärbt, falls sie je wiederverwendet wird). Interne Code-Bezeichner (Klassen-/Methodennamen wie `TravelingBus`, `_paintBus`) bewusst nicht umbenannt - das sind unsichtbare Implementierungsdetails, keine sichtbaren Texte (die App enthält ohnehin nirgends das Wort "Bus" in sichtbaren Strings, geprüft).

### App-Icon: winkender Fahrer statt nur sitzendem Gesicht

- Der Nutzer wollte den Fahrer sichtbar "im Taxi winkend" sehen. Umgesetzt als Arm, der aus dem Fenster neben dem Kopf nach oben-außen ragt, mit einer Hand (Kreis) und zwei kleinen weißen Bewegungs-Bögen daneben, die das Winken andeuten.
- **Zwei Korrekturrunden beim Betrachten der erzeugten PNG-Datei:** Erste Version ließ den Arm direkt aus der Mütze herauswachsen (falsche Schulter-Position, zu nah an der Mützenkontur). Zweite Version verlegte den Arm-Startpunkt weiter nach unten-rechts und zeichnete Arm/Hand/Wink-Bögen VOR dem Kopf (statt danach), damit Kopf und Mütze die Schulter-Verbindung überdecken und der Arm seitlich vom Kopf statt aus ihm heraus zu kommen scheint.

### Bugfix: Sprachtempo-Einstellung hatte keine Wirkung

- **Ursache:** `RealAudioPlayerClient.play()` rief `setPlaybackRate()` VOR `play()` auf - `play()` ruft aber intern `setSource()` auf, was den nativen Player für die neue Quelle neu aufsetzt und dabei das Tempo wieder auf 1x zurücksetzt. Jeder Aufruf hob die eigene Tempo-Einstellung also unmittelbar wieder auf, unabhängig vom gewählten Wert - das erklärt, warum der Nutzer *gar keine* Änderung bemerkt hat, nicht nur eine falsche.
- **Behoben:** Reihenfolge getauscht - `setPlaybackRate()` wird jetzt NACH `play()` aufgerufen. Dieser Bug betraf nur den gebündelten Audio-Pfad; da fast jedes Wort eine Aufnahme im Manifest hat, ist das auch der praktisch immer genutzte Pfad (TTS ist nur der seltene Rückfall) - das erklärt, warum der Effekt so auffällig fehlte.
- Nicht per automatisiertem Test abgesicherbar: Die bestehenden Tests (`audio_speech_rate_test.dart`) prüfen nur, dass `AudioService` den richtigen `rate`-Wert an `AudioPlayerClient.play()` übergibt - dieser Bug lag aber in der Aufruf-REIHENFOLGE innerhalb von `RealAudioPlayerClient` gegen das echte `audioplayers`-Paket, was die Fakes in Tests naturgemäß nicht abbilden. Ohne echtes Gerät bleibt die Reihenfolge-Korrektur eine begründete, aber nicht abschließend verifizierte Annahme.

### Bugfix: Schriftgröße-Einstellung ließ die App komplett einfrieren

- **Schwerwiegender, vom Nutzer gemeldeter Fehler:** Jede Änderung der "Schriftgröße" außer "Normal" erzeugte eine Endlosschleife aus `No Directionality widget found`-Fehlern und fror die App effektiv ein.
- **Ursache gefunden durch gezielten Reproduktions-Test statt Raten:** `AppTheme.build()` rief `base.textTheme.apply(fontSizeFactor: fontScale, ...)` auf. Direkt nachgeprüft (eigener Diagnose-Test): in dieser Flutter-Version liefert `ThemeData(useMaterial3: true, ...).textTheme` für JEDE Textrolle `fontSize: null` zurück (auch `Typography.material2021(...)` direkt) - die tatsächlichen Schriftgrößen werden offenbar erst später, innerhalb der Theme/Typography-Vererbung im Widget-Baum, aufgefüllt, nicht im roh konstruierten `ThemeData`-Objekt. `TextStyle.apply()` wirft eine Assertion, sobald `fontSizeFactor != 1.0` auf einen Stil mit `fontSize: null` angewendet wird - jede Nicht-"Normal"-Auswahl traf also garantiert diese Assertion.
- **Wichtige Nebenerkenntnis:** Die Funktion hat dadurch aller Wahrscheinlichkeit nach noch NIE tatsächlich Text vergrößert/verkleinert, seit sie eingeführt wurde - "Normal" (Faktor 1.0) hat den Fehler nur zufällig vermieden, ohne dass die Einstellung deshalb funktional gewesen wäre.
- **Behoben durch Umstieg auf den dafür vorgesehenen Flutter-Mechanismus:** Skalierung läuft jetzt über `MediaQuery`s `TextScaler` (`MaterialApp.builder`, `app.dart`), nicht mehr über eine manuell skalierte `TextTheme`. Das ist der offizielle, für genau diesen Zweck vorgesehene Weg, unabhängig davon, welche `TextStyle`-Felder zufällig gesetzt sind, und funktioniert unabhängig von den o.g. Details der Material-3-Standard-Typography. `AppTheme.build()` verliert dadurch seinen `fontScale`-Parameter komplett.
- **Per Reproduktions-Test verifiziert, nicht nur behauptet:** `test/widgets/font_size_setting_test.dart` wählt alle 4 Optionen durch (keine Exception) und prüft zusätzlich, dass sich die tatsächliche Render-Höhe eines Text-Widgets bei "Sehr groß" um exakt den erwarteten Faktor 1,3 ändert - damit ist nicht nur der Crash behoben, sondern auch bestätigt, dass die Einstellung jetzt wirklich etwas bewirkt.

### Korrektur: veralteter Hinweistext bei "ameseginalehu" (danke) - Wort selbst blieb erhalten

- Der Nutzer wies darauf hin, dass "Amaseganlo" nicht mehr der Namensgeber der App ist (Umbenennung zu Habesha Speak, Etappe 17) - der `hint`-Text des Lexems `lex_ameseginalehu` sagte aber wörtlich "Namensgeber dieser App"/"This app is named after this word." in allen 4 Sprachen, was jetzt falsch war.
- **Erster Versuch war ein Missverständnis der Auftragsgröße:** Auf eine Rückfrage, welches Wort gemeint ist, wurde das Wort komplett aus dem Wortschatz entfernt (Lexem-Eintrag, alle 6 Lektionen, Audio-Manifest, mp3-Datei, CSV-Zeile, zwei Tests mit fest verdrahteter Wortanzahl 8→7) und als eigener Commit dokumentiert. Der Nutzer korrigierte das umgehend: gemeint war ausschließlich der veraltete Hinweistext, nicht das Wort, seine Audiodatei oder seine Verwendung in Lektionen ("der Rest war schon passend").
- **Per `git revert` vollständig rückgängig gemacht** statt die Entfernung händisch nachzubauen (geringeres Risiko, eine der neun betroffenen Dateien zu übersehen) - stellt Lexem, alle 6 Lektionsreferenzen, Audio-Manifest-Eintrag, mp3-Datei und CSV-Zeile identisch zum Stand vor der Entfernung wieder her, inklusive der beiden Tests zurück auf 8.
- **Danach die eigentlich gewünschte, kleine Korrektur:** nur das `hint`-Feld des Lexems entfernt (keine Ersatzformulierung, um keine unbelegte linguistische Behauptung zu erfinden) - passt damit zu mehreren Geschwister-Lexemen in derselben Datei (`lex_awo`, `lex_yikirta`, `lex_algebagnem`, `lex_dehna`), die ebenfalls kein `hint`-Feld haben. Wort, Übersetzung, Audio und alle Lektionsreferenzen unverändert.
- **Lehre für zukünftige Rückfragen:** Eine Bestätigungsantwort auf "welches Wort meinst du?" beantwortet nur, WELCHES Wort gemeint ist - nicht automatisch den Umfang der gewünschten Änderung ("entfernen" vs. "nur einen falschen Teilaspekt korrigieren"). Bei mehrdeutigem Änderungsumfang wäre eine zweite, gezieltere Rückfrage angebracht gewesen.

## Etappe 19 (Design-Überarbeitung: Akzentfarben weg, Marken-Palette grün/gold/terracotta, modernere Onboarding-/Einstellungen-/Hauptmenü-Optik)

- **Auslöser:** Der Nutzer fand Onboarding, Einstellungen und Hauptmenü "zu einfach" - zu wenig visuelle Substanz, nicht wie eine "App von einem großen Hersteller". Zusätzlich, in einer Nachricht während der Umsetzung: die 8-farbige Akzentfarben-Wahl (Etappe 1/12) sollte komplett weg - nur noch Hell/Dunkel als Wahl - und stattdessen sollen grün/gelb/rot (die Landesfarben) als wiederkehrende Akzente in der App auftauchen, ohne es zu übertreiben; das Fahrzeug (Taxi) darf dagegen weiterhin mehr Farben haben als nur die drei.
- **8-Farben-Akzentwahl (`AppAccentColors`, inkl. der 2 Premium-Farben "Kaffee"/"Blauer Nil") vollständig entfernt** - `accentColorIndex` aus `AppSettings`/`SettingsProvider`/`AppTheme.build()` gestrichen, die Farbkreis-Auswahl-UI aus `settings_screen.dart` entfernt, den entsprechenden Premium-Feature-Eintrag (Icon + Farbkreise) aus `premium_screen.dart` entfernt. `settingsAccentColor`/`premiumFeatureColors`-Strings in allen 4 Sprachen gelöscht; `settingsPremiumHint`/`premiumDescription` (erwähnten die jetzt nicht mehr existierenden "Reise-Farben") auf das verbleibende Premium-Feature (Reisepass-Cover) umformuliert, ebenfalls in allen 4 Sprachen.
- **Neue feste Marken-Palette `AppBrandColors`** (grün `0xFF0F7A3D`, gold = `successColor` wiederverwendet, terracotta `0xFFB8492E` neu) **bewusst NICHT in `ColorScheme.secondary`/`.tertiary` verdrahtet**: Material leitet `onSecondary`/`secondaryContainer`/etc. weiterhin aus der Tonleiter des EINEN Seed-Farbtons ab, auch wenn man `secondary`/`tertiary` selbst überschreibt - das hätte an jeder der vielen Stellen, wo diese Rollen app-weit (in noch unangefassten Screens) verwendet werden, zu unpassenden Farbkombinationen führen können. Stattdessen werden gold/terracotta gezielt von Hand an einzelnen, bewusst gewählten Stellen eingesetzt (AppShell-Badges, Onboarding-Icon-Kreise, Einstellungen-Sektionsköpfe) - näher an dem, was "immer wieder zu erkennen, aber nicht übertrieben" tatsächlich bedeutet, als ein pauschales App-weites Umfärben.
- **Terracotta bewusst NICHT gleich `errorColor`**: Etappe 1 hatte ausdrücklich festgelegt, nie eine "echte" rote Markenfarbe zu verwenden, um Verwechslung mit Fehler-Feedback zu vermeiden. Diese Regel wurde hier bewusst für einen wärmeren, erdigeren Terrakotta-Ton aufgeweicht (auf expliziten Nutzerwunsch nach Rot als Flaggenfarbe) - `errorColor` bleibt trotzdem unverändert und ausschließlich für Fehler reserviert, die beiden Töne sind deutlich unterscheidbar.
- **`CardThemeData`: Elevation von 0 auf 2 erhöht** (plus `shadowColor`) - ein einzelner, globaler Wert, der die "zu flache" Optik in praktisch jedem Screen mit Karten mildert, ohne jeden einzelnen Screen einzeln anfassen zu müssen.
- **`AppShell` (Hauptmenü):** Neue `_StreakXpBadges` in der AppBar zeigen Serie (terracotta, Flammen-Icon) und Gesamt-XP (gold, Blitz-Icon) permanent an - die zwei Werte, die Lernende laut gängiger Sprachlern-App-Konvention am häufigsten im Blick haben wollen, jetzt einen Tap näher statt nur im Profil-Tab. Dazu ein 3px hoher grün-gold-terracotta-Verlaufsstreifen unter der AppBar als dezenter, wiederkehrender Flaggen-Akzent. `NavigationBar` bekommt etwas mehr Elevation (Schatten) für mehr visuelle Abgrenzung vom Inhalt.
- **Onboarding:** Jeder der 4 Schritte bekommt sein Icon jetzt in einem farbigen Kreis-Badge (grün/gold/terracotta/grün im Wechsel) statt eines bloßen Icons; Titel fett; der "Weiter/Los geht's"-Button ist jetzt ein breiter, durchgehender Call-to-Action-Button statt ein kleiner rechtsbündiger, "Zurück" wurde zu einem runden Icon-Button links daneben.
- **Einstellungen:** Komplett von einer flachen Liste mit Trennlinien auf gruppierte Karten umgestellt - jeder Abschnitt bekommt einen farbigen Icon-Badge-Kopf (grün/gold/terracotta im Wechsel) statt eines reinen Textlabels. Für zwei bisher kopflose Blöcke (Backup/Restore/Reset und die Schalter-Sammlung) neue, kurze Abschnittstitel per neuen l10n-Keys (`settingsDataSection`, `settingsMoreOptions`) ergänzt.
- **Ein neuer, kurzer l10n-Key `settingsPremiumSection` ("Premium")** extra für den Kartenkopf des Premium-Abschnitts eingeführt, statt dort den vollen Produktnamen ("Habesha Speak Premium") zu wiederholen - sonst hätte derselbe Text zwei Mal auf dem Bildschirm gestanden (Kartenkopf UND der tatsächlich tippbare `ListTile` darunter), was `find.text(...)`-Tests in `premium_redeem_test.dart`/`premium_screen_test.dart` erst durcheinandergebracht hatte, weil der Tap dann den falschen (nicht-interaktiven) Treffer erwischte.
- **Drei bestehende Widget-Tests mussten wegen der Umstrukturierung angepasst werden**, nicht weil sie falsch getestet hätten, sondern weil sich durch das neue Layout tatsächliche Mehrdeutigkeiten ergaben: `font_size_setting_test.dart` fand nach der Karten-Gruppierung plötzlich zwei "Normal"-Texte gleichzeitig im Baum (Schriftgröße UND Ha-Hu-Tempo, da sich die Scroll-Position/den Cache-Bereich der `ListView` verschoben hat) - jetzt gezielt auf die Schriftgrößen-`SegmentedButton` eingeschränkt per `find.descendant`. `profile_stats_test.dart` fand zwei "1000"-Texte (Profil-Statistik UND das neue AppBar-XP-Badge) - jetzt auf das `GridView` der Statistik-Kacheln eingeschränkt.
- **Kein Pixel-Sichttest im Browser möglich in dieser Umgebung:** Der lokale `flutter run -d web-server`-Vorschau-Tab blieb bei einem wiederkehrenden DWDS-/`injected-client.js`-Deserialisierungsfehler hängen (kein Flutter-Bezug, sondern ein Debug-Verbindungsproblem des Sandbox-Browsers) - der Canvas hat nie gemalt, Screenshots waren nicht möglich. Verifiziert wurde stattdessen ausschließlich über `flutter analyze` (0 Probleme) und die volle Testsuite (197 grün, inkl. echter Render-/Interaktions-Prüfungen für Onboarding, Einstellungen, AppShell und Premium-Navigation) - eine reine Pixel-Kontrolle (Farbkontrast, Abstände "von Auge") steht noch aus und wäre bei Gelegenheit auf einem echten Gerät/Emulator nachzuholen. **Das hier direkt bestätigt:** Der Nutzer meldete anschließend genau ein solches Sicht-Problem (siehe Etappe 20) - ein echter Gerätetest hätte es vermutlich schon vorher gefunden.

## Etappe 20 (Bugfix: Stationstext auf der Übersichtskarte zu lang, wurde abgeschnitten)

- **Gemeldeter Fehler:** Auf der Ebene-1-Übersichtskarte (`RegionNodeMarker`) zeigte das Label unter jedem Karten-Knoten den vollen Lehrplan-Abschnittstitel (z.B. "Station 1: Addis Abeba — die Hauptstadt-Ankunft") - bei `maxLines: 2` mit Ellipsis wurde davon oft nicht alles angezeigt. Der Nutzer wollte dort nur noch den Stadt-/Regionsnamen ("Addis Abeba"), da die Stationsnummer bereits als eigenes rundes Badge oben links auf dem Knoten sitzt (`_NumberFlag`) - redundant und zu lang zugleich.
- **Bewusst NICHT die Lehrplandaten (`curriculum.json`) geändert:** Die vollen, blumigeren Titel werden noch an anderer Stelle sinnvoll gebraucht (z.B. als AppBar-Titel der Regions-Detailkarte, Etappe-15-Ebene) - dort passt der ausführlichere Text. Stattdessen wird der Titel nur an der einen Stelle, wo er zu lang ist (dem Karten-Label), zur Anzeige gekürzt: `_shortRegionLabel()` in `region_node_marker.dart` schneidet die Zeit vor dem ersten ": " (Nummer-Präfix) und alles ab dem ersten " — " (Zusatz-Tagline) weg - ergibt zuverlässig "Addis Abeba", "Oromia", "Tigray", "Der Süden" für alle 4 Sektionen in allen 4 Sprachen (Muster geprüft: durchgehend `"<Wort> <N>: <Name> — <Tagline>"`). Fällt bei unerwartetem Format auf den unveränderten Volltext zurück, statt etwas falsch abzuschneiden.
- **Screenreader-Semantik bewusst unverändert:** `Semantics(label: title, ...)` bekommt weiterhin den VOLLEN Titel, nur der sichtbare `Text`-Widget-Inhalt wurde gekürzt - blinde Nutzer verlieren dadurch keinen Kontext, sehende Nutzer bekommen die kompakte Ansicht.
- **Drei Widget-Tests tippten bisher per `find.text(...)` auf den vollen Titel, um den Kartenknoten zu treffen** (`chapter_test_fail_flow_test.dart`, `region_locked_station_test.dart`, `world_map_navigation_test.dart`) - auf den neuen kurzen Text ("Addis Abeba") umgestellt. Die eine `expect(...)`-Prüfung auf der Regions-Detailkarte (deren AppBar-Titel weiterhin den vollen Text zeigt) blieb unverändert, da dort nichts gekürzt wurde.

## Etappe 21 ("Bewegung reduzieren" entfernt, "Alle Lektionen frei" aus den Einstellungen, mehr Schatten bei Regionen, Winke-Arm im Icon wieder weg)

- **"Bewegung reduzieren" (`reduceMotion`) vollständig entfernt** (Feld aus `AppSettings`, Setter aus `SettingsProvider`, Schalter aus `settings_screen.dart`, l10n-Key in allen 4 Sprachen) statt nur den Schalter zu verstecken: Die Einstellung wurde ausschließlich über genau diesen einen Schalter gesetzt - ohne ihn wäre das Feld für jede neue Installation für immer unerreichbar und `false` geblieben, also totes Gewicht. Alle Aufrufstellen (`router.dart`s Zoom-Übergang, `world_map_screen.dart`/`region_detail_screen.dart`s Bus-Fahrt-Animation, `fidel_lesson_screen.dart`s `HaHuDrill`) laufen jetzt fest auf "immer animieren" - `_startBusTravel` verlor dadurch seinen `reduceMotion`-Parameter komplett, `_zoomTransitionDuration` wurde von einer `context`-abhängigen Funktion zu einer festen `const Duration`. Das `HaHuDrill`-Widget behält seinen eigenen `reduceMotion`-Parameter unangetastet - der wird unabhängig von der (jetzt fehlenden) Einstellung weiterhin direkt von zwei Tests zum deterministischen Testen ohne Animationsverzögerung genutzt.
- **"Alle Lektionen frei zugänglich" (`allLessonsUnlocked`) bewusst NUR aus der Einstellungen-Oberfläche entfernt, nicht aus dem Modell:** Anders als bei `reduceMotion` wird dieses Feld noch aktiv von der Onboarding-Einstufungsfrage ("Kannst du schon etwas Amharisch?") gesetzt und von `journey_progress.dart`/`fidel_screen.dart` zum Freischalten aller Einheiten gelesen - eine vollständige Entfernung hätte diese Erstlauf-Funktion mitgerissen, die der Nutzer nicht angesprochen hat. `AppSettings.allLessonsUnlocked`, `SettingsProvider.setAllLessonsUnlocked` und die Onboarding-Anbindung bleiben deshalb unverändert, nur der manuelle Schalter samt l10n-Key ist weg.
- **Etwas mehr Schatten bei den Regionsknoten** (`region_node_marker.dart`): Kreis-Glow (blurRadius 8/16 → 12/22, plus Versatz nach unten) und Orts-Namen-Pennant (blurRadius 4 → 6, dunklerer Schatten) dezent verstärkt, auf Wunsch des Nutzers als kleiner Modernisierungs-Test ("Schattierungen... mach das auch bisschen mit Region").
- **Winkender Arm im App-Icon (Etappe 18) wieder entfernt**, auf ausdrücklichen Wunsch - `tool/generate_icon_test.dart` zeichnet den Taxifahrer jetzt wieder nur mit Kopf/Mütze/Gesicht im dritten Fenster, ohne Arm/Hand/Bewegungs-Bögen. Icon-PNG neu generiert, `flutter_launcher_icons` erneut gelaufen.
- **Live-Fehlersuche auf echtem Gerät, echter Bugfund statt Vermutung:** Der Nutzer meldete "gar kein Ton" beim Testen auf einem angeschlossenen Android-Handy (Samsung Galaxy S21 Ultra, `flutter run` per USB). Direkt per `adb logcat` mitgelesen statt zu raten: Die kurzen Richtig/Falsch-Klänge sind laut `assets/audio/manifest.json` (`"feedback": {"correct": null, "incorrect": null}`) schon immer unbestückt - kein Regressions-Bug, sondern fehlender Content. Über zwei Testfenster (insgesamt gut zwei Minuten aktives Tippen) fand sich dagegen kein einziger `ExoPlayer`-Play-Aufruf und kein TTS-„speak"-Aufruf im Log, obwohl die Sprachausgabe-Engine sauber verbunden war und die Medienlautstärke auf Maximum stand.
- **Die eigentliche Ursache gefunden per Code-Suche, nicht per Gerätelog:** `grep` nach `autoPlayNewWords` zeigte, dass die Einstellung "Neue Wörter automatisch abspielen" (Standard: an) im Modell/Provider/UI existiert, aber an KEINER Stelle im Code tatsächlich gelesen wird. Wortaudio lief ausschließlich über den manuellen Lautsprecher-Button auf der `IntroCard` (`onPlayAudio`) - eine Auto-Wiedergabe hat es nie gegeben, trotz des Einstellungsnamens. Das erklärt exakt den gemeldeten Befund: Der Nutzer hat vermutlich nie aktiv auf das kleine Lautsprecher-Icon getippt und deshalb tatsächlich nie ein Wort gehört, ohne dass mit der Audio-Pipeline selbst etwas falsch war.
- **Behoben in `lesson_screen.dart`:** `_buildIntro` löst jetzt bei jeder neu angezeigten Wortkarte automatisch `lessonProvider.playIntroAudio()` aus (per `addPostFrameCallback`, nicht synchron im `build()`, gleiches Muster wie die bestehenden `_started`/`_finishing`-Guards in dieser Datei), sofern `autoPlayNewWords` und `soundEnabled` an sind und Audio verfügbar ist. Ein `_autoPlayedIntroLexemeId`-Feld verhindert Mehrfach-Abspielen beim Neubau derselben Karte.
- **Neuer Regressionstest** `test/widgets/lesson_intro_autoplay_test.dart` mit einem Spy-`TtsClient`, der `isLanguageAvailable` immer bejaht und aufzeichnet, ob/was gesprochen wurde - bestätigt, dass eine frische Intro-Lektion ohne jeden Tap tatsächlich Audio auslöst. Dafür bekam `pumpTestLesson` (in `test_harness.dart`) einen optionalen `audioService`-Parameter, Standardverhalten für alle bestehenden Aufrufer unverändert.
- **Aber: Der Nutzer meldete danach, dass selbst das manuelle Tippen auf den Lautsprecher-Button auf dem echten Gerät weiterhin stumm blieb** - der Autoplay-Fix allein war also nicht die ganze Geschichte. Erneut per `adb logcat` mitgeschaut, diesmal mit frisch geleertem Puffer direkt vor einem gezielten Tap: wieder kein einziger `ExoPlayer`/TTS-Aufruf, obwohl jetzt sicher auf den Button getippt wurde.
- **Die tatsächliche Ursache: Die MP3-Dateien waren nie Teil der gebauten APK.** Direkt nachgeprüft mit `unzip -l build/app/outputs/flutter-apk/app-debug.apk` - `assets/audio/manifest.json` (54 KB, alle ~1057 Einträge) war enthalten, aber `assets/audio/words/*.mp3` (die eigentlichen Aufnahmen) kein einziges. Ein `flutter clean` + kompletter Neu-Build änderte daran nichts, also war es kein Cache-Problem. Ursache in `pubspec.yaml` gefunden: **Flutters Verzeichnis-Assets sind nicht rekursiv** - ein Eintrag wie `assets/audio/` bindet nur Dateien EINE Ebene tief ein (hier: `manifest.json`), nicht die verschachtelten `assets/audio/words/*.mp3`. Der zugehörige Kommentar in `pubspec.yaml` ("assets/audio/ enthält bisher nur manifest.json, noch ohne echte Audiodateien") stammte noch aus Etappe 7, als das tatsächlich stimmte - beim Hinzufügen der echten Aufnahmen in Etappe 15/16 wurde `pubspec.yaml` nie um `assets/audio/words/` als eigenen Eintrag ergänzt. Vermutlich hat deshalb NIE jemand echte Wortaussprache auf einem echten Gerät gehört, seit die Aufnahmen bestehen - in `flutter test` fällt das nie auf (Assets sind dort komplett gemockt), und offenbar wurde seither nicht (mehr) auf einem echten Gerät gegen die reale APK getestet.
- **Behoben:** `pubspec.yaml`s `assets:`-Liste um `assets/audio/words/` ergänzt, Kommentar korrigiert und der Rekursions-Fallstrick dort dauerhaft dokumentiert. Nach `flutter clean`, `flutter pub get` und Neu-Installation per `unzip -l` bestätigt: alle 1057 MP3s jetzt in der APK. Vom Nutzer auf dem echten Gerät bestätigt: Ton kommt jetzt tatsächlich.
- **Lehre:** `flutter test` deckt Asset-Bundling-Fehler grundsätzlich nicht ab, da jede Testfabrik einen eigenen (gemockten oder allenfalls über Roundtrip geprüften) `AssetBundle` verwendet, nie den echten, aus `pubspec.yaml` gebauten. Ein einziger echter Geräte-/Release-Build-Test hätte diesen Fehler vermutlich schon vor Etappe 21 aufgedeckt - für zukünftige, neu hinzugefügte Asset-Unterordner lohnt sich ein kurzer `unzip -l`-Check der gebauten APK als Stichprobe.

## Etappe 22 (Hauptseite überarbeitet: Äthiopien-Umriss, Harar, geschwungene Route, kumulative Freestyle-Wiederholung)

Großer, in einem Zug durchgearbeiteter Auftrag mit vier Teilen. Vor Beginn ein vollständiges Backup erstellt: Git-Tag `backup-vor-hauptseite-ueberarbeitung` auf dem damaligen HEAD plus eine komplette Ordnerkopie unter `C:\Dev\amaseganlo-backup-2026-08-06` (ohne die regenerierbaren `build/`, `.dart_tool/`, `android/.gradle`, `android/app/.cxx` - alles andere 1:1 kopiert, 1812 Dateien, 0 Fehler laut `robocopy`).

### Äthiopien-Umriss als Kartenhintergrund

- **Neue `EthiopiaMap`-Klasse** (`core/journey_map_layout.dart`): ein fest hinterlegtes, ~14-Punkte-Polygon aus groben Längen-/Breitengraden (nicht kartografisch exakt, bewusst "stilisiert" laut Auftrag), das über dieselbe `_project()`-Funktion in Bildschirmkoordinaten umgerechnet wird wie die Orts-Marker selbst - beide bleiben dadurch immer zueinander konsistent, unabhängig von der Canvas-Größe.
- **Der Umriss wird nicht als zusätzliche, separate Wasserzeichen-Form über die bestehende Karte gelegt, sondern als Clip-Pfad für die vorhandene Terrain-Zeichnung selbst verwendet** (`WorldMapPainter.paint()`): Außerhalb des Umrisses liegt jetzt ein neutraler, papierartiger Hintergrund, innerhalb läuft die bisherige "gemalte Landkarte" (Himmel-Verlauf, Regionen-Glow, Straße, Deko) unverändert weiter, plus ein dezenter Umriss-Strich zur Kontur. Das erfüllt "dezent, nicht zu dominant" eleganter als eine zweite, konkurrierende Ebene.
- **Erweiterbarkeit wie gefordert:** Ein neuer Ort braucht nur einen neuen `GeoPoint`-Eintrag in `EthiopiaMap.geoPositions` (Längen-/Breitengrad) plus einen Slot in `WorldMapLayout.order` - keine Strukturänderung, keine manuell nachjustierten Pixel-Koordinaten.
- **Echte Geografie clustert Addis Abeba/Oromia/Sidama zu eng für tastbare Kartenknoten** (real liegen alle drei nur wenige Breitengrade voneinander entfernt) - die hinterlegten Koordinaten sind deshalb in genau diesem Cluster bewusst weiter auseinandergezogen als real, aber in der jeweils korrekten Himmelsrichtung belassen ("nicht exakt maßstabsgetreu, aber grob richtig zueinander", explizit so vom Nutzer erlaubt). Ohne dieses Nachjustieren schlugen mehrere Widget-Tests fehl, weil sich die ~128px breiten Marker-Rechtecke im (kleinen) Test-Viewport tatsächlich überlappten und Taps beim falschen Knoten landeten - mit reinem Rechnen aus Rohkoordinaten wäre das erst beim echten Ausprobieren aufgefallen, hier hat die Testsuite es sofort sichtbar gemacht.

### Neuer Ort: Harar (gesperrt, "Bald verfügbar")

- **`JourneyRegion.harar` als fünfter Enum-Wert ergänzt**, aber bewusst von KEINER `CurriculumSection.region` referenziert - Harar hat noch keinen echten Lektionsinhalt, das war ausdrücklich Teil des Auftrags ("inhaltlich noch nicht ausgearbeitet"). `WorldMapLayout.order` ist dadurch jetzt länger als `curriculum.sections` - `WorldMapScreen._buildRegionNode` prüft das (`index >= curriculum.sections.length`) und rendert für jeden überzähligen Eintrag einen permanent gesperrten `RegionVisualState.comingSoon`-Platzhalter statt in `curriculum.sections[index]` zu indizieren und abzustürzen. Sobald Harar später einen echten Abschnitt bekommt, greift automatisch der normale Zweig - keine Code-Änderung an dieser Stelle nötig.
- **Neuer visueller Zustand `RegionVisualState.comingSoon`** (`region_node_marker.dart`): sieht wie `upcoming` aus (grauer Ring, Sanduhr- statt Schloss-Badge), tippen navigiert aber nirgendwohin, sondern zeigt nur eine kurze SnackBar mit "Bald verfügbar" - anders als ein normales "upcoming"-Ziel, das man laut bestehendem Verhalten schon vorab ansehen darf, gibt es bei Harar ja nichts zu zeigen. `RegionNodeMarker.onTap` wurde dafür nullable.
- **Bewusst keine erfundene Harar-Szene gezeichnet** - weder im Kartenknoten-Icon noch im Ebene-2-Terrain-Painter noch im alten, unbenutzten `journey_stop_banner.dart` (dort nur wegen Dart-Exhaustiveness-Zwang ein Fall ergänzt). Alle drei zeigen für Harar nur einen flachen Grauton statt einer thematischen Illustration, bis der Ort wirklich ausgearbeitet ist - eine falsche Ausschmückung jetzt hätte später wieder verworfen werden müssen.
- **Zukünftiger Fokus für Harar dokumentiert, aber NICHT umgesetzt** (ausdrücklich erst "sobald später ausgearbeitet" laut Auftrag): religiöser Wortschatz sowohl islamisch als auch christlich (Harar ist historisch für beide Religionen bedeutsam), zusätzlich zum üblichen Alltagswortschatz wie bei den anderen Orten. Icon-Wahl (`Icons.mosque` im Reisepass-Stempel, `_stampColor`/`_iconFor` in `profile_screen.dart`) nimmt das schon leicht vorweg, ist aber unverbindlich, solange kein echter Abschnitt existiert.

### Geschwungene Routenführung + Neuzuordnung der Orte

- **Die Straßen zwischen den Kartenknoten waren schon vor diesem Auftrag geschwungene quadratische Bézier-Kurven** (`WorldMapLayout.roadBetween`, Etappe 14) - dieser Teil des Auftrags war also größtenteils schon erfüllt; hier ging es primär darum, die REIHENFOLGE der Orte so zu wählen, dass die Kurven sich nicht kreuzen.
- **Reihenfolge geändert von Addis→Oromia→Tigray→Süden auf Addis→Tigray→Oromia→Süden→Harar.** Grund: Tigray liegt real weit im Norden, Oromia umgibt Addis Abeba großflächig (hier als südwestlicher Punkt modelliert), der Süden (Sidama/Gurage) liegt südlich davon, Harar weit im Osten. Die alte Reihenfolge sprang geografisch hin und her (Mitte → Südwest/Mitte → weit Norden → Süden), die neue läuft einmal im Bogen (Mitte → Norden → Südwesten → Süden → Osten) ohne Selbstüberschneidung - rechnerisch nachgeprüft, dass keine zwei Strecken-Segmente sich schneiden.
- **Dafür wurden `sec_a1_2`s und `sec_a2`s `region`/`title`-Felder in `curriculum.json` vertauscht** (Oromia ↔ Tigray) - die Level (A1.2/A2), `id`s und `units`-Listen (also die eigentlichen Lektionsinhalte) blieben exakt unverändert, wie im Auftrag verlangt ("nur die Zuordnung... darf sich ändern"). Die Stationsnummer in den Titeln ("Station 2"/"Station 3") blieb ebenfalls unverändert, da sie die POSITION beschreibt, nicht den Ort.
- **Harar kommt laut Auftrag ausdrücklich als "nächster Ort... nach den bestehenden Orten"**, also ans Ende der Reihenfolge (Position 5) - unabhängig davon, wie gut das geografisch zur Mitte der Route gepasst hätte. Das war eine harte Vorgabe, kein Interpretationsspielraum.

### Kumulative Freestyle-Wiederholung am Ende jeder Region

- **Neue Stationstyp am Ende jeder Region** (`region_detail_screen.dart`): Der Ebene-2-Pfad bekommt pro Region eine zusätzliche, letzte Station ("R"-Badge statt Nummer) - `RegionMapLayout.layout(unitIds.length + 1)` statt nur `unitIds.length`, der Rest der Kurven-/Deko-Logik läuft unverändert weiter, da sie generisch über die Stationsliste iteriert.
- **Freischaltung über die bestehende `JourneyProgress.isSectionDone`-Logik** - keine neue Fortschritts-Semantik nötig. Die Station zeigt NIE "abgeschlossen" (anders als echte Kapitel-Stationen), da sie beliebig oft wiederholbar sein soll, nicht einmalig abzuhaken.
- **Neue `ContentRepository`-Methoden** `sentencesForUnit` (Satz-Äquivalent zu `lexemesForUnit`) sowie `lexemesForSections`/`sentencesForSections`, die über eine Liste von Abschnitts-IDs iterieren und alle Wörter/Sätze aller darin enthaltenen Einheiten de-dupliziert einsammeln - genau der "kumulativ" Teil: Beim Tippen auf die Station wird ihr die Liste aller Abschnitts-IDs von der ersten Region bis zur aktuellen übergeben (`sections.take(sectionIndex + 1)`), nicht nur die aktuelle.
- **Neuer Screen `RegionReviewScreen`** (`screens/path/region_review_screen.dart`), fast identisch zum bestehenden `ReviewSessionScreen` (fällige/schwierige Wörter) aufgebaut - gleiches Muster: eine Ad-hoc-`Lesson` bauen und über `LessonProvider.startAdHocSession` starten, dieselbe `ExercisePlayer`/Abschluss-UI wiederverwenden. Zwei Unterschiede: (1) sowohl `lexemeIds` ALS AUCH `sentenceIds` werden befüllt (die alte Wiederholung kennt nur Wörter), (2) die erlaubten Übungstypen sind auf `wordTyping`/`sentenceBuild`/`sentenceGapTyping` beschränkt - bewusst NUR produktive, frei zu bildende Aufgaben, keine Multiple-Choice-artigen Typen (`wordChoice*`, `emojiMatch`, `pairMatching`, `trueFalse`, `sentenceGapChoice`, `sentenceTranslate`), exakt wie im Auftrag verlangt ("nicht nur Multiple-Choice").
- **`LessonKind.freeApplication` wiederverwendet statt eines neuen Enum-Werts** - das Modell hatte diesen Wert schon vorgesehen und beschreibt inhaltlich exakt das Gewünschte ("freies Anwenden"), ein neuer `LessonKind` für denselben Zweck wäre unnötige Redundanz gewesen.
- **Neue Route `region/:regionId/review`** (`router.dart`), Datenübergabe der kumulativen Abschnitts-ID-Liste über `state.extra` - dasselbe Muster wie die bestehende `/review/session`-Route für `ReviewSessionScreen`.
- **Zwei neue Tests:** `content_repository_test.dart` prüft `lexemesForSections`/`sentencesForSections` direkt (wächst kumulativ, keine Duplikate, unbekannte Abschnitts-ID crasht nicht); `region_review_screen_test.dart` pumpt `RegionReviewScreen` mit zwei Abschnitts-IDs und prüft, dass die entstehende Übungsliste nicht leer ist und ausschließlich aus den drei erlaubten, produktiven Übungstypen besteht.

### Zusammenfassung Verifikation

`flutter analyze`: 0 Probleme. `flutter test`: alle 203 Tests grün (7 neue: 1 Content-Repository-Test, 1 Region-Review-Screen-Test, plus 5 wegen der neuen Marker-Koordinaten notwendig gewordene, bereits bestehende Tap-Assertions in Weltkarten-/Regions-Tests, die aber inhaltlich unverändert blieben). Kein Pixel-Sichttest im Browser möglich (dieselbe Sandbox-Einschränkung wie in Etappe 19/21) - verifiziert stattdessen über die Testsuite und rechnerische Prüfung der Routen-Geometrie auf Kreuzungsfreiheit.

### Vertonung

Dieser Auftrag hat **keine neuen amharischen Wörter oder Sätze** erzeugt: Harar hat noch keinen Inhalt (bewusst als Platzhalter belassen), die Regions-Neuzuordnung tauscht nur Namen/Titel bestehender Abschnitte, und die neue Wiederholungsstation verwendet ausschließlich bereits vorhandenes, bereits vertontes Vokabular. Es gibt daher diesmal keine CSV-Liste nachzuliefern.

### Nachtrag: Umriss unklar erkennbar, Stationen zu groß, Straße wirkte abgerissen

- **Gemeldete Probleme:** (1) Der Umriss sah nicht nach Äthiopien aus, (2) die Kartenknoten waren zu groß, (3) die Straße schien an manchen Stationen nicht anzukommen.
- **Ursache für (3), die eigentlich wichtigste:** Beim erstmaligen Feinjustieren der Marker-Koordinaten gegen Test-Überlappungen (siehe oben) wurden Oromia/Sidama/Harar über die tatsächlichen Umriss-Grenzen hinausgeschoben - und Straße, Regionen-Glow UND Deko wurden bis dahin INNERHALB des `canvas.clipPath(outline)`-Blocks gezeichnet. Jede Straße, die zu einem außerhalb liegenden Marker führte, wurde exakt an der Küstenlinie abgeschnitten - genau der gemeldete Effekt. Behoben durch Umstrukturierung von `WorldMapPainter.paint()`: Nur noch die reine Himmel-/Terrain-Füllung bleibt auf den Umriss geclippt, Regionen-Glow, Deko und Straße werden bewusst UNGECLIPPT gezeichnet, damit ein ungefähr, aber nicht exakt getroffener Umriss niemals die Funktionalität sichtbar beschädigt.
- **Umriss (1) komplett neu gezogen** (`EthiopiaMap.outline()`): 10 statt 13 Eckpunkte, klarer erkennbare Merkmale (relativ gerade Westkante Richtung Sudan, gerundete Nordkante, spitz zulaufender Nordost-„Keil" Richtung Afar/Dschibuti, große Ausbuchtung nach Südosten für die Somali-Region, flachere Südkante Richtung Kenia). Die zugrunde liegende Projektionsbox (`_minLon`/`_maxLon`/`_minLat`/`_maxLat`) wurde dabei bewusst großzügig über den tatsächlichen Umriss- UND Marker-Koordinaten hinaus gewählt, damit kein Punkt mehr an den Rand geklemmt wird (was die Form verzerrt hätte).
- **Stationen (2) verkleinert** (`region_node_marker.dart`): Kreis-Durchmesser 88→64px, Gesamtbreite 128→96px, Rahmenbreite 4→3px, Nummer-/Status-Badges proportional mit verkleinert (26/24px → 20/18px). Die zugehörigen Zentrier-Offsets in `world_map_screen.dart` (`Positioned(left/top: ...)`) entsprechend nachgezogen.
- **Nach allen drei Korrekturen erneut die volle Testsuite laufen lassen** (nicht nur angenommen, dass es passt) - alle 203 Tests weiterhin grün, insbesondere die Tap-basierten Kartennavigations-Tests, die die letzte Marker-Überlappung überhaupt erst aufgedeckt hatten.

### Nachtrag 2: "sieht immer noch nicht nach Äthiopien aus" - Nachbarländer + Kontrast-Bug

- **Rückmeldung nach dem ersten Nachtrag:** Der Umriss/die Landschaft/"die Länder herum" wirken weiterhin nicht erkennbar - trotz neu gezogenem Umriss. Zwei tatsächliche Ursachen gefunden, keine davon war der Umriss selbst:
  1. **Echter Kontrast-Bug:** Der Terrain-Verlauf innerhalb des Umrisses lief von hellgrün OBEN nach `0xFFF3EFDD` UNTEN - exakt derselben Farbe wie der Hintergrund AUSSERHALB des Umrisses. Damit verschwand die Küstenlinie im unteren Kartenbereich fast komplett; die Form war objektiv kaum noch von ihrer Umgebung zu unterscheiden, unabhängig davon, wie gut die Umrisspunkte gewählt waren.
  2. **Fehlender Kontext:** Der Umriss stand isoliert auf einem leeren, einfarbigen Hintergrund. Ohne umgebende Landmasse, an der sich die Silhouette ablesen lässt, ist selbst eine geografisch korrekte Kontur schwer als "ein bestimmtes Land" zu erkennen - genau das hatte der Auftrag mit "die Landkarte Äthiopiens" und die Rückmeldung mit "die Länder herum" auch so benannt.
- **Fix 1 (Kontrast):** Hintergrund außerhalb auf ein neutrales, kühles Grau-Beige (`0xFFE9E7DE`) gesetzt; der Terrain-Verlauf innerhalb geht jetzt von hellem Hochland-Grün nach einem deutlich dunkleren Oliv (`0xFFDCF0D0` → `0xFFA9CE8E`) - beide Enden bleiben klar grün und unterscheiden sich in jeder Kartenhöhe sichtbar vom Hintergrund. Der Umriss-Strich selbst wurde von `0x33000000`/2px auf `0x59000000`/2.5px verstärkt.
- **Fix 2 (Nachbarländer):** Neue `NeighborLand`-Klasse (`journey_map_layout.dart`) mit vier groben, stilisierten Landmassen - Eritrea (Norden), Sudan/Südsudan (Westen, als eine Fläche, da auf dieser Zoomstufe nicht relevant zu unterscheiden), Kenia (Süden), Dschibuti/Somalia (Osten/Südosten, umschließt die östliche Ausbuchtung). Jede Fläche nutzt dieselbe Lon/Lat-Projektion wie der Äthiopien-Umriss selbst (`EthiopiaMap._project`), ist bewusst großzügig übergroß gezeichnet und überlappt an der äthiopien-zugewandten Kante absichtlich UNTER Äthiopiens eigener, deckender Terrain-Füllung (die danach gezeichnet wird) - eine nicht perfekt sitzende Naht fällt dadurch nie auf. Alle vier in verschiedenen, aber verwandten sandig-erdigen Tönen (nie grün), damit Äthiopiens grünes Hochland optisch klar die "im Fokus stehende" Fläche bleibt - das entspricht nebenbei auch der echten Geografie (Äthiopiens Hochland ist tatsächlich grüner als die trockeneren Nachbarländer).
- **Zeichenreihenfolge in `WorldMapPainter.paint()`:** neutraler Welt-Hintergrund → Nachbarländer (Füllung + dünner Rand) → Äthiopiens Terrain (auf den Umriss geclippt) → [unverändert, siehe Nachtrag 1: Glow/Deko/Straße ungeclippt] → Umriss-Strich → Wolken.
- **Kein visueller Sichttest möglich** (Browser-Vorschau in dieser Sandbox liefert weiterhin keine Screenshots - `preview_start` und `flutter run -d web-server` starten zwar erfolgreich, aber der Screenshot-Aufruf bricht mit "the Browser pane is not displayed" ab, wie schon in Etappe 19/21/22 dokumentiert). Verifiziert stattdessen über `flutter analyze` (0 Probleme) und die volle Testsuite (203/203 grün, unverändert).
- **Offen:** Ohne echtes visuelles Feedback bleibt nicht auszuschließen, dass auch diese Version dem Nutzer noch nicht ausreicht. Sollte das der Fall sein, wäre ein Screenshot vom Nutzer der zuverlässigste nächste Schritt, um konkret zu sehen, was noch fehlt, statt weiter blind zu raten.

### Nachtrag 3: Nutzer schickt drei Referenzbilder - Umriss/Terrain/Stationen daran ausgerichtet

- **Der Nutzer hat drei Bilder geschickt statt eines Screenshots seiner App** - genauso wertvoll, denn damit gab es endlich eine echte Vorlage statt Rätselraten: (1) eine präzise, schwarz-auf-weiß gezeichnete Äthiopien-Umrisskarte mit sichtbaren (grauen) Nachbarländer-Grenzen, (2) eine bunte Verwaltungsregionen-Karte (zur Orientierung, wo die Stationen ungefähr liegen sollten), (3) eine Relief-Karte mit grünem Hochland im Zentrum/Nordwesten und braunem Tiefland Richtung Somali-Region im Osten.
- **Umriss komplett neu nachgezogen** (`EthiopiaMap._outlineVertices`, jetzt 20 statt 10 Punkte) - orientiert an Bild 1: die kleine gezackte Nordkante, die schmale Kerbe Richtung Dschibuti, vor allem aber die lange, fast gerade Südost-Grenze zu Somalia (das mit Abstand markanteste Merkmal der echten Form, das in den vorherigen Versuchen komplett fehlte), die wellige Kenia-Südgrenze und die gerundete Südwest-Ecke zum Sudan/Südsudan.
- **Terrain-Füllung von flachem Vertikal-Verlauf auf einen an echter Geografie verankerten Grün→Braun-Verlauf umgestellt** (`WorldMapPainter.paint()`) - orientiert an Bild 3: ein `LinearGradient` von einem Fokuspunkt im Hochland (grob Lalibela/Addis-Gegend) zu einem Fokuspunkt im Somali-Tiefland, mit einer Oliv-Zwischenstufe. Die Fokuspunkte sind echte `GeoPoint`s, projiziert über `EthiopiaMap.projectToOffset` (neuer Helper) und in `Alignment` umgerechnet (`_toAlignment`) - der Grün/Braun-Übergang landet dadurch geografisch am richtigen Ort, unabhängig vom Seitenverhältnis der Kartenkachel.
- **Nachbarland-Flächen an den neuen Umriss angepasst** und farblich stärker vereinheitlicht (enge Familie warmer, heller Grautöne statt unterschiedlicher Sandtöne) - auf Bild 1/2 sind die Nachbarländer schlicht/neutral, nur Äthiopiens eigenes Gebiet ist farbig/detailliert ausgearbeitet; Dschibuti als eigene kleine Fläche von Somalia abgetrennt (vorher eine gemeinsame Fläche).
- **Stationskoordinaten gegen Bild 2 (echte Verwaltungskarte) geprüft und korrigiert:** Oromia und Sidama saßen bisher in echten Koordinaten, die eher zur "Region der südwestäthiopischen Völker"/"Süden" als zu Oromia/Sidama selbst gehören, und Harar lag weit draußen im Somali-Gebiet statt in seiner echten Ost-Ecke. Jetzt an den echten Hauptorten verankert (Jimma/Oromia, Hawassa-Gegend/Sidama, Harar-Stadt), mit Abstrichen bei der exakten Entfernung (nicht bei der Richtung) wo nötig.
- **Diese Koordinaten-Korrektur riss die Marker-Abstände sofort wieder auseinander** (`flutter test` schlug mit denselben "tap landet auf falschem Marker"-Fehlern fehl wie beim allerersten Mal, siehe oben) - diesmal aber nicht mehr durch Trial-and-Error gelöst: ein temporärer Debug-Test (`_debug_positions_test.dart`, direkt nach Gebrauch wieder gelöscht) hat die tatsächliche Canvas-Größe im Test (576×341px) und alle projizierten Pixel-Positionen ausgegeben. Daraus wurden die exakten px/Grad-Faktoren berechnet (~25,5px/Grad Länge, ~20,9px/Grad Breite) und für jedes der 10 Orte-Paare rechnerisch sichergestellt, dass mindestens eine Achse die Tap-Box (96×138px, wegen des asymmetrischen `top: position.dy - 32`-Offsets) vollständig trennt - nicht mehr nur so lange raten, bis der Test zufällig grün wird.
- **Verifiziert:** `flutter analyze` (0 Probleme), volle Testsuite (203/203 grün) beim ersten Durchlauf nach der rechnerischen Korrektur. Weiterhin kein echter Pixel-Sichttest möglich (siehe Nachtrag 1/2) - aber die Umriss-/Terrain-Form basiert dieses Mal auf einer echten Vorlage statt auf eigener geografischer Erinnerung.

### Nachtrag 4: "nimm einfach genau die Umrisse wie auf dem ersten Bild - eins zu eins"

- **Auftrag:** keine weitere eigene Stilisierung des Umrisses mehr, sondern exakt die Form aus Referenzbild 1 übernehmen.
- **Echte Grenzdaten besorgt statt weiter nachzuzeichnen:** per `curl` die Datei `ETH.geo.json` aus dem öffentlichen Datensatz `johan/world.geo.json` (GitHub) geladen - ein bereits sinnvoll vereinfachtes, aber echtes 58-Punkte-Umrisspolygon von Äthiopien (dieselbe Art Daten, aus der Referenzkarten wie Bild 1 typischerweise gezeichnet sind). `EthiopiaMap._outlineVertices` komplett durch diese echten Koordinaten ersetzt.
- **Keine Bezier-Glättung mehr für Äthiopiens eigenen Umriss:** `outline()` nutzt jetzt `_straightClosedShape` (reine `lineTo`-Segmente) statt der bisherigen `_smoothClosedShape` (quadratische Bezier durch Mittelpunkte) - bei "eins zu eins" hätte jede zusätzliche Glättung die echten Koordinaten wieder leicht verzerrt. Die Nachbarländer behalten die weichere Bezier-Glättung, da sie ohnehin nur grobe, unpräzise Kontext-Flächen sind.
- **Projektionsbox neu auf die echte Bounding-Box gefittet:** `_minLon/_maxLon/_minLat/_maxLat` = `32.0/49.0/2.5/16.0` (die echten Extremwerte liegen bei Lon 32,95-47,79, Lat 3,42-14,96 - die Box lässt bewusst ca. 1° Rand).
- **Nachbarland-Flächen neu an den echten Umriss angepasst:** die äthiopien-zugewandte Kante jeder Nachbarfläche übernimmt jetzt direkt zusammenhängende Abschnitte der echten `_outlineVertices` (statt einer groben Annäherung daran) - Dschibuti bekam dabei eine zweite, eigene Fläche für die schmale Kerbe der Afar-Region, die in den echten Daten viel ausgeprägter ist als in der vorherigen Handzeichnung.
- **Stationskoordinaten mussten komplett neu verifiziert werden**, weil sich sowohl der Umriss als auch die Projektionsbox geändert haben. Dafür kein Python verfügbar (nicht installiert) - stattdessen ein Wegwerf-Dart-Skript (`dart run` im Scratchpad-Verzeichnis, nicht im Projekt) geschrieben, das exakt dieselbe `_project`-Formel und einen Standard-Punkt-in-Polygon-Test (Ray-Casting) gegen das echte Grenzpolygon nutzt. Damit rechnerisch abgesichert, dass jede der fünf Positionen (a) innerhalb des echten Umrisses liegt UND (b) von jeder anderen Position auf mindestens einer Achse die Marker-Tap-Box (96×138px) trennt UND (c) die Routen-Segmente sich weiterhin nicht kreuzen (Standard-Liniensegment-Schnitttest). Oromia/Sidama/Harar landen dadurch etwas anders als die zuvor gewählten "echten Hauptort"-Koordinaten - näher an ihrer echten Richtung von Addis Abeba aus, aber an der jeweils nächsten Stelle innerhalb des echten Umrisses, die noch tap-sicher ist.
- **Finale Koordinaten:** Addis Abeba (38.75, 9.0, unverändert), Tigray (38.7, 14.0, unverändert), Oromia (34.0, 7.5), Sidama (42.3, 4.5), Harar (46.5, 8.1).
- **Verifiziert:** `flutter analyze` (0 Probleme), volle Testsuite (203/203 grün) - diesmal im ALLERERSTEN Durchlauf nach der Koordinatenänderung, weil die Abstände vorher rechnerisch (nicht durch Ausprobieren) geprüft wurden. Wegwerf-Skripte lagen ausschließlich im Scratchpad-Verzeichnis, nie im Projekt - `git status` bestätigt, dass nur `journey_map_layout.dart` geändert wurde.

### Nachtrag 5: Profil-Overflow, Emoji-Aufgaben entfernt, Karte nicht mehr verzerrt

Drei unabhängige Aufträge in einer Runde:

**1) `RenderFlex overflowed by 11 pixels` auf dem Profil-Screen.** Ursache: `_StatsGrid` nutzte `GridView.count` mit festem `childAspectRatio: 2.4` - das gibt jeder Statistik-Kachel eine feste Pixel-Höhe. Bricht das Label bei größerer Schriftgröße (Einstellung existiert bereits, siehe `font_size_setting_test.dart`) oder einer längeren Übersetzung auf zwei Zeilen um, reicht die feste Höhe nicht mehr. Fix: `GridView.count` durch `Wrap` + `LayoutBuilder`-gemessene halbe Breite ersetzt (`profile_screen.dart`) - jede Kachel wird jetzt so hoch wie ihr Inhalt braucht, kann also bei keiner Schriftgröße mehr überlaufen. `profile_stats_test.dart` scopte bisher auf `find.byType(GridView)`, um die Statistik-Kachel von der gleichlautenden XP-Anzeige in der AppBar zu unterscheiden - dafür jetzt einen `Key('profileStatsGrid')` ergänzt statt sich auf einen zufällig passenden Widget-Typ zu verlassen.

**2) `emojiMatch`-Übungstyp komplett entfernt.** Der Nutzer störte sich daran, dass manche Übungen NUR ein Emoji zeigen und das (deutsche) Wort dazu abgefragt wird; Emoji zusammen MIT einem Wort (rein dekorativ) soll dagegen bleiben. `ExerciseType.emojiMatch` und `ExerciseGenerator.generateEmojiMatch` komplett entfernt, alle Referenzen in `lesson_provider.dart`, `review_session_screen.dart`, `placement_test_screen.dart` (Kommentar), `multiple_choice_exercise.dart` (Kommentar) und dem Content-Generator-Tool `tool/content_lib.dart` bereinigt. Zusätzlich `"emojiMatch"` aus den `exerciseTypes`-Arrays aller 84 betroffenen `assets/content/unit_*_lessons.json`-Dateien gestrichen (PowerShell-Regex-Ersetzung, da 84 Dateien für Handarbeit zu viele sind) - die übrigen Übungstypen (wordChoice*, pairMatching) decken jede betroffene Lektion weiterhin ab, keine Lektion verliert dadurch alle ihre Übungen.

**3) Kartenverzerrung behoben - der eigentliche Kern des Auftrags.** `EthiopiaMap._project` normalisierte Lon/Lat bisher UNABHÄNGIG auf 0..1 pro Achse und multiplizierte das erst danach mit Breite/Höhe der Kachel - bei einem Seitenverhältnis, das nicht zum echten Lon/Lat-Verhältnis Äthiopiens passt (praktisch immer der Fall), wurde die Form dadurch gestaucht/gestreckt. Komplett umgebaut auf einen EINHEITLICHEN Maßstab (`EthiopiaMap._transformFor`): `scale = min(verfügbare Breite / Lon-Spanne, verfügbare Höhe / Lat-Spanne)`, zentriert über `dx`/`dy` (Letterboxing) auf der Achse mit Spielraum. `MapNodePosition` (die alte, größenunabhängige 0..1-Fraktion) komplett entfernt, da die Projektion jetzt zwingend die tatsächliche Canvas-`Size` kennen muss; `EthiopiaMap.positions`/`WorldMapLayout.positions` sind jetzt Methoden `(Size) -> Map<...,Offset>` statt einer einmalig gecachten Map.
- **Der neue, korrekte Maßstab ließ deutlich weniger horizontalen Spielraum** als der alte, verzerrende (der Ost-Teil der Karte wurde vorher künstlich "breiter gezogen" als er in Wirklichkeit ist) - Oromia/Sidama/Harar mussten deshalb ein drittes Mal neu verifiziert werden. Mit demselben Punkt-in-Polygon-/Abstands-Skript (Etappe 22 Nachtrag 4) unter der NEUEN Projektion nachgerechnet: Addis' Ostgrenze zum echten Küstenpunkt (47,79°) ist unter dem echten Maßstab nur ca. 4,52° breit - fast genau die 4,52°, die zwei Marker-Tap-Boxen (96px) zur gegenseitigen Trennung brauchen. Für Sidama UND Harar gleichzeitig blieb dabei praktisch kein Rand mehr übrig.
- **Fix:** Marker-Breite in `RegionNodeMarker` von 96 auf 80px verschmälert (spart real ~16px Trennabstand) - eine kleine, kaum wahrnehmbare Verschmälerung der Namens-Fahne, die aber genau den fehlenden Millimeter Platz zurückgibt. Rechnerisch erneut für alle 10 Orte-Paare bestätigt (Marge diesmal ~5-20px, nicht mehr auf Kante). Finale Koordinaten: Oromia (34.0, 7.5, unverändert), Sidama (43.5, 5.2), Harar (47.5, 8.0 - fast am östlichsten echten Punkt Äthiopiens).
- **Die schmalere Marker-Box hat selbst einen neuen, echten Overflow ausgelöst:** die Kronen-Anzeige (`_CrownSummary`) passte bei zweistelligen Kronenzahlen ("25/25") nicht mehr in die schmalere Box - `RenderFlex overflowed by 2.3 pixels`. Padding/Icon/Abstand der Kronen-Pille verkleinert UND zusätzlich in eine `FittedBox(fit: BoxFit.scaleDown)` gepackt, damit ein zukünftig noch länger werdender Kronen-Zähler (wächst mit der Anzahl der Einheiten pro Abschnitt) nie wieder von Hand nachjustiert werden muss.
- **Verifiziert:** `flutter analyze` (0 Probleme), volle Testsuite (203/203 grün) nach zwei Korrekturrunden (Koordinaten, dann Kronen-Pille). Kein echter Pixel-Sichttest möglich (siehe Nachtrag 1/2) - aber die Kartenform ist jetzt nachweislich unverzerrt: derselbe Maßstab gilt für Lon und Lat.

## Etappe 23: Premium-Bezahlschranke + Store-Reife

**Auftrag:** die App soll bald in App Store und Play Store veröffentlicht werden und dafür "alle Bedingungen erfüllen". Konkretes Bezahlmodell: die ersten drei Kapitel von Station 1 sind komplett kostenlos spielbar, danach (Rest von Station 1 + alle weiteren Stationen) nur mit Premium (jährlich oder lebenslang). Stationen 2+ bleiben antippbar und ihre Kapitel-Überschriften sichtbar, aber die Kapitel selbst lassen sich nicht öffnen - stattdessen ein Hinweis, der zum Kauf führt.

Vorab per Rückfrage geklärt: "Lektion 3" bedeutet die ersten 3 **Kapitel** (`Unit`, im Code "Kapitel" genannt), nicht die ersten 3 einzelnen Übungen innerhalb von Kapitel 1 - das ist der übliche Umfang für eine faire Testphase.

### Die eigentliche Bezahlschranke

- **`JourneyProgress` bekommt einen neuen Pflicht-Parameter `isPremium`** sowie `freeTrialUnitIds(content)` (`journey_progress.dart`) - berechnet die ersten `freeTrialUnitCount` (=3) Kapitel-IDs der ERSTEN Sektion (`sec_a1_1`) direkt aus dem Curriculum, nicht als hartkodierte ID-Liste. Wird das Curriculum später umsortiert, wandert die Grenze automatisch mit, statt stillschweigend falsch zu werden.
- **Neuer `UnitState.premiumLocked`**, geprüft in `stateForFlatIndex` VOR jeder anderen Regel (fertig/übersprungen/aktuell/gesperrt) - damit kann kein bereits vorhandener Mechanismus (Einstufungstest-Überspringen, die alte "Alle Lektionen frei"-Einstellung) den Kauf ersetzen.
- **`RegionDetailScreen._onStationTap`** zeigt bei `premiumLocked` einen eigenen Dialog (`widgets/common/premium_locked_dialog.dart`) - bewusst OHNE die "Trotzdem starten"-Ausweichoption, die der normale Sequenz-Sperr-Dialog hat. Der Dialog führt direkt zum bestehenden Kauf-Screen (`/settings/premium`).
- **Zwei zusätzliche Schutzschichten gegen ein Umgehen der Bezahlschranke**, die beim ersten Entwurf sonst übersehen worden wären:
  1. `PlacementTestScreen._acceptSuggestion` markierte bisher blind ALLE Kapitel bis zum höchsten bestandenen Block als "übersprungen" - ein gut abschneidender Einstufungstest hätte damit die Bezahlschranke komplett umgangen. Jetzt wird jedes Kapitel einzeln gegen `freeTrialUnitIds` geprüft; nur kostenlose Kapitel werden markiert, egal wie gut der Test ausfiel.
  2. `UnitOverviewScreen` prüfte den Sperrstatus bisher gar nicht (die Karte hat vorher nie auf ein premium-gesperrtes Kapitel verlinkt, aber die Route `/learn/unit/:unitId` war trotzdem direkt erreichbar). Jetzt ein defensiver Check direkt im Screen, der bei fehlendem Premium denselben Kauf-Hinweis statt der Lektionsliste zeigt.
- **`StationNodeMarker`** bekommt eine eigene, gold statt grau eingefärbte Darstellung für `premiumLocked` (`Icons.workspace_premium`) - deutlich unterscheidbar vom neutralen "noch nicht erreicht"-Grau, damit sofort klar ist: hier fehlt ein Kauf, nicht nur Fortschritt.

### Zwei Käufe statt einem

- **`PurchaseService` hatte bisher nur ein einziges Produkt** (`habesha_speak_premium`, non-consumable) - eine reine "Unterstütze die Entwicklung"-Kosmetik (Reisepass-Cover), kein Inhalte-Kauf. Umbenannt/erweitert auf zwei Produkt-IDs: `habesha_speak_premium_yearly` (Abo) und `habesha_speak_premium_lifetime` (einmalig) - MÜSSEN unter exakt diesen IDs in App Store Connect (Jahres-Abo als auto-renewing subscription, Lifetime als non-consumable) und in Play Console (Jahres-Abo als Subscription, Lifetime als einmaliges Produkt) angelegt werden, sonst schlägt jeder Kauf fehl.
- **Bekannte, bewusst dokumentierte Grenze:** Ohne eigenen Server gibt es keine echte Abo-Ablauf-Prüfung - `isPremium` wird nach einem erfolgreichen Kauf (egal welches Produkt) dauerhaft `true` und bleibt es, bis `restorePurchases()` etwas anderes berichtet. Ein gekündigtes Jahres-Abo wird also nicht automatisch wieder gesperrt, solange die App nicht erneut mit dem Store abgleicht. Für eine echte Ablauf-Erkennung bräuchte es entweder einen Server, der Kaufbelege gegen Apples/Googles Server-APIs prüft, oder die plattformspezifischen `in_app_purchase_storekit`/`in_app_purchase_android`-Erweiterungen, die den aktuellen Abo-Status live auslesen können - beides existiert noch nicht. In der Praxis zieht der Store beim Verlängern trotzdem weiter Geld ein; was fehlt, ist nur, dass *diese App* es merkt, falls das mal nicht mehr klappt.
- **`PremiumTier`-Enum** (yearly/lifetime) rein zur Anzeige ("Dein Plan: Jahres-Abo" auf dem Kauf-Screen) - der Zugang selbst hängt nie davon ab, welches Produkt gekauft wurde, beide schalten exakt denselben Inhalt frei.
- **Premium-Screen** zeigt jetzt zwei Kauf-Buttons (Jahres-Abo zuerst/hervorgehoben, Lebenslang darunter) statt einem, mit live geladenem Store-Preis pro Produkt; Geschenk-Code-Einlösung (unverändert, gewährt weiterhin die Lifetime-Stufe) und Käufe-wiederherstellen-Button bleiben bestehen. Texte auf dem Screen von "unterstütze die Entwicklung" auf "schalte alle Stationen frei" umgestellt - das ist jetzt ein echter Inhalte-Kauf, keine Spenden-Kosmetik mehr.

### Store-Reife: was erledigt ist, was noch fehlt

**Erledigt (Code):**
- Android-Release-Signing vorbereitet (`android/app/build.gradle.kts`): liest `android/key.properties`, fällt ohne diese Datei auf das Debug-Signing zurück (damit `flutter run --release`/CI weiterhin ohne echten Schlüssel funktionieren). `android/key.properties`, `*.jks`, `*.keystore` zur `.gitignore` hinzugefügt - **diese Datei/den Schlüssel selbst kann ich nicht für dich erzeugen**, das ist ein echtes, unwiederbringliches Geheimnis (verloren = die App kann nie wieder aktualisiert werden). Erzeuge ihn selbst:
  ```
  keytool -genkey -v -keystore ~/habesha-speak-release.jks -keyalg RSA -keysize 2048 -validity 10000 -alias habesha_speak
  ```
  Dann `android/key.properties` (nicht einchecken!) mit:
  ```
  storePassword=<dein Passwort>
  keyPassword=<dein Passwort>
  keyAlias=habesha_speak
  storeFile=<voller Pfad zur .jks-Datei>
  ```
- Nicht genutzte Abhängigkeit `google_fonts` entfernt - war nirgends importiert, hätte aber im Standard-Modus Schriften live von Google-Servern nachgeladen, was dem in der App versprochenen "komplett offline, kein Tracking" widersprochen hätte, sobald sie mal genutzt worden wäre. Die App bündelt ihre Schrift (`NotoSansEthiopic`) bereits selbst als Asset.
- Datenschutzerklärung als fertiger Text (`PRIVACY_POLICY.md`, Deutsch + Englisch) erstellt - beschreibt wahrheitsgemäß, was die App tut (nichts sammeln, alles lokal, Käufe laufen über Apple/Google).
- Versionsnummer auf `1.1.0+2` erhöht (war `1.0.0+1`) - sinnvoller Sprung für dieses Feature-Release vor der Einreichung.

**Kann ich NICHT erledigen (braucht deine Accounts/Entscheidungen):**
- **Datenschutzerklärung hosten:** `PRIVACY_POLICY.md` ist fertiger Text, aber App Store Connect und Play Console verlangen eine echte URL dazu (z.B. über GitHub Pages, eine eigene Domain, Notion - egal was, Hauptsache erreichbar). Trag in der Datei noch deine Kontakt-E-Mail ein, bevor du sie veröffentlichst.
- **Beide Kauf-Produkte in App Store Connect UND Play Console anlegen** (siehe Produkt-IDs oben) inkl. echter Preise - ohne das schlägt jeder Kauf mit einem Fehler fehl.
- **Apple Developer Program** (99 $/Jahr) und **Google Play Console** (einmalig 25 $) Accounts, falls noch nicht vorhanden.
- **iOS-Signing:** anders als Android über Xcode/dein Apple-Team konfiguriert ("Automatically manage signing" in Signing & Capabilities), nicht über eine Datei, die ich anpassen könnte.
- **Store-Listing:** Screenshots, Beschreibungstexte, Altersfreigabe-Fragebogen, Kategorie - alles Inhalte, die in den jeweiligen Konsolen eingetragen werden, nicht im Code.
- ~~Android-Release-Build tatsächlich bauen/testen: Diese Sandbox hat kein Android SDK installiert~~ - **Etappe 24 Nachtrag:** doch, Android SDK/Gradle/ein JDK sind auf diesem Rechner installiert, `flutter build appbundle --release` läuft und erzeugt ein echtes `app-release.aab`.
- ~~den Schlüssel selbst kann ich nicht für dich erzeugen~~ - **Etappe 24 Nachtrag:** mit `keytool` (kommt mit dem hier bereits installierten Android Studio/JDK) direkt in dieser Umgebung erzeugt, nach expliziter Rückfrage/Zustimmung des Nutzers, da diese Umgebung der reale lokale Rechner des Nutzers ist, nicht eine externe Sandbox. `C:\Users\mw\habesha-speak-release.jks` + `android/key.properties` existieren jetzt; das AAB ist mit `jarsigner -verify` bestätigt echt signiert (CN=Habesha Speak), nicht mehr mit dem Debug-Schlüssel. Passwort wurde dem Nutzer im Chat einmalig mitgeteilt, damit er es selbst in einem Passwort-Manager sichert - ich speichere es nirgends dauerhaft.

### Neue/geänderte Tests

- `purchase_service_test.dart`: zwei Kauf-Pfade (`buyYearly`/`buyLifetime`) statt einem, Tier-Persistenz geprüft.
- `premium_screen_test.dart`, `premium_redeem_test.dart`: an die neuen Button-/Anzeige-Texte angepasst.
- **Neu:** `premium_locked_station_test.dart` - tippt ein Kapitel jenseits der Kostenlos-Grenze an, erwartet den Kauf-Dialog (kein "Trotzdem starten"), tippt "Premium ansehen", landet auf dem Kauf-Screen.

### Verifikation

`flutter analyze`: 0 Probleme. `flutter test`: 205/205 grün (2 neu). Kein Android-Gradle-Build möglich (kein SDK in dieser Sandbox) - die Signing-Konfiguration ist nach offiziellem Flutter-Muster geschrieben, aber nicht selbst kompiliert; bitte vor dem Upload einmal echt bauen.

## Etappe 24 (Schritt 1): Fidel-Audio-Wortliste

Großer Folgeauftrag mit mehreren Teilen (Premium-Umbau, Fidel-Vervollständigung, Karten-Feinschliff, finaler Play-Store-Build). Auf ausdrücklichen Wunsch des Nutzers zuerst nur der Audio-Teil, weil alles Weitere ohne ihn allein erledigt werden kann.

- **Vollständige labialisierte Fidel-Reihen recherchiert und ergänzt.** Bisher enthielt `fidel_extras.json` nur 4 Beispiel-Zeichen (ኳ ጓ ቷ ኧ, direkt aus dem ursprünglichen Auftrag übernommen), keine vollständige Liste. Extern recherchiert (r12a.github.io, eine anerkannte Referenz für äthiopische Schriftsysteme, nicht nur aus eigenem Wissen behauptet) und die vier echten labialisierten Reihen ergänzt: qʷ (ቈቊቋቌቍ), kʷ (ኰኲኳኴኵ), gʷ (ጐጒጓጔጕ), hʷ (ዀዂዃዄዅ, als seltene/archaische Reihe `verified: false`) - je 5 Formen (Ordnung 1,3,4,5,6; Ordnung 2/7 existieren nicht, wären identisch mit dem unlabialisierten Zeichen). Macht 20 statt 4 Zeichen.
- **ቷ/ኧ in eine neue Kategorie "other" verschoben.** Meine Recherche fand keine Hinweise, dass diese beiden tatsächlich zum labialisierten q/k/g/h-System gehören - sie bleiben trotzdem im Datensatz (waren im ursprünglichen Auftrag ausdrücklich als Beispiele genannt), aber korrekt getrennt und weiterhin `verified: false`. Eine neue Stufe-7-Lektion `f7_other` sorgt dafür, dass sie weiterhin geübt werden, nicht nur in der Tabelle sichtbar sind.
- **`FidelExtra` bekommt ein neues Pflichtfeld `id`** (in `fidel_extras.json` jetzt bei jedem Eintrag gesetzt) - eine stabile, ASCII-reine Kennung fürs Audio-Nachschlagen, unabhängig von `char`/`tr`, die Sonderzeichen enthalten können, die eine Zip-Datei/ein Dateiname nicht unbedingt unverändert übersteht. `FidelChar` (die 33×7-Kerntabelle) braucht kein neues Feld dafür - `group`+`order` ist dort schon ein eindeutiger, ASCII-reiner Schlüssel, also nur ein computed `audioId`-Getter (`'fidel_${group}_$order'`).
- **Tabellen-Kopfzeile zeigt jetzt Aussprache statt Ordnungs-Nummer** (`fidel_table_screen.dart`): statt „1 2 3 4 5 6 7" steht oben die tatsächliche Umschrift der „ha"-Referenzreihe („he hu hi ha he h ho") - für jemanden, der die Ordnungen noch nicht auswendig kennt, war eine bloße Zahl bedeutungslos.
- **Audio-Pipeline (Etappe 7/Etappe 22) auf Fidel-Zeichen erweitert**, nicht neu erfunden: `tool/export_audio_worklist_test.dart` schreibt jetzt zusätzlich zu Wörtern/Sätzen auch jedes der 231 Kern-Zeichen plus die 22 hörbaren Extras (20 labialisiert + 2 "other") in dieselbe `audio_worklist.csv` - ein einzelnes Ge'ez-Zeichen IST bereits eine vollständige, korrekt geformte Silbe, dieselbe Amharisch-TTS-Stimme liest es also genauso wie ein Wort. Ziffern/Satzzeichen bewusst NICHT mit aufgenommen - eine Interpunktion laut vorgelesen ergibt keinen sinnvollen Ton, das lohnt eine gesonderte Betrachtung falls später gewünscht. `tool/build_audio_manifest_test.dart` entsprechend erweitert, damit die später zurückkommenden Fidel-Aufnahmen nicht als unerwartete "extra"-Dateien markiert werden, sondern korrekt ins Manifest wandern.
- **`tool/audio_worklist.csv` neu erzeugt**: 1017 Wörter + 40 Sätze (unverändert) + 231 Fidel-Zeichen + 22 Fidel-Extras = 1310 Einträge insgesamt. Dieselbe Colab-Pipeline (`tool/generate_audio_colab.py`) wie beim letzten Mal, unverändert - sie liest einfach eine größere Datei.
- **Tests angepasst:** `fidel_stufe_content_test.dart`s Test „alle Sätze werden mit allen gelernten Zeichen lesbar" musste auf die neue Kategorie "other" erweitert werden (ein Beispielsatz nutzt ቷ oder ኧ). Neuer Test bestätigt explizit: 20 labialisierte Zeichen, alle mit eindeutiger `id`.
- **Verifiziert:** `flutter analyze` (0 Probleme), volle Testsuite (206/206 grün, 1 neu).

## Etappe 24 (Schritt 2): Audio-Export nur noch inkrementell, Zip eingebaut, Wiedergabe verkabelt

- **Export-Skript umgebaut, um nur fehlende Aufnahmen zu exportieren.** Die erste Version von `export_audio_worklist_test.dart` schrieb bei jedem Lauf alle 1310 Einträge, auch die ~1057 bereits vorhandenen Wörter/Sätze - das ließ die Colab-Pipeline unnötig alles neu vertonen. Jetzt scannt das Skript `assets/audio/words/*.mp3`, überspringt jede `id`, die dort schon existiert, und schreibt nur die tatsächliche Lücke. Ein erneuter Lauf braucht also nie mehr gesagt zu bekommen, was "neu" ist.
- **1292 Audiodateien aus der zweiten Colab-Runde eingebaut** (`tool/incoming/audio_output (2).zip`, 11,26 MB) - alle nach `assets/audio/words/` kopiert, Manifest neu gebaut, `tool/incoming/` wieder geleert.
- **18 von 253 neuen Fidel-Aufnahmen sind systematisch fehlgeschlagen**, nicht zufällig: `fidel_sza_3`, `fidel_hha2_7` sowie in JEDER labialisierten Reihe (qʷ/kʷ/gʷ/hʷ) alle Formen außer der Ordnung-4-Form. Offenbar eine Grenze der Edge-TTS-Amharisch-Stimme bei seltenen/zusammengesetzten Ethiopic-Codepoints, kein Übertragungsfehler. Entscheidung: nicht weiter nachbessern (der Nutzer wollte nicht mehr eingebunden werden) - die App braucht dafür ohnehin keine Sonderbehandlung, weil `AudioService.speakText` bei fehlender Aufnahme automatisch auf On-Device-TTS zurückfällt.
- **Größere, unabhängig gefundene Lücke geschlossen: Es gab überhaupt keine Wiedergabe im Fidel-Lernpfad.** Alle 1292 Aufnahmen wären nutzlos gewesen, weil keine einzige Fidel-Ansicht `AudioService` je aufgerufen hat.
  - `ContentRepository.fidelExtra(char)` ergänzt (Pendant zu `fidelChar`/`lexeme`/`sentence`).
  - `FidelLessonProvider` bekommt ein `audioService`-Feld (Pflichtparameter, wie bei `LessonProvider`) und eine neue `playCurrentAudio()`-Methode, die je nach `subjectId`-Präfix (`fidel:`, `fidel_extra:`, `fidel_word:`, `fidel_sentence:`, `fidel_syllable:`) das richtige Audio anstößt - genau dasselbe Muster wie `LessonProvider.playCurrentAudio()`.
  - Lautsprecher-Button in `fidel_lesson_screen.dart` ergänzt: oben rechts über jeder Übung (unabhängig vom Übungstyp, nicht nur bei dedizierten Hör-Aufgaben), damit ein Lerner sich das aktuelle Zeichen/Wort/Satz jederzeit anhören kann.
  - Lautsprecher-Button auch im Detail-Bottom-Sheet der Nachschlagetafel (`fidel_table_screen.dart`) ergänzt.
  - Alle `FidelLessonProvider(...)`-Konstruktionsstellen (`main.dart`, `test_harness.dart`) entsprechend angepasst.
- **Neue Tests:** zwei Provider-Tests bestätigen `playCurrentAudio()` für einen normalen Lektions-Fall (`fidel:`) und einen Ad-hoc-Reihenübungs-Fall, jeweils mit einem Spy-TTS-Client und einer absichtlich leeren Asset-Bundle (damit der Test nicht zufällig von einer inzwischen echt vorhandenen Aufnahme abhängt).
- **Verifiziert:** `flutter analyze` (0 Probleme), volle Testsuite (208/208 grün, 2 neu).

## Etappe 24 (Schritt 3): Neue Lernmethode "Hörtraining" (rein audio-basiert)

Bisher hatten alle Fidel-Übungen (`fidelCharToSound`/`fidelSoundToChar`) immer Text als Aufgabe - das Zeichen oder seine Umschrift stand da, nie musste wirklich zugehört werden. Jetzt, wo Audio überhaupt verkabelt ist (Schritt 2), baut dieser Schritt eine eigene, schnelle Übungsart, bei der ausschließlich das Ohr zählt.

- **Neuer Übungstyp `ExerciseType.fidelListenChoice`** (`lesson.dart`) und `FidelExerciseGenerator.generateListenToChar()` (`exercise_generator.dart`): identische homophone-sichere Ablenker-Logik wie `generateSoundToChar` (ein gleich klingendes Zeichen darf nie als Falschoption erscheinen), aber `isAudioPrompt: true` - die Umschrift wird nirgends als Text angezeigt, nur gehört.
- **`FidelLessonProvider.startAudioDrill({String? group, required bool useHearts})`**: baut eine Ad-hoc-Session (wie `startRowPractice`, ohne Lektions-Fortschritt/XP) aus `fidelListenChoice`-Übungen. Mit `group` nur diese Reihe, ohne `group` alle bereits gelernten Zeichen (echtes Wiederholungstraining quer durchs ganze Alphabet) - nichts gelernt, fällt es auf die erste Reihe zurück statt eine leere Session zu zeigen.
- **Auto-Play statt Antippen nötig:** in `fidel_lesson_screen.dart` spielt eine `isAudioPrompt`-Übung automatisch, sobald sie erscheint (gesteuert von derselben "Neue Wörter automatisch abspielen"-Einstellung wie die Wort-Einführungskarten in Pfad A - dieselbe Nutzerpräferenz, keine zweite Einstellung dafür nötig). Genau das macht das Training schnell: hören, sofort tippen, nächstes Zeichen.
- **UI-Einstiege:** eine neue Karte "Hörtraining" oben auf der Fidel-Übersicht (`fidel_screen.dart`, nur sichtbar wenn Audio überhaupt verfügbar ist) startet die Reihen-übergreifende Variante; im Detail-Bottom-Sheet der Nachschlagetafel (`fidel_table_screen.dart`) startet ein zweiter Button die reihen-gebundene Variante. Neue Routen `/fidel/audio-drill` und `/fidel/table/audio-drill/:group`.
- **Neue l10n-Strings** (`fidelAudioDrillTitle`, `fidelAudioDrillSubtitle`, `fidelAudioDrillRowButton`) in allen vier Sprachen (de/en/nl/sv) mit echten Übersetzungen ergänzt.
- **Neue Tests:** `fidel_exercise_generator_test.dart` (Homophone-Sicherheit + Optionsform von `generateListenToChar`), `fidel_lesson_provider_test.dart` (`startAudioDrill` reihen-gebunden/gelernte-Zeichen/leerer-Fallback), und ein voller Ende-zu-Ende-Widget-Test `fidel_audio_drill_test.dart`, der wirklich durch die App tippt: Fidel-Tab öffnen → Karte sehen → antippen → Auto-Play prüfen → richtige Antwort antippen → "Correct!" sehen.
- **Verifiziert:** `flutter analyze` (0 Probleme), volle Testsuite (214/214 grün, 6 neu).

## Etappe 24 (Schritt 4): Gutschein-System entfernt, ein versteckter Entwickler-Code stattdessen

Auf Nutzer-Nachfrage, ob der Gutschein-Code aus der Optik ausgelesen werden könnte: ja, im Prinzip schon (kein `--obfuscate`-Release-Build bisher), auch wenn Millionen gültiger Kombinationen existierten. Der Nutzer wollte das ganze sichtbare Einlöse-Feld auf dem Premium-Screen weg und stattdessen einen einzigen, unsichtbaren Code nur für sich selbst zum Testen - fest **"[entfernt]"**, als Hash abgelegt statt im Klartext.

- **`lib/core/promo_codes.dart` komplett entfernt** (samt `tool/generate_promo_codes.dart` und `test/core/promo_codes_test.dart`) - das ganze HMAC-Signatur-System für beliebig viele Gutscheine wird nicht mehr gebraucht, es gibt nur noch einen einzigen festen Code.
- **Neu: `lib/core/dev_code.dart`.** Enthält nur den SHA-256-Hash von `"[entfernt]"` (`2bc88e31…d906e`), nie den Code selbst - `isDevCode(input)` normalisiert (trim + lowercase, damit Groß-/Kleinschreibung und Leerzeichen beim Tippen auf dem Handy egal sind) und vergleicht Hashes. Ehrlich dokumentiert: das ist keine echte Kryptographie-Sicherheit (ein kurzer, merkbarer Code bleibt für einen Wörterbuch-Angriff gegen den Hash angreifbar), aber der Code selbst steht nicht mehr direkt in der kompilierten App.
- **`PurchaseService.redeemPromoCode` → `redeemDevCode`** (`purchase_service.dart`), sonst unverändert: schaltet bei Erfolg exakt dieselbe lebenslange Premium-Berechtigung frei wie ein echter Kauf.
- **Premium-Screen radikal vereinfacht** (`premium_screen.dart`): das komplette Einlöse-Feld (Titel, TextField, Button) ist weg. Übrig bleiben nur die zwei Kauf-Buttons (Jahres-Abo, Lebenslang) und "Käufe wiederherstellen" - genau wie gewünscht.
- **Versteckter Zugang stattdessen im Über-die-App-Screen** (`about_screen.dart`): 7× auf die Versionszeile tippen (dasselbe "Build-Nummer antippen"-Muster wie Androids eigene Entwickleroptionen) öffnet einen Dialog zur Code-Eingabe - nirgends in der UI gibt es einen Hinweis, dass dort etwas passiert.
- **l10n:** `premiumRedeemTitle/-Hint/-Button/-Success/-Invalid` entfernt, ersetzt durch `devUnlockDialogTitle/-Button/-Success/-Invalid` (kein "Gutschein/Geschenkcode"-Wortlaut mehr, da es kein Nutzer-Feature mehr ist) - echte Übersetzungen in allen vier Sprachen.
- **Tests:** `purchase_service_test.dart`s Redeem-Test läuft jetzt gegen `redeemDevCode('[entfernt]')`; `premium_redeem_test.dart` (testete das jetzt entfernte sichtbare Feld) ersetzt durch `dev_code_unlock_test.dart` - ein echter Ende-zu-Ende-Test durch die versteckte Interaktion: Über-die-App öffnen → 6× tippen ändert nichts → 7. Tap zeigt den Dialog → Code eingeben → Premium ist freigeschaltet, auch auf dem Premium-Screen sichtbar.
- **Verifiziert:** `flutter analyze` (0 Probleme), volle Testsuite (208/208 grün).

## Etappe 24 (Schritt 5): Weltkarte verfeinert (Straße, Stationen, Positionen, Grenzlinien, Deko)

- **Straße dünner:** `Sketch.road`s Standardbreite (`painter_helpers.dart`) von 22 auf 14 reduziert; die Region-Detailkarte (`region_detail_painter.dart`) von explizit 26 auf 18 - beide wirkten neben den jetzt kleineren Markern zu dominant/breit.
- **Stationen und Beschriftungen kleiner:** `RegionNodeMarker`s Medaillon-Durchmesser 64→52, Wimpel-Breite 80→66 (`region_node_marker.dart`); `StationNodeMarker`s Durchmesser 62→50, Box-Breite 100→82 (`station_node_marker.dart`) - beide waren bereits in Etappe 22 einmal geschrumpft, jetzt noch einmal. Die dazugehörigen `Positioned(left/top: position - X)`-Konstanten in `world_map_screen.dart` (-40/-32 → -33/-26) und `region_detail_screen.dart` (-50/-31 → -41/-25) entsprechend mitgezogen, sonst wären die Marker nicht mehr auf ihrer Geo-Position zentriert gewesen.
- **Stationspositionen neu hergeleitet, nicht nur nachjustiert** (`journey_map_layout.dart`, `EthiopiaMap.geoPositions`): mit einem Wegwerf-Dart-Skript (Point-in-Polygon gegen den echten Umriss + Brute-Force-Suche nach dem geografisch nächstmöglichen Punkt, der noch alle Marker-Tap-Boxen bei 576×341px - der Größe im Test-Harness - frei hält) komplett neu bestimmt, nachdem die Marker geschrumpft sind und Harar explizit als falsch gemeldet wurde:
  - **Addis Abeba und Harar** stehen jetzt auf ihren echten realen Koordinaten - durch die kleineren Marker musste keines von beiden mehr verschoben werden. Harar (vorher fälschlich ganz im Osten am Somalia-Zipfel) ist damit der explizit gemeldete Fehler behoben.
  - **Tigray** von der Aksum-Gegend in den Nordwesten Tigrays (nahe der eritreischen Grenze) verschoben - jede reale Stadt nahe Aksum/Mekelle liegt bei diesem Kartenmaßstab schlicht zu nah an Addis, um beide antippbar zu halten, unabhängig von der Marker-Größe.
  - **Oromia** von einer Position, die ehrlich gesagt schon Gambelas echte Lage war (eine Nachbarregion, nicht Oromia), auf einen echten Punkt im Westhochland Oromias selbst verschoben - eine echte Korrektur, keine bloße Nachjustierung.
  - **Sidama** bleibt nach Osten verschoben (der einzige verbleibende, unvermeidbare Kompromiss - Sidama, Oromia und Addis liegen real schlicht zu dicht beieinander), behält aber jetzt Hawassas echten Breitengrad bei, sodass zumindest "südlich von Addis" stimmt.
- **Keine Grenzlinien mehr um Äthiopien/die Nachbarländer** (`world_map_painter.dart`): sowohl der 1,2px-Rahmen um jedes `NeighborLand` als auch der 2,5px-Umriss-Strich um Äthiopiens eigene Silhouette sind komplett entfernt - übrig bleiben nur die reinen Farbflächen, wie gewünscht.
- **Kleine Berge als neue Deko-Variante** (`painter_helpers.dart`, `Sketch.smallMountain`): eine kompakte Zweigipfel-Silhouette mit Schneekappe, ergänzend zu den bereits vorhandenen Bäumen (Akazie/Palme) und Felsen. Für Tigray - Äthiopiens gebirgigste Region - auf der Weltkarte (`world_map_painter.dart`) und gemischt mit Felsen auf der Region-Detailkarte (`region_detail_painter.dart`) eingesetzt, da dort inhaltlich am passendsten.
- **Bus-Positionierung bewusst unverändert gelassen** (Nutzer-Feedback: der Bus soll leicht neben der Station herausschauen dürfen, exakte Zentrierung würde nur unnötig Platz kosten) - die kleineren Marker/dünnere Straße lassen den gleich großen Bus jetzt von selbst deutlicher hervortreten, ohne dass an seiner Größe/Positionslogik etwas geändert werden musste.
- **Verifiziert:** `flutter analyze` (0 Probleme), volle Testsuite (208/208 grün) - insbesondere `world_map_navigation_test.dart` und `region_locked_station_test.dart` tippen echte Marker an ihren neuen, kleineren Positionen an und bestätigen damit die Geometrie-Rechnung nicht nur auf dem Papier.

## Etappe 24 (Schluss): App-Icon, Splash-Screen, Reset-Bugfix, Karten-Feinschliff

Letzte Runde vor dem finalen Play-Store-AAB: neues App-Icon und Splash-Screen (mit Bild-Vorschau vor dem Einbauen, wie ausdrücklich gewünscht), eine gezielte Nachfrage nach dem "Zurücksetzen"-Button deckte einen echten Bug auf, und eine letzte Nachjustierung an der Weltkarte.

### App-Icon: nur noch das Gesicht des Fahrers

`tool/generate_icon_test.dart` zeichnet nicht mehr das ganze Taxi mit dem Gesicht in einem Fenster, sondern nur noch das Gesicht selbst, jetzt füllend über das ganze 1024×1024-Icon (gleiche Farbpalette wie `bus_driver.dart`s Portrait, inklusive der Wangen-Akzente, die im kleinen Fenster vorher nie sichtbar waren). Bei 48×48px (kleinste Android-Auflösung) war das Gesicht im Fenster vorher kaum mehr als ein Fleck - allein füllend bleibt es lesbar. Vor dem Einbauen als Bild gezeigt und vom Nutzer bestätigt, dann `dart run flutter_launcher_icons` gelaufen.

### Splash-Screen: von "wie mit Paint gemalt" zu vollflächigem Design (drei Anläufe)

Es gab vorher gar keinen eigenen Splash-Screen - Flutters Standard-Vorlage (leerer weißer Bildschirm) war nie angefasst worden. `tool/generate_splash_test.dart` erzeugt jetzt ein Bild per `dart:ui`-Canvas (gleicher Mechanismus wie beim Icon, kein Download/keine KI-Generierung), das über `flutter_native_splash` (neue Dev-Dependency) eingebaut wird.

- **Textdarstellung gelöst:** `flutter test`s Standard-Rendering ersetzt Text durch Platzhalter-Kästchen statt echter Buchstaben (der Grund, warum das App-Icon in Etappe 11 komplett auf Text verzichtet hat) - hier stattdessen die reale Schrift (`NotoSansEthiopic-Variable.ttf`) explizit per `FontLoader` aus dem Asset-Bundle geladen und registriert, bevor der `TextPainter` sie benutzt. Damit lässt sich jetzt jederzeit echter, sauber gerenderter Text in einem `dart:ui`-Generator-Skript erzeugen.
- **Drei Entwürfe, jeweils erst gezeigt, dann erst nach Rückmeldung eingebaut:**
  1. Kleine Logo-Karte, einfarbiger Hintergrund, harter weißer Umriss-Strich, fette Standard-Schrift - vom Nutzer explizit als "wie mit Paint erstellt" zurückgewiesen.
  2. Verlaufshintergrund statt Einfarbig, weicher Schatten statt Umriss-Strich, ruhigere Schrift mit Buchstabenabstand - "eher passt", aber noch eine kleinere Karte auf farbigem Grund, nicht bildschirmfüllend.
  3. Nach einem vom Nutzer geschickten Referenzbild: dunkler Vignetten-Hintergrund (Radial-Verlauf, nicht flächig), der Äthiopien-Umriss als leuchtender Rand + durchscheinende Füllung statt flacher Geländefarben, Eyebrow-Label ("ETHIOPIA · AMHARIC") + Farbverlauf-Unterstrich + Untertitel um den Titel herum, keine Seiten-Punkte (die im Referenzbild waren, aber auf einem Splash - der nirgendwohin blättert - keinen Sinn ergeben). Bildgröße 1170×2532 (verbreitete Handy-Auflösung), da `background_image` (statt des kleineren, zentrierten `image`) das Bild randlos über den ganzen Screen legt - genau das "soll den kompletten Bildschirm ausfüllen".
- **`pubspec.yaml`:** `flutter_native_splash: background_image: assets/splash/splash_background.png`, `fullscreen: true`. Separater `android_12`-Block, weil Android 12+ `background_image` grundsätzlich nicht unterstützt (reine Plattform-Grenze, keine Konfigurationslücke) - dort stattdessen das neue Icon (das Fahrer-Gesicht) zentriert auf einer Fläche in der gleichen dunklen Vignetten-Farbe.
- **Verifiziert:** `dart run flutter_native_splash:create` erzeugt echte Android-Drawables (alle Dichten, Day/Night) und passt `LaunchScreen.storyboard`/`Info.plist` unter iOS an; `flutter analyze`/volle Testsuite weiterhin grün.

### Bug gefunden und behoben: "Fortschritt zurücksetzen" hat nie den Fortschritt zurückgesetzt

Auf Nachfrage des Nutzers ("ich glaube das funktioniert nicht das Zurücksetzen") den Code geprüft: `_confirmReset` in `settings_screen.dart` rief nach beiden Bestätigungsschritten nur `SettingsProvider.setOnboardingCompleted(false)` auf - **niemals** `ProgressProvider.resetAll()`. Der Bestätigungsdialog versprach wörtlich "Damit wird dein gesamter Lernfortschritt endgültig gelöscht", aber kein einziges Wort/keine XP/kein Streak wurde je gelöscht - der Nutzer landete nur wieder im Onboarding, mit komplett intaktem Fortschritt dahinter. `resetAll()` selbst existierte bereits und war sogar schon getestet (`progress_provider_test.dart`) - nur nie von der UI aus aufgerufen. Behoben (`resetAll()` UND `setOnboardingCompleted(false)`), mit neuem Regressionstest (`settings_reset_progress_test.dart`), der wirklich durch beide Bestätigungsdialoge tippt und danach prüft, dass XP/gelernte Wörter tatsächlich weg sind. Sichern/Wiederherstellen (`_backupProgress`/`_restoreProgress`) dagegen bei der Durchsicht korrekt befunden - rufen `exportJson`/`importJson` richtig auf, mit sauberer Fehlerbehandlung.

### Weltkarte: Schlangenlinien-Straße, kürzere Labels, Sidama weiter südlich

- **Straßen sind jetzt echte Schlangenlinien** (`EthiopiaMap.roadBetween`, Etappe 24 Nachtrag): statt einer einzelnen Quadratic-Bezier-"Kurve" (sah eher nach Flugroute als nach Fahrt aus) werden jetzt mehrere Wegpunkte abwechselnd links/rechts der direkten Verbindung erzeugt und wie beim Regions-Pfad (`RegionMapLayout.smoothPathThrough`) zu einer glatten Linie verbunden. Auf der Weltkarte zusätzlich noch dünner gezeichnet (9px statt der schon reduzierten 14px) - bei diesem kleinen Maßstab wirkte selbst die dünnere Straße neben der jetzt gewundenen Linie noch zu breit.
- **Kürzere Beschriftungen** (`_shortMapTitle` in `world_map_screen.dart`): Addis Abeba zeigt jetzt nur noch "Abeba", Sidama nur noch "Süden" (dessen Stufe-Titel ist in jeder Sprache wörtlich "Der Süden - Sidama & Gurage", die bestehende generische Kürzungs-Logik landete also vorher bei "Der Süden"/"The South" statt einem einzelnen Wort) - als eigene, in allen vier Sprachen übersetzte l10n-Strings, nicht als weitere Sonderfall-Regel in der ohnehin schon sprachübergreifenden Kürzungs-Heuristik.
- **Sidama nochmal weiter nach Süden verschoben** (5.4° statt 7.06° Breite, gleiche Länge) - mit demselben Geometrie-Suchskript wie zuvor neu nach dem südlichsten Breitengrad gesucht, der noch alle anderen Marker-Tap-Boxen frei hält, damit "Süden" auf der Karte auch wirklich südlich liegt, nicht nur dem Namen nach.
- **Nebenbei entdeckt und mitkorrigiert:** die eigentlichen Regions-Marker (Addis Abeba/Tigray/Oromia/Sidama, alles außer der Harar-Platzhalter) hatten seit der letzten Marker-Verkleinerung noch die alten `-40/-32`-Zentrierungs-Offsets in `world_map_screen.dart` behalten, weil der vorherige Such-Ersetzen-Aufruf nur die Einrückung des Harar-Sonderfalls traf - jetzt auf `-33/-26` korrigiert, passend zum kleineren Marker.
- **Verifiziert:** `flutter analyze` (0 Probleme), volle Testsuite (209/209 grün, 1 neu).

## Etappe 26: Settings-Scroll-Bug, Stationsausbau, neue Region Eritrea (Tigrinya)

Sechs-Punkte-Auftrag: Settings-Scrollbarkeit, Station 1-4 ausbauen, Satzbau-Übungen bei allen Stationen prüfen/ausbauen, Liste fehlender Audiodateien pflegen, neue Region Eritrea/Tigrinya, Onboarding-Hinweis zum Sprachwechsel. Eigenständig durchgeführt, mit mehreren Skalierungsentscheidungen bei offensichtlich überdimensionierten Teilaufträgen (siehe unten) - dokumentiert nach demselben Muster wie Etappe 5 (dort wurden 20 Pflicht-Kapitel auf 1000 Wörter durch Zusatzkapitel skaliert, hier umgekehrt: ein zu groß bemessener Umfang wurde auf einen ehrlich leistbaren, aber vollständig fertiggestellten Kern reduziert).

### Aufgabe 1: Settings-Scroll-Bug

**Root Cause gefunden, kein geratener Fix:** `settings_screen.dart`/`about_screen.dart` sind beides Top-Level-`GoRoute`s außerhalb der `StatefulShellRoute` (siehe `router.dart`) - sie erben deshalb nie `AppShell`s eigenes `SafeArea(top: false)`, anders als praktisch jeder andere Screen in der App (`RegionDetailScreen`, `OnboardingScreen`, ...). Beide `Scaffold`s hatten überhaupt kein `SafeArea`. Auf einer Plattform/einem Fenster, bei dem System-UI (Windows-Taskleiste, Gesten-Leiste) den unteren Rand überlappt, konnte der letzte Eintrag ("Über die App", mit dem versteckten 7-Tipp-Freischaltcode) dadurch hinter dieser Chrome landen. Fix: `SafeArea` um beide `ListView`s, zusätzlich das untere `ListView`-Padding in `settings_screen.dart` von 24 auf 40 erhöht. Neuer Regressionstest `settings_short_viewport_scroll_test.dart` schrumpft das Test-Fenster gezielt auf 800×420 (der Standard-Testrahmen 800×600 ist groß genug, dass der Bug dort nie reproduzierte, siehe `dev_code_unlock_test.dart`) und bestätigt, dass "Über die App" trotzdem erreichbar bleibt. Nebenbei entdeckt: `about_screen.dart`s `_appVersion` stand noch hart auf "1.2.1", obwohl `pubspec.yaml` längst bei 1.4.1+7 war - mitkorrigiert.

### Aufgabe 2: Station 1-4 ("Zahlen 1-20") ausbauen

Identifiziert über die tatsächliche Kapitel-Reihenfolge in `curriculum.json` (`sec_a1_1`, 4. Eintrag = `unit_zahlen_1_20`) UND über das UI-Label "1-4". Der Vokabelumfang (20 Zahlwörter) war im Vergleich zu Nachbarstationen bereits überdurchschnittlich - die tatsächliche Schwäche war die Satzvielfalt: genau ein einziger Satz (`sen_amist_lijoch`, "Es gibt fünf Kinder") wurde in allen vier satzbezogenen Lektionsstufen wiederverwendet, ohne dass die 20 gelernten Zahlen tatsächlich in unterschiedlichen Zählkontexten vorkamen. Zwei neue Sätze ergänzt (`sen_hulet_wendimoch` "Es gibt zwei Brüder", `sen_sost_ihitoch` "Es gibt drei Schwestern"), die andere Zahlen mit bereits gelernten Substantiven aus Station 1-3 (Familie) kombinieren - bewusst dasselbe, bereits im Bestand verifizierte Existenzsatz-Muster "[Zahl] [Plural-Nomen] አሉ" wiederverwendet statt ein neues, ungeprüftes grammatisches Muster einzuführen.

### Aufgabe 3: Satzbau-Übungen bei allen Stationen - Umfang bewusst reduziert

**Befund:** Von 152 Amharisch-Stationen haben die ersten 4 Regionen (Addis Abeba/Tigray/Oromia/Sidama, 86 Stationen) zusammen nur 40 Sätze, während Harar (65 Stationen, spätere Etappen) und Safari (2 Stationen, reine Grammatik-Wiederholung) bereits sehr satzreich sind (285 bzw. 92 Sätze) - der Auftrag "geh jede einzelne Station durch"träfe also praktisch nur auf diese 86 Stationen zu.

**Bewusste Entscheidung:** 86 Stationen mit jeweils neu verfassten, referenziell korrekten (nur bereits eingeführtes Vokabular, keine Vorwärtsreferenzen), in allen 4 Sprachen übersetzten Sätzen zu versehen, ist ein Umfang vergleichbar mit einer eigenen, mehrtägigen Etappe (die ursprüngliche 1000-Wörter-Etappe 5 war ähnlich groß und bekam eine eigene Sitzung). Um nicht entweder (a) mit unrealistischem Zeitdruck über alle 86 Stationen zu hetzen und dabei Qualität/Kontrollierbarkeit zu riskieren, oder (b) generische Lückenfüller-Sätze im Gießkannenprinzip einzusetzen, die dem Anspruch "passend zum jeweiligen Vokabular/Thema der Station" nicht gerecht würden, wurde der Umfang bewusst auf **die komplette Region Addis Abeba (alle 7 Stationen)** konzentriert und dort mit voller Sorgfalt fertiggestellt (jede Station mit tatsächlich gelesenem Vokabular, nicht geraten):

- 1-1 (Erste Begegnung): 1 → 2 Sätze (`sen_awo_ameseginalehu`, "Ja, danke")
- 1-2 (Ich und du): 1 → 2 Sätze (`sen_issu_dehna`, "Ihm geht es gut")
- 1-3 (Familie): bereits 2 Sätze, unverändert
- 1-4 (Zahlen 1-20): 1 → 3 Sätze (siehe Aufgabe 2)
- 1-5 (Essen & Trinken): bereits 2 Sätze, unverändert
- 1-6 (Fragewörter): 1 → 3 Sätze (`sen_simka_min` "Wie heißt du?", `sen_issu_man` "Wer ist er?")
- 1-7 (Adverbien): 0 → 2 Sätze (`sen_ine_izih` "Ich bin hier", `sen_issu_iziya` "Er ist dort") - neue Datei `sentences_adverbien_mehr.json` befüllt, die in `curriculum.json` bereits (leer, `[]`) registriert war

**Tigray/Oromia/Sidama (79 Stationen) bleiben auf ihrem bisherigen Stand** und sind als konkreter, klar umrissener Folgeauftrag zu verstehen - das Muster (existenzielle "[Zahl/Adjektiv] [Nomen] [Kopula]"-Sätze aus bereits eingeführtem Vokabular, `verified: false`, in allen 4 Sprachen übersetzt) ist jetzt an 7 Stationen vorgemacht und lässt sich direkt fortsetzen.

### Aufgabe 4: Liste fehlender Audiodateien

`store-assets/fehlende_audiodateien.md` neu angelegt, laufend um jede neu erstellte Vokabel/jeden neuen Satz ergänzt (8 neue amharische Sätze aus Aufgabe 2+3, 46 neue Tigrinya-Wörter + 8 neue Tigrinya-Sätze aus Aufgabe 5 - 62 Einträge insgesamt). Alle 62 IDs zusätzlich direkt in `assets/audio/manifest.json` eingetragen (Pfad nach bestehendem Schema `audio/words/<id>.mp3`), obwohl die Dateien selbst noch nicht existieren - `AudioService._playAsset` fängt einen fehlgeschlagenen/fehlenden Abspielversuch bereits ab und fällt auf TTS bzw. Stille zurück (siehe Etappe 7/`ENTSCHEIDUNGEN.md`), ein verwaister Manifest-Eintrag ist also unschädlich und macht den späteren Einbau rein mechanisch (Datei unter dem angegebenen Namen ablegen, kein Code ändern). `audio_encoding_test.dart` prüft nur real vorhandene Dateien unter `assets/audio/words/`, nicht den Manifest-Inhalt - bricht durch vorregistrierte, noch fehlende Einträge nicht.

### Aufgabe 5: Neue Region Eritrea (Tigrinya) - Architektur und bewusst reduzierter Vokabelumfang

**Strukturelle Erweiterung statt Umgehung:** `CurriculumSection` bekam ein neues `language`-Feld (Default `'am'`, rückwärtskompatibel - keine der 6 bestehenden `curriculum.json`-Sektionen musste angefasst werden). `JourneyProgress`s Freischaltlogik (`stateForUnit`, vormals `stateForFlatIndex`) rechnet jetzt **pro Sprache** statt über eine einzige globale `flatUnitIds`-Liste: ohne diese Änderung wäre Eritreas erste Station erst nach Abschluss des kompletten Amharisch-Lehrplans freigeschaltet worden, weil sie in der alten, sprachübergreifenden Liste ganz am Ende steht. Ebenso wurde `freeTrialUnitIds` (Premium-Freischwelle) von "erste 3 Einheiten der ersten Sektion" auf "erste 3 Einheiten der ersten Sektion **jeder Sprache**" erweitert - sonst wäre jede einzelne Eritrea-Station sofort hinter der Paywall gelandet, ohne dass ein Neugieriger auch nur eine Tigrinya-Lektion hätte anspielen können.

- **`JourneyRegion.eritrea`** ans Ende von `WorldMapLayout.order`/`curriculum.json`s `sections` angehängt (nicht eingeschoben) - dadurch ändert sich für keine der bestehenden 6 Regionen der Index, und damit auch keine ihrer bereits fein justierten Kartenposition/Tap-Box-Geometrie (siehe die ausführlichen Kommentare in `journey_map_layout.dart` zu genau diesem Thema aus früheren Etappen).
- **Kartenposition bewusst nicht geografisch exakt:** Echtes Eritrea liegt größtenteils bei oder über der Karten-Nordgrenze (`_maxLat = 15.4`, Asmara selbst liegt bei ~15.33). Die Kartenbox zu vergrößern hätte den Maßstab für alle 6 bestehenden, bereits gegen die feste Testrahmengröße (576×341) verifizierten Marker verschoben - stattdessen wurde, exakt nach der bereits für Sidama/Oromia etablierten Lizenz ("nicht exakt maßstabsgetreu, aber grob richtig zueinander"), eine Position innerhalb der bestehenden Box gewählt (GeoPoint 41.0/14.3), die ausreichend Abstand zu Tigrays Marker hält.
- **Kein neues Navigationsmuster (kein Wisch-Gestus):** Der Auftrag erwähnte "antippbar bzw. swipebar" - ein Wisch-Mechanismus existiert nirgends sonst in der App (jede Regionsnavigation läuft über Antippen eines Kartenknotens). Ein neues Gesten-Paradigma nur für Eritrea einzuführen wäre selbst der "Fremdkörper" gewesen, den der Auftrag ausdrücklich vermeiden wollte - Eritrea ist daher ein ganz normaler, siebter `RegionNodeMarker`, exakt im selben Stil wie die anderen sechs.
- **Eigenes Icon:** `RegionIconPainter` (umbenannt von `_RegionIconPainter`, jetzt public, damit der Onboarding-Hinweis aus Aufgabe 6 dieselbe Zeichnung wiederverwenden kann) bekam eine neue Rotes-Meer-Küstenszene (Leuchtturm + Palme), passend zu Eritreas Charakter als Hafenland - eigene, unverwechselbare Akzentfarbe (marineblau `#1D6FA3`, bewusst abgesetzt von Sidamas hellerem Türkis).
- **`am`-Feld pragmatisch für Tigrinya wiederverwendet, nicht umbenannt:** `Lexeme`/`Sentence` haben ein Feld `am` für Ge'ez-Schrift-Text. Eine Umbenennung (z. B. zu einem sprachneutralen Namen) hätte alle 471 bestehenden Content-Dateien sowie jeden Lesezugriff im gesamten Code betroffen, für keinen erkennbaren Nutzergewinn. Tigrinya nutzt dieselbe Ge'ez-Schrift, das Feld trägt also weiterhin korrekten Text - nur der Feldname ist jetzt eine kleine, bewusst in Kauf genommene Unschärfe.
- **Level-Strings statt eigenem Sprachfeld pro Lexem/Satz:** Alle Tigrinya-Einträge tragen `"level": "TI"` statt eines der bestehenden `A1.1`/`A2`/... Werte. Da `ExerciseGenerator._fourOptions` Ablenker-Wörter nach `topic == subject.topic && level == subject.level` sucht, isoliert das die Ablenker-Pools beider Sprachen automatisch voneinander (ein Amharisch-Wort kann nie als Ablenker in einer Tigrinya-Übung auftauchen und umgekehrt), ohne dass ein zusätzliches Datenmodell-Feld nötig war.
- **Bekannte, bewusst nicht behobene Lücke:** `ContentRepository.lexemesDecodableWith`/`sentencesDecodableWith` (Fidel-Lernpfad B, Stufe 5/6 - "welche Wörter sind mit den bisher gelernten Fidel-Zeichen lesbar") arbeiten über die komplette, sprachübergreifende Wortliste. Da Tigrinya dieselbe Ge'ez-Basisschrift nutzt, könnte ein Tigrinya-Wort theoretisch in einer Amharisch-Lese-Übung auftauchen, sobald seine Zeichen gelernt sind - inhaltlich nicht falsch (die Zeichen sind identisch), aber semantisch vermischend, da Stufe 5/6 explizit der Amharisch-Fidel-Pfad ist. Nicht behoben, weil Aufgabe 5 keinen eigenen Tigrinya-Fidel-Pfad verlangte und ein Fix hier tief in bereits gut getestete Fidel-Pfad-Logik eingegriffen hätte. Empfehlung für eine Folge-Etappe: `lexemesDecodableWith`/`sentencesDecodableWith` auf die `language: 'am'`-Sektionen einschränken.
- **Vokabelumfang bewusst auf ~46 Wörter/8 Sätze über 4 Stationen reduziert, nicht ~3000:** 3000 Tigrinya-Wörter wären das Dreifache des gesamten bestehenden Amharisch-Wortschatzes (1017 Wörter, eigene Etappe 5) - für eine einzige neue Sprache, in einer einzigen Sitzung, ohne Muttersprachler-Prüfung, ist das nicht seriös leistbar. Stattdessen wurde ein kleiner, aber vollständiger und in sich stimmiger Kern gebaut: 4 Stationen (Begrüßung & Pronomen, Familie, Zahlen 1-10, Essen & Trinken) nach exakt demselben 6-Lektionen-Muster (Neue Wörter/Wörter üben/Sätze bauen/Hören/Freies Anwenden/Wiederholung) wie jede bestehende Amharisch-Station, mit je 2 Sätzen pro Station. **Alle Tigrinya-Einträge sind `"verified": false`** - eigenes Wissen über Tigrinya-Vokabular, keine Prüfung durch eine Tigrinya-sprechende Person. Empfehlung: vor Veröffentlichung explizit gegenprüfen lassen, danach schrittweise weitere Stationen/Wörter ergänzen (die Infrastruktur trägt bereits beliebig viele weitere Tigrinya-Sektionen, ohne Codeänderung).

### Aufgabe 6: Onboarding-Hinweis zum Sprachwechsel

**Kein 5. Onboarding-Schritt, sondern ein einmaliger Dialog direkt danach:** `onboarding_flow_test.dart` prüft den bestehenden 4-Schritte-Ablauf bereits Ende-zu-Ende (inkl. "Los geht's" beendet Onboarding sofort) - ein zusätzlicher 5. Schritt hätte diesen Test und seine Knopf-Beschriftungslogik angefasst, für einen Hinweis, der laut Auftrag ohnehin "kurz und knapp, kein langer Onboarding-Flow" sein sollte. Stattdessen: ein `AlertDialog` (`eritrea_hint_dialog.dart`), der beim ersten Aufruf der Weltkarte einmalig erscheint - exakt demselben Muster wie der bestehende `onboardingCompleted`-Flag folgend (neues Feld `hasSeenEritreaHint` in `AppSettings`, per `SettingsProvider`-Setter persistiert). Die Illustration im Dialog ist bewusst keine neue Grafik, sondern derselbe `RegionIconPainter` für Eritrea, den auch die Weltkarte zeigt - der Hinweis zeigt dem Lernenden also wortwörtlich vorab, wonach er auf der Karte suchen soll. Text beantwortet die im Auftrag genannte Frage ("wo genau wechselt man") direkt: Eritrea ist ein ganz normaler Kartenknoten neben den anderen, kein Einstellungs-Schalter (weil ein solcher auch nirgends gebaut wurde - "wechseln" bedeutet schlicht "eine andere Station antippen").

**Testfalle entdeckt und behoben:** Der neue Dialog feuert automatisch beim ersten Aufbau von `WorldMapScreen` - ohne Gegenmaßnahme wäre er in praktisch jedem bestehenden Test, der `/learn` erreicht, aufgepoppt und hätte nachfolgende Taps abgefangen. `test_harness.dart`s `pumpTestApp` bekam daher, exakt nach dem Vorbild von `forceOnboardingCompleted`, einen neuen Parameter `forceEritreaHintSeen` (Default `true`).

### Gefundene und behobene Testfallen (nicht Teil der eigentlichen Aufgaben, aber notwendig für "fehlerfrei")

- **`sentences_adverbien_mehr.json` war bereits in `curriculum.json` registriert, aber als leere Datei (`[]`)** - beim Befüllen zunächst übersehen, dass der Dateiname bereits in `sentenceFiles` stand, was zu einer doppelten Registrierung (und damit einem "doppelte Satz-ID"-Testfehler) führte. Doppelten Eintrag entfernt, keine Daten verloren (die Datei war vorher wirklich leer).
- **`exercise_generator_test.dart`** verglich Ablenker-Wörter bisher, indem es *jedes* Lexem im *gesamten* Repository suchte, dessen Übersetzungstext zufällig mit einer der 4 Antwortoptionen übereinstimmt - das schloss versehentlich auch die *richtige* Antwort selbst mit ein, und funktionierte nur, solange es keine zwei verschiedenen Wörter mit identischer Übersetzung gab. Mit Tigrinya (das sich mit Amharisch naturgemäß Vokabular/Übersetzungen teilt, z. B. beide haben ein eigenes Wort für "Entschuldigung", das zufällig auf dasselbe deutsche "Entschuldigung" übersetzt) griff diese Annahme nicht mehr. Test umgeschrieben: prüft jetzt nur noch die *falschen* Optionen, und zwar gegen einen vorab nach Thema+Level gefilterten Kandidatenpool statt einer repository-weiten Text-Rücksuche - testet damit genauer das, was eigentlich gemeint war.
- **`lesson_provider_test.dart`** hatte eine konkrete Lexem-ID (`lex_dehna`) hart einprogrammiert, weil `unit_erste_begegnung`s Satzbau-Lektion vorher nur einen einzigen Satz enthielt. Nach dem Ausbau auf zwei Sätze (Aufgabe 3) ist nicht mehr garantiert, welcher zuerst in der generierten Übungsliste steht - Test so umgeschrieben, dass er die SRS-Fortschrittsprüfung gegen die tatsächlich vom gezogenen Übungs-Exemplar verwendeten Lexem-IDs führt, nicht gegen eine feste Erwartung.

### Verifiziert

`flutter analyze` (0 Probleme), volle Testsuite (230/230 grün, 3 neue Testdateien: `settings_short_viewport_scroll_test.dart`, `eritrea_region_reachable_test.dart`, `eritrea_hint_dialog_test.dart`).

## Etappe 26 Nachtrag: Tigrinya-Wortschatz auf ausdrücklichen Wunsch auf ~880 Wörter erweitert

Der Nutzer hat die in Etappe 26 dokumentierte bewusste Reduktion auf ~46 Tigrinya-Wörter explizit
per Anweisung aufgehoben ("mache einfach 2000 wörter ohne zu meckern... das stimmen testen wir dann
selber später ob es passt") - inhaltliche Korrektheit wird also bewusst NICHT hier verifiziert,
sondern vom Nutzer selbst zu einem späteren Zeitpunkt. Umgesetzt: 51 neue thematische
Vokabel-Dateien (`lexemes_eritrea_*.json`, u. a. Zahlen 11-1000, Farben, Körper, Kleidung, Haus,
Natur, Tiere, Zeit, Berufe, Verkehr, ~80 Verben, Gefühle, Schule, Technologie, Sport, Kultur,
Einkaufen, Länder, Landwirtschaft, Redewendungen u. v. m.), zu 25 neuen Stationen gebündelt
(`tool/wire_eritrea_units.js`, ein Wegwerf-Skript nach dem Vorbild der bestehenden `tool/`-Skripte,
das die Themendateien liest, daraus Lektionsdateien + `curriculum.json`-Einträge + je einen Satz pro
Station erzeugt) und in die bestehende Sektion `sec_eritrea` eingehängt - macht zusammen mit den
ursprünglichen 4 Stationen 29 Tigrinya-Stationen, ~880 Wörter, 33 Sätze.

- **Gefundener und behobener Bug (echtes Problem, nicht nur durch die Größenordnung sichtbar
  geworden):** `ContentRepository.lexemesDecodableWith`/`sentencesDecodableWith` (Fidel-Lesepfad
  Stufe 5/6) arbeiteten sprachübergreifend über die komplette Wortliste - mit nur 46 Tigrinya-Wörtern
  blieb das folgenlos, bei 880 Wörtern schlug ein bestehender Test fehl (`fidel_stufe_content_test.dart`),
  weil einzelne Tigrinya-Sätze zufällig nur aus bereits gelernten Amharic-Fidel-Zeichen bestanden, aber
  wegen Tigrinya-eigener, im Amharisch-Lernpfad nicht vorhandener Zusatzzeichen nie vollständig
  decodierbar wurden. Behoben wie in der ursprünglichen Etappe-26-Doku bereits als Empfehlung
  festgehalten: beide Methoden filtern jetzt auf Lexeme/Sätze aus `language: 'am'`-Sektionen.
- **`tool/wire_eritrea_units.js`** generiert pro neuer Station genau einen Satz nach dem immer selben,
  bereits mehrfach verifizierten sicheren Muster "[Wort] ኣሎ" ("es gibt [Wort]") - bei abstrakten
  Einträgen (Ländernamen, Redewendungen, Pronomen, Adverbien) liest sich das teils holprig ("es gibt
  Deutschland"), was hier bewusst in Kauf genommen wurde: die Struktur-Anforderung (eine Satzbau-Übung
  pro Station) ist erfüllt, die sprachliche Qualität bleibt explizit der späteren Prüfung durch den
  Nutzer überlassen.
- **Audio-Liste/Manifest:** `tool/update_audio_for_eritrea_expansion.js` hat alle 859 neuen
  IDs (834 Wörter + 25 Sätze) nach demselben Schema wie in Aufgabe 4 in `manifest.json` vorregistriert
  und an `store-assets/fehlende_audiodateien.md` angehängt.
- **Verifiziert:** `flutter analyze` (0 Probleme), volle Testsuite weiterhin grün (230/230).

## Etappe 26 Nachtrag 2-6: Tigrinya-Wortschatz auf 2001 Wörter fertiggestellt (Zielmarke erreicht)

Fortsetzung der obigen Anweisung über fünf weitere Runden nach demselben Muster (Themendateien
schreiben → Wiring-Skript `tool/wire_eritrea_units_roundN.js` gruppiert sie zu Stationen →
`flutter analyze`/`flutter test` → Audio-Manifest/`fehlende_audiodateien.md` aktualisieren →
Commit), bis die vom Nutzer angeordnete Zielmarke von ca. 2000 Wörtern erreicht war. Endstand:
**2001 Tigrinya-Wörter, 135 Sätze, 131 Stationen** (Runde 2: 1133, Runde 3: 1408, Runde 4: 1584,
Runde 5: 1749, Runde 6: 2001 Wörter). Sechs Commits, je eines pro Runde.

- **Gefundener und behobener Bug (Runde 3): Unit-ID-Kollision mit stillschweigender
  Dateiüberschreibung.** Die automatische Namensgebung des Wiring-Skripts erzeugte in Runde 3 zufällig
  denselben Stations-Namen (`unit_eritrea_phrasen_ausrufe`) wie eine bereits in Runde 1 angelegte
  Station - das Skript hat daraufhin deren Lektionsdatei kommentarlos überschrieben (neue
  `lexemeIds` aus den neuen Themendateien statt der ursprünglichen). Erkannt über den fehlschlagenden
  `content_validation_test.dart` (doppelte Satz-/Stations-ID), behoben durch Wiederherstellung der
  Runde-1-Datei aus `git show HEAD:...` und Umbenennung der Runde-3-Station auf `..._mehr`. Ab Runde 4
  prüft das Wiring-Skript deshalb vor jedem Schreibvorgang alle geplanten Stations-IDs gegen die schon
  in `curriculum.json` vorhandenen (`throw` bei Kollision, bevor irgendetwas geschrieben wird) - seither
  keine weitere Kollision aufgetreten.
- **Zwei gefundene und behobene Tippfehler:** Beim manuellen Schreiben der Themendateien haben sich
  zweimal versehentlich fremde Schriftzeichen eingeschlichen statt Ge'ez/Tigrinya-Text bzw. sauberer
  lateinischer Transliteration (ein chinesisches Zeichen in `lexemes_eritrea_gewuerze.json`
  „Knoblauch", ein kyrillisches Zeichen in `lexemes_eritrea_internetbegriffe.json` „Link"). Beide vor
  dem jeweiligen Commit über eine gezielte Regex-Prüfung auf CJK-/Kyrillisch-Zeichenbereiche in `am`/`tr`
  über alle `lexemes_eritrea_*.json`-Dateien gefunden und korrigiert; diese Prüfung lief ab da vor jedem
  weiteren Wiring-Lauf mit.
- **Bewusst keine erschöpfende Cross-Datei-Prüfung auf inhaltliche/semantische Doppelungen mehr.**
  Nach den ersten Runden zeigte sich, dass manche neuen Themenwörter zufällig dieselbe Bedeutung wie
  bereits vorhandene Einträge in anderen Dateien abdecken (z. B. „Löwe"/„Schmetterling" tauchen sowohl
  in älteren Tier-Dateien als auch in einer neuen Datei auf, mit unterschiedlicher ID). Technisch ist das
  unproblematisch (jede ID ist eindeutig, keine Testverletzung), inhaltlich aber Redundanz. Eine
  vollständige Prüfung gegen alle ~230 Dateien vor jedem neuen Wort hätte den Auftrag ("ohne zu
  meckern", Korrektheit wird selbst geprüft) faktisch unterlaufen und die Fertigstellung erheblich
  verzögert - stattdessen wurde nur auf (a) eindeutige Dateinamen (verhindert das Überschreibungs-
  Problem von oben) und (b) global eindeutige Lexem-/Satz-IDs geprüft (harte Testanforderung). Punktuell
  wurden nur besonders offensichtliche 1:1-Duplikate vermieden, wo beim Schreiben auffielen.
- **Automatisch generierte "Es gibt [Wort]"-Sätze bleiben wie in Runde 1 dokumentiert unangetastet** -
  bei rund 130 Stationen à 1 Satz ist ein Teil davon inhaltlich holprig, das war von Anfang an ein
  bewusst in Kauf genommener Kompromiss zwischen Struktur-Vollständigkeit (jede Station braucht eine
  Satzbau-Übung) und Zeitaufwand für individuell formulierte Sätze.
- **Verifiziert nach jeder Runde:** `flutter analyze` (0 Probleme) und volle Testsuite (230/230 grün)
  nach jeder der fünf Folgerunden, jeweils vor dem zugehörigen Commit.

## Etappe 27: Eritrea bekommt eine eigene, wischbare Weltkarte

Nutzer-Feedback nach Etappe 26: die 131 Tigrinya-Stationen sollten nicht als ein einzelner Knoten
auf der Äthiopien-Weltkarte hängen, sondern Eritrea sollte eine vollwertige, eigenständige Karte
bekommen - analog zur Äthiopien-Karte, erreichbar per Wisch-Geste (nicht Antippen), mit Erklärung
beim ersten Kontakt, weiterhin nur die ersten 3 Stationen kostenlos, und einem eigenen Reisepass
im Profil statt eines gemeinsamen. Umgesetzt als horizontales `PageView` in `WorldMapScreen` mit
zwei Seiten: die unveränderte Äthiopien-Karte (jetzt `_EthiopiaMapPage`, 6 Regionen) und eine neue
`EritreaMapView` (ein einzelner großer `RegionNodeMarker` auf einem eigenen Rotes-Meer-Hintergrund,
`EritreaMapPainter`) - kein drittes Kartenlevel und keine Gruppierung der 131 Stationen in
Über-Stationen (das war meine erste, vom Nutzer korrigierte Fehlinterpretation der Anfrage).

- **`JourneyProgress.currentRegionIndex`/`currentSectionId` (kreuzsprachlich) ersetzt durch
  `sectionsForLanguage(language)`/`currentRegionIndexForLanguage(language)`.** Die alte,
  kreuzsprachliche Berechnung hatte einen latenten Bug: wären irgendwann alle 6 Amharisch-Sektionen
  abgeschlossen gewesen, hätte `currentRegionIndex` in `curriculum.sections` bis zu `sec_eritrea`
  weitergezählt und der Busfahrer auf der (dann nicht mehr existierenden) Äthiopien-Karte fälschlich
  "Nächster Halt: Eritrea!" angesagt. Mit zwei komplett getrennten Karten musste das ohnehin
  aufgelöst werden - jede Karte berechnet ihre eigene "aktuelle Station" jetzt ausschließlich
  innerhalb der eigenen Sprache.
- **Stationssuche per Region statt per Listenindex.** `WorldMapScreen`/`RegionDetailScreen` haben
  Sektionen bisher teils per `curriculum.sections[index]` angesprochen, unter der stillschweigenden
  Annahme, dass `WorldMapLayout.order` und `curriculum.sections` exakt dieselbe Reihenfolge/Länge
  haben - eine Annahme, die mit Eritreas Auszug aus `order` gebrochen wäre. Jetzt überall
  `curriculum.sections.firstWhereOrNull((s) => journeyRegionFromId(s.region) == region)` (das
  Muster, das `RegionDetailScreen` für die Routen-Auflösung schon nutzte) - robust unabhängig von
  Sortierreihenfolge oder Listenlänge.
- **Eritrea-Karte ohne eigenes Geo-Projektionssystem.** `EthiopiaMap`/`WorldMapLayout` bauen ihre
  Positionen aus echten (grob stilisierten) Äthiopien-Koordinaten - für eine Karte mit nur einem
  einzigen Stopp wäre das reiner Overhead gewesen. `EritreaMapPainter` ist bewusst simpel: dieselbe
  Rotes-Meer-Kulisse (Himmel, Küstenlinie, Palmen, Leuchtturm), die die Eritrea-Medaillon-Grafik
  schon nutzt, nur bildschirmfüllend statt in einem 52px-Kreis.
- **Zustandsberechnung der einzelnen Eritrea-Station vereinfacht auf `current`/`completed`** (kein
  `locked`/`upcoming`/`comingSoon`) - mit nur einem Knoten auf dieser Karte gibt es kein "davor" oder
  "danach", das eine Sperre begründen würde; sie ist immer direkt erreichbar, wie in Etappe 26 schon
  für den (damals einzigen) Eritrea-Knoten auf der gemeinsamen Karte festgelegt.
- **Seiten-Punkte (2 kleine Kreise) statt Pfeile/Text als Wisch-Hinweis auf der Karte selbst** - dezent,
  passt ins bestehende Design, ergänzt (ersetzt nicht) den einmaligen Erklär-Dialog.
- **Der bestehende einmalige Eritrea-Hinweisdialog (Etappe 26) wurde inhaltlich umgeschrieben statt
  durch etwas Neues ersetzt** - Titel/Button-Text blieben unverändert (spart unnötige
  Test-/Übersetzungs-Änderungen), nur der Erklärtext beschreibt jetzt "nach links wischen" statt
  "Region antippen".
- **Zwei Reisepässe im Profil** (`_PassportCard`, je einmal für `language == 'am'` und einmal für
  `language == 'ti'`) statt einer gemeinsamen Stempelreihe - der gemeinsame Hinweistext
  ("Ein Stempel für jede Station...") wurde dafür sprachneutral umformuliert, statt zwei fast
  identische Varianten zu pflegen.
- **Freischaltungsgrenze (erste 3 Stationen kostenlos) unverändert, aber gezielt gegengetestet**
  (neuer `test/core/journey_progress_test.dart`): `freeTrialUnitIds()` zählt weiterhin nur die
  ersten 3 Einheiten der jeweils ersten Sektion pro Sprache, unabhängig davon, ob diese Sektion 4
  oder 131 Einheiten hat - bei 131 Einheiten bestätigt der neue Test explizit, dass Station 4 (und
  jede weitere) tatsächlich premium-gesperrt bleibt.
- **Sichtprüfung im Browser nur eingeschränkt möglich** (dieselbe schon in Etappe 8 dokumentierte
  Umgebungsgrenze: CanvasKit-Rendering ohne zugängliches DOM, Screenshot-Mechanismus dieser Umgebung
  liefert "Browser pane is not displayed"). Verifiziert stattdessen über (a) die Browser-Konsole
  (App startet fehlerfrei, einzige Meldung ist eine bekannte, unabhängige
  `flutter_local_notifications_web`-Plugin-Warnung im `web-server`-Debug-Modus) und (b) die
  vollständige automatisierte Testsuite inkl. zweier neuer, gezielter Tests
  (`world_map_swipe_test.dart` für das Wischen selbst, `journey_progress_test.dart` für die
  Freischaltungsgrenze).
- **Verifiziert:** `flutter analyze` (0 Probleme), volle Testsuite 233/233 grün.

## Etappe 27 Nachtrag: Eritrea-Karte wird zur echten 4-Regionen-Länderkarte

Direkt nach Etappe 27 stellte sich heraus, dass der einzelne Eritrea-Knoten den Nutzerwunsch nicht
traf: gewollt war von Anfang an eine vollwertige zweite Länderkarte analog zu Äthiopien, mit
mehreren "Ober-Stationen", eigenen Detailkarten pro Region, einer Straße mit Bus dazwischen und
entsprechend vielen Reisepass-Stempeln. Nach zwei weiteren, vom Nutzer präzisierten Anfragen (erst
3 Regionen, dann 4 mit einer Grammatik-Abschlussstation wie Äthiopiens "Safari") wurde die 131
Tigrinya-Stationen umfassende `sec_eritrea`-Sektion auf vier Regionen aufgeteilt: **Keren**
(Westland, 44 Einheiten, bestehender Wortschatz), **Asmara** (Hauptstadt, 44 Einheiten),
**Massawa** (Rotes-Meer-Küste, 43 Einheiten) und neu **Dahlak** (Abschlussstation, 1 Einheit mit
10 neuen Bindewort-Sätzen, kein neuer Wortschatz - exakt das gleiche Muster wie Äthiopiens Safari).

- **Unabhängige/parallele statt gemeinsame Implementierung, bewusst.** `EritreaCountryMap`
  (`lib/core/eritrea_map_layout.dart`) und `EritreaCountryPainter` dupliziert das Muster von
  `EthiopiaMap`/`WorldMapPainter` fast eins zu eins (eigene `_MapTransform`, eigene
  Geo-Projektion, eigene `_decorateZone`), statt beide auf eine gemeinsame, parametrisierte Basis
  zu heben. Gleiche Abwägung wie schon bei `LessonScreen`/`ExercisePlayer` in Etappe 6 dokumentiert:
  zwei einfache, unabhängig lesbare Implementierungen sind hier wartbarer als eine gemeinsame mit
  Verzweigungen für jede Länder-Eigenheit (unterschiedliche Anzahl Regionen, unterschiedliche
  Küstenform, Dahlaks Inselgruppe, die Äthiopien gar nicht hat).
- **Eritreas Umriss ist eine handgezeichnete Annäherung, keine vermessenen Daten** - anders als
  `EthiopiaMap`, deren Umriss auf echten (grob stilisierten) Koordinaten beruht. Aus dem vom Nutzer
  geschickten Referenzbild und allgemeinem Kartenwissen abgeleitet; für die Bus-Route und die grobe
  Silhouette ausreichend, aber bewusst nicht als geografisch exakt zu verstehen.
- **Regionspositionen sind bewusst NICHT die echten geografischen Koordinaten**, sondern manuell so
  gewählt, dass sie dem expliziten Nutzerwunsch folgen: "nicht zu nah beieinander", ein Pfad von
  oben links nach rechts mit "genügend Abstand" (Keren Nordwesten → Asmara Zentrum → Massawa Küste
  → Dahlak Inseln vor der Küste). Reales Asmara liegt geografisch näher an Massawa als an Keren -
  hier wurde lesbarer Kartenabstand bewusst über geografische Treue gestellt.
- **Vier neue `JourneyRegion`-Werte (`asmara`/`massawa`/`keren`/`dahlak`) ersetzen den einen alten
  `eritrea`-Wert vollständig**, statt Eritrea als Sub-Enum oder verschachtelte Struktur zu
  modellieren - jede Region ist auf Enum-Ebene gleichrangig zu Äthiopiens 6 Regionen, was
  `RegionDetailScreen` (komplett generisch, unverändert wiederverwendet) und alle
  `switch (region)`-Stellen ohne Sonderfall handhaben.
- **`RegionIconPainter`/`region_detail_painter.dart` bekamen für alle 4 neuen Regionen echte,
  unterschiedliche Illustrationen** (Asmara: Art-Deco-Fassaden, Massawa: die alte Eritrea-Grafik aus
  Etappe 26/27 unverändert übernommen, Keren: zwei Hügelzüge mit Akazien, Dahlak: türkise
  Lagune mit drei Inseln) - nur die inzwischen tote `journey_stop_banner.dart` und das
  Äthiopien-only iterierende `world_map_painter.dart` bekamen reine No-Op-Fälle, rein für
  Exhaustiveness, da sie diese Regionen nie tatsächlich rendern.
- **Sätze mit Bindewörtern für Äthiopiens Safari UND Eritreas neue Dahlak-Station**, beide aus
  ausschließlich bereits etabliertem, risikoarmem Wortschatz gebaut statt aus neuen, unsicheren
  Konstruktionen: Safari nutzt die bestehenden Kopula-Adjektiv-Satzpaare ("Er ist X, sie ist Y") mit
  6 nicht-zirkumfixen Amharisch-Konjunktionen (`gin`/aber, `ina`/und, `weyim`/oder, `silezih`/
  deshalb, `iyale`/während, `minim inikwan`/obwohl) - die zirkumfixen Konjunktionen (`ke...bi` usw.)
  wurden bewusst ausgelassen, weil sie mit dem wortweise-tokenisierten `chunks`-Satzbaumodell nicht
  sicher funktionieren. Dahlak nutzt das bestehende Tigrinya-Existenzmuster ("X ኣሎ") mit 6 neuen
  Tigrinya-Konjunktionslexemen, unter bewusstem, vollständigem Verzicht auf Verneinung (keine der
  verfügbaren Tigrinya-Verneinungsformen war sicher genug etabliert, um sie hier zu riskieren).
- **`sec_eritrea_dahlak` wurde bewusst NACH den anderen drei Eritrea-Sektionen angehängt** (nicht an
  beliebiger Stelle), damit die Content-Validierungsregel "Sätze dürfen nur Lexeme referenzieren,
  die spätestens in ihrer eigenen Unit eingeführt wurden" für Dahlaks Konjunktionssätze eingehalten
  bleibt - dieselbe Reihenfolge-Anforderung, die schon beim Anhängen von Safaris Bindewort-Unit an
  `sec_safari.units` beachtet wurde.
- **Icon-Kollision im Profil-Reisepass gefunden und behoben:** Asmara hätte als "Hauptstadt" naheliegend
  dasselbe `Icons.location_city` wie Addis Abeba bekommen - das kollidierte mit einem bestehenden
  Test (`profile_passport_test.dart`), der über `find.byIcon(...)` genau ein Icon erwartet, und wäre
  auch für echte Nutzer im UI nicht unterscheidbar gewesen (zwei gleiche Icons in zwei verschiedenen
  Pässen). Asmara bekam stattdessen `Icons.apartment` (passend zur Art-Deco-Bauweise).
- **Zwei zuvor Eritrea-spezifische Fahrer-Sprüche (`journeyDriverEritreaCurrent`/`AllDone`) wieder
  entfernt** - die neue 4-Knoten-Karte verhält sich strukturell wie Äthiopiens Karte und nutzt daher
  einfach dieselben generischen `journeyDriverWorldMapCurrent`/`AllDone`-Schlüssel wie dort, statt
  eigene (und inhaltlich ohnehin kaum noch passende, weil jetzt "Nächster Halt: Asmara!" statt
  "Nächster Halt: Eritrea!" gemeint ist) Varianten zu pflegen.
- **Zwei bestehende Tests mussten wegen der Strukturänderung angepasst werden**
  (`eritrea_region_reachable_test.dart`, `world_map_swipe_test.dart`, `journey_progress_test.dart`):
  sie suchten bisher nach `JourneyRegion.eritrea` bzw. einer Sektion mit `region == 'eritrea'`, die
  es nicht mehr gibt - jetzt zeigen sie stellvertretend auf `JourneyRegion.keren` (die erste der
  vier neuen Regionen) bzw. finden die erste `language == 'ti'`-Sektion dynamisch.
- **Verifiziert:** `flutter analyze` (0 Probleme), volle Testsuite 239/239 grün.

## Etappe 28: "Sätze bauen" auf mindestens 5 Sätze pro Station ausgebaut (Äthiopien + Eritrea)

Nutzerauftrag: jede Station (jede Lektion/jeder Kartenknoten in `RegionDetailScreen`, nicht nur die
6+4 Ober-Regionen) sollte mindestens 5 Sätze in ihrer "Sätze bauen"-Übung haben, ausdrücklich auch
mit neuem, stationsfremdem Wortschatz, falls nötig. Eine Bestandsaufnahme zeigte 257 von 285
Stationen unter 5 Sätzen (viele bei 0-2, aus früheren Runden mit nur einem Satz pro Thema). Statt
alle ~938 fehlenden Sätze einzeln von Hand zu verfassen, wurde ein einmaliges Node-Generierungs-
skript geschrieben (nach Gebrauch wieder gelöscht, nicht Teil des Repos), das systematisch für jede
Station die Lücke bis 5 auffüllt.

- **Drei feste, sichere Satzschablonen statt freier Textgenerierung**, je nach Wortart (`pos`) des
  gewählten Lexems, um Grammatikrisiko zu minimieren:
  - **Nomen/Zahl → Existenzsatz** ("[Wort] አለ።"/"[Wort] ኣሎ።", "es gibt X") - dasselbe Muster, das
    schon in hunderten bestehenden Sätzen genutzt wird.
  - **Adjektiv → Pronomen-Kopula** ("እሱ [Adjektiv] ነው።"/"ንሱ [Adjektiv] እዩ።", "er ist X") - dasselbe
    Muster wie Safaris Bindewort-Sätze (Etappe 27 Nachtrag).
  - **Amharisches Verb (liegt als Infinitiv vor, z. B. "መብላት"/"zu essen") → "[Infinitiv]
    እፈልጋለሁ።"** ("ich möchte X") - Standardkonstruktion Infinitiv + `ifeligalehu`; da `t.de/t.sv/t.nl`
    der Verb-Lexeme bereits als nackter Infinitiv gespeichert sind, funktionieren "möchte/vill/wil" +
    Infinitiv direkt korrekt in allen drei Sprachen.
  - **Phrase/Interjektion, sowie Tigrinya-Verben (liegen als Imperativ vor, z. B. "ኣጋግሕ" = "bügle!")
    → als-ist übernommen**, ggf. nur um Satzschlusszeichen ergänzt - das sind bereits vollständige
    Äußerungen, kein Wrapping nötig oder sinnvoll.
- **Pronomen, Partikel, Präpositionen, Konjunktionen und Adverbien bewusst von der Auswahl
  ausgeschlossen.** Ein erster Versuch zeigte, warum: das generische Existenz-Wrapping ergab bei
  diesen Wortarten Unsinn ("es gibt gestern", "es gibt kein" für die Negationspartikel `aydelem`,
  "es gibt du"). Da diese Kategorien zusammen nur ~3 % aller Lexeme ausmachen, verkleinert der
  Ausschluss den Kandidatenpool kaum - kein einziger der 285 Stationen hatte am Ende zu wenig
  Vokabular übrig (`unitsSkippedNoVocab: 0`).
- **Vokabelquelle: zuerst die eigenen Wörter der Station, erst bei Bedarf ältere Wörter derselben
  Sprache.** Für jede Station wurden zuerst ihre eigenen `wordPractice`-Lexeme durchprobiert
  (thematisch passend, direkte Wiederholung); nur wenn das nicht für 5 Sätze reichte (viele kleine
  Stationen mit nur 5-10 eigenen Wörtern), wurde auf bereits früher in derselben Sprache eingeführten
  Wortschatz zurückgegriffen (rückwärts ab der aktuellen Position, damit thematisch möglichst nah).
  Deckt den Nutzerwunsch "gerne auch neue Wörter, auch wenn sie nicht in der Station sind" ab, ohne
  neue Lexem-Einträge anlegen zu müssen - das gesamte bestehende Vokabular (4020 Lexeme) diente als
  Fallback-Pool, in derselben sprachlich getrennten Reihenfolge, die auch
  `content_validation_test.dart`s "keine Vorwärtsreferenzen"-Regel prüft.
- **Bug gefunden und behoben: Fidel-Lesbarkeits-Verletzung bei 13 der ersten 938 generierten
  Amharisch-Sätze.** Stufe 5/6 (Lese-Pfad) verlangt, dass jeder Amharisch-Satz bei vollständig
  gelerntem Alphabet lesbar ist (`content_repository.dart`s `_isDecodableWith`). 13 Sätze
  verwendeten Lexeme mit Klammer-Zusatzangaben ("ሰዓት (ግድግዳ)" = "Uhr (Wand-)", zur Abgrenzung von
  Homonymen) oder mit seltenen Lehnwort-Buchstaben (ቮ/ቪ/ቫ/ቧ/ኋ für v-Laute wie "ቴሌቪዝን"/Fernsehen),
  die die App nie unterrichtet. Das Generierungsskript prüft seither vor der Auswahl eines
  Amharisch-Lexems dessen Lesbarkeit gegen das komplette gelernte Zeichenset (Basistabelle + Stufe-7-
  Extras) und überspringt nicht-lesbare Kandidaten - für Tigrinya nicht relevant, da
  `sentencesDecodableWith` laut eigenem Kommentar bewusst nur den Amharisch-Lesepfad prüft.
- **Eine strukturelle Anomalie gefunden und repariert:** `unit_ich_und_du` (zweite Äthiopien-Station)
  hatte nie eine eigene `sentenceBuilding`-Stufe, sondern sprang direkt von `wordPractice` zu
  `listening` - mit 2 Sätzen, die nur in Listening/FreeApplication/Review auftauchten. Das
  Generierungsskript synthetisiert in so einem Fall eine neue `sentenceBuilding`-Stufe (Struktur wie
  überall sonst, direkt nach `wordPractice` eingefügt), vorbefüllt mit den 2 bestehenden Sätzen,
  bevor die übliche Auffüll-Logik greift.
- **8 neue, nach Region gebündelte Satzdateien** (`sentences_gen_addisabeba/tigray/oromia/sidama/
  harar/keren/asmara/massawa.json`, insgesamt 938 Sätze, alle `verified: false`) statt einer
  Datei pro Station oder einer einzigen Riesendatei - folgt derselben Gliederung wie die
  bestehenden Themen-Sammeldateien (z. B. `sentences_eritrea_mehr6.json`).
- **Ein bestehender Test musste wegen der neuen Stufe angepasst werden**
  (`region_locked_station_test.dart`): die "Kapitel-Test"-Kachel unter `unit_ich_und_du`s jetzt
  längerer Lektionsliste liegt nicht mehr automatisch im sichtbaren Bereich - derselbe, bereits in
  `eritrea_region_reachable_test.dart` etablierte Scroll-Fix.
- **Audio-Manifest + `fehlende_audiodateien.md`** um alle 938 neuen Satz-IDs ergänzt, gleiches
  Muster wie immer; die eigentlichen Audiodateien folgen wie besprochen erst später.
- **Verifiziert:** `flutter analyze` (0 Probleme), volle Testsuite 239/239 grün, inklusive
  `content_validation_test.dart` und `fidel_stufe_content_test.dart`.

## Etappe 28 Nachtrag: Satzschablonen variiert statt immer gleich

Nutzer-Einwand direkt nach Etappe 28, zurecht: mit nur einer festen Schablone pro Wortart sahen
viele Stationen fast identisch aus (`unit_eritrea_zahlen_mehr`: 4 von 5 Sätzen alle "[Zahl] ኣሎ።",
nur das Zahlwort unterschiedlich). Wer das Muster einmal erkennt, muss das eingesetzte Wort für die
Sätze-bauen-Übung gar nicht mehr verstehen - genau das Gegenteil vom Zweck der Übung.

- **2-3 Schablonen pro Wortart statt einer, rotierend pro Station vergeben.** Nomen/Zahlen wechseln
  zwischen Existenzsatz ("X gibt es"), Besitzsatz ("X habe ich", አለኝ/ኣሎኒ) und - nur Amharisch,
  sicherste Variante für Tigrinya nicht riskiert - "X mag ich" (እወዳለሁ, dieselbe Konstruktion, die
  auch schon für "möchte X tun" bei Verben lief, hier als direktes Objekt). Adjektive wechseln
  zwischen "er ist X", "sie ist X" und "es ist sehr X". Amharische Verben wechseln zwischen "ich
  möchte X tun" und "X mag ich" (Infinitiv vorangestellt: "Ich mag ${täti}." - im Deutschen durch
  Voranstellung des nominalisierten Infinitivs korrekt, z. B. "Essen mag ich."). Phrasen/
  Interjektionen und Tigrinya-Verben (liegen als Imperativ vor) bleiben unverändert als-ist, da sie
  schon von Natur aus nicht in dieses Repetitions-Problem fallen.
  - **Rotation pro Station, nicht global**, damit z. B. eine Station mit 4 Zahlwörtern tatsächlich
    4 unterschiedliche Sätze bekommt (Existenz/Besitz/mögen/Existenz), statt dass ganze Stationen
    zufällig eine einzige Schablone abbekommen.
- **Reine Inhaltskorrektur, keine neue Verkabelung nötig:** da IDs, `uses`, Level und Zuordnung zu
  Lektionsstufen unverändert blieben (nur `am`/`tr`/`t`/`chunks` der 814 betroffenen `sen_gen_*`-
  Einträge - Phrasen/Interjektionen/Tigrinya-Verben brauchten keine Änderung), waren
  `curriculum.json`, alle Lektionsdateien und `assets/audio/manifest.json` nicht betroffen; nur
  `fehlende_audiodateien.md`s Tabellenzeilen (enthalten den Satztext direkt) wurden neu erzeugt.
- **Neue Wrapper-Zeichenketten (አለኝ/ኣሎኒ/እሷ/ናት/በጣም/ንሳ/እያ) erneut gegen das komplette gelernte
  Fidel-Zeichenset geprüft** (gleiche Methode wie in Etappe 28 für die erste Bug-Behebung) - alle
  bestehen, keine neue Stufe-5/6-Verletzung.
- **Verifiziert:** `flutter analyze` (0 Probleme), volle Testsuite 239/239 grün.

## Etappe 27 Nachtrag 2: Eritrea-Umriss neu gezeichnet, nahe an der Referenz

Nutzer-Einwand: der erste Eritrea-Umriss (Etappe 27) war zu grob/"halbläbig" - der Nutzer schickte
erneut die Referenz-Umrissgrafik und wollte den Umriss 1:1 daran angelehnt, nicht nur ungefähr
ähnlich. `_outlineVertices` in `lib/core/eritrea_map_layout.dart` wurde von 18 auf 31 Punkte
erweitert und deutlich genauer an die reale/abgebildete Silhouette angenähert: die scharfe
Nordspitze bei Karora (Sudan/Rotes-Meer-Ecke), eine bucklige, mehrfach eingekerbte Westgrenze zu
Sudan, eine eingebuchtete Rotes-Meer-Küste, die "Taille" wo sich der Schwanz vom Hauptkörper löst,
und die südöstliche Landzunge bis zur spitzen Ras-Dumeira-Spitze an der Grenze zu Dschibuti.

- **Selbstüberschneidung des Polygons rechnerisch geprüft statt nur optisch.** Ein Screenshot-Check
  war in dieser Umgebung nicht möglich (dieselbe schon in Etappe 8/27 dokumentierte Einschränkung:
  "Browser pane is not displayed" beim Screenshot-Mechanismus). Stattdessen wurde der komplette
  31-Punkte-Umriss mit einem eigenständigen Segment-Schnittpunkt-Test (Node-Skript, nicht Teil des
  Repos) auf Selbstüberschneidungen geprüft - ein erster Entwurf mit mehr Zacken im Schwanzbereich
  hatte tatsächlich eine Überschneidung (Hinweg- und Rückweg-Kante der Landzunge kreuzten sich), was
  beim Rendern als verdrehte "Schleife" ausgesehen hätte. Der Schwanz wurde daraufhin bewusst mit
  weniger, aber sauber getrennten Kontrollpunkten gezeichnet (Hinweg/Küste konsequent östlich vom
  Rückweg/Grenze bei jedem Breitengrad) - am Ende 0 Überschneidungen, korrekte
  Umlaufrichtung, alle 4 Stations-Positionen weiterhin sinnvoll platziert (Keren/Asmara/Massawa
  liegen innerhalb der Landmasse, Dahlak bewusst leicht außerhalb - unverändert seit Etappe 27, da
  die Dahlak-Station ohnehin für die Vor-der-Küste-Inselgruppe steht und ihre Position schon immer
  für Kartenabstand statt geografischer Genauigkeit gewählt wurde).
- **Direkt im Browser gegen den laufenden `flutter run -d web-server` geprüft** (kein manueller
  Screenshot möglich, aber Konsole und Ladezustand kontrolliert: App startet fehlerfrei, keine neuen
  Laufzeitfehler gegenüber vorher, nur die schon bekannte, unabhängige DWDS-Websocket-Warnung im
  Debug-Modus).
- **Verifiziert:** `flutter analyze` (0 Probleme), volle Testsuite 239/239 grün. Echte visuelle
  Prüfung im Browser bleibt (wie in Etappe 8/27 dokumentiert) durch die Umgebung eingeschränkt -
  die geometrische Korrektheit (kein Selbstschnitt, richtige Fläche/Ausdehnung) ist rechnerisch
  sichergestellt, eine Pixel-genaue Übereinstimmung mit der Referenzgrafik aber nicht.

## Etappe 27 Nachtrag 3: Umriss auf 100 Punkte verdichtet

Nutzerauftrag: statt der 31 Punkte aus Nachtrag 2 sollen es 100 sein. 100 Punkte von Hand aus einer
Referenzgrafik abzulesen wäre weder präzise noch praktikabel gewesen - stattdessen wurde der bereits
geprüfte 31-Punkte-Umriss programmatisch verdichtet: jede der 31 Kanten wird in mehrere Teilstücke
zerlegt, mit kleinem senkrechtem Jitter (an den Endpunkten auf 0 auslaufend, damit die Nachbarkanten
weiter exakt ineinander übergehen) für eine natürlich wirkende, unregelmäßige Küstenlinie statt einer
glatten Kurve - dieselbe Silhouette, nur mit mehr Detailtreue.

- **Kanten-Budget proportional zur Kantenlänge verteilt** (längere Küstenabschnitte bekommen mehr
  Zusatzpunkte, kürzere weniger - realistischer als eine gleichmäßige Verteilung) und auf exakt 100
  Gesamtpunkte genau austariert (31 Basispunkte + 69 verteilte Zusatzpunkte).
- **Jitter-Amplitude im Schwanzbereich bewusst auf ein Viertel reduziert** (0,012° statt 0,055°):
  genau dort hatte Nachtrag 2 schon eine echte Selbstüberschneidung gefunden und beheben müssen, weil
  Hinweg- und Rückweg-Kante der schmalen Landzunge nah beieinander liegen - zusätzlicher Jitter hätte
  dort mit hoher Wahrscheinlichkeit erneut eine Überschneidung erzeugt.
- **Seed-Suche statt Handarbeit:** die Zufallszahlen für den Jitter kommen aus einem deterministischen
  Pseudozufallsgenerator; ein Skript hat automatisiert durchprobiert, bis ein Seed 0 Selbstüber-
  schneidungen ergab (derselbe Segment-Schnittpunkt-Test wie in Nachtrag 2), statt einzelne Punkte von
  Hand nachzujustieren.
- **Ergebnis geometrisch gegengeprüft:** exakt 100 Punkte, 0 Selbstüberschneidungen, gleiche
  Umlaufrichtung und Fläche wie der 31-Punkte-Vorgänger, Keren/Asmara/Massawa weiterhin innerhalb der
  Landmasse, Dahlak weiterhin knapp außerhalb (unverändert, siehe Nachtrag 2).
- **Verifiziert:** `flutter analyze` (0 Probleme), volle Testsuite 239/239 grün. Wie in Nachtrag 2:
  echte Pixel-Prüfung im Browser durch die Umgebung nicht möglich, nur Konsole/Ladezustand
  kontrolliert (fehlerfrei, keine neuen Laufzeitfehler).

## Etappe 27 Nachtrag 4: Eritrea-Umriss durch die echte Landesgrenze ersetzt

Nutzerauftrag, unmissverständlich: "1:1 wie die echte Eritrea Landkarte" statt einer weiteren
Annäherung. Genau die gleiche Anforderung, die `EthiopiaMap.outline` schon in Etappe 22 Nachtrag 4
seine echten Grenzdaten eingebracht hatte - also dieselbe Quelle noch einmal genutzt: das
`johan/world.geo.json`-Dataset (gemeinfrei/CC0, echte Vermessungsdaten), diesmal dessen
`ERI.geo.json`. Per `curl` direkt von `raw.githubusercontent.com` geladen (nicht über WebFetch, das
den Inhalt durch ein KI-Modell zusammenfassen lässt - für exakte Koordinatenwerte ungeeignet, ein
`curl` liefert die Rohdaten unverändert).

- **27 Punkte statt der 100 aus Nachtrag 3** - diesmal bewusst nicht rund/gewählt, sondern exakt so
  viele, wie die echte, bereits vereinfachte Vermessungsgrenze hat. Weniger Punkte als beim
  hand-verdichteten Vorgänger, aber die tatsächliche Form statt einer Annäherung daran.
  Übernommen ohne Glättung, exakt wie bei `EthiopiaMap.outline` ("used as-is with no smoothing").
- **Mehrere Punkte sind byte-identisch mit Punkten aus `EthiopiaMap.outline`** (z. B.
  `GeoPoint(42.35156, 12.54223)`, `GeoPoint(37.90607, 14.95943)`) - die gemeinsame Äthiopien-Eritrea-
  Grenze. Das ist keine Übereinstimmung, die man auf ein Hand-Zeichnen zurückführen könnte, sondern
  bestätigt, dass beide Länder-Umrisse aus demselben konsistenten, echten Datensatz stammen.
  Rechnerisch geprüft: 0 Selbstüberschneidungen, gleiche Umlaufrichtung wie zuvor.
- **Enthält die Dahlak-Inselgruppe nicht als eigene Geometrie** (dieses vereinfachte Festland-only-
  Dataset hat sie nicht) - `islands()` zeichnet sie unverändert als eigene, handgezeichnete Formen
  weiter, wie schon seit Etappe 27.
- **Massawa-Stationsposition leicht nachjustiert** (`(40.6, 14.0)` → `(40.4, 14.4)`): die echte
  Küstenlinie verläuft an der Stelle weiter westlich als die alte Annäherung - die alte Position wäre
  jetzt knapp außerhalb der (nun genauen) Landmasse gelandet. Keren/Asmara/Dahlak-Positionen
  unverändert, weiterhin bewusst nicht die exakten realen Koordinaten (siehe Etappe 27: Abstand für
  die Kartenlesbarkeit hat Vorrang vor geografischer Genauigkeit).
- **Verifiziert:** `flutter analyze` (0 Probleme), volle Testsuite 239/239 grün.

## Etappe 28 Nachtrag 2: Audio-Worklist-Export auf Amharisch beschränkt

Nutzerauftrag: erstmal nur die Amharisch-Aufnahmen "wie damals" - das bestehende
`tool/generate_audio_colab.py` kennt nur die Amharisch-Stimmen (`am-ET-*`) und würde Tigrinya-Text
mit falscher Aussprache vorlesen, statt sichtbar zu scheitern. `tool/export_audio_worklist_test.dart`
exportierte bisher sprachübergreifend alles - jetzt auf `am`-Sektionen eingeschränkt, nach demselben
Prinzip, das `ContentRepository._collectAmharicIds` für den Fidel-Lesepfad (Etappe 26) schon nutzt
(Zugehörigkeit über die Sektion, nicht über Raten anhand des ID-Präfixes).

- **Eigene Zwischenrechnung korrigiert:** vor dieser Umstellung hatte ich per ID-Präfix-Heuristik
  (`enthält _ti_?`) 956 fehlende Amharisch-Sätze überschlagen und dem Nutzer genannt - falsch. Die
  echte, App-eigene Sektionslogik ergibt 436. Die Differenz (520) waren Sätze, deren ID zufällig nicht
  auf `_ti_` passte, die aber trotzdem zu einer Tigrinya-Sektion gehören - eine ungeprüfte
  ID-Heuristik statt der echten Content-Zuordnung war hier schlicht der falsche Ansatz.
- **Endstand nach der Umstellung:** 436 fehlende Amharisch-Sätze, 0 fehlende Amharisch-Wörter (alle
  vorhanden), 0 fehlende Fidel-Zeichen (alle vorhanden) - macht `tool/audio_worklist.csv` mit genau
  436 Zeilen, bereit für einen Colab-Lauf mit der bestehenden Amharisch-Stimme. Tigrinya bekommt einen
  eigenen Export/eine eigene Stimme erst, wenn das explizit gewünscht wird.
- **Verifiziert:** `flutter analyze` (0 Probleme), volle Testsuite 239/239 grün.

## Etappe 28 Nachtrag 3: 436 Amharisch-Aufnahmen eingebaut

Der Nutzer hat `tool/audio_worklist.csv` durch `tool/generate_audio_colab.py` (edge-tts, weibliche
Stimme `am-ET-MekdesNeural`) laufen lassen und `audio_output.zip` als `tool/incoming/audio_output.zip`
abgelegt. Vor dem Einbau geprüft statt blind vertraut:

- **Encoding aller 484 gelieferten Dateien per Hand geparst** (MPEG-Frame-Header, dieselbe Methode wie
  beim ursprünglichen Fund des MPEG-2/16kHz-Bugs in Etappe 15) - alle einheitlich MPEG-1 Layer III bei
  44100 Hz, also im sicher abspielbaren Profil. Kein Wiederauftreten des alten Bugs.
- **436 der 484 Dateien deckten sich exakt mit der gesendeten Amharisch-Worklist** (Kreuzabgleich per
  ID) - diese wurden nach `assets/audio/words/` kopiert. Die restlichen 48 (`lex_ti_*`, Tigrinya-
  Wörter) wurden bewusst NICHT übernommen: unklar, mit welcher Stimme sie erzeugt wurden, und zu dem
  Zeitpunkt gab es noch keine geklärte Tigrinya-Stimme (siehe Nachtrag 4) - lieber auslassen als
  möglicherweise falsch ausgesprochenes Audio einbauen.
- **`fehlende_audiodateien.md` um die jetzt vorhandenen 436 Zeilen bereinigt** - dabei ein eigenes
  Skript-Detail gefunden und korrigiert: die 8 ältesten Zeilen (aus der allerersten Runde) hatten den
  Dateinamen in Backticks (`` `sen_hulet_wendimoch.mp3` ``) statt im späteren Format ohne Backticks -
  eine erste Entfernungsrunde per Regex hat die deshalb übersehen, eine zweite, gezielte Runde hat sie
  nachträglich erfasst.
- **Verifiziert:** `flutter analyze` (0 Probleme), volle Testsuite 239/239 grün,
  `audio_encoding_test.dart` bestätigt weiterhin durchgängig MPEG-1.

## Etappe 28 Nachtrag 4: Eigener Tigrinya-Audio-Pfad (Meta MMS statt edge-tts)

Nutzerauftrag: auch für Tigrinya eine Liste vorbereiten, mit weiblicher Stimme "wie bei Amharisch".
Vor dem Erstellen geprüft (nicht angenommen): keiner der drei großen TTS-Anbieter, die für Amharisch
in Frage kämen, hat eine echte Tigrinya-Stimme.

- **Per Websuche verifiziert, nicht aus Trainingswissen übernommen** (derselbe Vorsichtsgrundsatz wie
  schon bei der Verifikation der Amharisch-Stimmen in Etappe 16): Azure/edge-tts, Amazon Polly und
  Google Cloud TTS unterstützen Tigrinya alle nicht. Manche Drittanbieter-Tools "faken" Tigrinya-
  Unterstützung, indem sie im Hintergrund die Amharisch-Stimme einsetzen - das würde Tigrinya-Text mit
  falscher Aussprache vorlesen (andere Sprache, andere Ausspracheregeln trotz gemeinsamer Schrift),
  kein akzeptabler Ersatz.
- **Nutzer nach expliziter Rückfrage für Metas `facebook/mms-tts-tir`-Forschungsmodell entschieden**
  (Alternativen waren: vorerst zurückstellen, oder ersatzweise die Amharisch-Stimme missbrauchen) - per
  Websuche bestätigt existent (Meta AI, VITS-Architektur, dieselbe uroman-Vorverarbeitung wie das
  bereits bekannte `facebook/mms-tts-amh`). Dasselbe Modell, das für Amharisch wegen ungewohnter
  Betonung (überwiegend religiöse Trainingstexte) verworfen wurde - für Tigrinya aber die einzige
  verfügbare Option mit einer echten, trainierten Stimme.
- **`tool/generate_audio_colab_ti.py` aus dem historischen, VOR der edge-tts-Umstellung genutzten
  MMS-Skript abgeleitet** (`git show c2bb6c2^:tool/generate_audio_colab.py`), nicht neu geschrieben -
  dieses alte Skript hatte den MPEG-2/16kHz-Encoding-Fix (Etappe 15) bereits eingebaut, das wurde
  1:1 übernommen statt den Bug ein drittes Mal zu riskieren.
- **`tool/export_audio_worklist_ti_test.dart` als eigenständige Schwester-Datei** von
  `export_audio_worklist_test.dart` (nicht als Parameter/Flag in einer gemeinsamen Datei) - dieselbe
  "lieber getrennt als eine gemeinsame Datei mit Verzweigungen" Abwägung wie bei
  `EthiopiaMap`/`EritreaCountryMap` (Etappe 27). Sektionszugehörigkeit (`language == 'ti'`) statt
  ID-Präfix-Raten, exakt spiegelbildlich zur Amharisch-Variante.
- **Ergebnis:** 2666 fehlende Tigrinya-Einträge (2001 Wörter + 665 Sätze) - deutlich mehr als bei
  Amharisch, weil der ~2000-Wörter-Wortschatzausbau (Etappe 26 Nachtrag 2-6) nie mit Audio unterlegt
  wurde. `tool/audio_worklist_ti.csv` + `tool/generate_audio_colab_ti.py` an den Nutzer geschickt,
  Hinweis zur ungewissen Aussprachequalität explizit mitgegeben (Stichprobe hören vor dem Zurückschicken
  empfohlen).
- **Verifiziert:** `flutter analyze` (0 Probleme). Kein Testlauf des Colab-Skripts selbst möglich
  (externer Python-/GPU-Kontext) - wie bei der Amharisch-Variante schon der Fall.

## Etappe 28 Nachtrag 5: Tigrinya-Colab-Skript - uroman-Fehler behoben

Der Nutzer hat `generate_audio_colab_ti.py` laufen lassen: Modell lud korrekt (MMS-TTS-Gewichte,
762 Tensoren), aber beim ersten Satz schlug es fehl mit `uroman-Fehler 2: Can't open perl script
"/content/uroman/bin/uroman.pl": No such file or directory`.

- **Ursache gefunden statt geraten:** das aus dem historischen Amharic-MMS-Skript übernommene
  `git clone isi-nlp/uroman` + `perl bin/uroman.pl`-Vorgehen war zum Zeitpunkt des alten Skripts
  (Etappe 11) korrekt, aber *uroman* selbst hat seither auf ein offizielles Python-Paket umgestellt
  (Version 1.3.1, laut eigenem Änderungsprotokoll) - die alte Perl-Variante ist im aktuellen Repo
  nicht mehr in der erwarteten Form vorhanden. Per README-Abruf direkt von der Quelle bestätigt
  (`raw.githubusercontent.com/isi-nlp/uroman/master/README.md`), nicht angenommen.
- **Umgestellt auf `pip install uroman` + `import uroman as ur; ur.Uroman().romanize_string(...)`**
  - kein `git clone`, kein `perl`-Subprozess pro Satz mehr nötig. Nebeneffekt: die Romanisierungsdaten
  werden jetzt einmalig geladen statt bei jedem der 2666 Aufrufe einen neuen Perl-Prozess zu starten -
  sollte auch spürbar schneller laufen.
- **`lcode="tir"` explizit mitgegeben** (optionaler Sprachcode-Parameter der neuen Python-API,
  laut Doku potenziell bessere Romanisierung für die angegebene Sprache) - beim alten Perl-Aufruf gab
  es dafür keine Entsprechung.
- Datei erneut an den Nutzer geschickt, mit der Bitte, die Colab-Zelle komplett neu zu starten (der
  `pip install`-Schritt muss neu laufen).
- **Verifiziert:** Python-Syntax lokal per `ast.parse` geprüft (kein Python-Interpreter mit den
  Colab-spezifischen Paketen hier verfügbar, aber Syntaxfehler wären so schon aufgefallen),
  `flutter analyze` weiterhin 0 Probleme. Der eigentliche Colab-Lauf selbst bleibt ungetestet von
  hier aus möglich.

## Etappe 28 Nachtrag 6: Zweiter uroman-Fehler - Modul-Schatten durch alten Klon-Ordner

Der Fix aus Nachtrag 5 reichte nicht: nächster Fehler war `AttributeError: module 'uroman' has no
attribute 'Uroman'`, obwohl `pip install uroman` erfolgreich lief.

- **Ursache per Direktvergleich gefunden, nicht geraten:** das echte pip-Paket (`.whl` von PyPI
  heruntergeladen und entpackt) hat exakt die erwartete Struktur (`from .uroman import Uroman,
  RomFormat` in `__init__.py`) - das Paket selbst ist also nicht kaputt. Der eigentliche Grund: der
  allererste Versuch (mit dem alten, inzwischen ersetzten Skript) hatte per `git clone` einen Ordner
  namens `uroman/` im Colab-Arbeitsverzeichnis angelegt. Python bevorzugt beim Import einen
  gleichnamigen lokalen Ordner gegenüber einem installierten Paket - dieser Ordner (der rohe
  Git-Repo-Inhalt, keine echte Python-Bibliothek) hat das pip-Paket verdeckt, obwohl es korrekt
  installiert war.
- **Doppelt abgesichert statt nur einmal:** `!rm -rf uroman` entfernt den Ordner vor der Installation,
  zusätzlich `sys.modules.pop("uroman", None)` direkt vor dem Import - Letzteres, weil ein bereits
  fehlgeschlagener `import uroman` in derselben laufenden Python-Sitzung das kaputte Modul-Objekt
  schon zwischengespeichert haben könnte, was ein reines Datei-Löschen allein nicht rückgängig macht.
- **Nutzer explizit gebeten, diesmal die Laufzeit komplett neu zu starten** (Menü "Laufzeit" →
  "Sitzung neu starten"), nicht nur die Zelle erneut auszuführen - genau der Unterschied, der den
  vorherigen Fix wirkungslos gemacht haben könnte.
- **Verifiziert:** Python-Syntax weiterhin per `ast.parse` geprüft, `flutter analyze` 0 Probleme.

## Etappe 28 Nachtrag 7: Keine Ein-Wort-"Sätze" mehr bei Sätze bauen

Der Nutzer schickte einen Screenshot: ein "Sätze bauen"-Bildschirm mit nur einer Lücke (`___`) und
vier Wortoptionen - kein sichtbarer Satzkontext. Ursache gefunden: `sen_gen_yikirta` (ein Etappe-28-
generierter Satz aus dem Interjektions-Lexem "ይቅርታ"/"Entschuldigung") hat nur einen einzigen Chunk.
`generateSentenceGapChoice` ersetzt bei einem Ein-Chunk-Satz den einzigen Chunk durch die Lücke - übrig
bleibt buchstäblich nur "___", ohne jeden Kontext zum Erraten. Der Nutzer wollte das explizit behoben
haben, nicht nur für diesen einen Satz: "es kann nicht sein dass ein Satz aus einem Wort besteht".

- **Zwei Ebenen behoben, nicht nur eine.** Code-seitig (`lib/state/lesson_provider.dart`,
  `_generateSentenceExercise`): `sentenceBuild`/`sentenceGapChoice`/`sentenceGapTyping`/`listenBuild`
  werden jetzt für jeden Satz mit weniger als 2 Chunks übersprungen (`_chunkDependentTypes`-Guard) -
  eine dauerhafte Absicherung gegen jeden zukünftigen Ein-Chunk-Satz, egal woher er kommt. Zusätzlich
  mit einem gezielten Regressionstest in `test/core/lesson_provider_test.dart` abgesichert (prüft
  gegen echten Content, nicht gemockt).
- **Inhaltlich zusätzlich bereinigt, nicht nur code-seitig abgefangen** - der Nutzer wollte die
  Ein-Wort-Sätze aus der Sätze-bauen-Auswahl komplett draußen haben, nicht nur unauffällig
  übersprungen. Alle 81 Ein-Chunk-Sätze, die in irgendeiner `sentenceBuilding`-Stufe irgendeiner
  Station lagen (42 Stationen betroffen, beide Sprachen), wurden durch frisch generierte,
  garantiert mehrchunkige Sätze ersetzt - dieselben Nomen-/Adjektiv-/Verb-Schablonen wie in Etappe 28
  (Existenzsatz, Besitzsatz, "mag ich", Pronomen-Kopula), diesmal mit Phrasen/Interjektionen/
  Tigrinya-Verben (Imperativ-Form) bewusst als Quelle ausgeschlossen, da genau die die Ein-Chunk-Sätze
  verursacht hatten.
- **Bug im eigenen Ersatz-Skript gefunden und behoben, bevor geschrieben wurde:** ein erster Test-Lauf
  erzeugte Unsinn wie "ንዓ ኣሎ።" ("es gibt komm!") - Tigrinya-Verb-Lexeme (liegen als Imperativ vor)
  wurden versehentlich in die Nomen-Schablone einsortiert, weil die POS-Weiche im Ersatz-Skript den
  Tigrinya-Verb-Sonderfall (anders als im ursprünglichen Etappe-28-Skript) nicht abgefangen hatte.
  Vor dem eigentlichen Schreiben per Stichprobenkontrolle gefunden, korrigiert, erneut geprüft.
- **Vokabelknappheit bei den allerersten Stationen einer Sprache** (`unit_erste_begegnung` als erste
  Amharisch-Station, `unit_eritrea_greetings` als erste Tigrinya-Station) - dort gibt es kaum eigenes
  UND noch gar kein früheres Vokabular. Lösung: Wiederverwendung eines bereits in der Station
  genutzten Wortes für einen zweiten Satz, aber mit einer anderen Schablone (z. B. "er ist wohlauf" /
  "sie ist wohlauf" / "es ist sehr wohlauf" für `lex_dehna`) - ein echter Mehr-Wort-Satz aus
  wiederverwendetem statt neuem Wortschatz ist immer noch besser als ein Ein-Wort-Satz.
- **19 verwaiste Satz-Objekte gefunden und aufgeräumt, nicht einfach liegen gelassen.** Beim
  Entfernen der alten Ein-Chunk-Sätze aus den Lektionsstufen blieben ihre JSON-Objekte zunächst
  unreferenziert in ihren Dateien liegen (in der Annahme, das sei harmlos wie bei früheren
  Aufräumaktionen) - das brach aber `fidel_stufe_content_test.dart`s Annahme, dass jeder nicht-
  Tigrinya-Satz über eine `am`-Sektion erreichbar ist. Alle 81 verwaisten Satz-Objekte (19 Amharisch,
  62 Tigrinya) aus ihren Dateien entfernt. Bei 19 davon existierte bereits echtes, aufgenommenes
  Audio aus dem letzten Colab-Lauf (Etappe 28 Nachtrag 3) - diese Aufnahmen inklusive Manifest-
  Einträgen ebenfalls entfernt, da sie ab jetzt nichts mehr referenziert.
- **Audio-Tracking für die 81 neuen Ersatzsätze ergänzt** (Manifest + `fehlende_audiodateien.md`),
  aber bewusst NICHT die laufende `tool/audio_worklist_ti.csv` neu erzeugt/verschickt - der Nutzer
  hatte zu diesem Zeitpunkt bereits einen Colab-Lauf mit der bisherigen 2666er-Liste gestartet; ein
  Austausch der Datei mitten im Lauf hätte das nur durcheinandergebracht. Die 62 neuen Tigrinya-
  Ersatzsätze folgen im nächsten regulären Export.
- **Verifiziert:** `flutter analyze` (0 Probleme), volle Testsuite 240/240 grün (239 + 1 neuer
  Regressionstest), `content_validation_test.dart` und `fidel_stufe_content_test.dart` beide grün,
  0 verbleibende Ein-Chunk-Sätze in irgendeiner `sentenceBuilding`-Stufe (rechnerisch bestätigt).

## Etappe 28 Nachtrag 8: "Sätze bauen" aus Region 1 (Addis Abeba) entfernt

Nutzer-Feedback direkt im Anschluss an Nachtrag 7: "Sätze bauen bei den ersten Stationen macht gar
keinen Sinn, weil da Wörter benötigt werden, die man noch gar nicht kennt" - Wörter aktiv zu einem
Satz zusammenzusetzen, Sekunden nachdem man sie zum ersten Mal gesehen hat, ist für die allerersten
Stationen der ganzen App zu viel verlangt. Der Nutzer bot drei Optionen an (ganz raus, besser machen,
oder einfach raus) - bei zweifacher Nennung von "raus"/"weg" als klar geäußerte Präferenz interpretiert.

- **Die `sentenceBuilding`-Stufe komplett aus allen 7 Addis-Abeba-Einheiten entfernt**
  (`unit_erste_begegnung`, `unit_ich_und_du`, `unit_familie_menschen`, `unit_zahlen_1_20`,
  `unit_essen_trinken`, `unit_fragewoerter`, `unit_adverbien_mehr`) - nicht nur die
  chunk-abhängigen Übungstypen deaktiviert, sondern die ganze Stufe (und damit die "Sätze
  bauen"-Kachel) weg. Andere Sprachniveaus/Regionen unverändert - der Nutzer sprach explizit nur
  von den ersten Stationen.
- **Bewusst nur die Stufe entfernt, nicht die Sätze selbst.** Die 5 Sätze jeder Einheit bleiben in
  `listening`/`freeApplication`/`review` verdrahtet (Übersetzen, Wahr/Falsch, Hörverstehen) - diese
  Übungsformen verlangen kein aktives Zusammensetzen aus bekannten Wortbausteinen, sondern eher
  Wiedererkennen/Verstehen, was für den allerersten Kontakt angemessener ist. Kein Inhalt verloren,
  nur die eine zu anspruchsvolle Übungsform.
- **Technisch bereits als sicher bekannt:** `unit_ich_und_du` hatte vor Etappe 28 Nachtrag 7 schon
  einmal gar keine `sentenceBuilding`-Stufe (eine strukturelle Anomalie, die dort behoben wurde) -
  die App kam damit klar, ohne Sonderbehandlung im Code. Das Entfernen der Stufe für ganz Region 1
  ist also kein neuer, ungetesteter Zustand.
- **Zwei bestehende Tests mussten auf eine andere Einheit umgestellt werden**
  (`test/core/lesson_provider_test.dart`, Gruppe "sentence lessons"): beide nutzten bisher
  `unit_erste_begegnung`s (jetzt entfernte) `sentenceBuilding`-Stufe - umgestellt auf
  `unit_wetter_natur` (Oromia, Region 2), das dieselbe Struktur weiterhin hat.
- **Der zweite Test wurde inhaltlich neu ausgerichtet statt nur umbenannt:** er prüfte bisher explizit
  gegen drei konkrete Ein-Chunk-Sätze (`sen_gen_selam`/`ibakih`/`yikirta`), die es seit Nachtrag 7
  gar nicht mehr gibt. Jetzt prüft er allgemein, dass jede chunk-abhängige Übung in einer echten
  Lektion auf einen Satz mit mindestens 2 Chunks zeigt - und die eigentliche, dauerhafte Absicherung
  sitzt jetzt als eigener Test in `content_validation_test.dart` ("every sentence referenced by a
  sentenceBuilding-kind lesson stage has at least 2 chunks"), der die komplette Content-Basis prüft,
  nicht nur eine Beispiel-Lektion.
- **Verifiziert:** `flutter analyze` (0 Probleme), volle Testsuite 241/241 grün (240 + 1 neuer
  Content-Validierungstest).

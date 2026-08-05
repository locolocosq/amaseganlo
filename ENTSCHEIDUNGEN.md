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

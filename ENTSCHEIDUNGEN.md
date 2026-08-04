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

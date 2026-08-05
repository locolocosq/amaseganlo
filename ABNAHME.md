# Abnahme (Selbstabnahme, Etappe 11)

Datum: 2026-08-05. Dieses Dokument ist die abschließende Selbstprüfung vor der
Übergabe: was automatisiert geprüft wurde, was ich manuell im Browser
durchgespielt habe, und welche Lücken bewusst offen geblieben sind (mit
Begründung).

## 1. Automatisierte Prüfungen

- `flutter analyze`: **0 Probleme.**
- `flutter test`: **160 von 160 Tests grün**, Laufzeit ~10-20s (siehe
  ENTSCHEIDUNGEN.md Etappe 7 für die frühere Ursache extrem langer Laufzeiten
  und deren Behebung).
- Inhalts-Prüfung (`test/content/`, `test/models/`): mindestens 1000 eindeutige
  Vokabeln (tatsächlich 1017), Struktur-Referenzen (jede Lektion verweist auf
  existierende Vokabeln/Sätze/Fidel-Zeichen), Fidel-Dekodierbarkeit pro Stufe,
  gleiche Übersetzungsschlüssel in allen 4 Sprachdateien (`test/core/l10n_parity_test.dart`),
  keine leeren Übersetzungswerte.
- Kein `dart:io`-Import irgendwo unter `lib/` (nur eine Erwähnung in einem
  Doc-Kommentar). Alle Pakete in `pubspec.yaml` sind Web/Android/iOS-kompatibel
  (kein Paket mit ausschließlich nativer Implementierung).

## 2. Manuell im Browser durchgespielt (diese Sitzung)

Mit `flutter run -d web-server` gestartet und im Vorschau-Browser bedient:

- Onboarding-Flow komplett durchgeklickt (4 Schritte, Sprachwahl-Dropdown,
  Tagesziel, Einstufungsfrage) - landet korrekt auf dem Hauptbildschirm.
- Erste Lektion („Neue Wörter" von „Erste Begegnung") komplett gespielt -
  Wortkarten, Fortschrittsbalken, Abschluss-Bildschirm mit XP/Trefferquote/Dauer.
- „Weiterlernen"-Karte erscheint danach korrekt auf dem Lernpfad und springt
  beim Antippen direkt in die nächste offene Lektion desselben Kapitels.
- Tastenkürzel in einer echten Übung getestet: Taste `1` wählt die erste
  Antwortoption (mit sichtbarem Feedback), `Escape` überspringt eine
  Paar-Zuordnungsübung, `Enter` bestätigt/geht weiter - alle drei wie erwartet.
- „Fortschritt sichern" in den Einstellungen ausgelöst - löst im Web
  erwartungsgemäß einen Browser-Download aus, zeigt die Erfolgsmeldung.
- „Fortschritt wiederherstellen" ausgelöst und abgebrochen (Escape) - kein
  Absturz, keine Fehlermeldung, sauberer Zustand danach.
- Ungültige URL aufgerufen (`#/this-route-does-not-exist`) - zeigt die
  freundliche Fehlerseite („Da ist etwas schiefgelaufen" / „Zurück zur
  Startseite"), Button führt zurück zum Lernpfad.
- Zurück-Button-Tooltip per Hover geprüft (zeigt „Schließen") - bestätigt, dass
  die neu ergänzten Tooltips tatsächlich als Screenreader-Text ankommen.
- Responsive: 320px-Breite (Mobil-Untergrenze) - Text bricht sauber um, keine
  abgeschnittenen Elemente, Navigationsleiste passt. Große Bildschirmbreite
  (1400px) - Inhalt bleibt auf 600px zentriert, kein ausuferndes Layout.
- Dark Mode geprüft - Farben/Kontraste wirken durchgängig stimmig.

## 3. Bekannte, bewusst offene Lücken

Diese drei Punkte sind unverändert seit den jeweiligen Etappen offen, weil sie
entweder das Herunterladen einer Datei ohne vorherige Chat-Erlaubnis oder eine
Bildgenerierungsfähigkeit erfordern würden, die mir nicht zur Verfügung steht:

- **App-Icon-Bild** (`assets/icon/app_icon.png`): fehlt. Der App-*Name* ist seit
  Etappe 10 überall korrekt „Amaseganlo" (Android-Manifest, Web-Manifest,
  `index.html`). `flutter_launcher_icons` ist in `pubspec.yaml` vorkonfiguriert
  und kann sofort ausgeführt werden, sobald eine PNG-Datei unter diesem Pfad
  liegt.
- **NotoSansEthiopic-Schriftdatei**: die App nutzt für äthiopische Schrift
  aktuell die System-Schriftart als Rückfall statt einer eingebetteten Fidel-
  optimierten Schrift.
- **Echte Audio-Aufnahmen**: `assets/audio/manifest.json` existiert mit dem
  richtigen Schema, ist aber leer - Ton läuft ausschließlich über
  Text-to-Speech (falls eine Amharisch-Stimme auf dem Gerät verfügbar ist),
  nie über vorproduzierte Aufnahmen.

Alle drei sind rein additive Lücken: die App stürzt nicht ab, wenn diese
Dateien fehlen (siehe jeweilige Rückfall-Logik), sie liefert nur nicht das
optisch/akustisch vollständigste Ergebnis.

Inhaltliche (nicht funktionale) Unsicherheiten bei einzelnen Vokabeln/Fidel-
Zeichen, die eine Muttersprachlerin/ein Muttersprachler gegenlesen sollte,
stehen separat in [PRUEFLISTE.md](PRUEFLISTE.md).

## 4. Start-Befehl

```
flutter run -d edge
```

(oder `-d chrome`, `-d web-server`; für Android/iOS-Emulatoren das jeweilige
Gerät statt `-d edge` angeben).

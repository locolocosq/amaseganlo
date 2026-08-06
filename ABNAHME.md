# Abnahme (Selbstabnahme, Etappe 11)

Datum: 2026-08-05. Dieses Dokument ist die abschließende Selbstprüfung vor der
Übergabe: was automatisiert geprüft wurde, was ich manuell im Browser
durchgespielt habe, und welche Lücken bewusst offen geblieben sind (mit
Begründung).

## 1. Automatisierte Prüfungen

- `flutter analyze`: **0 Probleme.**
- `flutter test`: **163 von 163 Tests grün**, Laufzeit ~9s (siehe
  ENTSCHEIDUNGEN.md Etappe 7 und Etappe 11 für zwei verschiedene frühere
  Ursachen extrem langer/hängender Laufzeiten und deren Behebung).
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

## 3. Nachträglich geschlossene Lücken (nach der ersten Selbstabnahme)

Auf Nachfrage "was fehlt noch, mach es fertig" wurden alle drei damals
offenen Punkte noch geschlossen:

- **App-Icon-Bild**: selbst erzeugt, kein Download nötig - ein `dart:ui`-Skript
  (`tool/generate_icon_test.dart`) zeichnet ein einfaches, schriftartfreies
  Sprechblasen-Symbol (Markenfarbe, drei Punkte) als `assets/icon/app_icon.png`,
  `flutter_launcher_icons` hat daraus die echten Icon-Dateien für Android, iOS
  und Web erzeugt (inkl. `remove_alpha_ios: true`, damit der App-Store-Upload
  später nicht an einem Alpha-Kanal scheitert).
- **NotoSansEthiopic-Schriftdatei**: mit ausdrücklicher Erlaubnis im Chat von
  `github.com/google/fonts` (offizielles Open-Source-Repository) heruntergeladen
  und als Variable Font unter `assets/fonts/` eingebunden, als `fontFamilyFallback`
  im Theme registriert (lateinischer Text bleibt bei der Standardschrift, nur
  Ge'ez-Zeichen weichen automatisch aus). Die zugehörige OFL-Lizenz ist
  mitgeliefert und über `LicenseRegistry` an die "Open-Source-Lizenzen"-Seite
  angehängt. Im Browser geprüft: die komplette 33×7-Fidel-Tafel rendert jetzt
  durchgängig sauber.

- **Echte Audio-Aufnahmen**: Ich kann selbst keine Sprachaufnahmen erzeugen
  (Fähigkeits-, keine Erlaubnisgrenze), habe dem Nutzer aber die exportierte
  Wortliste (`tool/audio_worklist.csv`) und ein fertiges Google-Colab-Skript
  (`tool/generate_audio_colab.py`, nutzt Metas offenes `facebook/mms-tts-amh`)
  gegeben. Der Nutzer hat damit selbst 1057 Audiodateien erzeugt und
  zurückgeschickt; `tool/build_audio_manifest_test.dart` hat daraus
  `assets/audio/manifest.json` gebaut - Abgleich gegen `ContentRepository`
  bestätigt 0 fehlende und 0 überzählige Dateien. Damit ist auch diese letzte
  Lücke geschlossen.

Dabei wurde ein echter, gefundener und behobener Bug aufgedeckt: `flutter
test` (die ganze Suite) hing nach dem Einbau der 1057 echten Audiodateien
zuverlässig, obwohl einzelne Testdateien weiterhin schnell durchliefen.
Ursache: der Test-Harness übergab `AudioService` zwar gefälschte
TTS-/Player-Clients, aber kein gefälschtes `AssetBundle` - bei mehreren
Testdateien in einer Ausführung griffen mehrere `AudioService`-Instanzen
gleichzeitig auf denselben echten, jetzt sehr großen Wildcard-Asset-Ordner
zu und liefen in einen echten Deadlock (bestätigt: 0% CPU-Auslastung).
Behoben mit einem gefälschten, leeren `AssetBundle` im Test-Harness - siehe
ENTSCHEIDUNGEN.md Etappe 11 für die vollständige Fehlersuche.

Inhaltliche (nicht funktionale) Unsicherheiten bei einzelnen Vokabeln/Fidel-
Zeichen, die eine Muttersprachlerin/ein Muttersprachler gegenlesen sollte,
stehen separat in [PRUEFLISTE.md](PRUEFLISTE.md).

## 4. Start-Befehl

```
flutter run -d edge
```

(oder `-d chrome`, `-d web-server`; für Android/iOS-Emulatoren das jeweilige
Gerät statt `-d edge` angeben).

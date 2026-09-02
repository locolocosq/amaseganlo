# Stand der Arbeit — Habesha Speak (Stand: 2026-08-15)

Diese Datei fasst den aktuellen Stand zusammen, damit eine neue Claude-Code-Sitzung
(auf einem anderen PC) nahtlos weitermachen kann.

## Was die App ist

Habesha Speak (früher "Amaseganlo") ist eine Flutter-App zum Amharisch-Lernen
(Sprache aus Äthiopien), mit einer "Busreise durch Äthiopien" als Lernpfad-Metapher,
Fidel-Schrift-Training, über 1000 Vokabeln, Spaced-Repetition-Wiederholung,
Premium-Paywall (In-App-Kauf) und lokaler Push-Erinnerung.

- Package-Name: `com.vfyg.habeshaspeak`
- Aktuelle Version: 1.4.1+7 (siehe `pubspec.yaml`)
- Play-Store-Entwicklerkonto: neu angelegt, noch kein bestehendes Konto vorher

## Was in dieser Session fertig wurde

1. **Bugfix Backup/Export** (`lib/screens/settings/settings_screen.dart`): Das
   Speichern des Fortschritts als Datei funktionierte auf Android/iOS nicht, weil
   `file_selector`s `getSaveLocation()` dort gar nicht implementiert ist. Fix: auf
   Mobile wird jetzt `share_plus` (Share-Sheet) verwendet, Web/Desktop bleiben beim
   alten Speicherdialog-Flow.
2. **Bugfix Bus-Positionsdrift** (`lib/screens/path/world_map_screen.dart` +
   `region_detail_screen.dart`): Der Bus landete nicht an der richtigen Station,
   sondern versetzte sich zunehmend, weil die Fortschritts-Berechnung einen naiven
   Index-Bruchteil statt der echten kumulativen Pfadlänge nutzte. Fix: echte
   `Path.computeMetrics()`-Längen werden jetzt verwendet.
3. Neue Tests: `test/widgets/settings_backup_progress_test.dart`,
   `test/widgets/world_map_bus_position_test.dart`,
   `test/widgets/dev_code_unlock_test.dart` — alle validiert (Fix testweise
   zurückgedreht → Test schlägt erwartungsgemäß fehl → Fix wiederhergestellt →
   Test grün).
4. Version auf 1.4.1+7 gehoben, neue AAB gebaut und ausgeliefert.
5. Umfangreiche Play-Store-Einreichungsberatung: Konto-Erstellung, App-Formular,
   Finanzfunktionen (nein), Anmeldedaten/App-Zugriff (Premium-Freischaltung über
   versteckten Dev-Code, siehe unten), Altersfreigabe-Fragebogen, Datensicherheit
   (keine Datenerhebung), Werbe-ID (nein), Store-Eintrag-Texte + Grafiken erstellt.
6. Recherche + Vorbereitung zur Tester-Anwerbung für den geschlossenen Test
   (12 Tester/14 Tage Google-Anforderung): Reddit-Post-Entwurf, WhatsApp-Nachricht,
   englische Beta-Tester-Nachricht, Erklärung zu Google-Groups-basiertem
   Tester-Opt-in (offene Gruppe statt manueller E-Mail-Liste).

## Wichtige technische Fakten, die man kennen sollte

- **Versteckter Premium-Entwicklercode**: In `lib/core/dev_code.dart` liegt nur
  der SHA-256-Hash, nicht der Code selbst (der Klartext wurde bei der
  GitHub-Veröffentlichung aus diesem Dokument und `ENTSCHEIDUNGEN.md` entfernt und
  rotiert, siehe dort - steht seither an keiner Stelle mehr in einer versionierten
  Datei). Aufruf: Einstellungen → "Über die App" → 7x auf die Versionsnummer tippen
  → Dialog → Code eingeben. Falls dieser Code für Google Plays
  "Anmeldedaten"-Formular (App-Zugriff für Prüfer) eingetragen wurde: dort auf den
  neuen Code aktualisieren, sonst funktioniert der Zugang für Prüfer nicht mehr.
- **`defaultTargetPlatform`/`kIsWeb` statt `dart:io` Platform** wird bewusst
  verwendet, damit die Web-Kompilierung nicht bricht (siehe
  `ENTSCHEIDUNGEN.md` Etappe 10).
- Kein Analytics-, Ads- oder Tracking-SDK in der App — alle Datenschutz-/
  Datensicherheits-Formulare wurden entsprechend mit "Nein"/"keine Datenerhebung"
  beantwortet.

## Store-Materialien (liegen jetzt in `store-assets/`)

- `store_beschreibung.md` — Kurze + vollständige Play-Store-Beschreibung (DE)
- `datenschutzerklaerung.md` — Text für die Datenschutzerklärung (muss noch auf
  einer echten URL gehostet werden, z. B. Google Sites — E-Mail-Kontakt im Text
  noch mit echter Adresse ausfüllen)
- `app_icon_512.png` — App-Symbol in 512×512 fürs Store-Formular
- `feature_graphic_1024x500.png` — Vorstellungsgrafik im Markendesign
- `shot_01_map.png`, `shot_02_fidel.png`, `shot_03_profil.png` — Store-Screenshots
  (16:9, aus dem laufenden Flutter-Web-Build extrahiert)
- `reddit_tester_post.md` — Entwurf für r/AndroidClosedTesting (wurde vom
  Reddit-Filter entfernt — vermutlich weil neuer/karma-armer Account; Alternative:
  Google-Groups-Methode + eigenes Netzwerk)
- `tester_nachricht_final.md` — Fertige deutsche WhatsApp-Nachricht für Freunde/
  Familie zur Testeranwerbung (inkl. Google-Groups-Link, Opt-in-Link, Store-Link)
- `beta_tester_message_en.md` — Englische Version für fremde Interessenten

## Offene / nächste Schritte

1. **Play-Store-Einreichung fertigstellen**: Die letzten offenen Formularfelder
   ausfüllen (siehe store-assets/ für Texte) und zur Prüfung einreichen, sobald
   genug Tester (12, 14 Tage durchgehend opted-in) zusammen sind.
2. **Tester sammeln**: Google-Groups-Methode einrichten (offene Beitrittsgruppe
   statt E-Mail-Liste), Link über WhatsApp/eigenes Netzwerk + andere Kanäle
   streuen (Facebook-Gruppen, Discord, Telegram — Reddit hat den Post gefiltert).
   Ziel: 12+ gleichzeitig opted-in für 14 Tage am Stück (fällt die Zahl
   zwischendurch unter 12, reißt die Kette ab).
3. **Datenschutzerklärung hosten**: Text aus `store-assets/datenschutzerklaerung.md`
   auf einer echten URL veröffentlichen (z. B. Google Sites), dann die URL ins
   Play-Console-Formular eintragen.
4. **Apple App Store (später geplant)**: Braucht Mac/Xcode zum Bauen — Plan ist
   ein CI-Dienst wie Codemagic zu nutzen, da kein eigener Mac vorhanden. Neue
   In-App-Kauf-Produkte müssten in App Store Connect separat angelegt werden
   (StoreKit statt Play Billing). Datenschutzerklärung/Store-Texte können
   wiederverwendet werden, Screenshots müssen aber in Apples eigenen
   Formaten (6.7"/6.5"/5.5" iPhone, iPad) neu erstellt werden.
5. **`region_detail_screen.dart`s Bus-Positions-Fix** hat noch keinen eigenen,
   gezielten Regressionstest (nur indirekt über die volle Test-Suite abgedeckt).

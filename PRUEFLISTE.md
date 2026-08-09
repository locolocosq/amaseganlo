# Prüfliste

Alle Inhalte mit `"verified": false` bzw. Zeichen, die eine Muttersprachlerin/ein Muttersprachler gegenlesen sollte, sortiert nach Abschnitt.

## Fidel-Tafel (assets/content/fidel.json, erzeugt von tool/gen_fidel.dart)

Die komplette 33×7-Tafel wurde nach bestem Wissen zusammengestellt. Hohe Sicherheit bei den häufigen Reihen (ha, la, hha, ma, ra, sa, sha, qa, ba, ta, na, aa/ka, wa, za, ya, da, ja, ga, tta, tsa, tsa2, fa). **Geringere Sicherheit** bei folgenden, selteneren Reihen - bitte vorrangig gegenlesen:

| group | Zeichen (Ordnung 1-7) | Laut | Grund der Unsicherheit |
|---|---|---|---|
| hha2 | ኀኁኂኃኄኅኆ | h (3. gleichklingendes h) | Seltene, archaische Reihe - Formen der Ordnungen 2,3,5,7 nicht mit letzter Sicherheit geprüft. |
| aa | አኡኢኣኤእኦ | a (Glottal) | Bekannt unregelmäßige Reihe (Ordnung 4 und 6 weichen vom Muster ab) - deshalb `regular: false`. |
| kha | ኸኹኺኻኼኽኾ | kh | Sehr seltener Buchstabe im modernen Amharisch, kaum belegt - `regular: false` zur Vorsicht. |
| aa2 | ዐዑዒዓዔዕዖ | a (2. gleichklingendes a) | Wie „aa“ - unregelmäßige Reihe, dazu selten im Alltagstext. |
| zha | ዠዡዢዣዤዥዦ | zh | Sehr seltener Buchstabe (v. a. Lehnwörter) - `regular: false` zur Vorsicht. |
| ppa | ጰጱጲጳጴጵጶ | p' | Seltener Buchstabe (v. a. griechische Lehnwörter) - `regular: false` zur Vorsicht. |

**Empfehlung:** Vor dem produktiven Einsatz die komplette Tafel einmal von einer Muttersprachlerin/einem Muttersprachler gegen eine gedruckte Fidel-Tafel prüfen lassen - Ethiopic-Unicode hat einige einander sehr ähnliche Zeichen, bei denen ich mir ohne diese Prüfung keine 100%ige Sicherheit zutraue.

## Fidel-Extras (assets/content/fidel_extras.json, Stufe 7)

- **Ziffern 20-100** (፳ ፴ ፵ ፶ ፷ ፸ ፹ ፺ ፻): geringere Sicherheit als die Ziffern 1-10 (die direkt aus dem Auftrag stammen) - bitte gegenlesen.
- **Absatztrenner ፨**: geringere Sicherheit.
- **Labialisierte Formen (Etappe 24): jetzt die vollständige Liste statt 4 Beispielen** - recherchiert anhand einer externen Quelle (r12a.github.io Amharic-Schriftdokumentation, nicht nur aus eigenem Wissen). Die vier realen Reihen (jeweils Ordnung 1,3,4,5,6 - Ordnung 2 und 7 existieren nicht, die wären identisch mit dem unlabialisierten Zeichen):
  - qʷ-Reihe: ቈ ቊ ቋ ቌ ቍ - hohe Sicherheit, gängig im modernen Amharisch.
  - kʷ-Reihe: ኰ ኲ ኳ ኴ ኵ - hohe Sicherheit, gängig.
  - gʷ-Reihe: ጐ ጒ ጓ ጔ ጕ - hohe Sicherheit, gängig.
  - hʷ-Reihe: ዀ ዂ ዃ ዄ ዅ - **geringere Sicherheit**, sehr seltene/archaische Reihe (labialisierte Form des ohnehin schon seltenen ኀ-Lauts), `verified: false`.
- **ቷ ("twa") und ኧ ("ea") in eigene Kategorie "other" verschoben**, nicht mehr unter "labialized" - meine Recherche fand keine der beiden als Teil des echten q/k/g/h-labialisierten Systems. Beide bleiben trotzdem im Datensatz (der ursprüngliche Auftrag hatte sie ausdrücklich als Beispiele genannt), aber weiterhin `verified: false` - bitte insbesondere prüfen, ob ቷ überhaupt ein im modernen Amharisch verwendetes eigenständiges Zeichen ist oder eher eine seltene/informelle Schreibweise.

## Abschnitt A1.1 — Erste Begegnung

| id | Amharisch | Umschrift | Meine Übersetzung | Grund der Unsicherheit |
|---|---|---|---|---|
| lex_aydelem | አይደለም | aydelem | Nein | Wörtlich Verneinung von „sein“, nicht sicher, ob im Alltag durchgehend als generelles „Nein“ verstanden wird. |
| lex_ibakih | እባክህ | ibakih | Bitte (zu einem Mann) | Genus-abhängige Form (ibakih/ibakish) - Grundform unsicher, ob sie hier korrekt zugeordnet ist. |
| lex_yikirta | ይቅርታ | yikirta | Entschuldigung / Verzeihung | Transliteration nach meinem Regelwerk nicht 100% sicher. |
| lex_algebagnem | አልገባኝም | algebagnim | Ich verstehe nicht | Verbform (1. Person, negiert) - Konjugation nicht mit letzter Sicherheit geprüft. |
| lex_dehna | ደህና | dehna | gut / wohl | Einfaches Wort, aber Übersetzungsnuance („gut“ vs. „in Ordnung“) unsicher. |
| sen_dehna_negn | ደህና ነኝ። | dehna negn. | Mir geht es gut. | Copula-Form „negn“ (1. Person) - Zusammenschreibung/Betonung nicht letztgültig geprüft. |
| sen_ine_ityopiawi | እኔ ኢትዮጵያ ውስጥ ነኝ። | ine ityopia wist negn. | Ich bin in Äthiopien. | Satzstellung mit „wist“ (in/innerhalb) - Wortstellung und ob „wist“ hier die natürlichste Wahl ist, nicht sicher. |

## Abschnitt A1.1 — Ich und du

| id | Amharisch | Umschrift | Meine Übersetzung | Grund der Unsicherheit |
|---|---|---|---|---|
| lex_sim | ስም | sim | der Name | Einfaches Nomen, aber Vokallänge/Betonung in der Umschrift nicht letztgültig geprüft. |

---

## Restlicher Wortschatz (Etappe 5, Zusatz-Kapitel A-E)

Um die im Auftrag geforderten mindestens 1000 Vokabeln zu erreichen, wurden über die 20 vorgeschriebenen Kapitel hinaus 51 weitere Zusatz-Kapitel erzeugt (`tool/gen_supplement_a.dart` bis `tool/gen_supplement_e.dart`). Bei diesem Umfang war eine wort-für-wort-Prüfung durch mich allein nicht seriös möglich - im Sinne von Abschnitt 14 ("lieber 1000 richtige Wörter mit markierten Zweifelsfällen als geratene") wurde daher bewusst großzügig mit `"verified": false` markiert, statt bei Unsicherheit zu raten.

**Stand: 468 von 1017 Vokabeln (46%) sind `"verified": false`.** Auffindbar per Volltextsuche nach `"verified": false` in `assets/content/lexemes_*.json`, oder programmatisch über `ContentRepository`/die rohen JSON-Dateien.

Als `verified: true` markiert sind nur Wörter, bei denen ich hohe Sicherheit habe: Zahlen, sehr geläufige Alltagswörter, bekannte Lehnwörter (z.B. ባንክ/bank, ፕላኔት/planet) und ikonisch-äthiopische Begriffe (z.B. buna, berbere, teff, kitfo, meskel).

Kategorien mit besonders hoher Unsicherheit, die vorrangig gegengelesen werden sollten:

- **Umschreibende Mehrwort-Ausdrücke** statt eines echten Einzelworts, z.B. „Cousin/Cousine", „Witwer", „Stiefmutter" (unit_familie_mehr) - hier bin ich mir nicht sicher, ob es nicht doch etablierte kürzere Einzelwörter gibt.
- **Abstrakte/seltenere Substantive und Fachbegriffe** in unit_substantive_mehr, unit_substantive_3, unit_recht_justiz, unit_astronomie, unit_finanzen - viele davon sind eher aus dem Wortstamm erschlossen als aus aktivem Sprachgebrauch bekannt.
- **Gefühls- und Persönlichkeits-Adjektive** (unit_gefuehle_mehr, unit_gefuehle_3, unit_persoenlichkeit) - im Amharischen oft eher als Verb- oder Nomenkonstruktion ausgedrückt als als einfaches Adjektiv; meine Wortartzuordnung ist hier unsicher.
- **Kochverben** (unit_verben_kochen) - die Abgrenzung zwischen z.B. „braten" und „rösten" ist im Amharischen möglicherweise anders gezogen als im Deutschen.

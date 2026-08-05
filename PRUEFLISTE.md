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
- **ኧ (als „ea“ notiert)**: im Auftrag nur als Beispiel genannt, meine Umschrift dafür ist unsicher.
- **Labialisierte Formen sind nur eine kleine Beispielauswahl** (ኳ ጓ ቷ ኧ, direkt aus dem Auftrag übernommen), keine vollständige Liste aller labialisierten Zeichen. Eine vollständige Liste bräuchte eine eigene Recherche mit Muttersprachler-Prüfung.

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

Weitere Einträge kommen in Etappe 5 hinzu, sobald der volle Wortschatz (mind. 1000 Vokabeln) erstellt wird.

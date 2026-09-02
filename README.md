# Habesha Speak

Habesha Speak ist eine App zum Lernen von Amharisch (der Amtssprache Äthiopiens) und Tigrinya (der Sprache Eritreas). Sie richtet sich an Menschen, die noch keine Vorkenntnisse haben, und arbeitet ohne Konto, ohne Internetverbindung im Betrieb und ohne Werbung.

## Wie man die App öffnet

Die App läuft direkt im Browser, auch auf dem iPhone:

https://locolocosq.github.io/amaseganlo/

Man ruft die Adresse einfach in Safari (oder einem anderen Browser) auf. Es ist keine Installation nötig. Der Lernfortschritt wird lokal im Browser gespeichert, nicht auf einem Server - wer den Browser-Speicher der Seite löscht, verliert damit auch den Fortschritt.

Alternativ kann man das Projekt als Flutter-App auf dem eigenen Rechner bauen und auf einem Android- oder iOS-Gerät installieren. Dafür wird das Flutter-SDK benötigt (siehe https://docs.flutter.dev/get-started/install). Mit dem SDK im Pfad reicht im Projektordner:

```
flutter pub get
flutter run
```

## Wie man die App bedient

Beim ersten Öffnen fragt die App kurz nach der Sprache der Bedienoberfläche (Deutsch, Englisch, Schwedisch, Niederländisch, Italienisch oder Spanisch) und nach einem täglichen Lernziel. Wer schon etwas Amharisch kann, kann das in einem kurzen Einstufungstest angeben, um nicht ganz vorne anfangen zu müssen.

Danach gibt es vier Bereiche, erreichbar über die Leiste am unteren Bildschirmrand:

- **Lernen**: der Hauptweg. Auf einer Landkarte von Äthiopien (und, per Wischen zur Seite, Eritrea) gibt es mehrere Regionen mit jeweils mehreren Stationen. Jede Station besteht aus mehreren kurzen Lektionen: neue Wörter, Wörter üben, Sätze bauen, Hören, freies Anwenden und eine Wiederholung. Am Ende einer Station steht eine kleine Prüfung.
- **Fidel**: ein zweiter, paralleler Lernweg für die äthiopische Schrift (das Fidel-Alphabet). Wer nur die lateinische Umschrift lernen will, kann diesen Bereich einfach ignorieren.
- **Wiederholen**: fällige Wiederholungen von bereits gelernten Wörtern, sortiert nach Fälligkeit, sowie freies Üben nach Niveau.
- **Profil**: Lernstatistiken, ein Wörterbuch der bereits gelernten Wörter, Abzeichen für erreichte Meilensteine, und der Einstufungstest, falls man ihn nachträglich noch machen möchte.

In den Übungen tippt oder wählt man Übersetzungen, baut Sätze aus einzelnen Wortstücken, hört sich Aussprache an und beantwortet Wahr-Falsch-Fragen. Ein rotes Herz-Symbol zeigt an, wie viele Fehler innerhalb einer Lektion noch erlaubt sind (das lässt sich in den Einstellungen auch abschalten).

Über das Zahnrad-Symbol oben rechts erreicht man die Einstellungen: Bedienoberflächen-Sprache, Erscheinungsbild (hell/dunkel/System), Schriftgröße, Lautstärke und Sprechtempo der Aussprache, tägliches Lernziel, eine tägliche Erinnerung, sowie eine Sicherung und Wiederherstellung des eigenen Lernfortschritts als Datei.

## Was in diesem Repository liegt

- `lib/`, `assets/`, `test/`: der Flutter-Quellcode, die Lerninhalte (Wörter, Sätze, Audio) und die automatisierten Tests.
- `docs/`: die fertig gebaute Web-Version, über die GitHub Pages die Adresse oben ausliefert. Wird neu gebaut mit `flutter build web --base-href /amaseganlo/` und dann nach `docs/` kopiert.
- `tool/`: Hilfsskripte, mit denen die Lerninhalte und Audiodateien erzeugt wurden.
- `ENTSCHEIDUNGEN.md`: eine laufende Dokumentation der wichtigeren Entscheidungen und Änderungen an der App.

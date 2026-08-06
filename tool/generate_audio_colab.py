# ============================================================
#  Habesha Speak - Amharisch-Audio mit Microsoft Edge-Neural-Stimmen erzeugen
# ============================================================
#  Warum dieser Ansatz statt Meta MMS (die vorherige Version dieses
#  Skripts): MMS-TTS ist ein Forschungsmodell fuer >1100 Sprachen, laut
#  Meta ueberwiegend mit Lesungen religioeser Texte trainiert - dadurch
#  klang die Aussprache bei vielen Alltagswoertern schief. "edge-tts" ist
#  ein freies, quelloffenes Tool (github.com/rany2/edge-tts), das dieselben
#  professionell produzierten Amharisch-Neural-Stimmen anspricht, die auch
#  hinter Microsofts kostenpflichtiger Azure-Sprachsynthese stehen - und
#  zwar ueber Edge-Browsers kostenlose "Laut vorlesen"-Funktion, ganz ohne
#  Azure-Account oder API-Schluessel. Qualitativ ist das eine ganz andere
#  Kategorie als ein Multi-Sprachen-Forschungsmodell, weil es sich um
#  echte, fuer genau diese Sprache aufgenommene/trainierte Stimmen handelt.
#
#  So geht's:
#  1) colab.research.google.com -> "Neues Notebook"
#     (keine GPU noetig - dieses Skript ruft nur einen Online-Dienst auf,
#     der normale kostenlose CPU-Laufzeittyp reicht locker)
#  2) Diesen kompletten Code in eine Zelle einfuegen, ausfuehren.
#  3) Im Upload-Dialog "audio_worklist.csv" auswaehlen (die Datei, die dir
#     mitgeschickt wurde - enthaelt alle Woerter/Saetze mit ihrer ID).
#  4) Warten, bis "Fertig!" erscheint - da nur Netzwerk-Anfragen noetig
#     sind (kein Modell-Download, keine GPU-Berechnung), ist das deutlich
#     schneller als mit MMS: bei ~1057 Eintraegen realistisch 5-15 Minuten.
#  5) audio_output.zip wird automatisch zum Download angeboten.
#  6) Diese zip-Datei an Claude zurueckschicken - der Rest (Einbau in die
#     App) passiert dann automatisch.
#
#  Stimme wechseln: Standard ist "am-ET-MekdesNeural" (weiblich). Fuer die
#  maennliche Stimme VOICE unten auf "am-ET-AmehaNeural" setzen.
#  SPEECH_RATE ("-10%") laesst die Stimme etwas langsamer sprechen als im
#  normalen Gespraech - das verbessert erfahrungsgemaess die Verstaend-
#  lichkeit fuer Sprachlerner. Auf 0% stellen fuer normales Sprechtempo.
# ============================================================

!pip install -q edge-tts

import asyncio
import csv
import os
import shutil
import subprocess

import edge_tts
from google.colab import files

VOICE = "am-ET-MekdesNeural"
SPEECH_RATE = "-10%"
MAX_CONCURRENT_REQUESTS = 8
MAX_RETRIES = 3

RAW_DIR = "output_raw"
MP3_DIR = "output_mp3"
os.makedirs(RAW_DIR, exist_ok=True)
os.makedirs(MP3_DIR, exist_ok=True)

print("Bitte audio_worklist.csv auswaehlen...")
uploaded = files.upload()
csv_path = list(uploaded.keys())[0]

with open(csv_path, encoding="utf-8") as f:
    rows = list(csv.DictReader(f))

print(f"{len(rows)} Eintraege gefunden. Stimme: {VOICE}, Tempo: {SPEECH_RATE}")


async def synthesize_one(row, semaphore):
    item_id = row["id"]
    text = row["amharic"]
    raw_path = os.path.join(RAW_DIR, f"{item_id}.mp3")

    if os.path.exists(raw_path):
        return  # schon erzeugt (z.B. nach Neustart der Zelle) - ueberspringen

    async with semaphore:
        for attempt in range(1, MAX_RETRIES + 1):
            try:
                communicate = edge_tts.Communicate(text, VOICE, rate=SPEECH_RATE)
                await communicate.save(raw_path)
                return
            except Exception as exc:  # Netzwerk-Hickser sind bei vielen
                # schnellen Anfragen an einen kostenlosen Dienst normal.
                if attempt == MAX_RETRIES:
                    print(f"  FEHLER bei {item_id} nach {MAX_RETRIES} Versuchen: {exc}")
                else:
                    await asyncio.sleep(2 * attempt)


async def synthesize_all():
    semaphore = asyncio.Semaphore(MAX_CONCURRENT_REQUESTS)
    done = 0
    for i in range(0, len(rows), MAX_CONCURRENT_REQUESTS):
        batch = rows[i:i + MAX_CONCURRENT_REQUESTS]
        await asyncio.gather(*(synthesize_one(row, semaphore) for row in batch))
        done += len(batch)
        print(f"{min(done, len(rows))}/{len(rows)} erledigt...")


await synthesize_all()

print("Normalisiere Encoding (garantiert abspielbares Format fuer Android/iOS/Web)...")
for fname in os.listdir(RAW_DIR):
    if not fname.endswith(".mp3"):
        continue
    raw_path = os.path.join(RAW_DIR, fname)
    mp3_path = os.path.join(MP3_DIR, fname)
    # -ar 44100 ist hier keine reine Vorsichtsmassnahme, sondern noetig:
    # der Dienst liefert das Rohaudio als 24 kHz mp3 - unter 32 kHz wechselt
    # praktisch jeder MP3-Encoder (nicht nur ffmpeg) auf das weniger
    # kompatible MPEG-2-Profil, exakt die schon behobene Ursache des
    # "Audio funktioniert nicht"-Bugs bei den vorherigen MMS-Dateien (siehe
    # ENTSCHEIDUNGEN.md) - ohne dieses Resampling wuerde derselbe Fehler
    # mit der neuen Stimme nur wieder auftreten.
    subprocess.run(
        ["ffmpeg", "-y", "-i", raw_path, "-ar", "44100", "-codec:a", "libmp3lame", "-qscale:a", "4", mp3_path],
        stdout=subprocess.DEVNULL,
        stderr=subprocess.DEVNULL,
    )

print("Fertig! Packe alles in ein zip...")
shutil.make_archive("audio_output", "zip", MP3_DIR)
files.download("audio_output.zip")
print("audio_output.zip wird heruntergeladen - das ist die Datei fuer Claude.")
print("Tipp: vor dem Zurueckschicken ein paar zufaellige Dateien aus output_mp3/ anhoeren.")

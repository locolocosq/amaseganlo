# ============================================================
#  Amaseganlo - Amharisch-Audio mit Meta MMS-TTS erzeugen
# ============================================================
#  So geht's:
#  1) colab.research.google.com -> "Neues Notebook"
#  2) Oben rechts: "Verbinden" / Laufzeittyp -> GPU auswaehlen (T4 reicht,
#     kostenlos verfuegbar) - ohne GPU dauert es deutlich laenger.
#  3) Diesen kompletten Code in eine Zelle einfuegen, ausfuehren.
#  4) Im Upload-Dialog "audio_worklist.csv" auswaehlen (die Datei, die dir
#     mitgeschickt wurde - enthaelt alle 1017 Woerter + 40 Saetze mit ihrer
#     jeweiligen ID).
#  5) Warten, bis "Fertig!" erscheint - bei ~1057 Eintraegen auf GPU
#     realistisch 20-60 Minuten, ohne GPU deutlich laenger.
#  6) audio_output.zip wird automatisch zum Download angeboten.
#  7) Diese zip-Datei an Claude zurueckschicken - der Rest (Einbau in die
#     App) passiert dann automatisch.
#
#  Wichtig zur Qualitaet: das Modell wurde laut Meta ueberwiegend mit
#  Lesungen religioeser Texte trainiert - Alltagswoerter sollten trotzdem
#  verstaendlich sein, aber Betonung/Klang kann stellenweise ungewohnt
#  klingen. Am besten nach dem ersten Durchlauf ein paar zufaellige Dateien
#  aus output_mp3/ anhoeren, bevor du das ganze Paket zurueckschickst.
# ============================================================

!pip install -q --upgrade transformers accelerate
!git clone -q https://github.com/isi-nlp/uroman.git
# Falls diese Zeile mit "perl: command not found" fehlschlaegt (Colab hat
# perl normalerweise vorinstalliert), einmalig zusaetzlich ausfuehren:
# !apt-get -y install perl ffmpeg

import csv
import os
import shutil
import subprocess

import torch
from transformers import VitsModel, VitsTokenizer, set_seed
import scipy.io.wavfile
from google.colab import files

os.environ["UROMAN"] = os.path.abspath("uroman")

MODEL_NAME = "facebook/mms-tts-amh"
WAV_DIR = "output_wav"
MP3_DIR = "output_mp3"
os.makedirs(WAV_DIR, exist_ok=True)
os.makedirs(MP3_DIR, exist_ok=True)

print("Bitte audio_worklist.csv auswaehlen...")
uploaded = files.upload()
csv_path = list(uploaded.keys())[0]

device = "cuda" if torch.cuda.is_available() else "cpu"
print(f"Geraet: {device}")

tokenizer = VitsTokenizer.from_pretrained(MODEL_NAME)
model = VitsModel.from_pretrained(MODEL_NAME).to(device)
print(f"Braucht uroman-Umschrift: {tokenizer.is_uroman}")


def uromanize(text, uroman_path):
    """Wandelt Ge'ez-Text in lateinische Schrift um - das MMS-TTS-Modell
    erwartet laut offizieller Doku fuer nicht-lateinische Schriften diese
    Vorverarbeitung."""
    script_path = os.path.join(uroman_path, "bin", "uroman.pl")
    process = subprocess.Popen(
        ["perl", script_path],
        stdin=subprocess.PIPE,
        stdout=subprocess.PIPE,
        stderr=subprocess.PIPE,
    )
    stdout, stderr = process.communicate(input=text.encode("utf-8"))
    if process.returncode != 0:
        raise ValueError(f"uroman-Fehler {process.returncode}: {stderr.decode()}")
    return stdout.decode("utf-8").strip()


with open(csv_path, encoding="utf-8") as f:
    rows = list(csv.DictReader(f))

print(f"{len(rows)} Eintraege gefunden.")

for i, row in enumerate(rows):
    item_id = row["id"]
    text = row["amharic"]
    wav_path = os.path.join(WAV_DIR, f"{item_id}.wav")

    if os.path.exists(wav_path):
        continue  # schon erzeugt (z.B. nach Neustart der Zelle) - ueberspringen

    prepared = uromanize(text, os.environ["UROMAN"]) if tokenizer.is_uroman else text
    inputs = tokenizer(text=prepared, return_tensors="pt").to(model.device)

    set_seed(555)  # fuer reproduzierbare Ergebnisse
    with torch.no_grad():
        outputs = model(**inputs)
    waveform = outputs.waveform[0].cpu().numpy()

    scipy.io.wavfile.write(wav_path, rate=model.config.sampling_rate, data=waveform)

    if (i + 1) % 25 == 0 or (i + 1) == len(rows):
        print(f"{i + 1}/{len(rows)} erledigt...")

print("Konvertiere zu MP3 (deutlich kleinere Dateigroesse fuer die App)...")
for fname in os.listdir(WAV_DIR):
    if not fname.endswith(".wav"):
        continue
    wav_path = os.path.join(WAV_DIR, fname)
    mp3_path = os.path.join(MP3_DIR, fname.replace(".wav", ".mp3"))
    subprocess.run(
        ["ffmpeg", "-y", "-i", wav_path, "-codec:a", "libmp3lame", "-qscale:a", "4", mp3_path],
        stdout=subprocess.DEVNULL,
        stderr=subprocess.DEVNULL,
    )

print("Fertig! Packe alles in ein zip...")
shutil.make_archive("audio_output", "zip", MP3_DIR)
files.download("audio_output.zip")
print("audio_output.zip wird heruntergeladen - das ist die Datei fuer Claude.")

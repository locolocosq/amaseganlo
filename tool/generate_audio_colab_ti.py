# ============================================================
#  Habesha Speak - Tigrinya-Audio mit Meta MMS-TTS erzeugen
# ============================================================
#  Warum ein anderes Skript als fuer Amharisch: Microsoft/Edge-TTS, Amazon
#  Polly und Google Cloud TTS haben alle KEINE echte Tigrinya-Stimme (per
#  Websuche geprueft, Stand 2026 - nicht angenommen). "facebook/mms-tts-tir"
#  (Metas Massively-Multilingual-Speech-Projekt) ist das einzige verfuegbare
#  Modell mit echter Tigrinya-Unterstuetzung.
#
#  Wichtig zur Qualitaet: dasselbe Forschungsmodell (MMS), das wir bei
#  Amharisch wegen ungewohnter Betonung (Training ueberwiegend auf religioese
#  Textlesungen) wieder verworfen haben - fuer Tigrinya gibt es aber aktuell
#  keine Alternative mit einer echten, professionell trainierten Stimme.
#  Nach dem ersten Durchlauf unbedingt ein paar zufaellige Dateien aus
#  output_mp3/ anhoeren, bevor du das Paket zurueckschickst.
#
#  So geht's:
#  1) colab.research.google.com -> "Neues Notebook"
#  2) Oben rechts: "Verbinden" / Laufzeittyp -> GPU auswaehlen (T4 reicht,
#     kostenlos verfuegbar) - ohne GPU dauert es deutlich laenger.
#  3) Diesen kompletten Code in eine Zelle einfuegen, ausfuehren.
#  4) Im Upload-Dialog "audio_worklist_ti.csv" auswaehlen (die Datei, die dir
#     mitgeschickt wurde).
#  5) Warten, bis "Fertig!" erscheint - bei ~2666 Eintraegen auf GPU
#     realistisch 1-2 Stunden, ohne GPU deutlich laenger. Bei Bedarf in
#     mehreren Sitzungen laufen lassen - bereits erzeugte Dateien werden
#     beim Neustart der Zelle uebersprungen.
#  6) audio_output_ti.zip wird automatisch zum Download angeboten.
#  7) Diese zip-Datei an Claude zurueckschicken.
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

MODEL_NAME = "facebook/mms-tts-tir"
WAV_DIR = "output_wav"
MP3_DIR = "output_mp3"
os.makedirs(WAV_DIR, exist_ok=True)
os.makedirs(MP3_DIR, exist_ok=True)

print("Bitte audio_worklist_ti.csv auswaehlen...")
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
    text = row["amharic"]  # Spaltenname aus dem Export-Format uebernommen, enthaelt hier Tigrinya-Text
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
    # -ar 44100 ist noetig: das Modell liefert 16000 Hz, und libmp3lame
    # wechselt darunter automatisch auf das weniger kompatible MPEG-2-Profil
    # (bestaetigte Ursache eines frueheren "Audio funktioniert nicht"-Bugs,
    # siehe ENTSCHEIDUNGEN.md). Resampling haelt die Ausgabe im ueberall
    # unterstuetzten MPEG-1-Layer-III-Profil.
    subprocess.run(
        ["ffmpeg", "-y", "-i", wav_path, "-ar", "44100", "-codec:a", "libmp3lame", "-qscale:a", "4", mp3_path],
        stdout=subprocess.DEVNULL,
        stderr=subprocess.DEVNULL,
    )

print("Fertig! Packe alles in ein zip...")
shutil.make_archive("audio_output_ti", "zip", MP3_DIR)
files.download("audio_output_ti.zip")
print("audio_output_ti.zip wird heruntergeladen - das ist die Datei fuer Claude.")
print("Tipp: vor dem Zurueckschicken ein paar zufaellige Dateien aus output_mp3/ anhoeren.")

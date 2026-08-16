// One-off for Etappe 26 Nachtrag: registers every newly added Tigrinya
// lexeme/sentence id in the audio manifest (pointing at the standard
// audio/words/<id>.mp3 path, matching the existing schema, even though the
// files don't exist yet - see AudioService's silent-fallback behaviour) and
// appends a compact table to store-assets/fehlende_audiodateien.md.
const fs = require('fs');
const path = require('path');
const contentDir = path.join(__dirname, '..', 'assets', 'content');
const root = path.join(__dirname, '..');

const topicFiles = fs.readdirSync(contentDir).filter((f) => f.startsWith('lexemes_eritrea_') && f.endsWith('.json'));
// The 4 original files (greetings/family/numbers/food) were already
// registered in Aufgabe 5's manifest update - only the 51 new topic files
// from this Nachtrag need adding here.
const originalFiles = new Set(['lexemes_eritrea_greetings.json', 'lexemes_eritrea_family.json', 'lexemes_eritrea_numbers.json', 'lexemes_eritrea_food.json']);
const newTopicFiles = topicFiles.filter((f) => !originalFiles.has(f)).sort();

const newLexemes = [];
for (const f of newTopicFiles) {
  const items = JSON.parse(fs.readFileSync(path.join(contentDir, f), 'utf8'));
  for (const item of items) newLexemes.push(item);
}

const newSentences = JSON.parse(fs.readFileSync(path.join(contentDir, 'sentences_eritrea_mehr.json'), 'utf8'));

const manifestPath = path.join(root, 'assets', 'audio', 'manifest.json');
const manifest = JSON.parse(fs.readFileSync(manifestPath, 'utf8'));
let addedCount = 0;
for (const item of [...newLexemes, ...newSentences]) {
  if (!manifest.words[item.id]) {
    manifest.words[item.id] = `audio/words/${item.id}.mp3`;
    addedCount++;
  }
}
fs.writeFileSync(manifestPath, JSON.stringify(manifest, null, 2) + '\n');

const rows = [];
for (const l of newLexemes) {
  rows.push(`| Tigrinya | ${l.am} | ${l.tr} | \`${l.id}.mp3\` |`);
}
for (const s of newSentences) {
  rows.push(`| Tigrinya | ${s.am} | ${s.tr} | \`${s.id}.mp3\` |`);
}

const mdAddition = `

## Nachtrag: Tigrinya-Wortschatz-Erweiterung auf ~2000 Wörter

Auf ausdrücklichen Wunsch des Nutzers wurde der Tigrinya-Wortschatz von den ursprünglichen 46
Wörtern (Aufgabe 5) auf ${46 + newLexemes.length} Wörter erweitert - der Nutzer hat dabei
explizit angeordnet, die inhaltliche Korrektheit selbst zu prüfen, statt sie hier vorab zu
verifizieren. Alle ${newLexemes.length} neuen Wörter und ${newSentences.length} neuen Sätze
sind wie gehabt bereits im Code/Content verdrahtet und im Audio-Manifest vorregistriert.

| Sprache | Text | Transliteration | Dateiname |
|---|---|---|---|
${rows.join('\n')}

**Neue Gesamtsumme Tigrinya:** ${46 + newLexemes.length} Wörter, ${8 + newSentences.length} Sätze,
${880 + newLexemes.length - (880 - 46)} Audiodateien insgesamt für diesen Nachtrag zusätzlich zu den
62 aus der ursprünglichen Etappe 26.
`;

fs.appendFileSync(path.join(root, 'store-assets', 'fehlende_audiodateien.md'), mdAddition);

console.log('Manifest entries added:', addedCount);
console.log('Markdown rows added:', rows.length);

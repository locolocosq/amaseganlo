// Round 2 of the Etappe 26 Nachtrag wiring (same pattern as
// wire_eritrea_units.js) - bundles the second batch of topic files into
// further curriculum units.
const fs = require('fs');
const path = require('path');
const contentDir = path.join(__dirname, '..', 'assets', 'content');

const groups = [
  { unit: 'unit_eritrea_koerperteile_mehr', files: ['koerperteile2'], title: { de: 'Körperteile (mehr)', en: 'Body Parts (more)', sv: 'Kroppsdelar (mer)', nl: 'Lichaamsdelen (meer)' }, topic: 'body_parts_more' },
  { unit: 'unit_eritrea_finanzen_arbeit', files: ['finanzen', 'arbeit'], title: { de: 'Finanzen & Arbeit', en: 'Finance & Work', sv: 'Ekonomi & Arbete', nl: 'Financiën & Werk' }, topic: 'finance_work' },
  { unit: 'unit_eritrea_fahrzeuge_buero', files: ['fahrzeugteile', 'buerobedarf'], title: { de: 'Fahrzeugteile & Bürobedarf', en: 'Vehicle Parts & Office Supplies', sv: 'Fordonsdelar & Kontorsmaterial', nl: 'Voertuigonderdelen & Kantoorbenodigdheden' }, topic: 'vehicles_office' },
  { unit: 'unit_eritrea_musik_feste', files: ['musik', 'feste'], title: { de: 'Musik & Feste', en: 'Music & Festivals', sv: 'Musik & Högtider', nl: 'Muziek & Feesten' }, topic: 'music_festivals' },
  { unit: 'unit_eritrea_charakter_vergleich', files: ['charakter', 'vergleich'], title: { de: 'Charakter & Vergleiche', en: 'Character & Comparisons', sv: 'Karaktär & Jämförelser', nl: 'Karakter & Vergelijkingen' }, topic: 'character_comparison' },
  { unit: 'unit_eritrea_wetter_geologie', files: ['wetter', 'geologie'], title: { de: 'Wetter & Geologie', en: 'Weather & Geology', sv: 'Väder & Geologi', nl: 'Weer & Geologie' }, topic: 'weather_geology' },
  { unit: 'unit_eritrea_recht_notfall', files: ['recht', 'notfall'], title: { de: 'Recht & Notfälle', en: 'Law & Emergencies', sv: 'Rätt & Nödsituationer', nl: 'Recht & Noodgevallen' }, topic: 'law_emergency' },
  { unit: 'unit_eritrea_kommunikation_dialog', files: ['kommunikation', 'dialog'], title: { de: 'Kommunikation & Dialog', en: 'Communication & Dialogue', sv: 'Kommunikation & Dialog', nl: 'Communicatie & Dialoog' }, topic: 'communication_dialogue' },
  { unit: 'unit_eritrea_insekten_voegel', files: ['insekten', 'voegel'], title: { de: 'Insekten & Vögel', en: 'Insects & Birds', sv: 'Insekter & Fåglar', nl: 'Insecten & Vogels' }, topic: 'insects_birds' },
  { unit: 'unit_eritrea_geschichte_bildung', files: ['geschichte', 'bildung'], title: { de: 'Geschichte & Bildung', en: 'History & Education', sv: 'Historia & Utbildning', nl: 'Geschiedenis & Onderwijs' }, topic: 'history_education' },
  { unit: 'unit_eritrea_gesundheit_kinder', files: ['gesundheit2', 'kinder'], title: { de: 'Gesundheit & Kinder (mehr)', en: 'Health & Children (more)', sv: 'Hälsa & Barn (mer)', nl: 'Gezondheid & Kinderen (meer)' }, topic: 'health_children' },
  { unit: 'unit_eritrea_sport_reise', files: ['sport2', 'reise'], title: { de: 'Sport & Reisen (mehr)', en: 'Sports & Travel (more)', sv: 'Sport & Resor (mer)', nl: 'Sport & Reizen (meer)' }, topic: 'sports_travel' },
  { unit: 'unit_eritrea_mathematik_mehr', files: ['geometrie', 'mathematik', 'astronomie2'], title: { de: 'Mathematik & Astronomie (mehr)', en: 'Math & Astronomy (more)', sv: 'Matematik & Astronomi (mer)', nl: 'Wiskunde & Astronomie (meer)' }, topic: 'math_astronomy' },
  { unit: 'unit_eritrea_mode_pflanzen', files: ['mode', 'pflanzen'], title: { de: 'Mode & Pflanzen', en: 'Fashion & Plants', sv: 'Mode & Växter', nl: 'Mode & Planten' }, topic: 'fashion_plants' },
  { unit: 'unit_eritrea_kochen_wissenschaft', files: ['kochen', 'wissenschaft'], title: { de: 'Kochen & Wissenschaft', en: 'Cooking & Science', sv: 'Matlagning & Vetenskap', nl: 'Koken & Wetenschap' }, topic: 'cooking_science' },
  { unit: 'unit_eritrea_beziehungen_emotionen', files: ['beziehungen', 'emotionen2'], title: { de: 'Beziehungen & Gefühle (mehr)', en: 'Relationships & Emotions (more)', sv: 'Relationer & Känslor (mer)', nl: 'Relaties & Emoties (meer)' }, topic: 'relationships_emotions' },
  { unit: 'unit_eritrea_wohnen', files: ['wohnen'], title: { de: 'Wohnen', en: 'Housing', sv: 'Boende', nl: 'Wonen' }, topic: 'housing' },
];

function readLexemes(topicKey) {
  const file = path.join(contentDir, `lexemes_eritrea_${topicKey}.json`);
  return JSON.parse(fs.readFileSync(file, 'utf8'));
}

const curriculumPath = path.join(contentDir, 'curriculum.json');
const curriculum = JSON.parse(fs.readFileSync(curriculumPath, 'utf8'));

const newUnitIds = [];
const newSentenceFileEntry = 'sentences_eritrea_mehr2.json';
const allNewSentences = [];

for (const g of groups) {
  const lexemes = [];
  for (const f of g.files) lexemes.push(...readLexemes(f));
  const lexemeIds = lexemes.map((l) => l.id);

  const subject = lexemes[0];
  const sentId = `sen_ti_${g.unit.replace('unit_eritrea_', '')}_1`;
  const deWord = (subject.t.de || '').split(',')[0].split('(')[0].trim();
  allNewSentences.push({
    id: sentId,
    am: `${subject.am} ኣሎ።`,
    tr: `${subject.tr} alo.`,
    level: 'TI',
    uses: [subject.id],
    t: {
      de: `Es gibt ${deWord}.`,
      en: `There is ${subject.t.en}.`,
      sv: `Det finns ${subject.t.sv}.`,
      nl: `Er is ${subject.t.nl}.`,
    },
    alt: {},
    chunks: [subject.tr, 'alo'],
    verified: false,
  });

  const lessonBase = (kind, exerciseTypes, sentenceIds) => ({
    id: `${g.unit}_${kind}`,
    kind,
    lexemeIds,
    sentenceIds,
    exerciseTypes,
  });

  const lessons = [
    lessonBase('intro', [], []),
    lessonBase('words', ['wordChoiceAmToNative', 'wordChoiceNativeToAm', 'pairMatching'], []),
    lessonBase('sentences', ['sentenceBuild', 'sentenceGapChoice'], [sentId]),
    lessonBase('listening', ['listenChoice', 'listenBuild'], [sentId]),
    lessonBase('free', ['wordTyping', 'sentenceTranslate'], [sentId]),
    lessonBase('review', ['wordChoiceAmToNative', 'wordChoiceNativeToAm', 'wordTyping', 'trueFalse'], [sentId]),
  ];

  const lessonFileName = `${g.unit}_lessons.json`;
  fs.writeFileSync(path.join(contentDir, lessonFileName), JSON.stringify(lessons, null, 2) + '\n');

  curriculum.units.push({
    id: g.unit,
    sectionId: 'sec_eritrea',
    level: 'TI',
    title: g.title,
    topic: g.topic,
    lessonFile: lessonFileName,
  });
  newUnitIds.push(g.unit);
}

const eritreaSection = curriculum.sections.find((s) => s.id === 'sec_eritrea');
eritreaSection.units.push(...newUnitIds);
curriculum.sentenceFiles.push(newSentenceFileEntry);

// Register the 33 new lexeme files too (round 2 topic files weren't in
// curriculum.json's lexemeFiles yet either).
const allTopicFiles = fs.readdirSync(contentDir).filter((f) => f.startsWith('lexemes_eritrea_') && f.endsWith('.json'));
const existingLexFiles = new Set(curriculum.lexemeFiles);
for (const f of allTopicFiles) {
  if (!existingLexFiles.has(f)) curriculum.lexemeFiles.push(f);
}

fs.writeFileSync(curriculumPath, JSON.stringify(curriculum, null, 2) + '\n');
fs.writeFileSync(path.join(contentDir, newSentenceFileEntry), JSON.stringify(allNewSentences, null, 2) + '\n');

console.log('New units created:', newUnitIds.length);
console.log('New sentences created:', allNewSentences.length);

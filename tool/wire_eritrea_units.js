// One-off wiring script for Etappe 26 Nachtrag (2000-word Tigrinya expansion,
// on explicit user order). Groups the topic lexeme files written this
// session into curriculum units, writes their lesson files, extends
// curriculum.json, and appends new sentences using each unit's own
// vocabulary with the same safe existential pattern already established
// elsewhere ("[word] alo/alewu"). Run once with `node tool/wire_eritrea_units.js`.
const fs = require('fs');
const path = require('path');
const contentDir = path.join(__dirname, '..', 'assets', 'content');

const groups = [
  { unit: 'unit_eritrea_zahlen_mehr', files: ['numbers_mehr'], title: { de: 'Zahlen 11-1000', en: 'Numbers 11-1000', sv: 'Siffror 11-1000', nl: 'Getallen 11-1000' }, topic: 'numbers_more' },
  { unit: 'unit_eritrea_farben_formen', files: ['farben', 'formen'], title: { de: 'Farben & Formen', en: 'Colors & Shapes', sv: 'Färger & Former', nl: 'Kleuren & Vormen' }, topic: 'colors_shapes' },
  { unit: 'unit_eritrea_koerper_gesundheit', files: ['koerper', 'gesundheit', 'hygiene'], title: { de: 'Körper & Gesundheit', en: 'Body & Health', sv: 'Kropp & Hälsa', nl: 'Lichaam & Gezondheid' }, topic: 'body_health' },
  { unit: 'unit_eritrea_kleidung_schmuck', files: ['kleidung', 'schmuck', 'tracht'], title: { de: 'Kleidung & Schmuck', en: 'Clothing & Jewelry', sv: 'Kläder & Smycken', nl: 'Kleding & Sieraden' }, topic: 'clothing_jewelry' },
  { unit: 'unit_eritrea_haus_mehr', files: ['haus', 'haushaltsgeraete', 'hausarbeit'], title: { de: 'Haus & Haushalt', en: 'House & Household', sv: 'Hus & Hushåll', nl: 'Huis & Huishouden' }, topic: 'house_more' },
  { unit: 'unit_eritrea_natur_geographie', files: ['natur', 'weltraum', 'geographie'], title: { de: 'Natur & Geografie', en: 'Nature & Geography', sv: 'Natur & Geografi', nl: 'Natuur & Geografie' }, topic: 'nature_geography' },
  { unit: 'unit_eritrea_tiere_mehr', files: ['tiere', 'tiere_mehr'], title: { de: 'Tiere (mehr)', en: 'Animals (more)', sv: 'Djur (mer)', nl: 'Dieren (meer)' }, topic: 'animals_more' },
  { unit: 'unit_eritrea_zeit_mehr', files: ['zeit', 'ordnungszahlen'], title: { de: 'Zeit & Datum (mehr)', en: 'Time & Date (more)', sv: 'Tid & Datum (mer)', nl: 'Tijd & Datum (meer)' }, topic: 'time_more' },
  { unit: 'unit_eritrea_berufe_staat', files: ['berufe', 'regierung'], title: { de: 'Berufe & Staat', en: 'Professions & State', sv: 'Yrken & Stat', nl: 'Beroepen & Staat' }, topic: 'professions_state' },
  { unit: 'unit_eritrea_verkehr_stadt', files: ['verkehr', 'stadt'], title: { de: 'Verkehr & Stadt', en: 'Transport & City', sv: 'Transport & Stad', nl: 'Verkeer & Stad' }, topic: 'transport_city' },
  { unit: 'unit_eritrea_verben', files: ['verben'], title: { de: 'Verben (Grundlagen)', en: 'Verbs (basics)', sv: 'Verb (grunder)', nl: 'Werkwoorden (basis)' }, topic: 'verbs' },
  { unit: 'unit_eritrea_verben_mehr', files: ['verben2', 'modalverben'], title: { de: 'Verben (mehr)', en: 'Verbs (more)', sv: 'Verb (mer)', nl: 'Werkwoorden (meer)' }, topic: 'verbs_more' },
  { unit: 'unit_eritrea_gefuehle_sinne', files: ['gefuehle', 'sinne'], title: { de: 'Gefühle & Sinne', en: 'Emotions & Senses', sv: 'Känslor & Sinnen', nl: 'Emoties & Zintuigen' }, topic: 'emotions_senses' },
  { unit: 'unit_eritrea_schule_faecher', files: ['schule', 'faecher'], title: { de: 'Schule & Fächer', en: 'School & Subjects', sv: 'Skola & Ämnen', nl: 'School & Vakken' }, topic: 'school_subjects' },
  { unit: 'unit_eritrea_technologie_masse', files: ['technologie', 'masse'], title: { de: 'Technologie & Maße', en: 'Technology & Measurements', sv: 'Teknik & Mått', nl: 'Technologie & Maten' }, topic: 'technology_measurements' },
  { unit: 'unit_eritrea_sport_freizeit', files: ['sport', 'freizeit'], title: { de: 'Sport & Freizeit', en: 'Sports & Leisure', sv: 'Sport & Fritid', nl: 'Sport & Vrije tijd' }, topic: 'sports_leisure' },
  { unit: 'unit_eritrea_kultur', files: ['kultur'], title: { de: 'Kultur & Religion', en: 'Culture & Religion', sv: 'Kultur & Religion', nl: 'Cultuur & Religie' }, topic: 'culture' },
  { unit: 'unit_eritrea_einkaufen_restaurant', files: ['einkaufen', 'restaurant'], title: { de: 'Einkaufen & Restaurant', en: 'Shopping & Restaurant', sv: 'Shopping & Restaurang', nl: 'Winkelen & Restaurant' }, topic: 'shopping_restaurant' },
  { unit: 'unit_eritrea_essen_gerichte', files: ['essen_mehr', 'geschmack', 'gerichte', 'getraenke'], title: { de: 'Essen & Gerichte (mehr)', en: 'Food & Dishes (more)', sv: 'Mat & Rätter (mer)', nl: 'Eten & Gerechten (meer)' }, topic: 'food_more' },
  { unit: 'unit_eritrea_familie_pronomen', files: ['familie_mehr', 'pronomen'], title: { de: 'Familie & Pronomen (mehr)', en: 'Family & Pronouns (more)', sv: 'Familj & Pronomen (mer)', nl: 'Familie & Voornaamwoorden (meer)' }, topic: 'family_pronouns' },
  { unit: 'unit_eritrea_laender', files: ['laender'], title: { de: 'Länder & Sprachen', en: 'Countries & Languages', sv: 'Länder & Språk', nl: 'Landen & Talen' }, topic: 'countries_languages' },
  { unit: 'unit_eritrea_landwirtschaft_werkzeuge', files: ['landwirtschaft', 'werkzeuge'], title: { de: 'Landwirtschaft & Werkzeuge', en: 'Agriculture & Tools', sv: 'Jordbruk & Verktyg', nl: 'Landbouw & Gereedschap' }, topic: 'agriculture_tools' },
  { unit: 'unit_eritrea_materialien_allgemein', files: ['materialien', 'allgemein'], title: { de: 'Materialien & Allgemeines', en: 'Materials & General', sv: 'Material & Allmänt', nl: 'Materialen & Algemeen' }, topic: 'materials_general' },
  { unit: 'unit_eritrea_phrasen_ausrufe', files: ['phrasen', 'ausrufe'], title: { de: 'Redewendungen & Ausrufe', en: 'Phrases & Exclamations', sv: 'Fraser & Utrop', nl: 'Zinnen & Uitroepen' }, topic: 'phrases_exclamations' },
  { unit: 'unit_eritrea_adverbien_mehr', files: ['adverbien_mehr'], title: { de: 'Adverbien & Präpositionen (mehr)', en: 'Adverbs & Prepositions (more)', sv: 'Adverb & Prepositioner (mer)', nl: 'Bijwoorden & Voorzetsels (meer)' }, topic: 'adverbs_more' },
];

function readLexemes(topicKey) {
  const file = path.join(contentDir, `lexemes_eritrea_${topicKey}.json`);
  return JSON.parse(fs.readFileSync(file, 'utf8'));
}

const curriculumPath = path.join(contentDir, 'curriculum.json');
const curriculum = JSON.parse(fs.readFileSync(curriculumPath, 'utf8'));

const newUnitIds = [];
const newSentenceFileEntry = 'sentences_eritrea_mehr.json';
const allNewSentences = [];

for (const g of groups) {
  const lexemes = [];
  for (const f of g.files) lexemes.push(...readLexemes(f));
  const lexemeIds = lexemes.map((l) => l.id);

  // One safe sentence per unit: "[first suitable noun/adjective] alo." style
  // existential, reusing the exact pattern already used and reviewed
  // elsewhere in this session (Aufgabe 2/3/5) - "X alo/alewu" ("there is/are
  // X"). Picks the first lexeme whose translation is a plain noun-ish word.
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

// Extend the Eritrea section with all new units.
const eritreaSection = curriculum.sections.find((s) => s.id === 'sec_eritrea');
eritreaSection.units.push(...newUnitIds);

// Register the new consolidated sentence file.
curriculum.sentenceFiles.push(newSentenceFileEntry);

fs.writeFileSync(curriculumPath, JSON.stringify(curriculum, null, 2) + '\n');
fs.writeFileSync(path.join(contentDir, newSentenceFileEntry), JSON.stringify(allNewSentences, null, 2) + '\n');

console.log('New units created:', newUnitIds.length);
console.log('New sentences created:', allNewSentences.length);

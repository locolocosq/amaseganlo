// Round 3 of the Etappe 26 Nachtrag wiring (same pattern as
// wire_eritrea_units.js / round2) - bundles the third batch of topic files
// into further curriculum units.
const fs = require('fs');
const path = require('path');
const contentDir = path.join(__dirname, '..', 'assets', 'content');

const groups = [
  { unit: 'unit_eritrea_verben_adjektive', files: ['verben3', 'adjektive'], title: { de: 'Verben & Adjektive (mehr)', en: 'Verbs & Adjectives (more)', sv: 'Verb & Adjektiv (mer)', nl: 'Werkwoorden & Bijvoeglijke naamwoorden (meer)' }, topic: 'verbs_adjectives' },
  { unit: 'unit_eritrea_praepositionen', files: ['praepositionen'], title: { de: 'Präpositionen', en: 'Prepositions', sv: 'Prepositioner', nl: 'Voorzetsels' }, topic: 'prepositions' },
  { unit: 'unit_eritrea_medizin', files: ['medizin'], title: { de: 'Medizin & Krankenhaus', en: 'Medicine & Hospital', sv: 'Medicin & Sjukhus', nl: 'Medicijnen & Ziekenhuis' }, topic: 'medicine' },
  { unit: 'unit_eritrea_technologie_mehr', files: ['technologie2'], title: { de: 'Technologie (mehr)', en: 'Technology (more)', sv: 'Teknik (mer)', nl: 'Technologie (meer)' }, topic: 'technology_more' },
  { unit: 'unit_eritrea_umwelt_medien', files: ['umwelt', 'medien'], title: { de: 'Umwelt & Medien', en: 'Environment & Media', sv: 'Miljö & Media', nl: 'Milieu & Media' }, topic: 'environment_media' },
  { unit: 'unit_eritrea_hobbys', files: ['hobbys'], title: { de: 'Hobbys', en: 'Hobbies', sv: 'Hobbyer', nl: 'Hobby\'s' }, topic: 'hobbies' },
  { unit: 'unit_eritrea_laender_mehr', files: ['laender2'], title: { de: 'Länder (mehr)', en: 'Countries (more)', sv: 'Länder (mer)', nl: 'Landen (meer)' }, topic: 'countries_more' },
  { unit: 'unit_eritrea_sport_mehr2', files: ['sport3'], title: { de: 'Sport (mehr)', en: 'Sports (more)', sv: 'Sport (mer)', nl: 'Sport (meer)' }, topic: 'sports_more2' },
  { unit: 'unit_eritrea_berufe_mehr', files: ['berufe2'], title: { de: 'Berufe (mehr)', en: 'Professions (more)', sv: 'Yrken (mer)', nl: 'Beroepen (meer)' }, topic: 'professions_more' },
  { unit: 'unit_eritrea_wetter_mehr', files: ['wetter2'], title: { de: 'Wetter (mehr)', en: 'Weather (more)', sv: 'Väder (mer)', nl: 'Weer (meer)' }, topic: 'weather_more' },
  { unit: 'unit_eritrea_kleidung_mehr', files: ['kleidung2'], title: { de: 'Kleidung (mehr)', en: 'Clothing (more)', sv: 'Kläder (mer)', nl: 'Kleding (meer)' }, topic: 'clothing_more' },
  { unit: 'unit_eritrea_recht_mehr', files: ['recht2'], title: { de: 'Recht (mehr)', en: 'Law (more)', sv: 'Rätt (mer)', nl: 'Recht (meer)' }, topic: 'law_more' },
  { unit: 'unit_eritrea_meerestiere', files: ['meerestiere'], title: { de: 'Meerestiere', en: 'Marine Life', sv: 'Havsdjur', nl: 'Zeedieren' }, topic: 'marine_life' },
  { unit: 'unit_eritrea_spielzeug', files: ['spielzeug'], title: { de: 'Spielzeug', en: 'Toys', sv: 'Leksaker', nl: 'Speelgoed' }, topic: 'toys' },
  { unit: 'unit_eritrea_buero_waehrung', files: ['buero', 'waehrung'], title: { de: 'Büro & Währung', en: 'Office & Currency', sv: 'Kontor & Valuta', nl: 'Kantoor & Valuta' }, topic: 'office_currency' },
  { unit: 'unit_eritrea_moebel_kueche', files: ['moebel', 'kuechengeschirr'], title: { de: 'Möbel & Küchengeschirr', en: 'Furniture & Kitchenware', sv: 'Möbler & Köksredskap', nl: 'Meubels & Keukengerei' }, topic: 'furniture_kitchenware' },
  { unit: 'unit_eritrea_bauernhof_landschaft', files: ['bauernhoftiere', 'landschaft'], title: { de: 'Bauernhof & Landschaft', en: 'Farm & Landscape', sv: 'Bondgård & Landskap', nl: 'Boerderij & Landschap' }, topic: 'farm_landscape' },
  { unit: 'unit_eritrea_post_hygiene', files: ['post', 'hygiene2'], title: { de: 'Post & Hygiene (mehr)', en: 'Post Office & Hygiene (more)', sv: 'Post & Hygien (mer)', nl: 'Post & Hygiëne (meer)' }, topic: 'post_hygiene' },
  { unit: 'unit_eritrea_phrasen_ausrufe_mehr', files: ['phrasen2', 'ausrufe2'], title: { de: 'Redewendungen & Ausrufe (mehr)', en: 'Phrases & Exclamations (more)', sv: 'Fraser & Utrop (mer)', nl: 'Uitdrukkingen & Uitroepen (meer)' }, topic: 'phrases_exclamations' },
  { unit: 'unit_eritrea_verkehr_flughafen', files: ['verkehr2', 'flughafen'], title: { de: 'Verkehr & Flughafen', en: 'Traffic & Airport', sv: 'Trafik & Flygplats', nl: 'Verkeer & Luchthaven' }, topic: 'traffic_airport' },
  { unit: 'unit_eritrea_sinne_farben', files: ['sinne2', 'farbnuancen'], title: { de: 'Sinne & Farbnuancen', en: 'Senses & Color Shades', sv: 'Sinnen & Färgnyanser', nl: 'Zintuigen & Kleurtinten' }, topic: 'senses_colors' },
];

function readLexemes(topicKey) {
  const file = path.join(contentDir, `lexemes_eritrea_${topicKey}.json`);
  return JSON.parse(fs.readFileSync(file, 'utf8'));
}

const curriculumPath = path.join(contentDir, 'curriculum.json');
const curriculum = JSON.parse(fs.readFileSync(curriculumPath, 'utf8'));

const newUnitIds = [];
const newSentenceFileEntry = 'sentences_eritrea_mehr3.json';
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

const allTopicFiles = fs.readdirSync(contentDir).filter((f) => f.startsWith('lexemes_eritrea_') && f.endsWith('.json'));
const existingLexFiles = new Set(curriculum.lexemeFiles);
for (const f of allTopicFiles) {
  if (!existingLexFiles.has(f)) curriculum.lexemeFiles.push(f);
}

fs.writeFileSync(curriculumPath, JSON.stringify(curriculum, null, 2) + '\n');
fs.writeFileSync(path.join(contentDir, newSentenceFileEntry), JSON.stringify(allNewSentences, null, 2) + '\n');

console.log('New units created:', newUnitIds.length);
console.log('New sentences created:', allNewSentences.length);

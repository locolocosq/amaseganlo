// Round 4 of the Etappe 26 Nachtrag wiring (same pattern as previous
// rounds) - bundles the fourth batch of topic files into further
// curriculum units. Learned the hard way in round 3: always check the
// generated unit id against curriculum.json's existing units before
// writing, since a name collision silently overwrites another station's
// lesson file.
const fs = require('fs');
const path = require('path');
const contentDir = path.join(__dirname, '..', 'assets', 'content');

const groups = [
  { unit: 'unit_eritrea_literatur', files: ['literatur'], title: { de: 'Literatur', en: 'Literature', sv: 'Litteratur', nl: 'Literatuur' }, topic: 'literature' },
  { unit: 'unit_eritrea_versicherung_reparatur', files: ['versicherung', 'reparatur'], title: { de: 'Versicherung & Reparatur', en: 'Insurance & Repair', sv: 'Försäkring & Reparation', nl: 'Verzekering & Reparatie' }, topic: 'insurance_repair' },
  { unit: 'unit_eritrea_umzug_nachbarschaft', files: ['umzug', 'nachbarschaft'], title: { de: 'Umzug & Nachbarschaft', en: 'Moving & Neighborhood', sv: 'Flytt & Grannskap', nl: 'Verhuizen & Buurt' }, topic: 'moving_neighborhood' },
  { unit: 'unit_eritrea_schwangerschaft', files: ['schwangerschaft'], title: { de: 'Schwangerschaft & Baby', en: 'Pregnancy & Baby', sv: 'Graviditet & Bebis', nl: 'Zwangerschap & Baby' }, topic: 'pregnancy' },
  { unit: 'unit_eritrea_handwerk_baustelle', files: ['handwerk', 'baustelle'], title: { de: 'Handwerk & Baustelle', en: 'Crafts & Construction', sv: 'Hantverk & Byggarbetsplats', nl: 'Ambacht & Bouwplaats' }, topic: 'crafts_construction' },
  { unit: 'unit_eritrea_richtungen_uhrzeit', files: ['richtungen', 'uhrzeit'], title: { de: 'Richtungen & Uhrzeit', en: 'Directions & Clock Time', sv: 'Riktningar & Klockan', nl: 'Richtingen & Kloktijd' }, topic: 'directions_clock' },
  { unit: 'unit_eritrea_universitaet_sprachlernen', files: ['universitaet', 'sprachlernen'], title: { de: 'Universität & Sprachenlernen', en: 'University & Language Learning', sv: 'Universitet & Språkinlärning', nl: 'Universiteit & Taal leren' }, topic: 'university_language' },
  { unit: 'unit_eritrea_bankdienste', files: ['bankdienste'], title: { de: 'Bankdienste', en: 'Banking Services', sv: 'Banktjänster', nl: 'Bankdiensten' }, topic: 'banking' },
  { unit: 'unit_eritrea_picknick_strand', files: ['picknick', 'strand'], title: { de: 'Picknick & Strand', en: 'Picnic & Beach', sv: 'Picknick & Strand', nl: 'Picknick & Strand' }, topic: 'picnic_beach' },
  { unit: 'unit_eritrea_wanderung', files: ['wanderung'], title: { de: 'Wandern', en: 'Hiking', sv: 'Vandring', nl: 'Wandelen' }, topic: 'hiking' },
  { unit: 'unit_eritrea_planeten_mineralien', files: ['planeten', 'mineralien'], title: { de: 'Planeten & Mineralien', en: 'Planets & Minerals', sv: 'Planeter & Mineraler', nl: 'Planeten & Mineralen' }, topic: 'planets_minerals' },
  { unit: 'unit_eritrea_baeume_blumen', files: ['baeume', 'blumen'], title: { de: 'Bäume & Blumen', en: 'Trees & Flowers', sv: 'Träd & Blommor', nl: 'Bomen & Bloemen' }, topic: 'trees_flowers' },
  { unit: 'unit_eritrea_gewuerze_backen', files: ['gewuerze', 'backen'], title: { de: 'Gewürze & Backen', en: 'Spices & Baking', sv: 'Kryddor & Bakning', nl: 'Kruiden & Bakken' }, topic: 'spices_baking' },
  { unit: 'unit_eritrea_getreide', files: ['getreide'], title: { de: 'Getreide', en: 'Grains', sv: 'Spannmål', nl: 'Granen' }, topic: 'grains' },
  { unit: 'unit_eritrea_diplomatie', files: ['diplomatie'], title: { de: 'Diplomatie', en: 'Diplomacy', sv: 'Diplomati', nl: 'Diplomatie' }, topic: 'diplomacy' },
  { unit: 'unit_eritrea_internetbegriffe', files: ['internetbegriffe'], title: { de: 'Internetbegriffe', en: 'Internet Terms', sv: 'Internetbegrepp', nl: 'Internetbegrippen' }, topic: 'internet_terms' },
  { unit: 'unit_eritrea_haustiere_spielplatz', files: ['haustiere', 'spielplatz'], title: { de: 'Haustiere & Spielplatz', en: 'Pets & Playground', sv: 'Husdjur & Lekplats', nl: 'Huisdieren & Speelplaats' }, topic: 'pets_playground' },
  { unit: 'unit_eritrea_tanzen_gastfreundschaft', files: ['tanzen', 'gastfreundschaft'], title: { de: 'Tanzen & Gastfreundschaft', en: 'Dance & Hospitality', sv: 'Dans & Gästfrihet', nl: 'Dansen & Gastvrijheid' }, topic: 'dance_hospitality' },
];

function readLexemes(topicKey) {
  const file = path.join(contentDir, `lexemes_eritrea_${topicKey}.json`);
  return JSON.parse(fs.readFileSync(file, 'utf8'));
}

const curriculumPath = path.join(contentDir, 'curriculum.json');
const curriculum = JSON.parse(fs.readFileSync(curriculumPath, 'utf8'));

const existingUnitIds = new Set(curriculum.units.map((u) => u.id));
for (const g of groups) {
  if (existingUnitIds.has(g.unit)) {
    throw new Error(`Unit id collision detected before writing anything: ${g.unit} already exists. Fix the group name.`);
  }
}

const newUnitIds = [];
const newSentenceFileEntry = 'sentences_eritrea_mehr4.json';
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

// Round 5 of the Etappe 26 Nachtrag wiring (same pattern as previous
// rounds, with the round-3-learned pre-check for unit id collisions).
const fs = require('fs');
const path = require('path');
const contentDir = path.join(__dirname, '..', 'assets', 'content');

const groups = [
  { unit: 'unit_eritrea_raumfahrt_archaeologie', files: ['raumfahrt', 'archaeologie'], title: { de: 'Raumfahrt & Archäologie', en: 'Space Travel & Archaeology', sv: 'Rymdfärd & Arkeologi', nl: 'Ruimtevaart & Archeologie' }, topic: 'space_archaeology' },
  { unit: 'unit_eritrea_chemie_computerhardware', files: ['chemie', 'computerhardware'], title: { de: 'Chemie & Computerhardware', en: 'Chemistry & Computer Hardware', sv: 'Kemi & Datorhårdvara', nl: 'Scheikunde & Computerhardware' }, topic: 'chemistry_hardware' },
  { unit: 'unit_eritrea_wildtiere', files: ['wildtiere'], title: { de: 'Wildtiere Afrikas', en: 'African Wildlife', sv: 'Afrikas vilda djur', nl: 'Afrikaanse wilde dieren' }, topic: 'wild_animals' },
  { unit: 'unit_eritrea_elektrizitaet_fabrik', files: ['elektrizitaet', 'fabrik'], title: { de: 'Elektrizität & Fabrik', en: 'Electricity & Factory', sv: 'Elektricitet & Fabrik', nl: 'Elektriciteit & Fabriek' }, topic: 'electricity_factory' },
  { unit: 'unit_eritrea_feuerwehr_notdienste', files: ['feuerwehr', 'notdienste'], title: { de: 'Feuerwehr & Notdienste', en: 'Firefighting & Emergency Services', sv: 'Brandkår & Räddningstjänster', nl: 'Brandweer & Hulpdiensten' }, topic: 'firefighting_emergency' },
  { unit: 'unit_eritrea_flugzeugteile_fotografie', files: ['flugzeugteile', 'fotografie'], title: { de: 'Flugzeugteile & Fotografie', en: 'Airplane Parts & Photography', sv: 'Flygplansdelar & Fotografi', nl: 'Vliegtuigonderdelen & Fotografie' }, topic: 'airplane_photography' },
  { unit: 'unit_eritrea_friseursalon_schneiderei', files: ['friseursalon', 'schneiderei'], title: { de: 'Friseursalon & Schneiderei', en: 'Hair Salon & Tailoring', sv: 'Frisörsalong & Skrädderi', nl: 'Kapsalon & Kleermakerij' }, topic: 'salon_tailoring' },
  { unit: 'unit_eritrea_gaerten_gartengeraete', files: ['gaerten', 'gartengeraete'], title: { de: 'Gärten & Gartengeräte', en: 'Gardens & Garden Tools', sv: 'Trädgårdar & Trädgårdsredskap', nl: 'Tuinen & Tuingereedschap' }, topic: 'gardens_tools' },
  { unit: 'unit_eritrea_hochzeitsfeier', files: ['hochzeitsfeier'], title: { de: 'Hochzeitsfeier', en: 'Wedding Celebration', sv: 'Bröllopsfest', nl: 'Bruiloftsfeest' }, topic: 'wedding' },
  { unit: 'unit_eritrea_brettspiele_jahrmarkt', files: ['brettspiele', 'jahrmarkt'], title: { de: 'Brettspiele & Jahrmarkt', en: 'Board Games & Funfair', sv: 'Brädspel & Nöjesfält', nl: 'Bordspellen & Kermis' }, topic: 'games_funfair' },
  { unit: 'unit_eritrea_seefahrt_gewaesser', files: ['seefahrt', 'gewaesser'], title: { de: 'Seefahrt & Gewässer', en: 'Seafaring & Bodies of Water', sv: 'Sjöfart & Vattendrag', nl: 'Scheepvaart & Wateren' }, topic: 'seafaring_water' },
  { unit: 'unit_eritrea_sicherheit_verpackung', files: ['sicherheit', 'verpackung'], title: { de: 'Sicherheit & Verpackung', en: 'Security & Packaging', sv: 'Säkerhet & Förpackning', nl: 'Veiligheid & Verpakking' }, topic: 'security_packaging' },
  { unit: 'unit_eritrea_veranstaltung_zirkus', files: ['veranstaltung', 'zirkus'], title: { de: 'Veranstaltung & Zirkus', en: 'Events & Circus', sv: 'Evenemang & Cirkus', nl: 'Evenementen & Circus' }, topic: 'events_circus' },
  { unit: 'unit_eritrea_textilien_mode2', files: ['textilien', 'mode2'], title: { de: 'Textilien & Modebranche', en: 'Textiles & Fashion Industry', sv: 'Textilier & Modebransch', nl: 'Textiel & Modebranche' }, topic: 'textiles_fashion' },
  { unit: 'unit_eritrea_reinigung_kunstwerke', files: ['reinigung', 'kunstwerke'], title: { de: 'Reinigung & Kunstwerke', en: 'Cleaning & Artworks', sv: 'Städning & Konstverk', nl: 'Schoonmaken & Kunstwerken' }, topic: 'cleaning_art' },
  { unit: 'unit_eritrea_modeaccessoires_bergbau', files: ['modeaccessoires', 'bergbau'], title: { de: 'Mode-Accessoires & Bergbau', en: 'Fashion Accessories & Mining', sv: 'Modeaccessoarer & Gruvdrift', nl: 'Mode-accessoires & Mijnbouw' }, topic: 'accessories_mining' },
  { unit: 'unit_eritrea_kalligraphie_gastronomie', files: ['kalligraphie', 'gastronomie'], title: { de: 'Kalligraphie & Gastronomie', en: 'Calligraphy & Gastronomy', sv: 'Kalligrafi & Gastronomi', nl: 'Kalligrafie & Gastronomie' }, topic: 'calligraphy_gastronomy' },
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
const newSentenceFileEntry = 'sentences_eritrea_mehr5.json';
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

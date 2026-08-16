// Round 6 (final push) of the Etappe 26 Nachtrag wiring - bundles the
// sixth batch of topic files (including a large "closing" mini-batch of
// short thematic files added to cross the ~2000-word target) into further
// curriculum units. Same pattern as rounds 3-5, with the collision
// pre-check.
const fs = require('fs');
const path = require('path');
const contentDir = path.join(__dirname, '..', 'assets', 'content');

const groups = [
  { unit: 'unit_eritrea_zoo_wildpflege', files: ['zoo', 'tierpflege'], title: { de: 'Zoo & Tierpflege', en: 'Zoo & Pet Care', sv: 'Zoo & Djurvård', nl: 'Dierentuin & Dierenverzorging' }, topic: 'zoo_pet_care' },
  { unit: 'unit_eritrea_gletscher_schmetterlinge', files: ['gletscher', 'schmetterlinge'], title: { de: 'Gletscher & Insekten', en: 'Glaciers & Insects', sv: 'Glaciärer & Insekter', nl: 'Gletsjers & Insecten' }, topic: 'glaciers_insects' },
  { unit: 'unit_eritrea_flohmarkt_supermarkt', files: ['flohmarkt', 'supermarkt'], title: { de: 'Flohmarkt & Supermarkt', en: 'Flea Market & Supermarket', sv: 'Loppmarknad & Snabbköp', nl: 'Vlooienmarkt & Supermarkt' }, topic: 'flea_market_supermarket' },
  { unit: 'unit_eritrea_optik_zahnarzt', files: ['optik', 'zahnarzt'], title: { de: 'Optiker & Zahnarzt', en: 'Optician & Dentist', sv: 'Optiker & Tandläkare', nl: 'Opticien & Tandarts' }, topic: 'optician_dentist' },
  { unit: 'unit_eritrea_brauerei_kaffeezeremonie', files: ['brauerei', 'kaffeezeremonie'], title: { de: 'Brauerei & Kaffeezeremonie', en: 'Brewing & Coffee Ceremony', sv: 'Bryggeri & Kaffeceremoni', nl: 'Brouwerij & Koffieceremonie' }, topic: 'brewing_coffee' },
  { unit: 'unit_eritrea_erstehilfe_notdienste2', files: ['erstehilfe'], title: { de: 'Erste Hilfe', en: 'First Aid', sv: 'Första hjälpen', nl: 'EHBO' }, topic: 'first_aid' },
  { unit: 'unit_eritrea_mobilfunk_technikphrasen', files: ['mobilfunk', 'technikphrasen'], title: { de: 'Mobilfunk & Technikprobleme', en: 'Mobile Phones & Tech Issues', sv: 'Mobiltelefoner & Tekniska problem', nl: 'Mobiele telefoons & Techproblemen' }, topic: 'mobile_tech_issues' },
  { unit: 'unit_eritrea_steuern_immobilien', files: ['steuern', 'immobilien'], title: { de: 'Steuern & Immobilien', en: 'Taxes & Real Estate', sv: 'Skatter & Fastigheter', nl: 'Belastingen & Vastgoed' }, topic: 'taxes_real_estate' },
  { unit: 'unit_eritrea_architektur_denkmal', files: ['architektur', 'denkmal'], title: { de: 'Architektur & Denkmäler', en: 'Architecture & Monuments', sv: 'Arkitektur & Monument', nl: 'Architectuur & Monumenten' }, topic: 'architecture_monuments' },
  { unit: 'unit_eritrea_seniorenpflege_jugend', files: ['seniorenpflege', 'jugend'], title: { de: 'Seniorenpflege & Jugend', en: 'Elderly Care & Youth', sv: 'Äldreomsorg & Ungdom', nl: 'Ouderenzorg & Jeugd' }, topic: 'elderly_youth' },
  { unit: 'unit_eritrea_energie2_landwirtschaft2', files: ['energie2', 'landwirtschaft2'], title: { de: 'Erneuerbare Energie & Landwirtschaft (mehr)', en: 'Renewable Energy & Agriculture (more)', sv: 'Förnybar energi & Jordbruk (mer)', nl: 'Duurzame energie & Landbouw (meer)' }, topic: 'renewable_agriculture' },
  { unit: 'unit_eritrea_fleischerei_baeckerei', files: ['fleischerei', 'baeckerei'], title: { de: 'Metzgerei & Bäckerei', en: 'Butchery & Bakery', sv: 'Slakteri & Bageri', nl: 'Slagerij & Bakkerij' }, topic: 'butchery_bakery' },
  { unit: 'unit_eritrea_tankstelle_bibliothek', files: ['tankstelle', 'bibliothek'], title: { de: 'Tankstelle & Bibliothek', en: 'Gas Station & Library', sv: 'Bensinstation & Bibliotek', nl: 'Tankstation & Bibliotheek' }, topic: 'gas_station_library' },
  { unit: 'unit_eritrea_gesten_koerperhaltung', files: ['gesten', 'koerperhaltung'], title: { de: 'Gestik & Körperhaltung', en: 'Gestures & Body Posture', sv: 'Gester & Kroppshållning', nl: 'Gebaren & Lichaamshouding' }, topic: 'gestures_posture' },
  { unit: 'unit_eritrea_briefmarken_traeume', files: ['briefmarken', 'traeume'], title: { de: 'Sammeln & Träume', en: 'Collecting & Dreams', sv: 'Samlande & Drömmar', nl: 'Verzamelen & Dromen' }, topic: 'collecting_dreams' },
  { unit: 'unit_eritrea_gewohnheiten_meinungen', files: ['gewohnheiten', 'meinungen'], title: { de: 'Gewohnheiten & Meinungen', en: 'Habits & Opinions', sv: 'Vanor & Åsikter', nl: 'Gewoontes & Meningen' }, topic: 'habits_opinions' },
  { unit: 'unit_eritrea_konflikt_zustimmung', files: ['konflikt', 'zustimmung'], title: { de: 'Konflikt & Zustimmung', en: 'Conflict & Agreement', sv: 'Konflikt & Samtycke', nl: 'Conflict & Instemming' }, topic: 'conflict_agreement' },
  { unit: 'unit_eritrea_erinnerung_zukunftsplaene', files: ['erinnerung', 'zukunftsplaene'], title: { de: 'Erinnerung & Zukunftspläne', en: 'Memory & Future Plans', sv: 'Minne & Framtidsplaner', nl: 'Herinnering & Toekomstplannen' }, topic: 'memory_future' },
  { unit: 'unit_eritrea_hoeflichkeit_zustaende', files: ['hoeflichkeit', 'zustaende'], title: { de: 'Höflichkeit & Zustände', en: 'Politeness & States', sv: 'Artighet & Tillstånd', nl: 'Beleefdheid & Toestanden' }, topic: 'politeness_states' },
  { unit: 'unit_eritrea_bewegung_koerperfunktionen', files: ['bewegung', 'koerperfunktionen'], title: { de: 'Bewegung & Körperfunktionen', en: 'Movement & Body Functions', sv: 'Rörelse & Kroppsfunktioner', nl: 'Beweging & Lichaamsfuncties' }, topic: 'movement_body_functions' },
  { unit: 'unit_eritrea_geraeusche_licht', files: ['geraeusche', 'licht'], title: { de: 'Geräusche & Licht', en: 'Sounds & Light', sv: 'Ljud & Ljus', nl: 'Geluiden & Licht' }, topic: 'sounds_light' },
  { unit: 'unit_eritrea_temperatur_form_textur', files: ['temperatur', 'form_textur'], title: { de: 'Temperatur & Textur', en: 'Temperature & Texture', sv: 'Temperatur & Textur', nl: 'Temperatuur & Textuur' }, topic: 'temperature_texture' },
  { unit: 'unit_eritrea_menge_gefahren', files: ['menge', 'gefahren'], title: { de: 'Menge & Gefahren', en: 'Quantity & Danger', sv: 'Mängd & Fara', nl: 'Hoeveelheid & Gevaar' }, topic: 'quantity_danger' },
  { unit: 'unit_eritrea_veraenderung_vergleiche2', files: ['veraenderung', 'vergleiche2'], title: { de: 'Veränderung & Vergleiche (mehr)', en: 'Change & Comparisons (more)', sv: 'Förändring & Jämförelser (mer)', nl: 'Verandering & Vergelijkingen (meer)' }, topic: 'change_comparison' },
  { unit: 'unit_eritrea_position_haeufigkeit', files: ['position', 'haeufigkeit'], title: { de: 'Position & Häufigkeit', en: 'Position & Frequency', sv: 'Position & Frekvens', nl: 'Positie & Frequentie' }, topic: 'position_frequency' },
  { unit: 'unit_eritrea_konjunktionen_geld_ausdruecke', files: ['konjunktionen', 'geld_ausdruecke'], title: { de: 'Konjunktionen & Geldausdrücke', en: 'Conjunctions & Money Expressions', sv: 'Konjunktioner & Penninguttryck', nl: 'Voegwoorden & Geld-uitdrukkingen' }, topic: 'conjunctions_money' },
  { unit: 'unit_eritrea_wetterausdruecke_verabschiedung', files: ['wetterausdruecke', 'verabschiedung'], title: { de: 'Wetterausdrücke & Verabschiedung', en: 'Weather Expressions & Farewells', sv: 'Väderuttryck & Avsked', nl: 'Weer-uitdrukkingen & Afscheid' }, topic: 'weather_farewell' },
  { unit: 'unit_eritrea_smalltalk_notfallphrasen', files: ['smalltalk', 'notfallphrasen'], title: { de: 'Small Talk & Notfallphrasen', en: 'Small Talk & Emergency Phrases', sv: 'Småprat & Nödfraser', nl: 'Small talk & Noodzinnen' }, topic: 'smalltalk_emergency' },
  { unit: 'unit_eritrea_gluecksphrasen_wuensche', files: ['gluecksphrasen', 'wuensche', 'abschluss'], title: { de: 'Glückwünsche & Wünsche', en: 'Congratulations & Wishes', sv: 'Gratulationer & Önskningar', nl: 'Felicitaties & Wensen' }, topic: 'congratulations_wishes' },
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
const newSentenceFileEntry = 'sentences_eritrea_mehr6.json';
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

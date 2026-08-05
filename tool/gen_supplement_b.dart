import 'content_lib.dart';

void main() {
  writeUnit(UnitSpec(
    id: 'unit_laender',
    sectionId: 'sec_a2',
    level: 'A2',
    topic: 'countries',
    title: const Tr('Länder & Sprachen', 'Countries & languages', 'Länder & språk', 'Landen & talen'),
    lexemes: [
      LexemeSpec(id: 'lex_deutschland', am: 'ጀርመን', tr: 'jerman', pos: 'noun', topic: 'countries', level: 'A2', emoji: '🇩🇪', verified: true, t: const Tr('Deutschland', 'Germany', 'Tyskland', 'Duitsland')),
      LexemeSpec(id: 'lex_england', am: 'እንግሊዝ', tr: 'ingiliz', pos: 'noun', topic: 'countries', level: 'A2', emoji: '🇬🇧', verified: true, t: const Tr('England', 'England', 'England', 'Engeland')),
      LexemeSpec(id: 'lex_schweden', am: 'ስዊድን', tr: 'swidin', pos: 'noun', topic: 'countries', level: 'A2', emoji: '🇸🇪', t: const Tr('Schweden', 'Sweden', 'Sverige', 'Zweden')),
      LexemeSpec(id: 'lex_niederlande', am: 'ሆላንድ', tr: 'holand', pos: 'noun', topic: 'countries', level: 'A2', emoji: '🇳🇱', t: const Tr('die Niederlande, Holland', 'the Netherlands, Holland', 'Nederländerna, Holland', 'Nederland, Holland')),
      LexemeSpec(id: 'lex_frankreich', am: 'ፈረንሳይ', tr: 'ferensay', pos: 'noun', topic: 'countries', level: 'A2', emoji: '🇫🇷', verified: true, t: const Tr('Frankreich', 'France', 'Frankrike', 'Frankrijk')),
      LexemeSpec(id: 'lex_italien', am: 'ጣልያን', tr: "t'aliyan", pos: 'noun', topic: 'countries', level: 'A2', emoji: '🇮🇹', verified: true, t: const Tr('Italien', 'Italy', 'Italien', 'Italië')),
      LexemeSpec(id: 'lex_amerika', am: 'አሜሪካ', tr: 'amerika', pos: 'noun', topic: 'countries', level: 'A2', emoji: '🇺🇸', verified: true, t: const Tr('Amerika', 'America', 'Amerika', 'Amerika')),
      LexemeSpec(id: 'lex_china', am: 'ቻይና', tr: 'chayna', pos: 'noun', topic: 'countries', level: 'A2', emoji: '🇨🇳', verified: true, t: const Tr('China', 'China', 'Kina', 'China')),
      LexemeSpec(id: 'lex_kenia', am: 'ኬንያ', tr: 'kenya', pos: 'noun', topic: 'countries', level: 'A2', emoji: '🇰🇪', verified: true, t: const Tr('Kenia', 'Kenya', 'Kenya', 'Kenia')),
      LexemeSpec(id: 'lex_aegypten', am: 'ግብጽ', tr: "gibts'", pos: 'noun', topic: 'countries', level: 'A2', emoji: '🇪🇬', verified: true, t: const Tr('Ägypten', 'Egypt', 'Egypten', 'Egypte')),
      LexemeSpec(id: 'lex_sudan', am: 'ሱዳን', tr: 'sudan', pos: 'noun', topic: 'countries', level: 'A2', emoji: '🇸🇩', verified: true, t: const Tr('Sudan', 'Sudan', 'Sudan', 'Soedan')),
      LexemeSpec(id: 'lex_spanien', am: 'ስፔን', tr: 'spain', pos: 'noun', topic: 'countries', level: 'A2', emoji: '🇪🇸', t: const Tr('Spanien', 'Spain', 'Spanien', 'Spanje')),
      LexemeSpec(id: 'lex_deutsch_sprache', am: 'ጀርመንኛ', tr: 'jermenigna', pos: 'noun', topic: 'countries', level: 'A2', t: const Tr('Deutsch (Sprache)', 'German (language)', 'tyska (språk)', 'Duits (taal)')),
      LexemeSpec(id: 'lex_englisch_sprache', am: 'እንግሊዝኛ', tr: 'ingilizigna', pos: 'noun', topic: 'countries', level: 'A2', verified: true, t: const Tr('Englisch (Sprache)', 'English (language)', 'engelska (språk)', 'Engels (taal)')),
    ],
    sentences: [
      SentenceSpec(id: 'sen_ine_jerman', am: 'እኔ ከጀርመን ነኝ።', tr: 'ine ke-jerman negn.', level: 'A2', uses: ['lex_ine', 'lex_deutschland'], chunks: ['ine', 'ke-jerman', 'negn'], t: const Tr('Ich bin aus Deutschland.', 'I am from Germany.', 'Jag är från Tyskland.', 'Ik kom uit Duitsland.'), verified: false),
    ],
  ));

  writeUnit(UnitSpec(
    id: 'unit_essen_mehr',
    sectionId: 'sec_a1_2',
    level: 'A1.2',
    topic: 'food_more',
    title: const Tr('Mehr Essen', 'More food', 'Mer mat', 'Meer voedsel'),
    lexemes: [
      LexemeSpec(id: 'lex_zwiebel', am: 'ሽንኩርት', tr: 'shinkurt', pos: 'noun', topic: 'food_more', level: 'A1.2', emoji: '🧅', verified: true, t: const Tr('die Zwiebel', 'onion', 'lök', 'ui')),
      LexemeSpec(id: 'lex_tomate', am: 'ቲማቲም', tr: 'timatim', pos: 'noun', topic: 'food_more', level: 'A1.2', emoji: '🍅', verified: true, t: const Tr('die Tomate', 'tomato', 'tomat', 'tomaat')),
      LexemeSpec(id: 'lex_kartoffel', am: 'ድንች', tr: 'dinich', pos: 'noun', topic: 'food_more', level: 'A1.2', emoji: '🥔', verified: true, t: const Tr('die Kartoffel', 'potato', 'potatis', 'aardappel')),
      LexemeSpec(id: 'lex_knoblauch', am: 'ነጭ ሽንኩርት', tr: 'nech shinkurt', pos: 'noun', topic: 'food_more', level: 'A1.2', emoji: '🧄', t: const Tr('der Knoblauch', 'garlic', 'vitlök', 'knoflook')),
      LexemeSpec(id: 'lex_avocado', am: 'አቮካዶ', tr: 'avokado', pos: 'noun', topic: 'food_more', level: 'A1.2', emoji: '🥑', verified: true, t: const Tr('die Avocado', 'avocado', 'avokado', 'avocado')),
      LexemeSpec(id: 'lex_karotte', am: 'ካሮት', tr: 'karot', pos: 'noun', topic: 'food_more', level: 'A1.2', emoji: '🥕', t: const Tr('die Karotte', 'carrot', 'morot', 'wortel')),
      LexemeSpec(id: 'lex_linsen', am: 'ምስር', tr: 'misir', pos: 'noun', topic: 'food_more', level: 'A1.2', verified: true, t: const Tr('die Linsen', 'lentils', 'linser', 'linzen')),
      LexemeSpec(id: 'lex_kohl', am: 'ጎመን', tr: 'gomen', pos: 'noun', topic: 'food_more', level: 'A1.2', emoji: '🥬', verified: true, t: const Tr('der Kohl (Grünkohl-Gericht)', 'collard greens', 'kål', 'boerenkool')),
      LexemeSpec(id: 'lex_limette', am: 'ሎሚ', tr: 'lomi', pos: 'noun', topic: 'food_more', level: 'A1.2', emoji: '🍋', verified: true, t: const Tr('die Limette, die Zitrone', 'lime, lemon', 'lime, citron', 'limoen, citroen')),
      LexemeSpec(id: 'lex_oel', am: 'ዘይት', tr: 'zeyit', pos: 'noun', topic: 'food_more', level: 'A1.2', verified: true, t: const Tr('das Öl', 'oil', 'olja', 'olie')),
      LexemeSpec(id: 'lex_butter', am: 'ቅቤ', tr: 'kibbe', pos: 'noun', topic: 'food_more', level: 'A1.2', verified: true, t: const Tr('die Butter', 'butter', 'smör', 'boter')),
    ],
    sentences: [
      SentenceSpec(id: 'sen_shinkurt_keyy', am: 'ሽንኩርቱ ቀይ ነው።', tr: 'shinkurtu keyy new.', level: 'A1.2', uses: ['lex_zwiebel', 'lex_rot'], chunks: ['shinkurtu', 'keyy', 'new'], t: const Tr('Die Zwiebel ist rot.', 'The onion is red.', 'Löken är röd.', 'De ui is rood.'), verified: false),
    ],
  ));

  writeUnit(UnitSpec(
    id: 'unit_kalender_aethiopien',
    sectionId: 'sec_b1',
    level: 'B1',
    topic: 'ethiopian_calendar',
    title: const Tr('Der äthiopische Kalender', 'The Ethiopian calendar', 'Den etiopiska kalendern', 'De Ethiopische kalender'),
    lexemes: [
      LexemeSpec(id: 'lex_meskerem', am: 'መስከረም', tr: 'meskerem', pos: 'noun', topic: 'ethiopian_calendar', level: 'B1', t: const Tr('Meskerem (1. Monat)', 'Meskerem (1st month)', 'Meskerem (1:a månaden)', 'Meskerem (1e maand)')),
      LexemeSpec(id: 'lex_tikimt', am: 'ጥቅምት', tr: "t'ikimt", pos: 'noun', topic: 'ethiopian_calendar', level: 'B1', t: const Tr('Tikimt (2. Monat)', 'Tikimt (2nd month)', 'Tikimt (2:a månaden)', 'Tikimt (2e maand)')),
      LexemeSpec(id: 'lex_hidar', am: 'ህዳር', tr: 'hidar', pos: 'noun', topic: 'ethiopian_calendar', level: 'B1', t: const Tr('Hidar (3. Monat)', 'Hidar (3rd month)', 'Hidar (3:e månaden)', 'Hidar (3e maand)')),
      LexemeSpec(id: 'lex_tahsas', am: 'ታህሳስ', tr: 'tahsas', pos: 'noun', topic: 'ethiopian_calendar', level: 'B1', t: const Tr('Tahsas (4. Monat)', 'Tahsas (4th month)', 'Tahsas (4:e månaden)', 'Tahsas (4e maand)')),
      LexemeSpec(id: 'lex_tir', am: 'ጥር', tr: 'tir', pos: 'noun', topic: 'ethiopian_calendar', level: 'B1', t: const Tr('Tir (5. Monat)', 'Tir (5th month)', 'Tir (5:e månaden)', 'Tir (5e maand)')),
      LexemeSpec(id: 'lex_yekatit', am: 'የካቲት', tr: 'yekatit', pos: 'noun', topic: 'ethiopian_calendar', level: 'B1', t: const Tr('Yekatit (6. Monat)', 'Yekatit (6th month)', 'Yekatit (6:e månaden)', 'Yekatit (6e maand)')),
      LexemeSpec(id: 'lex_megabit', am: 'መጋቢት', tr: 'megabit', pos: 'noun', topic: 'ethiopian_calendar', level: 'B1', t: const Tr('Megabit (7. Monat)', 'Megabit (7th month)', 'Megabit (7:e månaden)', 'Megabit (7e maand)')),
      LexemeSpec(id: 'lex_miyazya', am: 'ሚያዚያ', tr: 'miyazya', pos: 'noun', topic: 'ethiopian_calendar', level: 'B1', t: const Tr('Miazia (8. Monat)', 'Miazia (8th month)', 'Miazia (8:e månaden)', 'Miazia (8e maand)')),
      LexemeSpec(id: 'lex_ginbot', am: 'ግንቦት', tr: 'ginbot', pos: 'noun', topic: 'ethiopian_calendar', level: 'B1', t: const Tr('Ginbot (9. Monat)', 'Ginbot (9th month)', 'Ginbot (9:e månaden)', 'Ginbot (9e maand)')),
      LexemeSpec(id: 'lex_sene', am: 'ሰኔ', tr: 'sene', pos: 'noun', topic: 'ethiopian_calendar', level: 'B1', t: const Tr('Sene (10. Monat)', 'Sene (10th month)', 'Sene (10:e månaden)', 'Sene (10e maand)')),
      LexemeSpec(id: 'lex_hamle', am: 'ሐምሌ', tr: 'hamle', pos: 'noun', topic: 'ethiopian_calendar', level: 'B1', t: const Tr('Hamle (11. Monat)', 'Hamle (11th month)', 'Hamle (11:e månaden)', 'Hamle (11e maand)')),
      LexemeSpec(id: 'lex_nehase', am: 'ነሐሴ', tr: 'nehase', pos: 'noun', topic: 'ethiopian_calendar', level: 'B1', t: const Tr('Nehase (12. Monat)', 'Nehase (12th month)', 'Nehase (12:e månaden)', 'Nehase (12e maand)')),
      LexemeSpec(id: 'lex_pagume', am: 'ጳጉሜ', tr: 'pagume', pos: 'noun', topic: 'ethiopian_calendar', level: 'B1', t: const Tr('Pagumen (13. Monat, kurz)', 'Pagume (13th, short month)', 'Pagume (13:e, kort månaden)', 'Pagume (13e, korte maand)')),
    ],
    sentences: [],
  ));

  writeUnit(UnitSpec(
    id: 'unit_zahlen_ordnung',
    sectionId: 'sec_a1_2',
    level: 'A1.2',
    topic: 'numbers_more',
    title: const Tr('Ordnungszahlen & mehr Zahlen', 'Ordinal & more numbers', 'Ordningstal & fler siffror', 'Rangtelwoorden & meer cijfers'),
    lexemes: [
      LexemeSpec(id: 'lex_erste', am: 'አንደኛ', tr: 'andegna', pos: 'adjective', topic: 'numbers_more', level: 'A1.2', verified: true, t: const Tr('erste(r/s)', 'first', 'första', 'eerste')),
      LexemeSpec(id: 'lex_zweite', am: 'ሁለተኛ', tr: 'huletegna', pos: 'adjective', topic: 'numbers_more', level: 'A1.2', verified: true, t: const Tr('zweite(r/s)', 'second', 'andra', 'tweede')),
      LexemeSpec(id: 'lex_dritte', am: 'ሶስተኛ', tr: 'sostegna', pos: 'adjective', topic: 'numbers_more', level: 'A1.2', t: const Tr('dritte(r/s)', 'third', 'tredje', 'derde')),
      LexemeSpec(id: 'lex_vierte', am: 'አራተኛ', tr: 'arategna', pos: 'adjective', topic: 'numbers_more', level: 'A1.2', t: const Tr('vierte(r/s)', 'fourth', 'fjärde', 'vierde')),
      LexemeSpec(id: 'lex_fuenfte', am: 'አምስተኛ', tr: 'amistegna', pos: 'adjective', topic: 'numbers_more', level: 'A1.2', t: const Tr('fünfte(r/s)', 'fifth', 'femte', 'vijfde')),
      LexemeSpec(id: 'lex_zahl_200', am: 'ሁለት መቶ', tr: 'hulet meto', pos: 'number', topic: 'numbers_more', level: 'A1.2', verified: true, t: const Tr('200', '200', '200', '200')),
      LexemeSpec(id: 'lex_zahl_300', am: 'ሶስት መቶ', tr: 'sost meto', pos: 'number', topic: 'numbers_more', level: 'A1.2', verified: true, t: const Tr('300', '300', '300', '300')),
      LexemeSpec(id: 'lex_zahl_500', am: 'አምስት መቶ', tr: 'amist meto', pos: 'number', topic: 'numbers_more', level: 'A1.2', verified: true, t: const Tr('500', '500', '500', '500')),
      LexemeSpec(id: 'lex_million', am: 'ሚሊዮን', tr: 'milyon', pos: 'number', topic: 'numbers_more', level: 'A1.2', verified: true, t: const Tr('die Million', 'million', 'miljon', 'miljoen')),
    ],
    sentences: [],
  ));

  writeUnit(UnitSpec(
    id: 'unit_verben_mehr',
    sectionId: 'sec_a2',
    level: 'A2',
    topic: 'verbs_more',
    title: const Tr('Mehr Verben', 'More verbs', 'Fler verb', 'Meer werkwoorden'),
    lexemes: [
      LexemeSpec(id: 'lex_v_bauen', am: 'መገንባት', tr: 'megenbat', pos: 'verb', topic: 'verbs_more', level: 'A2', t: const Tr('bauen', 'to build', 'bygga', 'bouwen')),
      LexemeSpec(id: 'lex_v_tragen', am: 'መሸከም', tr: 'meshekem', pos: 'verb', topic: 'verbs_more', level: 'A2', t: const Tr('tragen', 'to carry', 'bära', 'dragen')),
      LexemeSpec(id: 'lex_v_ziehen', am: 'መጎተት', tr: 'megotet', pos: 'verb', topic: 'verbs_more', level: 'A2', t: const Tr('ziehen', 'to pull', 'dra', 'trekken')),
      LexemeSpec(id: 'lex_v_fallen', am: 'መውደቅ', tr: "mewdek'", pos: 'verb', topic: 'verbs_more', level: 'A2', t: const Tr('fallen', 'to fall', 'falla', 'vallen')),
      LexemeSpec(id: 'lex_v_springen', am: 'መዝለል', tr: 'mezlel', pos: 'verb', topic: 'verbs_more', level: 'A2', t: const Tr('springen', 'to jump', 'hoppa', 'springen')),
      LexemeSpec(id: 'lex_v_fliegen', am: 'መብረር', tr: 'mebrer', pos: 'verb', topic: 'verbs_more', level: 'A2', t: const Tr('fliegen', 'to fly', 'flyga', 'vliegen')),
      LexemeSpec(id: 'lex_v_atmen', am: 'መተንፈስ', tr: 'metenfes', pos: 'verb', topic: 'verbs_more', level: 'A2', t: const Tr('atmen', 'to breathe', 'andas', 'ademen')),
      LexemeSpec(id: 'lex_v_leben', am: 'መኖር', tr: 'menor', pos: 'verb', topic: 'verbs_more', level: 'A2', verified: true, t: const Tr('leben', 'to live', 'leva', 'leven')),
      LexemeSpec(id: 'lex_v_heiraten', am: 'ማግባት', tr: 'magbat', pos: 'verb', topic: 'verbs_more', level: 'A2', t: const Tr('heiraten', 'to marry', 'gifta sig', 'trouwen')),
      LexemeSpec(id: 'lex_v_geborenwerden', am: 'መወለድ', tr: 'meweled', pos: 'verb', topic: 'verbs_more', level: 'A2', t: const Tr('geboren werden', 'to be born', 'födas', 'geboren worden')),
      LexemeSpec(id: 'lex_v_sterben', am: 'መሞት', tr: 'memot', pos: 'verb', topic: 'verbs_more', level: 'A2', verified: true, t: const Tr('sterben', 'to die', 'dö', 'sterven')),
      LexemeSpec(id: 'lex_v_reparieren', am: 'መጠገን', tr: "met'egen", pos: 'verb', topic: 'verbs_more', level: 'A2', t: const Tr('reparieren', 'to repair', 'reparera', 'repareren')),
    ],
    sentences: [],
  ));

  writeUnit(UnitSpec(
    id: 'unit_adverbien_mehr',
    sectionId: 'sec_a1_1',
    level: 'A1.1',
    topic: 'adverbs_more',
    title: const Tr('Mehr Adverbien', 'More adverbs', 'Fler adverb', 'Meer bijwoorden'),
    lexemes: [
      LexemeSpec(id: 'lex_hier', am: 'እዚህ', tr: 'izih', pos: 'adverb', topic: 'adverbs_more', level: 'A1.1', verified: true, t: const Tr('hier', 'here', 'här', 'hier')),
      LexemeSpec(id: 'lex_dort', am: 'እዚያ', tr: 'iziya', pos: 'adverb', topic: 'adverbs_more', level: 'A1.1', verified: true, t: const Tr('dort', 'there', 'där', 'daar')),
      LexemeSpec(id: 'lex_ueberall', am: 'በሁሉም ቦታ', tr: 'behulem bota', pos: 'adverb', topic: 'adverbs_more', level: 'A1.1', t: const Tr('überall', 'everywhere', 'överallt', 'overal')),
      LexemeSpec(id: 'lex_draussen', am: 'ውጭ', tr: 'wich', pos: 'adverb', topic: 'adverbs_more', level: 'A1.1', verified: true, t: const Tr('draußen', 'outside', 'utomhus', 'buiten')),
      LexemeSpec(id: 'lex_oben', am: 'በላይ', tr: 'belay', pos: 'adverb', topic: 'adverbs_more', level: 'A1.1', t: const Tr('oben', 'above, up', 'ovanför', 'boven')),
      LexemeSpec(id: 'lex_unten', am: 'በታች', tr: 'betach', pos: 'adverb', topic: 'adverbs_more', level: 'A1.1', t: const Tr('unten', 'below, down', 'nedanför', 'onder')),
      LexemeSpec(id: 'lex_zusammen', am: 'በጋራ', tr: 'begara', pos: 'adverb', topic: 'adverbs_more', level: 'A1.1', t: const Tr('zusammen', 'together', 'tillsammans', 'samen')),
      LexemeSpec(id: 'lex_allein', am: 'ብቻ', tr: 'bicha', pos: 'adverb', topic: 'adverbs_more', level: 'A1.1', t: const Tr('allein, nur', 'alone, only', 'ensam, bara', 'alleen, slechts')),
    ],
    sentences: [],
  ));

  writeUnit(UnitSpec(
    id: 'unit_moebel',
    sectionId: 'sec_a1_2',
    level: 'A1.2',
    topic: 'furniture',
    title: const Tr('Möbel', 'Furniture', 'Möbler', 'Meubels'),
    lexemes: [
      LexemeSpec(id: 'lex_teppich', am: 'ምንጣፍ', tr: "mint'af", pos: 'noun', topic: 'furniture', level: 'A1.2', emoji: '🟫', t: const Tr('der Teppich', 'carpet, rug', 'matta', 'tapijt')),
      LexemeSpec(id: 'lex_kissen', am: 'ትራስ', tr: 'tiras', pos: 'noun', topic: 'furniture', level: 'A1.2', t: const Tr('das Kissen', 'pillow, cushion', 'kudde', 'kussen')),
      LexemeSpec(id: 'lex_decke', am: 'ብርድ ልብስ', tr: 'birid libs', pos: 'noun', topic: 'furniture', level: 'A1.2', t: const Tr('die Decke (Bettdecke)', 'blanket', 'täcke', 'deken')),
      LexemeSpec(id: 'lex_vorhang', am: 'መጋረጃ', tr: 'megareja', pos: 'noun', topic: 'furniture', level: 'A1.2', t: const Tr('der Vorhang', 'curtain', 'gardin', 'gordijn')),
      LexemeSpec(id: 'lex_wand', am: 'ግድግዳ', tr: 'gidigida', pos: 'noun', topic: 'furniture', level: 'A1.2', t: const Tr('die Wand', 'wall', 'vägg', 'muur')),
    ],
    sentences: [],
  ));

  writeUnit(UnitSpec(
    id: 'unit_hoefliche_phrasen',
    sectionId: 'sec_b1',
    level: 'B1',
    topic: 'polite_phrases',
    title: const Tr('Höfliche Redewendungen', 'Polite phrases', 'Artiga fraser', 'Beleefde uitdrukkingen'),
    lexemes: [
      LexemeSpec(id: 'lex_tut_mir_leid', am: 'አዝናለሁ', tr: 'aznalehu', pos: 'phrase', topic: 'polite_phrases', level: 'B1', t: const Tr('Es tut mir leid', "I'm sorry", 'Jag är ledsen', 'Het spijt me')),
      LexemeSpec(id: 'lex_kein_problem', am: 'ችግር የለም', tr: 'chiggir yelem', pos: 'phrase', topic: 'polite_phrases', level: 'B1', verified: true, t: const Tr('Kein Problem', 'No problem', 'Inga problem', 'Geen probleem')),
      LexemeSpec(id: 'lex_viel_glueck', am: 'መልካም እድል', tr: 'melkam idil', pos: 'phrase', topic: 'polite_phrases', level: 'B1', t: const Tr('Viel Glück', 'Good luck', 'Lycka till', 'Veel geluk')),
      LexemeSpec(id: 'lex_gute_reise', am: 'መልካም ጉዞ', tr: 'melkam guzo', pos: 'phrase', topic: 'polite_phrases', level: 'B1', t: const Tr('Gute Reise', 'Have a good trip', 'Trevlig resa', 'Goede reis')),
      LexemeSpec(id: 'lex_zum_wohl', am: 'ለጤናዎ', tr: "lete'nawo", pos: 'phrase', topic: 'polite_phrases', level: 'B1', t: const Tr('Zum Wohl, Prost', 'Cheers', 'Skål', 'Proost')),
    ],
    sentences: [],
  ));

  writeUnit(UnitSpec(
    id: 'unit_materialien',
    sectionId: 'sec_a2',
    level: 'A2',
    topic: 'materials',
    title: const Tr('Materialien', 'Materials', 'Material', 'Materialen'),
    lexemes: [
      LexemeSpec(id: 'lex_holz', am: 'እንጨት', tr: 'inchet', pos: 'noun', topic: 'materials', level: 'A2', emoji: '🪵', verified: true, t: const Tr('das Holz', 'wood', 'trä', 'hout')),
      LexemeSpec(id: 'lex_stein', am: 'ድንጋይ', tr: 'dingay', pos: 'noun', topic: 'materials', level: 'A2', emoji: '🪨', verified: true, t: const Tr('der Stein', 'stone', 'sten', 'steen')),
      LexemeSpec(id: 'lex_eisen', am: 'ብረት', tr: 'biret', pos: 'noun', topic: 'materials', level: 'A2', verified: true, t: const Tr('das Eisen, Metall', 'iron, metal', 'järn, metall', 'ijzer, metaal')),
      LexemeSpec(id: 'lex_plastik', am: 'ላስቲክ', tr: 'lastik', pos: 'noun', topic: 'materials', level: 'A2', t: const Tr('das Plastik', 'plastic', 'plast', 'plastic')),
    ],
    sentences: [],
  ));

  writeUnit(UnitSpec(
    id: 'unit_musikinstrumente',
    sectionId: 'sec_b1',
    level: 'B1',
    topic: 'instruments',
    title: const Tr('Traditionelle Musikinstrumente', 'Traditional musical instruments', 'Traditionella musikinstrument', 'Traditionele muziekinstrumenten'),
    lexemes: [
      LexemeSpec(id: 'lex_krar', am: 'ክራር', tr: 'kirar', pos: 'noun', topic: 'instruments', level: 'B1', emoji: '🎻', verified: true, t: const Tr('die Krar (Leier)', 'krar (lyre)', 'krar (lyra)', 'krar (lier)')),
      LexemeSpec(id: 'lex_masinko', am: 'ማሲንቆ', tr: 'masinko', pos: 'noun', topic: 'instruments', level: 'B1', emoji: '🎻', verified: true, t: const Tr('die Masinko (Fiedel)', 'masinko (fiddle)', 'masinko (fiol)', 'masinko (vedel)')),
      LexemeSpec(id: 'lex_kebero', am: 'ከበሮ', tr: 'kebero', pos: 'noun', topic: 'instruments', level: 'B1', emoji: '🥁', verified: true, t: const Tr('die Kebero (Trommel)', 'kebero (drum)', 'kebero (trumma)', 'kebero (drum)')),
      LexemeSpec(id: 'lex_washint', am: 'ዋሽንት', tr: 'washint', pos: 'noun', topic: 'instruments', level: 'B1', emoji: '🎶', t: const Tr('die Washint (Flöte)', 'washint (flute)', 'washint (flöjt)', 'washint (fluit)')),
    ],
    sentences: [],
  ));
}

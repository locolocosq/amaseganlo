import 'content_lib.dart';

void main() {
  ensureSection(
    id: 'sec_a1_2',
    level: 'A1.2',
    title: const Tr('Niveau A1.2 — Alltag', 'Level A1.2 — everyday life', 'Nivå A1.2 — vardagen', 'Niveau A1.2 — dagelijks leven'),
  );

  writeUnit(UnitSpec(
    id: 'unit_zuhause',
    sectionId: 'sec_a1_2',
    level: 'A1.2',
    topic: 'home',
    title: const Tr('Zuhause', 'Home', 'Hemma', 'Thuis'),
    lexemes: [
      LexemeSpec(id: 'lex_haus', am: 'ቤት', tr: 'biet', pos: 'noun', topic: 'home', level: 'A1.2', emoji: '🏠', verified: true, t: const Tr('das Haus, zu Hause', 'house, home', 'hus, hem', 'huis, thuis')),
      LexemeSpec(id: 'lex_zimmer', am: 'ክፍል', tr: 'kifil', pos: 'noun', topic: 'home', level: 'A1.2', emoji: '🚪', t: const Tr('das Zimmer', 'room', 'rum', 'kamer')),
      LexemeSpec(id: 'lex_tuer', am: 'በር', tr: 'ber', pos: 'noun', topic: 'home', level: 'A1.2', emoji: '🚪', verified: true, t: const Tr('die Tür', 'door', 'dörr', 'deur')),
      LexemeSpec(id: 'lex_tisch', am: 'ጠረጴዛ', tr: "t'eret'eza", pos: 'noun', topic: 'home', level: 'A1.2', emoji: '🪑', t: const Tr('der Tisch', 'table', 'bord', 'tafel')),
      LexemeSpec(id: 'lex_stuhl', am: 'ወንበር', tr: 'wenber', pos: 'noun', topic: 'home', level: 'A1.2', emoji: '🪑', verified: true, t: const Tr('der Stuhl', 'chair', 'stol', 'stoel')),
      LexemeSpec(id: 'lex_bett', am: 'አልጋ', tr: 'alga', pos: 'noun', topic: 'home', level: 'A1.2', emoji: '🛏️', verified: true, t: const Tr('das Bett', 'bed', 'säng', 'bed')),
      LexemeSpec(id: 'lex_kueche', am: 'ማድቤት', tr: 'madbiet', pos: 'noun', topic: 'home', level: 'A1.2', emoji: '🍳', t: const Tr('die Küche', 'kitchen', 'kök', 'keuken')),
      LexemeSpec(id: 'lex_fenster', am: 'መስኮት', tr: 'meskot', pos: 'noun', topic: 'home', level: 'A1.2', emoji: '🪟', t: const Tr('das Fenster', 'window', 'fönster', 'raam')),
      LexemeSpec(id: 'lex_schluessel', am: 'ቁልፍ', tr: 'kulf', pos: 'noun', topic: 'home', level: 'A1.2', emoji: '🔑', t: const Tr('der Schlüssel', 'key', 'nyckel', 'sleutel')),
      LexemeSpec(id: 'lex_lampe', am: 'መብራት', tr: 'mebrat', pos: 'noun', topic: 'home', level: 'A1.2', emoji: '💡', t: const Tr('die Lampe, das Licht', 'lamp, light', 'lampa, ljus', 'lamp, licht')),
      LexemeSpec(id: 'lex_schrank', am: 'ካቢኔ', tr: 'kabine', pos: 'noun', topic: 'home', level: 'A1.2', emoji: '🗄️', t: const Tr('der Schrank', 'cupboard', 'skåp', 'kast')),
      LexemeSpec(id: 'lex_spiegel', am: 'መስተዋት', tr: 'mestewat', pos: 'noun', topic: 'home', level: 'A1.2', emoji: '🪞', t: const Tr('der Spiegel', 'mirror', 'spegel', 'spiegel')),
      LexemeSpec(id: 'lex_dach', am: 'ጣራ', tr: "t'ara", pos: 'noun', topic: 'home', level: 'A1.2', emoji: '🏠', t: const Tr('das Dach', 'roof', 'tak', 'dak')),
      LexemeSpec(id: 'lex_boden', am: 'ወለል', tr: 'welel', pos: 'noun', topic: 'home', level: 'A1.2', t: const Tr('der Boden, Fußboden', 'floor', 'golv', 'vloer')),
      LexemeSpec(id: 'lex_garten', am: 'ግቢ', tr: 'gibi', pos: 'noun', topic: 'home', level: 'A1.2', emoji: '🌳', t: const Tr('der Garten, Hof', 'garden, yard', 'trädgård, gård', 'tuin, erf')),
      LexemeSpec(id: 'lex_badezimmer', am: 'መጸዳጃ ቤት', tr: "mets'edaja biet", pos: 'noun', topic: 'home', level: 'A1.2', emoji: '🚽', t: const Tr('das Badezimmer', 'bathroom', 'badrum', 'badkamer')),
    ],
    sentences: [
      SentenceSpec(id: 'sen_biet_tilik', am: 'ቤቱ ትልቅ ነው።', tr: 'bietu tilik new.', level: 'A1.2', uses: ['lex_haus'], chunks: ['bietu', 'tilik', 'new'], t: const Tr('Das Haus ist groß.', 'The house is big.', 'Huset är stort.', 'Het huis is groot.')),
      SentenceSpec(id: 'sen_ber_kefeto', am: 'በሩ ተከፍቷል።', tr: 'beru tekeftual.', level: 'A1.2', uses: ['lex_tuer'], chunks: ['beru', 'tekeftual'], t: const Tr('Die Tür ist offen.', 'The door is open.', 'Dörren är öppen.', 'De deur is open.'), verified: false),
    ],
  ));

  writeUnit(UnitSpec(
    id: 'unit_zeit',
    sectionId: 'sec_a1_2',
    level: 'A1.2',
    topic: 'time',
    title: const Tr('Zeit', 'Time', 'Tid', 'Tijd'),
    lexemes: [
      LexemeSpec(id: 'lex_heute', am: 'ዛሬ', tr: 'zare', pos: 'adverb', topic: 'time', level: 'A1.2', verified: true, t: const Tr('heute', 'today', 'idag', 'vandaag')),
      LexemeSpec(id: 'lex_morgen_tag', am: 'ነገ', tr: 'nege', pos: 'adverb', topic: 'time', level: 'A1.2', verified: true, t: const Tr('morgen (der nächste Tag)', 'tomorrow', 'imorgon', 'morgen (volgende dag)')),
      LexemeSpec(id: 'lex_gestern', am: 'ትላንት', tr: 'tilant', pos: 'adverb', topic: 'time', level: 'A1.2', verified: true, t: const Tr('gestern', 'yesterday', 'igår', 'gisteren')),
      LexemeSpec(id: 'lex_tag', am: 'ቀን', tr: 'ken', pos: 'noun', topic: 'time', level: 'A1.2', emoji: '☀️', verified: true, t: const Tr('der Tag', 'day', 'dag', 'dag')),
      LexemeSpec(id: 'lex_nacht', am: 'ሌሊት', tr: 'lelit', pos: 'noun', topic: 'time', level: 'A1.2', emoji: '🌙', verified: true, t: const Tr('die Nacht', 'night', 'natt', 'nacht')),
      LexemeSpec(id: 'lex_abend', am: 'ማታ', tr: 'mata', pos: 'noun', topic: 'time', level: 'A1.2', emoji: '🌆', t: const Tr('der Abend', 'evening', 'kväll', 'avond')),
      LexemeSpec(id: 'lex_morgen_zeit', am: 'ጠዋት', tr: "t'ewat", pos: 'noun', topic: 'time', level: 'A1.2', emoji: '🌅', verified: true, t: const Tr('der Morgen', 'morning', 'morgon', 'ochtend')),
      LexemeSpec(id: 'lex_woche', am: 'ሳምንት', tr: 'samint', pos: 'noun', topic: 'time', level: 'A1.2', verified: true, t: const Tr('die Woche', 'week', 'vecka', 'week')),
      LexemeSpec(id: 'lex_monat', am: 'ወር', tr: 'wer', pos: 'noun', topic: 'time', level: 'A1.2', verified: true, t: const Tr('der Monat', 'month', 'månad', 'maand')),
      LexemeSpec(id: 'lex_jahr', am: 'አመት', tr: 'amet', pos: 'noun', topic: 'time', level: 'A1.2', verified: true, t: const Tr('das Jahr', 'year', 'år', 'jaar')),
      LexemeSpec(id: 'lex_stunde', am: 'ሰዓት', tr: "se'at", pos: 'noun', topic: 'time', level: 'A1.2', emoji: '🕐', verified: true, t: const Tr('die Stunde, die Uhr', 'hour, clock/watch', 'timme, klocka', 'uur, klok')),
      LexemeSpec(id: 'lex_minute', am: 'ደቂቃ', tr: 'dekika', pos: 'noun', topic: 'time', level: 'A1.2', t: const Tr('die Minute', 'minute', 'minut', 'minuut')),
      LexemeSpec(id: 'lex_montag', am: 'ሰኞ', tr: 'segno', pos: 'noun', topic: 'time', level: 'A1.2', verified: true, t: const Tr('Montag', 'Monday', 'måndag', 'maandag')),
      LexemeSpec(id: 'lex_dienstag', am: 'ማክሰኞ', tr: 'maksegno', pos: 'noun', topic: 'time', level: 'A1.2', verified: true, t: const Tr('Dienstag', 'Tuesday', 'tisdag', 'dinsdag')),
      LexemeSpec(id: 'lex_mittwoch', am: 'ረቡዕ', tr: "rebu'", pos: 'noun', topic: 'time', level: 'A1.2', verified: true, t: const Tr('Mittwoch', 'Wednesday', 'onsdag', 'woensdag')),
      LexemeSpec(id: 'lex_donnerstag', am: 'ሐሙስ', tr: 'hamus', pos: 'noun', topic: 'time', level: 'A1.2', verified: true, t: const Tr('Donnerstag', 'Thursday', 'torsdag', 'donderdag')),
      LexemeSpec(id: 'lex_freitag', am: 'አርብ', tr: 'arb', pos: 'noun', topic: 'time', level: 'A1.2', verified: true, t: const Tr('Freitag', 'Friday', 'fredag', 'vrijdag')),
      LexemeSpec(id: 'lex_samstag', am: 'ቅዳሜ', tr: 'kidame', pos: 'noun', topic: 'time', level: 'A1.2', verified: true, t: const Tr('Samstag', 'Saturday', 'lördag', 'zaterdag')),
      LexemeSpec(id: 'lex_sonntag', am: 'እሁድ', tr: 'ihud', pos: 'noun', topic: 'time', level: 'A1.2', verified: true, t: const Tr('Sonntag', 'Sunday', 'söndag', 'zondag')),
    ],
    sentences: [
      SentenceSpec(id: 'sen_zare_segno', am: 'ዛሬ ሰኞ ነው።', tr: 'zare segno new.', level: 'A1.2', uses: ['lex_heute', 'lex_montag'], chunks: ['zare', 'segno', 'new'], t: const Tr('Heute ist Montag.', 'Today is Monday.', 'Idag är det måndag.', 'Vandaag is het maandag.')),
      SentenceSpec(id: 'sen_nege_kidame', am: 'ነገ ቅዳሜ ነው።', tr: 'nege kidame new.', level: 'A1.2', uses: ['lex_morgen_tag', 'lex_samstag'], chunks: ['nege', 'kidame', 'new'], t: const Tr('Morgen ist Samstag.', 'Tomorrow is Saturday.', 'Imorgon är det lördag.', 'Morgen is het zaterdag.')),
    ],
  ));

  writeUnit(UnitSpec(
    id: 'unit_farben_eigenschaften',
    sectionId: 'sec_a1_2',
    level: 'A1.2',
    topic: 'colors_properties',
    title: const Tr('Farben & Eigenschaften', 'Colors & properties', 'Färger & egenskaper', 'Kleuren & eigenschappen'),
    lexemes: [
      LexemeSpec(id: 'lex_rot', am: 'ቀይ', tr: 'keyy', pos: 'adjective', topic: 'colors_properties', level: 'A1.2', emoji: '🔴', verified: true, t: const Tr('rot', 'red', 'röd', 'rood')),
      LexemeSpec(id: 'lex_blau', am: 'ሰማያዊ', tr: 'semayawi', pos: 'adjective', topic: 'colors_properties', level: 'A1.2', emoji: '🔵', verified: true, t: const Tr('blau', 'blue', 'blå', 'blauw')),
      LexemeSpec(id: 'lex_gruen', am: 'አረንጓዴ', tr: 'arenguadie', pos: 'adjective', topic: 'colors_properties', level: 'A1.2', emoji: '🟢', verified: true, t: const Tr('grün', 'green', 'grön', 'groen')),
      LexemeSpec(id: 'lex_gelb', am: 'ቢጫ', tr: 'bicha', pos: 'adjective', topic: 'colors_properties', level: 'A1.2', emoji: '🟡', verified: true, t: const Tr('gelb', 'yellow', 'gul', 'geel')),
      LexemeSpec(id: 'lex_schwarz', am: 'ጥቁር', tr: "t'ikur", pos: 'adjective', topic: 'colors_properties', level: 'A1.2', emoji: '⚫', verified: true, t: const Tr('schwarz', 'black', 'svart', 'zwart')),
      LexemeSpec(id: 'lex_weiss', am: 'ነጭ', tr: 'nech', pos: 'adjective', topic: 'colors_properties', level: 'A1.2', emoji: '⚪', verified: true, t: const Tr('weiß', 'white', 'vit', 'wit')),
      LexemeSpec(id: 'lex_braun', am: 'ቡኒ', tr: 'buni', pos: 'adjective', topic: 'colors_properties', level: 'A1.2', emoji: '🟤', t: const Tr('braun', 'brown', 'brun', 'bruin')),
      LexemeSpec(id: 'lex_rosa', am: 'ሮዝ', tr: 'roz', pos: 'adjective', topic: 'colors_properties', level: 'A1.2', emoji: '🩷', t: const Tr('rosa, pink', 'pink', 'rosa', 'roze')),
      LexemeSpec(id: 'lex_lila', am: 'ሐምራዊ', tr: 'hamrawi', pos: 'adjective', topic: 'colors_properties', level: 'A1.2', emoji: '🟣', t: const Tr('lila, violett', 'purple', 'lila', 'paars')),
      LexemeSpec(id: 'lex_grau', am: 'ግራጫ', tr: 'gracha', pos: 'adjective', topic: 'colors_properties', level: 'A1.2', t: const Tr('grau', 'gray', 'grå', 'grijs')),
      LexemeSpec(id: 'lex_gross', am: 'ትልቅ', tr: 'tilik', pos: 'adjective', topic: 'colors_properties', level: 'A1.2', verified: true, t: const Tr('groß', 'big', 'stor', 'groot')),
      LexemeSpec(id: 'lex_klein', am: 'ትንሽ', tr: 'tinish', pos: 'adjective', topic: 'colors_properties', level: 'A1.2', verified: true, t: const Tr('klein', 'small', 'liten', 'klein')),
      LexemeSpec(id: 'lex_gut', am: 'ጥሩ', tr: "t'iru", pos: 'adjective', topic: 'colors_properties', level: 'A1.2', verified: true, t: const Tr('gut', 'good', 'bra', 'goed')),
      LexemeSpec(id: 'lex_schlecht', am: 'መጥፎ', tr: "met'ifo", pos: 'adjective', topic: 'colors_properties', level: 'A1.2', verified: true, t: const Tr('schlecht', 'bad', 'dålig', 'slecht')),
      LexemeSpec(id: 'lex_neu', am: 'አዲስ', tr: 'addis', pos: 'adjective', topic: 'colors_properties', level: 'A1.2', verified: true, t: const Tr('neu', 'new', 'ny', 'nieuw')),
      LexemeSpec(id: 'lex_alt', am: 'አሮጌ', tr: 'aroge', pos: 'adjective', topic: 'colors_properties', level: 'A1.2', verified: true, t: const Tr('alt (Sache)', 'old (thing)', 'gammal (sak)', 'oud (dingen)')),
      LexemeSpec(id: 'lex_heiss', am: 'ሙቅ', tr: 'muk', pos: 'adjective', topic: 'colors_properties', level: 'A1.2', t: const Tr('heiß, warm', 'hot, warm', 'varm', 'heet, warm')),
      LexemeSpec(id: 'lex_kalt', am: 'ቀዝቃዛ', tr: 'kezkaza', pos: 'adjective', topic: 'colors_properties', level: 'A1.2', verified: true, t: const Tr('kalt', 'cold', 'kall', 'koud')),
      LexemeSpec(id: 'lex_schoen', am: 'ቆንጆ', tr: 'konjo', pos: 'adjective', topic: 'colors_properties', level: 'A1.2', verified: true, t: const Tr('schön, hübsch', 'beautiful, pretty', 'vacker', 'mooi'), emoji: '✨'),
      LexemeSpec(id: 'lex_lang', am: 'ረጅም', tr: 'rejim', pos: 'adjective', topic: 'colors_properties', level: 'A1.2', verified: true, t: const Tr('lang, groß (Person)', 'long, tall', 'lång', 'lang'), ),
      LexemeSpec(id: 'lex_kurz', am: 'አጭር', tr: 'achir', pos: 'adjective', topic: 'colors_properties', level: 'A1.2', verified: true, t: const Tr('kurz', 'short', 'kort', 'kort')),
    ],
    sentences: [
      SentenceSpec(id: 'sen_bietu_konjo', am: 'ቤቱ ቆንጆ ነው።', tr: 'bietu konjo new.', level: 'A1.2', uses: ['lex_haus', 'lex_schoen'], chunks: ['bietu', 'konjo', 'new'], t: const Tr('Das Haus ist schön.', 'The house is beautiful.', 'Huset är vackert.', 'Het huis is mooi.')),
      SentenceSpec(id: 'sen_wuha_kezkaza', am: 'ውሃው ቀዝቃዛ ነው።', tr: 'wuhaw kezkaza new.', level: 'A1.2', uses: ['lex_wasser', 'lex_kalt'], chunks: ['wuhaw', 'kezkaza', 'new'], t: const Tr('Das Wasser ist kalt.', 'The water is cold.', 'Vattnet är kallt.', 'Het water is koud.'), verified: false),
    ],
  ));

  final bigNumbers = <List<String>>[
    ['30', 'ሰላሳ', 'selasa'],
    ['40', 'አርባ', 'arba'],
    ['50', 'ሃምሳ', 'hamsa'],
    ['60', 'ስድሳ', 'sidsa'],
    ['70', 'ሰባ', 'seba'],
    ['80', 'ሰማንያ', 'semania'],
    ['90', 'ዘጠና', 'zetena'],
    ['100', 'መቶ', 'meto'],
    ['1000', 'ሺ', 'shi'],
  ];
  writeUnit(UnitSpec(
    id: 'unit_zahlen_einkaufen',
    sectionId: 'sec_a1_2',
    level: 'A1.2',
    topic: 'numbers_shopping',
    title: const Tr('Zahlen 20-1000 & Einkaufen', 'Numbers 20-1000 & shopping', 'Siffror 20-1000 & att shoppa', 'Cijfers 20-1000 & winkelen'),
    lexemes: [
      for (final n in bigNumbers)
        LexemeSpec(id: 'lex_zahl_${n[0]}', am: n[1], tr: n[2], pos: 'number', topic: 'numbers_shopping', level: 'A1.2', verified: true, t: Tr(n[0], n[0], n[0], n[0])),
      LexemeSpec(id: 'lex_geld', am: 'ገንዘብ', tr: 'genzeb', pos: 'noun', topic: 'numbers_shopping', level: 'A1.2', emoji: '💰', verified: true, t: const Tr('das Geld', 'money', 'pengar', 'geld')),
      LexemeSpec(id: 'lex_preis', am: 'ዋጋ', tr: 'waga', pos: 'noun', topic: 'numbers_shopping', level: 'A1.2', verified: true, t: const Tr('der Preis', 'price', 'pris', 'prijs')),
      LexemeSpec(id: 'lex_teuer', am: 'ውድ', tr: 'wid', pos: 'adjective', topic: 'numbers_shopping', level: 'A1.2', verified: true, t: const Tr('teuer', 'expensive', 'dyr', 'duur')),
      LexemeSpec(id: 'lex_billig', am: 'ርካሽ', tr: 'rikash', pos: 'adjective', topic: 'numbers_shopping', level: 'A1.2', t: const Tr('billig', 'cheap', 'billig', 'goedkoop')),
      LexemeSpec(id: 'lex_kaufen', am: 'መግዛት', tr: 'megzat', pos: 'verb', topic: 'numbers_shopping', level: 'A1.2', t: const Tr('kaufen', 'to buy', 'köpa', 'kopen')),
      LexemeSpec(id: 'lex_verkaufen', am: 'መሸጥ', tr: "meshet'", pos: 'verb', topic: 'numbers_shopping', level: 'A1.2', t: const Tr('verkaufen', 'to sell', 'sälja', 'verkopen')),
      LexemeSpec(id: 'lex_markt', am: 'ገበያ', tr: 'gebeya', pos: 'noun', topic: 'numbers_shopping', level: 'A1.2', emoji: '🛒', verified: true, t: const Tr('der Markt', 'market', 'marknad', 'markt')),
      LexemeSpec(id: 'lex_laden', am: 'ሱቅ', tr: 'suk', pos: 'noun', topic: 'numbers_shopping', level: 'A1.2', emoji: '🏪', verified: true, t: const Tr('der Laden, das Geschäft', 'shop, store', 'affär', 'winkel')),
      LexemeSpec(id: 'lex_wieviel_kostet', am: 'ስንት ነው?', tr: 'sint new?', pos: 'phrase', topic: 'numbers_shopping', level: 'A1.2', t: const Tr('Wie viel kostet das?', 'How much is it?', 'Hur mycket kostar det?', 'Hoeveel kost het?')),
    ],
    sentences: [
      SentenceSpec(id: 'sen_wagau_wid', am: 'ዋጋው ውድ ነው።', tr: 'wagaw wid new.', level: 'A1.2', uses: ['lex_preis', 'lex_teuer'], chunks: ['wagaw', 'wid', 'new'], t: const Tr('Der Preis ist teuer.', 'The price is expensive.', 'Priset är dyrt.', 'De prijs is duur.'), verified: false),
    ],
  ));

  writeUnit(UnitSpec(
    id: 'unit_in_der_stadt',
    sectionId: 'sec_a1_2',
    level: 'A1.2',
    topic: 'city',
    title: const Tr('In der Stadt', 'In the city', 'I staden', 'In de stad'),
    lexemes: [
      LexemeSpec(id: 'lex_strasse', am: 'መንገድ', tr: 'mengad', pos: 'noun', topic: 'city', level: 'A1.2', emoji: '🛣️', verified: true, t: const Tr('die Straße, der Weg', 'street, road', 'gata, väg', 'straat, weg')),
      LexemeSpec(id: 'lex_krankenhaus', am: 'ሆስፒታል', tr: 'hospital', pos: 'noun', topic: 'city', level: 'A1.2', emoji: '🏥', verified: true, t: const Tr('das Krankenhaus', 'hospital', 'sjukhus', 'ziekenhuis')),
      LexemeSpec(id: 'lex_schule', am: 'ትምህርት ቤት', tr: 'timhirt biet', pos: 'noun', topic: 'city', level: 'A1.2', emoji: '🏫', verified: true, t: const Tr('die Schule', 'school', 'skola', 'school')),
      LexemeSpec(id: 'lex_bank', am: 'ባንክ', tr: 'bank', pos: 'noun', topic: 'city', level: 'A1.2', emoji: '🏦', verified: true, t: const Tr('die Bank', 'bank', 'bank', 'bank')),
      LexemeSpec(id: 'lex_kirche', am: 'ቤተ ክርስቲያን', tr: 'bete kristiyan', pos: 'noun', topic: 'city', level: 'A1.2', emoji: '⛪', verified: true, t: const Tr('die Kirche', 'church', 'kyrka', 'kerk')),
      LexemeSpec(id: 'lex_moschee', am: 'መስጊድ', tr: 'mesgid', pos: 'noun', topic: 'city', level: 'A1.2', emoji: '🕌', verified: true, t: const Tr('die Moschee', 'mosque', 'moské', 'moskee')),
      LexemeSpec(id: 'lex_stadt', am: 'ከተማ', tr: 'ketema', pos: 'noun', topic: 'city', level: 'A1.2', emoji: '🏙️', verified: true, t: const Tr('die Stadt', 'city', 'stad', 'stad')),
      LexemeSpec(id: 'lex_dorf', am: 'መንደር', tr: 'mender', pos: 'noun', topic: 'city', level: 'A1.2', emoji: '🏡', t: const Tr('das Dorf', 'village', 'by', 'dorp')),
      LexemeSpec(id: 'lex_hotel', am: 'ሆቴል', tr: 'hotel', pos: 'noun', topic: 'city', level: 'A1.2', emoji: '🏨', verified: true, t: const Tr('das Hotel', 'hotel', 'hotell', 'hotel')),
      LexemeSpec(id: 'lex_restaurant', am: 'ምግብ ቤት', tr: 'migib biet', pos: 'noun', topic: 'city', level: 'A1.2', emoji: '🍽️', t: const Tr('das Restaurant', 'restaurant', 'restaurang', 'restaurant')),
      LexemeSpec(id: 'lex_flughafen', am: 'አየር ማረፊያ', tr: 'ayer marefiya', pos: 'noun', topic: 'city', level: 'A1.2', emoji: '✈️', t: const Tr('der Flughafen', 'airport', 'flygplats', 'luchthaven')),
      LexemeSpec(id: 'lex_polizei', am: 'ፖሊስ', tr: 'polis', pos: 'noun', topic: 'city', level: 'A1.2', emoji: '👮', verified: true, t: const Tr('die Polizei', 'police', 'polis', 'politie')),
      LexemeSpec(id: 'lex_rechts', am: 'ቀኝ', tr: 'kegn', pos: 'adverb', topic: 'city', level: 'A1.2', verified: true, t: const Tr('rechts', 'right', 'höger', 'rechts')),
      LexemeSpec(id: 'lex_links', am: 'ግራ', tr: 'gira', pos: 'adverb', topic: 'city', level: 'A1.2', verified: true, t: const Tr('links', 'left', 'vänster', 'links')),
      LexemeSpec(id: 'lex_geradeaus', am: 'ቀጥታ', tr: "k'et'ita", pos: 'adverb', topic: 'city', level: 'A1.2', t: const Tr('geradeaus', 'straight ahead', 'rakt fram', 'rechtdoor')),
      LexemeSpec(id: 'lex_wo_ist', am: 'የት ነው?', tr: 'yet new?', pos: 'phrase', topic: 'city', level: 'A1.2', t: const Tr('Wo ist...?', 'Where is...?', 'Var är...?', 'Waar is...?')),
    ],
    sentences: [
      SentenceSpec(id: 'sen_suk_yet_new', am: 'ሱቁ የት ነው?', tr: 'suku yet new?', level: 'A1.2', uses: ['lex_laden', 'lex_wo_ist'], chunks: ['suku', 'yet', 'new?'], t: const Tr('Wo ist der Laden?', 'Where is the shop?', 'Var är affären?', 'Waar is de winkel?'), verified: false),
      SentenceSpec(id: 'sen_ketema_tilik', am: 'ከተማው ትልቅ ነው።', tr: 'ketemaw tilik new.', level: 'A1.2', uses: ['lex_stadt', 'lex_gross'], chunks: ['ketemaw', 'tilik', 'new'], t: const Tr('Die Stadt ist groß.', 'The city is big.', 'Staden är stor.', 'De stad is groot.')),
    ],
  ));
}

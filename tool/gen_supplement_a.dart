import 'content_lib.dart';

void main() {
  // Kleidung
  writeUnit(UnitSpec(
    id: 'unit_kleidung',
    sectionId: 'sec_a1_2',
    level: 'A1.2',
    topic: 'clothing',
    title: const Tr('Kleidung', 'Clothing', 'Kläder', 'Kleding'),
    lexemes: [
      LexemeSpec(id: 'lex_kleidung', am: 'ልብስ', tr: 'libs', pos: 'noun', topic: 'clothing', level: 'A1.2', emoji: '👕', verified: true, t: const Tr('die Kleidung', 'clothes', 'kläder', 'kleding')),
      LexemeSpec(id: 'lex_hemd', am: 'ሸሚዝ', tr: 'shemiz', pos: 'noun', topic: 'clothing', level: 'A1.2', emoji: '👔', verified: true, t: const Tr('das Hemd', 'shirt', 'skjorta', 'overhemd')),
      LexemeSpec(id: 'lex_hose', am: 'ሱሪ', tr: 'suri', pos: 'noun', topic: 'clothing', level: 'A1.2', emoji: '👖', verified: true, t: const Tr('die Hose', 'trousers, pants', 'byxor', 'broek')),
      LexemeSpec(id: 'lex_schuh', am: 'ጫማ', tr: 'chama', pos: 'noun', topic: 'clothing', level: 'A1.2', emoji: '👞', verified: true, t: const Tr('der Schuh', 'shoe', 'sko', 'schoen')),
      LexemeSpec(id: 'lex_hut', am: 'ካፕ', tr: 'kap', pos: 'noun', topic: 'clothing', level: 'A1.2', emoji: '🧢', t: const Tr('die Mütze, der Hut', 'hat, cap', 'mössa, keps', 'pet, hoed')),
      LexemeSpec(id: 'lex_kleid', am: 'ቀሚስ', tr: 'kemis', pos: 'noun', topic: 'clothing', level: 'A1.2', emoji: '👗', verified: true, t: const Tr('das Kleid', 'dress', 'klänning', 'jurk')),
      LexemeSpec(id: 'lex_jacke', am: 'ጃኬት', tr: 'jaket', pos: 'noun', topic: 'clothing', level: 'A1.2', emoji: '🧥', verified: true, t: const Tr('die Jacke', 'jacket', 'jacka', 'jas')),
      LexemeSpec(id: 'lex_socke', am: 'ካልሲ', tr: 'kalsi', pos: 'noun', topic: 'clothing', level: 'A1.2', emoji: '🧦', t: const Tr('die Socke', 'sock', 'strumpa', 'sok')),
      LexemeSpec(id: 'lex_guertel', am: 'ቀበቶ', tr: 'kebeto', pos: 'noun', topic: 'clothing', level: 'A1.2', t: const Tr('der Gürtel', 'belt', 'skärp', 'riem')),
      LexemeSpec(id: 'lex_brille', am: 'መነጽር', tr: "menets'ir", pos: 'noun', topic: 'clothing', level: 'A1.2', emoji: '👓', t: const Tr('die Brille', 'glasses', 'glasögon', 'bril')),
      LexemeSpec(id: 'lex_ring', am: 'ቀለበት', tr: 'kelebet', pos: 'noun', topic: 'clothing', level: 'A1.2', emoji: '💍', t: const Tr('der Ring', 'ring', 'ring', 'ring')),
    ],
    sentences: [
      SentenceSpec(id: 'sen_shemizu_keyy', am: 'ሸሚዙ ቀይ ነው።', tr: 'shemizu keyy new.', level: 'A1.2', uses: ['lex_hemd', 'lex_rot'], chunks: ['shemizu', 'keyy', 'new'], t: const Tr('Das Hemd ist rot.', 'The shirt is red.', 'Skjortan är röd.', 'Het overhemd is rood.')),
    ],
  ));

  // Berufe
  writeUnit(UnitSpec(
    id: 'unit_berufe',
    sectionId: 'sec_a2',
    level: 'A2',
    topic: 'professions',
    title: const Tr('Berufe', 'Professions', 'Yrken', 'Beroepen'),
    lexemes: [
      LexemeSpec(id: 'lex_bauer', am: 'ገበሬ', tr: 'geberie', pos: 'noun', topic: 'professions', level: 'A2', emoji: '🧑‍🌾', verified: true, t: const Tr('der Bauer, die Bäuerin', 'farmer', 'bonde', 'boer')),
      LexemeSpec(id: 'lex_koch', am: 'አብሳይ', tr: 'abesay', pos: 'noun', topic: 'professions', level: 'A2', emoji: '👨‍🍳', t: const Tr('der Koch, die Köchin', 'cook', 'kock', 'kok')),
      LexemeSpec(id: 'lex_fahrer', am: 'ሹፌር', tr: 'shoferr', pos: 'noun', topic: 'professions', level: 'A2', emoji: '🚗', verified: true, t: const Tr('der Fahrer', 'driver', 'förare', 'chauffeur')),
      LexemeSpec(id: 'lex_ingenieur', am: 'ኢንጂነር', tr: 'injinerr', pos: 'noun', topic: 'professions', level: 'A2', verified: true, t: const Tr('der Ingenieur', 'engineer', 'ingenjör', 'ingenieur')),
      LexemeSpec(id: 'lex_kuenstler', am: 'አርቲስት', tr: 'artist', pos: 'noun', topic: 'professions', level: 'A2', emoji: '🎨', verified: true, t: const Tr('der Künstler', 'artist', 'konstnär', 'kunstenaar')),
      LexemeSpec(id: 'lex_musiker', am: 'ሙዚቀኛ', tr: 'muzikegna', pos: 'noun', topic: 'professions', level: 'A2', emoji: '🎵', t: const Tr('der Musiker', 'musician', 'musiker', 'muzikant')),
      LexemeSpec(id: 'lex_schriftsteller', am: 'ደራሲ', tr: 'derasi', pos: 'noun', topic: 'professions', level: 'A2', t: const Tr('der Schriftsteller', 'writer', 'författare', 'schrijver')),
      LexemeSpec(id: 'lex_verkaeufer', am: 'ሻጭ', tr: 'shach', pos: 'noun', topic: 'professions', level: 'A2', t: const Tr('der Verkäufer', 'seller', 'säljare', 'verkoper')),
      LexemeSpec(id: 'lex_pilot', am: 'ፓይለት', tr: 'pilot', pos: 'noun', topic: 'professions', level: 'A2', emoji: '✈️', verified: true, t: const Tr('der Pilot', 'pilot', 'pilot', 'piloot')),
      LexemeSpec(id: 'lex_kellner', am: 'አሳላፊ', tr: 'asalafi', pos: 'noun', topic: 'professions', level: 'A2', t: const Tr('der Kellner', 'waiter', 'servitör', 'ober')),
      LexemeSpec(id: 'lex_anwalt', am: 'ጠበቃ', tr: "t'ebeka", pos: 'noun', topic: 'professions', level: 'A2', t: const Tr('der Anwalt', 'lawyer', 'advokat', 'advocaat')),
      LexemeSpec(id: 'lex_soldat', am: 'ወታደር', tr: 'wetader', pos: 'noun', topic: 'professions', level: 'A2', verified: true, t: const Tr('der Soldat', 'soldier', 'soldat', 'soldaat')),
      LexemeSpec(id: 'lex_praesident', am: 'ፕሬዝዳንት', tr: 'president', pos: 'noun', topic: 'professions', level: 'A2', verified: true, t: const Tr('der Präsident', 'president', 'president', 'president')),
    ],
    sentences: [
      SentenceSpec(id: 'sen_geberie_sira', am: 'ገበሬው ይሰራል።', tr: 'geberiew yiserall.', level: 'A2', uses: ['lex_bauer'], chunks: ['geberiew', 'yiserall'], t: const Tr('Der Bauer arbeitet.', 'The farmer works.', 'Bonden arbetar.', 'De boer werkt.'), verified: false),
    ],
  ));

  // Tiere (mehr)
  writeUnit(UnitSpec(
    id: 'unit_tiere_mehr',
    sectionId: 'sec_a2',
    level: 'A2',
    topic: 'animals_more',
    title: const Tr('Mehr Tiere', 'More animals', 'Fler djur', 'Meer dieren'),
    lexemes: [
      LexemeSpec(id: 'lex_pferd', am: 'ፈረስ', tr: 'feres', pos: 'noun', topic: 'animals_more', level: 'A2', emoji: '🐴', verified: true, t: const Tr('das Pferd', 'horse', 'häst', 'paard')),
      LexemeSpec(id: 'lex_kuh', am: 'ላም', tr: 'lam', pos: 'noun', topic: 'animals_more', level: 'A2', emoji: '🐄', verified: true, t: const Tr('die Kuh', 'cow', 'ko', 'koe')),
      LexemeSpec(id: 'lex_schaf', am: 'በግ', tr: 'beg', pos: 'noun', topic: 'animals_more', level: 'A2', emoji: '🐑', verified: true, t: const Tr('das Schaf', 'sheep', 'får', 'schaap')),
      LexemeSpec(id: 'lex_ziege', am: 'ፍየል', tr: 'fiyel', pos: 'noun', topic: 'animals_more', level: 'A2', emoji: '🐐', verified: true, t: const Tr('die Ziege', 'goat', 'get', 'geit')),
      LexemeSpec(id: 'lex_esel', am: 'አህያ', tr: 'ahiya', pos: 'noun', topic: 'animals_more', level: 'A2', emoji: '🫏', verified: true, t: const Tr('der Esel', 'donkey', 'åsna', 'ezel')),
      LexemeSpec(id: 'lex_kamel', am: 'ግመል', tr: 'gimel', pos: 'noun', topic: 'animals_more', level: 'A2', emoji: '🐫', verified: true, t: const Tr('das Kamel', 'camel', 'kamel', 'kameel')),
      LexemeSpec(id: 'lex_hase', am: 'ጥንቸል', tr: "t'inichel", pos: 'noun', topic: 'animals_more', level: 'A2', emoji: '🐇', t: const Tr('der Hase, das Kaninchen', 'rabbit', 'kanin', 'konijn')),
      LexemeSpec(id: 'lex_maus', am: 'አይጥ', tr: "ayt'", pos: 'noun', topic: 'animals_more', level: 'A2', emoji: '🐁', t: const Tr('die Maus', 'mouse', 'mus', 'muis')),
      LexemeSpec(id: 'lex_biene', am: 'ንብ', tr: 'nib', pos: 'noun', topic: 'animals_more', level: 'A2', emoji: '🐝', t: const Tr('die Biene', 'bee', 'bi', 'bij')),
      LexemeSpec(id: 'lex_schmetterling', am: 'ቢራቢሮ', tr: 'birabiro', pos: 'noun', topic: 'animals_more', level: 'A2', emoji: '🦋', t: const Tr('der Schmetterling', 'butterfly', 'fjäril', 'vlinder')),
      LexemeSpec(id: 'lex_frosch', am: 'እንቁራሪት', tr: 'inkuraritt', pos: 'noun', topic: 'animals_more', level: 'A2', emoji: '🐸', t: const Tr('der Frosch', 'frog', 'groda', 'kikker')),
    ],
    sentences: [
      SentenceSpec(id: 'sen_feres_yirotal', am: 'ፈረሱ ይሮጣል።', tr: 'feresu yirot\'all.', level: 'A2', uses: ['lex_pferd'], chunks: ['feresu', "yirot'all"], t: const Tr('Das Pferd rennt.', 'The horse runs.', 'Hästen springer.', 'Het paard rent.'), verified: false),
    ],
  ));

  // Fragewörter & Konjunktionen
  writeUnit(UnitSpec(
    id: 'unit_fragewoerter',
    sectionId: 'sec_a1_1',
    level: 'A1.1',
    topic: 'question_words',
    title: const Tr('Fragewörter & Konjunktionen', 'Question words & conjunctions', 'Frågeord & konjunktioner', 'Vraagwoorden & voegwoorden'),
    lexemes: [
      LexemeSpec(id: 'lex_was', am: 'ምን', tr: 'min', pos: 'pronoun', topic: 'question_words', level: 'A1.1', verified: true, t: const Tr('was', 'what', 'vad', 'wat')),
      LexemeSpec(id: 'lex_wer', am: 'ማን', tr: 'man', pos: 'pronoun', topic: 'question_words', level: 'A1.1', verified: true, t: const Tr('wer', 'who', 'vem', 'wie')),
      LexemeSpec(id: 'lex_wo_word', am: 'የት', tr: 'yet', pos: 'pronoun', topic: 'question_words', level: 'A1.1', verified: true, t: const Tr('wo', 'where', 'var', 'waar')),
      LexemeSpec(id: 'lex_wann', am: 'መቼ', tr: 'meche', pos: 'pronoun', topic: 'question_words', level: 'A1.1', verified: true, t: const Tr('wann', 'when', 'när', 'wanneer')),
      LexemeSpec(id: 'lex_warum', am: 'ለምን', tr: 'lemin', pos: 'pronoun', topic: 'question_words', level: 'A1.1', verified: true, t: const Tr('warum', 'why', 'varför', 'waarom')),
      LexemeSpec(id: 'lex_wie', am: 'እንዴት', tr: 'indiet', pos: 'pronoun', topic: 'question_words', level: 'A1.1', verified: true, t: const Tr('wie', 'how', 'hur', 'hoe')),
      LexemeSpec(id: 'lex_welche', am: 'የትኛው', tr: 'yetegnaw', pos: 'pronoun', topic: 'question_words', level: 'A1.1', t: const Tr('welche(r/s)', 'which', 'vilken', 'welke')),
      LexemeSpec(id: 'lex_und', am: 'እና', tr: 'ina', pos: 'conjunction', topic: 'question_words', level: 'A1.1', verified: true, t: const Tr('und', 'and', 'och', 'en')),
      LexemeSpec(id: 'lex_oder', am: 'ወይም', tr: 'weyim', pos: 'conjunction', topic: 'question_words', level: 'A1.1', verified: true, t: const Tr('oder', 'or', 'eller', 'of')),
      LexemeSpec(id: 'lex_aber', am: 'ግን', tr: 'gin', pos: 'conjunction', topic: 'question_words', level: 'A1.1', verified: true, t: const Tr('aber', 'but', 'men', 'maar')),
      LexemeSpec(id: 'lex_weil', am: 'ስለ', tr: 'sile', pos: 'conjunction', topic: 'question_words', level: 'A1.1', t: const Tr('weil, wegen', 'because, about', 'eftersom, om', 'omdat, over')),
      LexemeSpec(id: 'lex_dass', am: 'እንደ', tr: 'inde', pos: 'conjunction', topic: 'question_words', level: 'A1.1', t: const Tr('dass, wie, als', 'that, as, like', 'att, som', 'dat, zoals')),
    ],
    sentences: [
      SentenceSpec(id: 'sen_min_new', am: 'ይህ ምን ነው?', tr: 'yih min new?', level: 'A1.1', uses: ['lex_was'], chunks: ['yih', 'min', 'new?'], t: const Tr('Was ist das?', 'What is this?', 'Vad är detta?', 'Wat is dit?'), verified: false),
    ],
  ));

  // Präpositionen & Richtungen
  writeUnit(UnitSpec(
    id: 'unit_praepositionen',
    sectionId: 'sec_a1_2',
    level: 'A1.2',
    topic: 'prepositions',
    title: const Tr('Präpositionen & Richtungen', 'Prepositions & directions', 'Prepositioner & riktningar', 'Voorzetsels & richtingen'),
    lexemes: [
      LexemeSpec(id: 'lex_in_innerhalb', am: 'ውስጥ', tr: 'wist', pos: 'preposition', topic: 'prepositions', level: 'A1.2', verified: true, t: const Tr('in, innerhalb', 'in, inside', 'i, inuti', 'in, binnen')),
      LexemeSpec(id: 'lex_auf_ueber', am: 'ላይ', tr: 'lay', pos: 'preposition', topic: 'prepositions', level: 'A1.2', verified: true, t: const Tr('auf, über', 'on, above', 'på, ovanpå', 'op, boven')),
      LexemeSpec(id: 'lex_unter', am: 'ስር', tr: 'sir', pos: 'preposition', topic: 'prepositions', level: 'A1.2', t: const Tr('unter', 'under', 'under', 'onder')),
      LexemeSpec(id: 'lex_neben', am: 'አጠገብ', tr: "at'egeb", pos: 'preposition', topic: 'prepositions', level: 'A1.2', t: const Tr('neben', 'beside, next to', 'bredvid', 'naast')),
      LexemeSpec(id: 'lex_vor', am: 'ፊት', tr: 'fit', pos: 'preposition', topic: 'prepositions', level: 'A1.2', t: const Tr('vor', 'in front of, before', 'framför', 'voor')),
      LexemeSpec(id: 'lex_hinter', am: 'ኋላ', tr: 'hwala', pos: 'preposition', topic: 'prepositions', level: 'A1.2', t: const Tr('hinter', 'behind', 'bakom', 'achter')),
      LexemeSpec(id: 'lex_zwischen', am: 'መካከል', tr: 'mekakel', pos: 'preposition', topic: 'prepositions', level: 'A1.2', t: const Tr('zwischen', 'between', 'mellan', 'tussen')),
      LexemeSpec(id: 'lex_norden', am: 'ሰሜን', tr: 'semien', pos: 'noun', topic: 'prepositions', level: 'A1.2', verified: true, t: const Tr('Norden', 'north', 'norr', 'noorden')),
      LexemeSpec(id: 'lex_sueden', am: 'ደቡብ', tr: 'debub', pos: 'noun', topic: 'prepositions', level: 'A1.2', verified: true, t: const Tr('Süden', 'south', 'söder', 'zuiden')),
      LexemeSpec(id: 'lex_osten', am: 'ምስራቅ', tr: "misrak'", pos: 'noun', topic: 'prepositions', level: 'A1.2', verified: true, t: const Tr('Osten', 'east', 'öster', 'oosten')),
      LexemeSpec(id: 'lex_westen', am: 'ምዕራብ', tr: "mi'irab", pos: 'noun', topic: 'prepositions', level: 'A1.2', verified: true, t: const Tr('Westen', 'west', 'väster', 'westen')),
    ],
    sentences: [
      SentenceSpec(id: 'sen_kulfu_lay', am: 'ቁልፉ ጠረጴዛው ላይ ነው።', tr: "kulfu t'eret'ezaw lay new.", level: 'A1.2', uses: ['lex_schluessel', 'lex_tisch', 'lex_auf_ueber'], chunks: ['kulfu', "t'eret'ezaw", 'lay', 'new'], t: const Tr('Der Schlüssel ist auf dem Tisch.', 'The key is on the table.', 'Nyckeln ligger på bordet.', 'De sleutel ligt op de tafel.'), verified: false),
    ],
  ));

  // Haushaltsgegenstände
  writeUnit(UnitSpec(
    id: 'unit_haushalt',
    sectionId: 'sec_a1_2',
    level: 'A1.2',
    topic: 'household',
    title: const Tr('Haushaltsgegenstände', 'Household items', 'Hushållsartiklar', 'Huishoudelijke spullen'),
    lexemes: [
      LexemeSpec(id: 'lex_teller', am: 'ሳህን', tr: 'sahin', pos: 'noun', topic: 'household', level: 'A1.2', emoji: '🍽️', t: const Tr('der Teller', 'plate', 'tallrik', 'bord')),
      LexemeSpec(id: 'lex_tasse', am: 'ኩባያ', tr: 'kubaya', pos: 'noun', topic: 'household', level: 'A1.2', emoji: '☕', t: const Tr('die Tasse', 'cup', 'kopp', 'kopje')),
      LexemeSpec(id: 'lex_loeffel', am: 'ማንኪያ', tr: 'mankiya', pos: 'noun', topic: 'household', level: 'A1.2', emoji: '🥄', t: const Tr('der Löffel', 'spoon', 'sked', 'lepel')),
      LexemeSpec(id: 'lex_gabel', am: 'ፎርክ', tr: 'fork', pos: 'noun', topic: 'household', level: 'A1.2', emoji: '🍴', t: const Tr('die Gabel', 'fork', 'gaffel', 'vork')),
      LexemeSpec(id: 'lex_messer', am: 'ቢላዋ', tr: 'bilawa', pos: 'noun', topic: 'household', level: 'A1.2', emoji: '🔪', t: const Tr('das Messer', 'knife', 'kniv', 'mes')),
      LexemeSpec(id: 'lex_topf', am: 'ድስት', tr: 'dist', pos: 'noun', topic: 'household', level: 'A1.2', emoji: '🍲', t: const Tr('der Topf', 'pot', 'gryta', 'pan')),
      LexemeSpec(id: 'lex_seife', am: 'ሳሙና', tr: 'samuna', pos: 'noun', topic: 'household', level: 'A1.2', emoji: '🧼', verified: true, t: const Tr('die Seife', 'soap', 'tvål', 'zeep')),
      LexemeSpec(id: 'lex_handtuch', am: 'ፎጣ', tr: "fot'a", pos: 'noun', topic: 'household', level: 'A1.2', t: const Tr('das Handtuch', 'towel', 'handduk', 'handdoek')),
    ],
    sentences: [
      SentenceSpec(id: 'sen_sahinu_nech', am: 'ሳህኑ ነጭ ነው።', tr: 'sahinu nech new.', level: 'A1.2', uses: ['lex_teller', 'lex_weiss'], chunks: ['sahinu', 'nech', 'new'], t: const Tr('Der Teller ist weiß.', 'The plate is white.', 'Tallriken är vit.', 'Het bord is wit.')),
    ],
  ));

  // Sport & Freizeit
  writeUnit(UnitSpec(
    id: 'unit_sport_freizeit',
    sectionId: 'sec_a2',
    level: 'A2',
    topic: 'sports_leisure',
    title: const Tr('Sport & Freizeit', 'Sports & leisure', 'Sport & fritid', 'Sport & vrije tijd'),
    lexemes: [
      LexemeSpec(id: 'lex_fussball', am: 'እግር ኳስ', tr: 'igir kwas', pos: 'noun', topic: 'sports_leisure', level: 'A2', emoji: '⚽', verified: true, t: const Tr('der Fußball', 'soccer, football', 'fotboll', 'voetbal')),
      LexemeSpec(id: 'lex_v_schwimmen', am: 'መዋኘት', tr: 'mewagnet', pos: 'verb', topic: 'sports_leisure', level: 'A2', t: const Tr('schwimmen', 'to swim', 'simma', 'zwemmen')),
      LexemeSpec(id: 'lex_musik', am: 'ሙዚቃ', tr: 'muzika', pos: 'noun', topic: 'sports_leisure', level: 'A2', emoji: '🎵', verified: true, t: const Tr('die Musik', 'music', 'musik', 'muziek')),
      LexemeSpec(id: 'lex_film', am: 'ፊልም', tr: 'film', pos: 'noun', topic: 'sports_leisure', level: 'A2', emoji: '🎬', verified: true, t: const Tr('der Film', 'film, movie', 'film', 'film')),
      LexemeSpec(id: 'lex_fernsehen', am: 'ቴሌቪዝን', tr: 'televizin', pos: 'noun', topic: 'sports_leisure', level: 'A2', emoji: '📺', verified: true, t: const Tr('das Fernsehen', 'television', 'tv', 'televisie')),
      LexemeSpec(id: 'lex_radio', am: 'ራድዮ', tr: 'radiyo', pos: 'noun', topic: 'sports_leisure', level: 'A2', emoji: '📻', verified: true, t: const Tr('das Radio', 'radio', 'radio', 'radio')),
      LexemeSpec(id: 'lex_spiel', am: 'ጨዋታ', tr: 'chewata', pos: 'noun', topic: 'sports_leisure', level: 'A2', emoji: '🎮', t: const Tr('das Spiel', 'game', 'spel', 'spel')),
    ],
    sentences: [
      SentenceSpec(id: 'sen_igirkwas_chewata', am: 'እግር ኳስ ጨዋታ አለ።', tr: 'igir kwas chewata ale.', level: 'A2', uses: ['lex_fussball', 'lex_spiel'], chunks: ['igir', 'kwas', 'chewata', 'ale'], t: const Tr('Es gibt ein Fußballspiel.', "There's a football game.", 'Det finns en fotbollsmatch.', 'Er is een voetbalwedstrijd.'), verified: false),
    ],
  ));

  // Mehr Adjektive
  writeUnit(UnitSpec(
    id: 'unit_mehr_adjektive',
    sectionId: 'sec_a2',
    level: 'A2',
    topic: 'more_adjectives',
    title: const Tr('Mehr Adjektive', 'More adjectives', 'Fler adjektiv', 'Meer bijvoeglijke naamwoorden'),
    lexemes: [
      LexemeSpec(id: 'lex_schnell', am: 'ፈጣን', tr: 'fetan', pos: 'adjective', topic: 'more_adjectives', level: 'A2', t: const Tr('schnell', 'fast', 'snabb', 'snel')),
      LexemeSpec(id: 'lex_langsam', am: 'ዝግተኛ', tr: 'zigitegna', pos: 'adjective', topic: 'more_adjectives', level: 'A2', t: const Tr('langsam', 'slow', 'långsam', 'langzaam')),
      LexemeSpec(id: 'lex_sauber', am: 'ንጹህ', tr: 'nitsuh', pos: 'adjective', topic: 'more_adjectives', level: 'A2', t: const Tr('sauber', 'clean', 'ren', 'schoon')),
      LexemeSpec(id: 'lex_schmutzig', am: 'ቆሻሻ', tr: "k'oshasha", pos: 'adjective', topic: 'more_adjectives', level: 'A2', t: const Tr('schmutzig', 'dirty', 'smutsig', 'vuil')),
      LexemeSpec(id: 'lex_voll', am: 'ሙሉ', tr: 'mulu', pos: 'adjective', topic: 'more_adjectives', level: 'A2', verified: true, t: const Tr('voll', 'full', 'full', 'vol')),
      LexemeSpec(id: 'lex_leer', am: 'ባዶ', tr: 'bado', pos: 'adjective', topic: 'more_adjectives', level: 'A2', t: const Tr('leer', 'empty', 'tom', 'leeg')),
      LexemeSpec(id: 'lex_reich', am: 'ሀብታም', tr: 'habtam', pos: 'adjective', topic: 'more_adjectives', level: 'A2', t: const Tr('reich', 'rich', 'rik', 'rijk')),
      LexemeSpec(id: 'lex_arm', am: 'ድሃ', tr: 'dha', pos: 'adjective', topic: 'more_adjectives', level: 'A2', verified: true, t: const Tr('arm', 'poor', 'fattig', 'arm')),
      LexemeSpec(id: 'lex_stark', am: 'ጠንካራ', tr: "t'enkara", pos: 'adjective', topic: 'more_adjectives', level: 'A2', t: const Tr('stark', 'strong', 'stark', 'sterk')),
      LexemeSpec(id: 'lex_schwach', am: 'ደካማ', tr: 'dekama', pos: 'adjective', topic: 'more_adjectives', level: 'A2', t: const Tr('schwach', 'weak', 'svag', 'zwak')),
      LexemeSpec(id: 'lex_jung', am: 'ወጣት', tr: "wet'at", pos: 'adjective', topic: 'more_adjectives', level: 'A2', verified: true, t: const Tr('jung, der/die Jugendliche', 'young, youth', 'ung, ungdom', 'jong, jongere')),
    ],
    sentences: [
      SentenceSpec(id: 'sen_wushaw_fetan', am: 'ውሻው ፈጣን ነው።', tr: 'wushaw fetan new.', level: 'A2', uses: ['lex_hund', 'lex_schnell'], chunks: ['wushaw', 'fetan', 'new'], t: const Tr('Der Hund ist schnell.', 'The dog is fast.', 'Hunden är snabb.', 'De hond is snel.'), verified: false),
    ],
  ));
}

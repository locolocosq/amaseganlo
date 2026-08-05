import 'content_lib.dart';

void main() {
  // Unit 3: Familie & Menschen
  writeUnit(UnitSpec(
    id: 'unit_familie_menschen',
    sectionId: 'sec_a1_1',
    level: 'A1.1',
    topic: 'family',
    title: const Tr('Familie & Menschen', 'Family & people', 'Familj & människor', 'Familie & mensen'),
    lexemes: [
      LexemeSpec(id: 'lex_person', am: 'ሰው', tr: 'sew', pos: 'noun', topic: 'family', level: 'A1.1', emoji: '🧍', verified: true, t: const Tr('die Person, der Mensch', 'person, human', 'person, människa', 'persoon, mens')),
      LexemeSpec(id: 'lex_familie', am: 'ቤተሰብ', tr: 'beteseb', pos: 'noun', topic: 'family', level: 'A1.1', emoji: '👨‍👩‍👧', verified: true, t: const Tr('die Familie', 'family', 'familj', 'familie')),
      LexemeSpec(id: 'lex_mutter', am: 'እናት', tr: 'innat', pos: 'noun', topic: 'family', level: 'A1.1', emoji: '👩', verified: true, t: const Tr('die Mutter', 'mother', 'mamma', 'moeder')),
      LexemeSpec(id: 'lex_vater', am: 'አባት', tr: 'abbat', pos: 'noun', topic: 'family', level: 'A1.1', emoji: '👨', verified: true, t: const Tr('der Vater', 'father', 'pappa', 'vader')),
      LexemeSpec(id: 'lex_kind', am: 'ልጅ', tr: 'lij', pos: 'noun', topic: 'family', level: 'A1.1', emoji: '🧒', verified: true, t: const Tr('das Kind', 'child', 'barn', 'kind')),
      LexemeSpec(id: 'lex_bruder', am: 'ወንድም', tr: 'wendim', pos: 'noun', topic: 'family', level: 'A1.1', emoji: '👦', verified: true, t: const Tr('der Bruder', 'brother', 'bror', 'broer')),
      LexemeSpec(id: 'lex_schwester', am: 'እህት', tr: 'ihit', pos: 'noun', topic: 'family', level: 'A1.1', emoji: '👧', verified: true, t: const Tr('die Schwester', 'sister', 'syster', 'zus')),
      LexemeSpec(id: 'lex_freund', am: 'ጓደኛ', tr: 'guadegna', pos: 'noun', topic: 'family', level: 'A1.1', emoji: '🧑‍🤝‍🧑', verified: true, t: const Tr('der Freund, die Freundin', 'friend', 'vän', 'vriend')),
      LexemeSpec(id: 'lex_mann', am: 'ወንድ', tr: 'wend', pos: 'noun', topic: 'family', level: 'A1.1', emoji: '👨', t: const Tr('der Mann, männlich', 'man, male', 'man, manlig', 'man, mannelijk')),
      LexemeSpec(id: 'lex_frau', am: 'ሴት', tr: 'set', pos: 'noun', topic: 'family', level: 'A1.1', emoji: '👩', t: const Tr('die Frau, weiblich', 'woman, female', 'kvinna, kvinnlig', 'vrouw, vrouwelijk')),
      LexemeSpec(id: 'lex_baby', am: 'ሕፃን', tr: 'hitsan', pos: 'noun', topic: 'family', level: 'A1.1', emoji: '👶', t: const Tr('das Baby', 'baby', 'bebis', 'baby')),
      LexemeSpec(id: 'lex_grosseltern', am: 'አያት', tr: 'ayat', pos: 'noun', topic: 'family', level: 'A1.1', emoji: '👴', t: const Tr('die Großmutter/der Großvater', 'grandmother/grandfather', 'mormor/morfar', 'grootmoeder/grootvader')),
      LexemeSpec(id: 'lex_onkel', am: 'አጎት', tr: 'agot', pos: 'noun', topic: 'family', level: 'A1.1', emoji: '👨', t: const Tr('der Onkel', 'uncle', 'farbror', 'oom')),
      LexemeSpec(id: 'lex_tante', am: 'አክስት', tr: 'akist', pos: 'noun', topic: 'family', level: 'A1.1', emoji: '👩', t: const Tr('die Tante', 'aunt', 'faster', 'tante')),
      LexemeSpec(id: 'lex_leute', am: 'ሰዎች', tr: 'sewoch', pos: 'noun', topic: 'family', level: 'A1.1', emoji: '👥', t: const Tr('die Leute, die Menschen', 'people', 'människor', 'mensen')),
      LexemeSpec(id: 'lex_ehemann', am: 'ባል', tr: 'bal', pos: 'noun', topic: 'family', level: 'A1.1', emoji: '🤵', t: const Tr('der Ehemann', 'husband', 'make', 'echtgenoot')),
      LexemeSpec(id: 'lex_ehefrau', am: 'ሚስት', tr: 'mist', pos: 'noun', topic: 'family', level: 'A1.1', emoji: '👰', t: const Tr('die Ehefrau', 'wife', 'maka', 'echtgenote')),
    ],
    sentences: [
      SentenceSpec(id: 'sen_ine_sew_negn', am: 'እኔ ሰው ነኝ።', tr: 'ine sew negn.', level: 'A1.1', uses: ['lex_ine', 'lex_person'], chunks: ['ine', 'sew', 'negn'], t: const Tr('Ich bin ein Mensch.', 'I am a person.', 'Jag är en människa.', 'Ik ben een mens.')),
      SentenceSpec(id: 'sen_beteseb_tilik', am: 'ቤተሰቤ ትልቅ ነው።', tr: 'betesebe tilik new.', level: 'A1.1', uses: ['lex_familie'], chunks: ['betesebe', 'tilik', 'new'], t: const Tr('Meine Familie ist groß.', 'My family is big.', 'Min familj är stor.', 'Mijn familie is groot.')),
    ],
  ));

  // Unit 4: Zahlen 1-20
  final numberWords = <List<String>>[
    ['1', 'አንድ', 'and'],
    ['2', 'ሁለት', 'hulet'],
    ['3', 'ሶስት', 'sost'],
    ['4', 'አራት', 'arat'],
    ['5', 'አምስት', 'amist'],
    ['6', 'ስድስት', 'sidist'],
    ['7', 'ሰባት', 'sebat'],
    ['8', 'ስምንት', 'siminit'],
    ['9', 'ዘጠኝ', "zet'egn"],
    ['10', 'አስር', 'asir'],
    ['11', 'አስራ አንድ', 'asra and'],
    ['12', 'አስራ ሁለት', 'asra hulet'],
    ['13', 'አስራ ሶስት', 'asra sost'],
    ['14', 'አስራ አራት', 'asra arat'],
    ['15', 'አስራ አምስት', 'asra amist'],
    ['16', 'አስራ ስድስት', 'asra sidist'],
    ['17', 'አስራ ሰባት', 'asra sebat'],
    ['18', 'አስራ ስምንት', 'asra siminit'],
    ['19', 'አስራ ዘጠኝ', "asra zet'egn"],
    ['20', 'ሃያ', 'haya'],
  ];
  writeUnit(UnitSpec(
    id: 'unit_zahlen_1_20',
    sectionId: 'sec_a1_1',
    level: 'A1.1',
    topic: 'numbers',
    title: const Tr('Zahlen 1-20', 'Numbers 1-20', 'Siffror 1-20', 'Cijfers 1-20'),
    lexemes: [
      for (final n in numberWords)
        LexemeSpec(
          id: 'lex_zahl_${n[0]}',
          am: n[1],
          tr: n[2],
          pos: 'number',
          topic: 'numbers',
          level: 'A1.1',
          verified: true,
          t: Tr(n[0], n[0], n[0], n[0]),
        ),
    ],
    sentences: [
      SentenceSpec(id: 'sen_amist_lijoch', am: 'አምስት ልጆች አሉ።', tr: 'amist lijoch alu.', level: 'A1.1', uses: ['lex_zahl_5', 'lex_kind'], chunks: ['amist', 'lijoch', 'alu'], t: const Tr('Es gibt fünf Kinder.', 'There are five children.', 'Det finns fem barn.', 'Er zijn vijf kinderen.')),
    ],
  ));

  // Unit 5: Essen & Trinken
  writeUnit(UnitSpec(
    id: 'unit_essen_trinken',
    sectionId: 'sec_a1_1',
    level: 'A1.1',
    topic: 'food_drink',
    title: const Tr('Essen & Trinken', 'Food & drink', 'Mat & dryck', 'Eten & drinken'),
    lexemes: [
      LexemeSpec(id: 'lex_wasser', am: 'ውሃ', tr: 'wuha', pos: 'noun', topic: 'food_drink', level: 'A1.1', emoji: '💧', verified: true, t: const Tr('das Wasser', 'water', 'vatten', 'water')),
      LexemeSpec(id: 'lex_brot', am: 'ዳቦ', tr: 'dabo', pos: 'noun', topic: 'food_drink', level: 'A1.1', emoji: '🍞', verified: true, t: const Tr('das Brot', 'bread', 'bröd', 'brood')),
      LexemeSpec(id: 'lex_kaffee', am: 'ቡና', tr: 'buna', pos: 'noun', topic: 'food_drink', level: 'A1.1', emoji: '☕', verified: true, t: const Tr('der Kaffee', 'coffee', 'kaffe', 'koffie')),
      LexemeSpec(id: 'lex_milch', am: 'ወተት', tr: 'wetet', pos: 'noun', topic: 'food_drink', level: 'A1.1', emoji: '🥛', verified: true, t: const Tr('die Milch', 'milk', 'mjölk', 'melk')),
      LexemeSpec(id: 'lex_fleisch', am: 'ስጋ', tr: 'siga', pos: 'noun', topic: 'food_drink', level: 'A1.1', emoji: '🥩', verified: true, t: const Tr('das Fleisch', 'meat', 'kött', 'vlees')),
      LexemeSpec(id: 'lex_gemuese', am: 'አትክልት', tr: 'atkilt', pos: 'noun', topic: 'food_drink', level: 'A1.1', emoji: '🥬', t: const Tr('das Gemüse', 'vegetable', 'grönsak', 'groente')),
      LexemeSpec(id: 'lex_injera', am: 'እንጀራ', tr: 'injera', pos: 'noun', topic: 'food_drink', level: 'A1.1', emoji: '🫓', verified: true, t: const Tr('die Injera', 'injera (Ethiopian flatbread)', 'injera', 'injera')),
      LexemeSpec(id: 'lex_ei', am: 'እንቁላል', tr: 'inkulal', pos: 'noun', topic: 'food_drink', level: 'A1.1', emoji: '🥚', verified: true, t: const Tr('das Ei', 'egg', 'ägg', 'ei')),
      LexemeSpec(id: 'lex_zucker', am: 'ስኳር', tr: 'sikuar', pos: 'noun', topic: 'food_drink', level: 'A1.1', emoji: '🍬', t: const Tr('der Zucker', 'sugar', 'socker', 'suiker')),
      LexemeSpec(id: 'lex_salz', am: 'ጨው', tr: 'chew', pos: 'noun', topic: 'food_drink', level: 'A1.1', emoji: '🧂', verified: true, t: const Tr('das Salz', 'salt', 'salt', 'zout')),
      LexemeSpec(id: 'lex_frucht', am: 'ፍራፍሬ', tr: 'firafire', pos: 'noun', topic: 'food_drink', level: 'A1.1', emoji: '🍎', t: const Tr('das Obst, die Früchte', 'fruit', 'frukt', 'fruit')),
      LexemeSpec(id: 'lex_tee', am: 'ሻይ', tr: 'shai', pos: 'noun', topic: 'food_drink', level: 'A1.1', emoji: '🍵', verified: true, t: const Tr('der Tee', 'tea', 'te', 'thee')),
      LexemeSpec(id: 'lex_huhn', am: 'ዶሮ', tr: 'doro', pos: 'noun', topic: 'food_drink', level: 'A1.1', emoji: '🐔', verified: true, t: const Tr('das Huhn', 'chicken', 'kyckling', 'kip')),
      LexemeSpec(id: 'lex_reis', am: 'ሩዝ', tr: 'ruz', pos: 'noun', topic: 'food_drink', level: 'A1.1', emoji: '🍚', t: const Tr('der Reis', 'rice', 'ris', 'rijst')),
      LexemeSpec(id: 'lex_banane', am: 'ሙዝ', tr: 'muz', pos: 'noun', topic: 'food_drink', level: 'A1.1', emoji: '🍌', verified: true, t: const Tr('die Banane', 'banana', 'banan', 'banaan')),
      LexemeSpec(id: 'lex_apfel', am: 'ፖም', tr: 'pom', pos: 'noun', topic: 'food_drink', level: 'A1.1', emoji: '🍎', t: const Tr('der Apfel', 'apple', 'äpple', 'appel')),
      LexemeSpec(id: 'lex_orange', am: 'ብርቱካን', tr: 'birtukan', pos: 'noun', topic: 'food_drink', level: 'A1.1', emoji: '🍊', t: const Tr('die Orange', 'orange', 'apelsin', 'sinaasappel')),
      LexemeSpec(id: 'lex_berbere', am: 'በርበሬ', tr: 'berbere', pos: 'noun', topic: 'food_drink', level: 'A1.1', emoji: '🌶️', verified: true, t: const Tr('das Berbere-Gewürz', 'berbere spice', 'berberekrydda', 'berberekruid')),
      LexemeSpec(id: 'lex_teff', am: 'ጤፍ', tr: "t'ef", pos: 'noun', topic: 'food_drink', level: 'A1.1', emoji: '🌾', verified: true, t: const Tr('der Teff', 'teff grain', 'teff', 'teff')),
      LexemeSpec(id: 'lex_honig', am: 'ማር', tr: 'mar', pos: 'noun', topic: 'food_drink', level: 'A1.1', emoji: '🍯', t: const Tr('der Honig', 'honey', 'honung', 'honing')),
      LexemeSpec(id: 'lex_essen_verb', am: 'መብላት', tr: 'mebilat', pos: 'verb', topic: 'food_drink', level: 'A1.1', t: const Tr('essen', 'to eat', 'äta', 'eten')),
      LexemeSpec(id: 'lex_trinken_verb', am: 'መጠጣት', tr: "met'et'at", pos: 'verb', topic: 'food_drink', level: 'A1.1', t: const Tr('trinken', 'to drink', 'dricka', 'drinken')),
      LexemeSpec(id: 'lex_hungrig', am: 'ርቦኛል', tr: 'ribogniall', pos: 'phrase', topic: 'food_drink', level: 'A1.1', t: const Tr('Ich bin hungrig', 'I am hungry', 'Jag är hungrig', 'Ik heb honger')),
      LexemeSpec(id: 'lex_durstig', am: 'ጠምቶኛል', tr: "t'emtogniall", pos: 'phrase', topic: 'food_drink', level: 'A1.1', t: const Tr('Ich bin durstig', 'I am thirsty', 'Jag är törstig', 'Ik heb dorst')),
    ],
    sentences: [
      SentenceSpec(id: 'sen_wuha_itetalehu', am: 'ውሃ እጠጣለሁ።', tr: "wuha it'et'alehu.", level: 'A1.1', uses: ['lex_wasser', 'lex_trinken_verb'], chunks: ['wuha', "it'et'alehu"], t: const Tr('Ich trinke Wasser.', 'I drink water.', 'Jag dricker vatten.', 'Ik drink water.')),
      SentenceSpec(id: 'sen_dabo_ibelalehu', am: 'ዳቦ እበላለሁ።', tr: 'dabo ibelalehu.', level: 'A1.1', uses: ['lex_brot', 'lex_essen_verb'], chunks: ['dabo', 'ibelalehu'], t: const Tr('Ich esse Brot.', 'I eat bread.', 'Jag äter bröd.', 'Ik eet brood.')),
    ],
  ));
}

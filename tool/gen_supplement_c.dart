import 'content_lib.dart';

const _units = [
  ['1', 'and'],
  ['2', 'hulet'],
  ['3', 'sost'],
  ['4', 'arat'],
  ['5', 'amist'],
  ['6', 'sidist'],
  ['7', 'sebat'],
  ['8', 'siminit'],
  ["9", "zet'egn"],
];
const _unitsAm = ['አንድ', 'ሁለት', 'ሶስት', 'አራት', 'አምስት', 'ስድስት', 'ሰባት', 'ስምንት', 'ዘጠኝ'];
const _tens = [
  ['20', 'ሃያ', 'haya'],
  ['30', 'ሰላሳ', 'selasa'],
  ['40', 'አርባ', 'arba'],
  ['50', 'ሃምሳ', 'hamsa'],
  ['60', 'ስድሳ', 'sidsa'],
  ['70', 'ሰባ', 'seba'],
  ['80', 'ሰማንያ', 'semania'],
  ['90', 'ዘጠና', 'zetena'],
];

void main() {
  // Zahlen 21-99 (systematisch: Zehner + Einer, ähnlich wie 11-19)
  final numberLexemes = <LexemeSpec>[];
  for (final ten in _tens) {
    final tenValue = int.parse(ten[0]);
    for (var i = 0; i < _units.length; i++) {
      final value = tenValue + int.parse(_units[i][0]);
      numberLexemes.add(LexemeSpec(
        id: 'lex_zahl_$value',
        am: '${ten[1]} ${_unitsAm[i]}',
        tr: '${ten[2]} ${_units[i][1]}',
        pos: 'number',
        topic: 'numbers_21_99',
        level: 'A1.2',
        verified: true,
        t: Tr('$value', '$value', '$value', '$value'),
      ));
    }
  }
  writeUnit(UnitSpec(
    id: 'unit_zahlen_21_99',
    sectionId: 'sec_a1_2',
    level: 'A1.2',
    topic: 'numbers_21_99',
    title: const Tr('Zahlen 21-99', 'Numbers 21-99', 'Siffror 21-99', 'Cijfers 21-99'),
    lexemes: numberLexemes,
    sentences: [],
  ));

  writeUnit(UnitSpec(
    id: 'unit_zahlen_mehr2',
    sectionId: 'sec_a1_2',
    level: 'A1.2',
    topic: 'numbers_more2',
    title: const Tr('Mehr Ordnungs- und Hunderterzahlen', 'More ordinals and hundreds', 'Fler ordningstal och hundratal', 'Meer rangtelwoorden en honderdtallen'),
    lexemes: [
      LexemeSpec(id: 'lex_sechste', am: 'ስድስተኛ', tr: 'sidistegna', pos: 'adjective', topic: 'numbers_more2', level: 'A1.2', t: const Tr('sechste(r/s)', 'sixth', 'sjätte', 'zesde')),
      LexemeSpec(id: 'lex_siebte', am: 'ሰባተኛ', tr: 'sebategna', pos: 'adjective', topic: 'numbers_more2', level: 'A1.2', t: const Tr('siebte(r/s)', 'seventh', 'sjunde', 'zevende')),
      LexemeSpec(id: 'lex_achte', am: 'ስምንተኛ', tr: 'siminitegna', pos: 'adjective', topic: 'numbers_more2', level: 'A1.2', t: const Tr('achte(r/s)', 'eighth', 'åttonde', 'achtste')),
      LexemeSpec(id: 'lex_neunte', am: 'ዘጠነኛ', tr: 'zetenegna', pos: 'adjective', topic: 'numbers_more2', level: 'A1.2', t: const Tr('neunte(r/s)', 'ninth', 'nionde', 'negende')),
      LexemeSpec(id: 'lex_zehnte', am: 'አስረኛ', tr: 'asregna', pos: 'adjective', topic: 'numbers_more2', level: 'A1.2', t: const Tr('zehnte(r/s)', 'tenth', 'tionde', 'tiende')),
      LexemeSpec(id: 'lex_zahl_400', am: 'አራት መቶ', tr: 'arat meto', pos: 'number', topic: 'numbers_more2', level: 'A1.2', verified: true, t: const Tr('400', '400', '400', '400')),
      LexemeSpec(id: 'lex_zahl_600', am: 'ስድስት መቶ', tr: 'sidist meto', pos: 'number', topic: 'numbers_more2', level: 'A1.2', verified: true, t: const Tr('600', '600', '600', '600')),
      LexemeSpec(id: 'lex_zahl_700', am: 'ሰባት መቶ', tr: 'sebat meto', pos: 'number', topic: 'numbers_more2', level: 'A1.2', verified: true, t: const Tr('700', '700', '700', '700')),
      LexemeSpec(id: 'lex_zahl_800', am: 'ስምንት መቶ', tr: 'siminit meto', pos: 'number', topic: 'numbers_more2', level: 'A1.2', verified: true, t: const Tr('800', '800', '800', '800')),
      LexemeSpec(id: 'lex_zahl_900', am: 'ዘጠኝ መቶ', tr: "zet'egn meto", pos: 'number', topic: 'numbers_more2', level: 'A1.2', verified: true, t: const Tr('900', '900', '900', '900')),
    ],
    sentences: [],
  ));

  writeUnit(UnitSpec(
    id: 'unit_verben_erweitert',
    sectionId: 'sec_a2',
    level: 'A2',
    topic: 'verbs_extended',
    title: const Tr('Noch mehr Verben', 'Even more verbs', 'Ännu fler verb', 'Nog meer werkwoorden'),
    lexemes: [
      LexemeSpec(id: 'lex_v_beginnen', am: 'መጀመር', tr: 'mejemer', pos: 'verb', topic: 'verbs_extended', level: 'A2', verified: true, t: const Tr('beginnen', 'to begin', 'börja', 'beginnen')),
      LexemeSpec(id: 'lex_v_aufhoeren', am: 'ማቆም', tr: "mak'om", pos: 'verb', topic: 'verbs_extended', level: 'A2', t: const Tr('aufhören, anhalten', 'to stop', 'sluta, stanna', 'stoppen')),
      LexemeSpec(id: 'lex_v_gewinnen', am: 'ማሸነፍ', tr: 'mashenef', pos: 'verb', topic: 'verbs_extended', level: 'A2', t: const Tr('gewinnen', 'to win', 'vinna', 'winnen')),
      LexemeSpec(id: 'lex_v_verlieren', am: 'ማጣት', tr: "mat'at", pos: 'verb', topic: 'verbs_extended', level: 'A2', t: const Tr('verlieren', 'to lose', 'förlora', 'verliezen')),
      LexemeSpec(id: 'lex_v_bezahlen', am: 'መክፈል', tr: 'mekfel', pos: 'verb', topic: 'verbs_extended', level: 'A2', t: const Tr('bezahlen', 'to pay', 'betala', 'betalen')),
      LexemeSpec(id: 'lex_v_sparen', am: 'ማጠራቀም', tr: "mat'erakem", pos: 'verb', topic: 'verbs_extended', level: 'A2', t: const Tr('sparen', 'to save (money)', 'spara', 'sparen')),
      LexemeSpec(id: 'lex_v_teilen', am: 'ማካፈል', tr: 'makafel', pos: 'verb', topic: 'verbs_extended', level: 'A2', t: const Tr('teilen', 'to share', 'dela', 'delen')),
      LexemeSpec(id: 'lex_v_sammeln', am: 'መሰብሰብ', tr: 'mesebsebe', pos: 'verb', topic: 'verbs_extended', level: 'A2', t: const Tr('sammeln', 'to collect', 'samla', 'verzamelen')),
      LexemeSpec(id: 'lex_v_waehlen', am: 'መምረጥ', tr: "memret'", pos: 'verb', topic: 'verbs_extended', level: 'A2', t: const Tr('wählen', 'to choose', 'välja', 'kiezen')),
      LexemeSpec(id: 'lex_v_vergessen', am: 'መርሳት', tr: 'mersat', pos: 'verb', topic: 'verbs_extended', level: 'A2', t: const Tr('vergessen', 'to forget', 'glömma', 'vergeten')),
      LexemeSpec(id: 'lex_v_erinnern', am: 'ማስታወስ', tr: 'mastawes', pos: 'verb', topic: 'verbs_extended', level: 'A2', t: const Tr('sich erinnern', 'to remember', 'komma ihåg', 'onthouden')),
      LexemeSpec(id: 'lex_v_erklaeren', am: 'ማብራራት', tr: 'mabrarat', pos: 'verb', topic: 'verbs_extended', level: 'A2', t: const Tr('erklären', 'to explain', 'förklara', 'uitleggen')),
      LexemeSpec(id: 'lex_v_uebersetzen', am: 'መተርጎም', tr: 'metergom', pos: 'verb', topic: 'verbs_extended', level: 'A2', t: const Tr('übersetzen', 'to translate', 'översätta', 'vertalen')),
      LexemeSpec(id: 'lex_v_wiederholen', am: 'መድገም', tr: 'medgem', pos: 'verb', topic: 'verbs_extended', level: 'A2', t: const Tr('wiederholen', 'to repeat', 'upprepa', 'herhalen')),
      LexemeSpec(id: 'lex_v_ueben', am: 'መለማመድ', tr: 'melemamed', pos: 'verb', topic: 'verbs_extended', level: 'A2', t: const Tr('üben', 'to practice', 'öva', 'oefenen')),
      LexemeSpec(id: 'lex_v_unterrichten', am: 'ማስተማር', tr: 'mastemar', pos: 'verb', topic: 'verbs_extended', level: 'A2', t: const Tr('unterrichten', 'to teach', 'undervisa', 'onderwijzen')),
      LexemeSpec(id: 'lex_v_putzen', am: 'ማጽዳት', tr: "mats'idat", pos: 'verb', topic: 'verbs_extended', level: 'A2', t: const Tr('putzen, reinigen', 'to clean', 'göra rent', 'schoonmaken')),
      LexemeSpec(id: 'lex_v_zeigen', am: 'ማሳየት', tr: 'masayet', pos: 'verb', topic: 'verbs_extended', level: 'A2', t: const Tr('zeigen', 'to show', 'visa', 'laten zien')),
      LexemeSpec(id: 'lex_v_treffen', am: 'መገናኘት', tr: 'megenagnet', pos: 'verb', topic: 'verbs_extended', level: 'A2', t: const Tr('treffen', 'to meet', 'träffa', 'ontmoeten')),
      LexemeSpec(id: 'lex_v_besuchen', am: 'መጎብኘት', tr: 'megobignet', pos: 'verb', topic: 'verbs_extended', level: 'A2', t: const Tr('besuchen', 'to visit', 'besöka', 'bezoeken')),
      LexemeSpec(id: 'lex_v_einladen', am: 'መጋበዝ', tr: 'megabez', pos: 'verb', topic: 'verbs_extended', level: 'A2', t: const Tr('einladen', 'to invite', 'bjuda in', 'uitnodigen')),
      LexemeSpec(id: 'lex_v_danken', am: 'ማመስገን', tr: 'mamesgen', pos: 'verb', topic: 'verbs_extended', level: 'A2', verified: true, t: const Tr('danken', 'to thank', 'tacka', 'bedanken')),
      LexemeSpec(id: 'lex_v_laecheln', am: 'ፈገግ ማለት', tr: 'fegeg malet', pos: 'verb', topic: 'verbs_extended', level: 'A2', t: const Tr('lächeln', 'to smile', 'le', 'glimlachen')),
      LexemeSpec(id: 'lex_v_schreien', am: 'መጮህ', tr: 'mechoh', pos: 'verb', topic: 'verbs_extended', level: 'A2', t: const Tr('schreien', 'to scream', 'skrika', 'schreeuwen')),
      LexemeSpec(id: 'lex_v_beruehren', am: 'መነካካት', tr: 'menekakat', pos: 'verb', topic: 'verbs_extended', level: 'A2', t: const Tr('berühren', 'to touch', 'röra', 'aanraken')),
      LexemeSpec(id: 'lex_v_riechen', am: 'ማሽተት', tr: 'mashtet', pos: 'verb', topic: 'verbs_extended', level: 'A2', t: const Tr('riechen', 'to smell', 'lukta', 'ruiken')),
      LexemeSpec(id: 'lex_v_backen', am: 'መጋገር', tr: 'megager', pos: 'verb', topic: 'verbs_extended', level: 'A2', t: const Tr('backen', 'to bake', 'baka', 'bakken')),
      LexemeSpec(id: 'lex_v_schneiden', am: 'መቁረጥ', tr: "mek'uret'", pos: 'verb', topic: 'verbs_extended', level: 'A2', t: const Tr('schneiden', 'to cut', 'skära', 'snijden')),
      LexemeSpec(id: 'lex_v_druecken', am: 'መጫን', tr: 'mechan', pos: 'verb', topic: 'verbs_extended', level: 'A2', t: const Tr('drücken', 'to press', 'trycka', 'duwen')),
      LexemeSpec(id: 'lex_v_drehen', am: 'ማዞር', tr: 'mazor', pos: 'verb', topic: 'verbs_extended', level: 'A2', t: const Tr('drehen', 'to turn', 'vrida', 'draaien')),
      LexemeSpec(id: 'lex_v_fangen', am: 'መያዝ', tr: 'meyaz', pos: 'verb', topic: 'verbs_extended', level: 'A2', t: const Tr('fangen, halten', 'to catch, to hold', 'fånga, hålla', 'vangen, houden')),
      LexemeSpec(id: 'lex_v_verlassen', am: 'መልቀቅ', tr: "melk'ek'", pos: 'verb', topic: 'verbs_extended', level: 'A2', t: const Tr('verlassen', 'to leave', 'lämna', 'verlaten')),
      LexemeSpec(id: 'lex_v_bleiben', am: 'መቆየት', tr: "mek'oyet", pos: 'verb', topic: 'verbs_extended', level: 'A2', t: const Tr('bleiben', 'to stay', 'stanna', 'blijven')),
    ],
    sentences: [],
  ));

  writeUnit(UnitSpec(
    id: 'unit_abstrakte_begriffe',
    sectionId: 'sec_b1',
    level: 'B1',
    topic: 'abstract_concepts',
    title: const Tr('Abstrakte Begriffe', 'Abstract concepts', 'Abstrakta begrepp', 'Abstracte begrippen'),
    lexemes: [
      LexemeSpec(id: 'lex_idee', am: 'ሀሳብ', tr: 'hasab', pos: 'noun', topic: 'abstract_concepts', level: 'B1', t: const Tr('die Idee, der Gedanke', 'idea, thought', 'idé, tanke', 'idee, gedachte')),
      LexemeSpec(id: 'lex_problem', am: 'ችግር', tr: 'chiggir', pos: 'noun', topic: 'abstract_concepts', level: 'B1', verified: true, t: const Tr('das Problem', 'problem', 'problem', 'probleem')),
      LexemeSpec(id: 'lex_loesung', am: 'መፍትሄ', tr: 'mefithe', pos: 'noun', topic: 'abstract_concepts', level: 'B1', t: const Tr('die Lösung', 'solution', 'lösning', 'oplossing')),
      LexemeSpec(id: 'lex_grund', am: 'ምክንያት', tr: 'mikinyat', pos: 'noun', topic: 'abstract_concepts', level: 'B1', verified: true, t: const Tr('der Grund', 'reason', 'anledning', 'reden')),
      LexemeSpec(id: 'lex_beispiel', am: 'ምሳሌ', tr: 'misale', pos: 'noun', topic: 'abstract_concepts', level: 'B1', verified: true, t: const Tr('das Beispiel', 'example', 'exempel', 'voorbeeld')),
      LexemeSpec(id: 'lex_ganz', am: 'ጠቅላላ', tr: "tek'lala", pos: 'adjective', topic: 'abstract_concepts', level: 'B1', t: const Tr('ganz, gesamt', 'whole, total', 'hel, total', 'geheel, totaal')),
      LexemeSpec(id: 'lex_haelfte', am: 'ግማሽ', tr: 'gimash', pos: 'noun', topic: 'abstract_concepts', level: 'B1', verified: true, t: const Tr('die Hälfte', 'half', 'hälft', 'helft')),
      LexemeSpec(id: 'lex_nummer', am: 'ቁጥር', tr: "k'ut'ir", pos: 'noun', topic: 'abstract_concepts', level: 'B1', verified: true, t: const Tr('die Nummer, die Zahl', 'number', 'nummer', 'nummer')),
      LexemeSpec(id: 'lex_liste', am: 'ዝርዝር', tr: 'zirzir', pos: 'noun', topic: 'abstract_concepts', level: 'B1', t: const Tr('die Liste', 'list', 'lista', 'lijst')),
      LexemeSpec(id: 'lex_regel', am: 'ደንብ', tr: 'deneb', pos: 'noun', topic: 'abstract_concepts', level: 'B1', t: const Tr('die Regel', 'rule', 'regel', 'regel')),
      LexemeSpec(id: 'lex_gesetz', am: 'ህግ', tr: 'higg', pos: 'noun', topic: 'abstract_concepts', level: 'B1', verified: true, t: const Tr('das Gesetz', 'law', 'lag', 'wet')),
      LexemeSpec(id: 'lex_freiheit', am: 'ነፃነት', tr: "nets'anet", pos: 'noun', topic: 'abstract_concepts', level: 'B1', verified: true, t: const Tr('die Freiheit', 'freedom', 'frihet', 'vrijheid')),
      LexemeSpec(id: 'lex_krieg', am: 'ጦርነት', tr: "t'orinet", pos: 'noun', topic: 'abstract_concepts', level: 'B1', verified: true, t: const Tr('der Krieg', 'war', 'krig', 'oorlog')),
      LexemeSpec(id: 'lex_sieg', am: 'ድል', tr: 'dil', pos: 'noun', topic: 'abstract_concepts', level: 'B1', verified: true, t: const Tr('der Sieg', 'victory', 'seger', 'overwinning')),
      LexemeSpec(id: 'lex_veraenderung', am: 'ለውጥ', tr: "lewt'", pos: 'noun', topic: 'abstract_concepts', level: 'B1', t: const Tr('die Veränderung', 'change', 'förändring', 'verandering')),
    ],
    sentences: [],
  ));

  writeUnit(UnitSpec(
    id: 'unit_elektronik_kontinente',
    sectionId: 'sec_a2',
    level: 'A2',
    topic: 'electronics_world',
    title: const Tr('Elektronik & Kontinente', 'Electronics & continents', 'Elektronik & kontinenter', 'Elektronica & continenten'),
    lexemes: [
      LexemeSpec(id: 'lex_telefon', am: 'ስልክ', tr: 'silk', pos: 'noun', topic: 'electronics_world', level: 'A2', emoji: '📱', verified: true, t: const Tr('das Telefon, Handy', 'telephone, phone', 'telefon', 'telefoon')),
      LexemeSpec(id: 'lex_internet', am: 'ኢንተርኔት', tr: 'internet', pos: 'noun', topic: 'electronics_world', level: 'A2', emoji: '🌐', verified: true, t: const Tr('das Internet', 'internet', 'internet', 'internet')),
      LexemeSpec(id: 'lex_email', am: 'ኢሜል', tr: 'imayl', pos: 'noun', topic: 'electronics_world', level: 'A2', emoji: '📧', t: const Tr('die E-Mail', 'email', 'e-post', 'e-mail')),
      LexemeSpec(id: 'lex_nachricht', am: 'መልእክት', tr: 'melikt', pos: 'noun', topic: 'electronics_world', level: 'A2', t: const Tr('die Nachricht', 'message', 'meddelande', 'bericht')),
      LexemeSpec(id: 'lex_batterie', am: 'ባትሪ', tr: 'batri', pos: 'noun', topic: 'electronics_world', level: 'A2', emoji: '🔋', t: const Tr('die Batterie', 'battery', 'batteri', 'batterij')),
      LexemeSpec(id: 'lex_v_anrufen', am: 'መደወል', tr: 'medewel', pos: 'verb', topic: 'electronics_world', level: 'A2', t: const Tr('anrufen', 'to call', 'ringa', 'bellen')),
      LexemeSpec(id: 'lex_foto', am: 'ፎቶ', tr: 'foto', pos: 'noun', topic: 'electronics_world', level: 'A2', emoji: '📷', verified: true, t: const Tr('das Foto', 'photo', 'foto', 'foto')),
      LexemeSpec(id: 'lex_europa', am: 'ኤውሮፓ', tr: 'ewrop\'a', pos: 'noun', topic: 'electronics_world', level: 'A2', emoji: '🌍', verified: true, t: const Tr('Europa', 'Europe', 'Europa', 'Europa')),
      LexemeSpec(id: 'lex_asien', am: 'ኤዥያ', tr: "ezhya", pos: 'noun', topic: 'electronics_world', level: 'A2', emoji: '🌏', t: const Tr('Asien', 'Asia', 'Asien', 'Azië')),
      LexemeSpec(id: 'lex_afrika', am: 'አፍሪካ', tr: 'afrika', pos: 'noun', topic: 'electronics_world', level: 'A2', emoji: '🌍', verified: true, t: const Tr('Afrika', 'Africa', 'Afrika', 'Afrika')),
      LexemeSpec(id: 'lex_australien', am: 'አውስትራልያ', tr: 'awstralya', pos: 'noun', topic: 'electronics_world', level: 'A2', emoji: '🌏', t: const Tr('Australien', 'Australia', 'Australien', 'Australië')),
    ],
    sentences: [],
  ));

  writeUnit(UnitSpec(
    id: 'unit_mengen_zeit_jahreszeiten',
    sectionId: 'sec_a1_2',
    level: 'A1.2',
    topic: 'quantities_time',
    title: const Tr('Mengen, Zeit & Jahreszeiten', 'Quantities, time & seasons', 'Mängder, tid & årstider', 'Hoeveelheden, tijd & seizoenen'),
    lexemes: [
      LexemeSpec(id: 'lex_viel', am: 'ብዙ', tr: 'bizu', pos: 'adjective', topic: 'quantities_time', level: 'A1.2', verified: true, t: const Tr('viel', 'much, many', 'mycket, många', 'veel')),
      LexemeSpec(id: 'lex_wenig', am: 'ጥቂት', tr: "t'ik'it", pos: 'adjective', topic: 'quantities_time', level: 'A1.2', t: const Tr('wenig, ein paar', 'little, few', 'lite, några', 'weinig, een paar')),
      LexemeSpec(id: 'lex_mehr', am: 'ተጨማሪ', tr: 'techemari', pos: 'adjective', topic: 'quantities_time', level: 'A1.2', t: const Tr('mehr, zusätzlich', 'more, additional', 'mer, ytterligare', 'meer, extra')),
      LexemeSpec(id: 'lex_alle', am: 'ሁሉም', tr: 'hulem', pos: 'pronoun', topic: 'quantities_time', level: 'A1.2', verified: true, t: const Tr('alle', 'all', 'alla', 'alle')),
      LexemeSpec(id: 'lex_nichts', am: 'ምንም', tr: 'minim', pos: 'pronoun', topic: 'quantities_time', level: 'A1.2', verified: true, t: const Tr('nichts', 'nothing', 'ingenting', 'niets')),
      LexemeSpec(id: 'lex_etwas', am: 'የሆነ ነገር', tr: 'yehone neger', pos: 'pronoun', topic: 'quantities_time', level: 'A1.2', t: const Tr('etwas', 'something', 'något', 'iets')),
      LexemeSpec(id: 'lex_genug', am: 'በቂ', tr: "beki'", pos: 'adjective', topic: 'quantities_time', level: 'A1.2', t: const Tr('genug', 'enough', 'nog', 'genoeg')),
      LexemeSpec(id: 'lex_nachmittag', am: 'ከሰዓት በኋላ', tr: "kese'at behwala", pos: 'noun', topic: 'quantities_time', level: 'A1.2', t: const Tr('der Nachmittag', 'afternoon', 'eftermiddag', 'namiddag')),
      LexemeSpec(id: 'lex_mittag', am: 'ቀትር', tr: "ket'ir", pos: 'noun', topic: 'quantities_time', level: 'A1.2', t: const Tr('der Mittag', 'noon', 'middag', 'middag')),
      LexemeSpec(id: 'lex_mitternacht', am: 'እኩለ ሌሊት', tr: 'ikule lelit', pos: 'noun', topic: 'quantities_time', level: 'A1.2', t: const Tr('die Mitternacht', 'midnight', 'midnatt', 'middernacht')),
      LexemeSpec(id: 'lex_wochenende', am: 'የሳምንት መጨረሻ', tr: 'yesamint mecheresha', pos: 'noun', topic: 'quantities_time', level: 'A1.2', t: const Tr('das Wochenende', 'weekend', 'helg', 'weekend')),
      LexemeSpec(id: 'lex_jahreszeit', am: 'ወቅት', tr: "wek'it", pos: 'noun', topic: 'quantities_time', level: 'A1.2', verified: true, t: const Tr('die Jahreszeit', 'season', 'årstid', 'seizoen')),
      LexemeSpec(id: 'lex_regenzeit', am: 'ክረምት', tr: 'kiremt', pos: 'noun', topic: 'quantities_time', level: 'A1.2', verified: true, t: const Tr('die Regenzeit', 'rainy season', 'regnperiod', 'regenseizoen')),
      LexemeSpec(id: 'lex_trockenzeit', am: 'በጋ', tr: 'bega', pos: 'noun', topic: 'quantities_time', level: 'A1.2', verified: true, t: const Tr('die Trockenzeit, der Sommer', 'dry season, summer', 'torrperiod, sommar', 'droge seizoen, zomer')),
    ],
    sentences: [],
  ));

  writeUnit(UnitSpec(
    id: 'unit_gesundheit_natur_schule',
    sectionId: 'sec_a2',
    level: 'A2',
    topic: 'misc_a2',
    title: const Tr('Gesundheit, Natur & Schule (mehr)', 'Health, nature & school (more)', 'Hälsa, natur & skola (mer)', 'Gezondheid, natuur & school (meer)'),
    lexemes: [
      LexemeSpec(id: 'lex_impfung', am: 'ክትባት', tr: 'kitibat', pos: 'noun', topic: 'misc_a2', level: 'A2', t: const Tr('die Impfung', 'vaccination', 'vaccination', 'vaccinatie')),
      LexemeSpec(id: 'lex_verletzung', am: 'ጉዳት', tr: 'gudat', pos: 'noun', topic: 'misc_a2', level: 'A2', t: const Tr('die Verletzung', 'injury', 'skada', 'verwonding')),
      LexemeSpec(id: 'lex_unfall', am: 'አደጋ', tr: 'adega', pos: 'noun', topic: 'misc_a2', level: 'A2', verified: true, t: const Tr('der Unfall', 'accident', 'olycka', 'ongeluk')),
      LexemeSpec(id: 'lex_regenbogen', am: 'ቀስተ ደመና', tr: "k'este demena", pos: 'noun', topic: 'misc_a2', level: 'A2', emoji: '🌈', verified: true, t: const Tr('der Regenbogen', 'rainbow', 'regnbåge', 'regenboog')),
      LexemeSpec(id: 'lex_wueste', am: 'በረሃ', tr: 'bereha', pos: 'noun', topic: 'misc_a2', level: 'A2', verified: true, t: const Tr('die Wüste', 'desert', 'öken', 'woestijn')),
      LexemeSpec(id: 'lex_gras', am: 'ሳር', tr: 'sar', pos: 'noun', topic: 'misc_a2', level: 'A2', verified: true, t: const Tr('das Gras', 'grass', 'gräs', 'gras')),
      LexemeSpec(id: 'lex_insekt', am: 'ተባይ', tr: 'tebay', pos: 'noun', topic: 'misc_a2', level: 'A2', t: const Tr('das Insekt', 'insect', 'insekt', 'insect')),
      LexemeSpec(id: 'lex_schulfach', am: 'ትምህርት', tr: 'timhirt', pos: 'noun', topic: 'misc_a2', level: 'A2', verified: true, t: const Tr('das Schulfach, die Bildung', 'school subject, education', 'skolämne, utbildning', 'schoolvak, onderwijs')),
      LexemeSpec(id: 'lex_note', am: 'ውጤት', tr: "wit'et", pos: 'noun', topic: 'misc_a2', level: 'A2', t: const Tr('die Note, das Ergebnis', 'grade, result', 'betyg, resultat', 'cijfer, resultaat')),
      LexemeSpec(id: 'lex_nett', am: 'ደግ', tr: 'deg', pos: 'adjective', topic: 'misc_a2', level: 'A2', verified: true, t: const Tr('nett, freundlich', 'kind, friendly', 'snäll, vänlig', 'aardig, vriendelijk')),
      LexemeSpec(id: 'lex_vorsichtig', am: 'ጥንቃቄ', tr: "t'inik'ak'e", pos: 'noun', topic: 'misc_a2', level: 'A2', t: const Tr('die Vorsicht, vorsichtig', 'caution, careful', 'försiktighet', 'voorzichtigheid')),
    ],
    sentences: [],
  ));

  writeUnit(UnitSpec(
    id: 'unit_kueche_farben_getraenke',
    sectionId: 'sec_a1_2',
    level: 'A1.2',
    topic: 'kitchen_colors_drinks',
    title: const Tr('Küche, Farben & Getränke (mehr)', 'Kitchen, colors & drinks (more)', 'Kök, färger & drycker (mer)', 'Keuken, kleuren & dranken (meer)'),
    lexemes: [
      LexemeSpec(id: 'lex_kuehlschrank', am: 'ማቀዝቀዣ', tr: "mak'ezk'eza", pos: 'noun', topic: 'kitchen_colors_drinks', level: 'A1.2', emoji: '🧊', t: const Tr('der Kühlschrank', 'refrigerator', 'kylskåp', 'koelkast')),
      LexemeSpec(id: 'lex_ofen', am: 'ምድጃ', tr: 'midija', pos: 'noun', topic: 'kitchen_colors_drinks', level: 'A1.2', t: const Tr('der Ofen, Herd', 'oven, stove', 'ugn, spis', 'oven, fornuis')),
      LexemeSpec(id: 'lex_gold', am: 'ወርቅ', tr: "werk'", pos: 'noun', topic: 'kitchen_colors_drinks', level: 'A1.2', emoji: '🥇', verified: true, t: const Tr('das Gold', 'gold', 'guld', 'goud')),
      LexemeSpec(id: 'lex_silber', am: 'ብር', tr: 'bir', pos: 'noun', topic: 'kitchen_colors_drinks', level: 'A1.2', verified: true, t: const Tr('das Silber', 'silver', 'silver', 'zilver')),
      LexemeSpec(id: 'lex_bier', am: 'ቢራ', tr: 'bira', pos: 'noun', topic: 'kitchen_colors_drinks', level: 'A1.2', emoji: '🍺', verified: true, t: const Tr('das Bier', 'beer', 'öl', 'bier')),
      LexemeSpec(id: 'lex_wein', am: 'ወይን', tr: 'wain', pos: 'noun', topic: 'kitchen_colors_drinks', level: 'A1.2', emoji: '🍷', t: const Tr('der Wein', 'wine', 'vin', 'wijn')),
      LexemeSpec(id: 'lex_saft', am: 'ጭማቂ', tr: "chimak'i", pos: 'noun', topic: 'kitchen_colors_drinks', level: 'A1.2', emoji: '🧃', t: const Tr('der Saft', 'juice', 'juice', 'sap')),
    ],
    sentences: [],
  ));

  writeUnit(UnitSpec(
    id: 'unit_aethiopien_extra',
    sectionId: 'sec_b1',
    level: 'B1',
    topic: 'ethiopia_extra',
    title: const Tr('Äthiopische Städte & Gerichte', 'Ethiopian cities & dishes', 'Etiopiska städer & rätter', 'Ethiopische steden & gerechten'),
    lexemes: [
      LexemeSpec(id: 'lex_gondar', am: 'ጎንደር', tr: 'gonder', pos: 'noun', topic: 'ethiopia_extra', level: 'B1', t: const Tr('Gondar (Stadt)', 'Gondar (city)', 'Gondar (stad)', 'Gondar (stad)')),
      LexemeSpec(id: 'lex_axum', am: 'አክሱም', tr: 'aksum', pos: 'noun', topic: 'ethiopia_extra', level: 'B1', verified: true, t: const Tr('Axum (Stadt)', 'Axum (city)', 'Axum (stad)', 'Axum (stad)')),
      LexemeSpec(id: 'lex_lalibela', am: 'ላሊበላ', tr: 'lalibela', pos: 'noun', topic: 'ethiopia_extra', level: 'B1', verified: true, t: const Tr('Lalibela (Stadt)', 'Lalibela (city)', 'Lalibela (stad)', 'Lalibela (stad)')),
      LexemeSpec(id: 'lex_bahirdar', am: 'ባህር ዳር', tr: 'bahir dar', pos: 'noun', topic: 'ethiopia_extra', level: 'B1', t: const Tr('Bahir Dar (Stadt)', 'Bahir Dar (city)', 'Bahir Dar (stad)', 'Bahir Dar (stad)')),
      LexemeSpec(id: 'lex_mekelle', am: 'መቀሌ', tr: "mekele", pos: 'noun', topic: 'ethiopia_extra', level: 'B1', t: const Tr('Mekelle (Stadt)', 'Mekelle (city)', 'Mekelle (stad)', 'Mekelle (stad)')),
      LexemeSpec(id: 'lex_hawassa', am: 'ሀዋሳ', tr: 'hawassa', pos: 'noun', topic: 'ethiopia_extra', level: 'B1', t: const Tr('Hawassa (Stadt)', 'Hawassa (city)', 'Hawassa (stad)', 'Hawassa (stad)')),
      LexemeSpec(id: 'lex_tibs', am: 'ጥብስ', tr: "t'ibs", pos: 'noun', topic: 'ethiopia_extra', level: 'B1', emoji: '🍖', verified: true, t: const Tr('Tibs (gebratenes Fleisch)', 'tibs (fried meat)', 'tibs (stekt kött)', 'tibs (gebakken vlees)')),
      LexemeSpec(id: 'lex_kitfo', am: 'ክትፎ', tr: 'kitfo', pos: 'noun', topic: 'ethiopia_extra', level: 'B1', emoji: '🍽️', verified: true, t: const Tr('Kitfo (Hackfleisch-Gericht)', 'kitfo (minced meat dish)', 'kitfo (köttfärsrätt)', 'kitfo (gehaktgerecht)')),
      LexemeSpec(id: 'lex_wat', am: 'ወጥ', tr: 'wat', pos: 'noun', topic: 'ethiopia_extra', level: 'B1', emoji: '🍲', verified: true, t: const Tr('Wat (Eintopf/Soße)', 'wat (stew)', 'wat (gryta)', 'wat (stoofpot)')),
      LexemeSpec(id: 'lex_firfir', am: 'ፍርፍር', tr: 'firfir', pos: 'noun', topic: 'ethiopia_extra', level: 'B1', t: const Tr('Firfir (Injera-Gericht)', 'firfir (injera dish)', 'firfir (injera-rätt)', 'firfir (injeragerecht)')),
    ],
    sentences: [],
  ));
}

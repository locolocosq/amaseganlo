// Harar, Kapitel 1 (Etappe 24 Nachtrag 2): Islam-Wortschatz, wie er in
// Äthiopien (v.a. Addis Abeba) gebraucht wird. Deliberately builds past what
// `lexemes_religion_kultur.json` (sec_b1) already teaches - the generic
// "das Gebet"/"ጸሎት", "das Fasten"/"ጾም", "der Feiertag"/"በዓል", "der
// Segen"/"በረከት" are already known by this point, so this unit set goes one
// level more specific (the ritual prayer itself, the fasting month itself,
// the specific holidays) rather than re-teaching the same generic nouns.
// Run once via `dart run tool/gen_harar_setup.dart` first to create
// sec_harar, then this script.
import 'content_lib.dart';

void main() {
  writeUnit(UnitSpec(
    id: 'unit_harar_islam_grundlagen',
    sectionId: 'sec_harar',
    level: 'B2',
    topic: 'islam_basics',
    title: const Tr('Islam: Grundbegriffe', 'Islam: basic terms', 'Islam: grundbegrepp', 'Islam: basisbegrippen'),
    lexemes: [
      LexemeSpec(id: 'lex_islam_din', am: 'እስልምና', tr: 'isilimina', pos: 'noun', topic: 'islam_basics', level: 'B2', verified: true, t: const Tr('der Islam (die Religion)', 'Islam (the religion)', 'islam (religionen)', 'islam (de religie)')),
      LexemeSpec(id: 'lex_muslim', am: 'ሙስሊም', tr: 'muslim', pos: 'noun', topic: 'islam_basics', level: 'B2', verified: true, t: const Tr('der Muslim, die Muslimin', 'Muslim', 'muslim', 'moslim')),
      LexemeSpec(id: 'lex_allah', am: 'አላህ', tr: 'alah', pos: 'noun', topic: 'islam_basics', level: 'B2', verified: true, t: const Tr('Allah, Gott (im Islam)', 'Allah, God (in Islam)', 'Allah, Gud (inom islam)', 'Allah, God (in de islam)')),
      LexemeSpec(id: 'lex_nebiy', am: 'ነቢይ', tr: 'nebiy', pos: 'noun', topic: 'islam_basics', level: 'B2', verified: true, t: const Tr('der Prophet', 'prophet', 'profet', 'profeet')),
      LexemeSpec(id: 'lex_kuran', am: 'ቁርኣን', tr: "k'uran", pos: 'noun', topic: 'islam_basics', level: 'B2', verified: true, t: const Tr('der Koran', 'the Quran', 'Koranen', 'de Koran')),
      LexemeSpec(id: 'lex_mesgid', am: 'መስጊድ', tr: 'mesgid', pos: 'noun', topic: 'islam_basics', level: 'B2', verified: true, emoji: '🕌', t: const Tr('die Moschee', 'mosque', 'moské', 'moskee')),
      LexemeSpec(id: 'lex_imam', am: 'ኢማም', tr: 'imam', pos: 'noun', topic: 'islam_basics', level: 'B2', verified: true, t: const Tr('der Imam', 'imam', 'imam', 'imam')),
      LexemeSpec(id: 'lex_amagn', am: 'አማኝ', tr: 'amagn', pos: 'noun', topic: 'islam_basics', level: 'B2', t: const Tr('der/die Gläubige', 'believer', 'troende', 'gelovige')),
      LexemeSpec(id: 'lex_adj_tamagn', am: 'ታማኝ', tr: 'tamagn', pos: 'adjective', topic: 'islam_basics', level: 'B2', verified: true, t: const Tr('treu, loyal, gläubig', 'faithful, loyal', 'trogen, lojal', 'trouw, loyaal')),
    ],
    sentences: [],
  ));

  writeUnit(UnitSpec(
    id: 'unit_harar_islam_praxis',
    sectionId: 'sec_harar',
    level: 'B2',
    topic: 'islam_practice',
    title: const Tr('Islam: Gebet & Praxis', 'Islam: prayer & practice', 'Islam: bön & praktik', 'Islam: gebed & praktijk'),
    lexemes: [
      LexemeSpec(id: 'lex_solat', am: 'ሶላት', tr: 'solat', pos: 'noun', topic: 'islam_practice', level: 'B2', t: const Tr('das rituelle Pflichtgebet', 'the ritual prayer (salat)', 'den rituella bönen', 'het rituele gebed')),
      LexemeSpec(id: 'lex_remedan', am: 'ረመዳን', tr: 'remedan', pos: 'noun', topic: 'islam_practice', level: 'B2', verified: true, t: const Tr('der Ramadan', 'Ramadan', 'ramadan', 'ramadan')),
      LexemeSpec(id: 'lex_v_tsom_isl', am: 'መጾም', tr: 'metsom', pos: 'verb', topic: 'islam_practice', level: 'B2', verified: true, t: const Tr('fasten', 'to fast', 'fasta', 'vasten')),
      LexemeSpec(id: 'lex_id_holiday', am: 'ኢድ', tr: 'id', pos: 'noun', topic: 'islam_practice', level: 'B2', t: const Tr('das Id-Fest (islamischer Feiertag)', 'Eid (Islamic holiday)', 'eid (islamisk högtid)', 'eid (islamitisch feest)')),
      LexemeSpec(id: 'lex_hagg', am: 'ሐጅ', tr: 'hagg', pos: 'noun', topic: 'islam_practice', level: 'B2', t: const Tr('die Pilgerfahrt nach Mekka (Hadsch)', 'the pilgrimage to Mecca (Hajj)', 'pilgrimsfärden till Mecka (hajj)', 'de pelgrimstocht naar Mekka (hadj)')),
      LexemeSpec(id: 'lex_meka', am: 'መካ', tr: 'meka', pos: 'noun', topic: 'islam_practice', level: 'B2', verified: true, t: const Tr('Mekka', 'Mecca', 'Mecka', 'Mekka')),
      LexemeSpec(id: 'lex_v_mesged', am: 'መስገድ', tr: 'mesiged', pos: 'verb', topic: 'islam_practice', level: 'B2', verified: true, t: const Tr('sich niederwerfen, (rituell) beten', 'to prostrate, to pray (ritually)', 'buga sig, be (rituellt)', 'zich neerbuigen, (rituelt) bidden')),
      LexemeSpec(id: 'lex_zekat', am: 'ዘካት', tr: 'zekat', pos: 'noun', topic: 'islam_practice', level: 'B2', t: const Tr('die Pflichtabgabe, das Almosen (Zakat)', 'obligatory almsgiving (zakat)', 'allmosoplikten (zakat)', 'de verplichte aalmoes (zakat)')),
    ],
    sentences: [],
  ));

  writeUnit(UnitSpec(
    id: 'unit_harar_islam_gemeinschaft',
    sectionId: 'sec_harar',
    level: 'B2',
    topic: 'islam_community',
    title: const Tr('Islam: Gemeinschaft', 'Islam: community', 'Islam: gemenskap', 'Islam: gemeenschap'),
    lexemes: [
      LexemeSpec(id: 'lex_sheikh', am: 'ሼኽ', tr: 'sheikh', pos: 'noun', topic: 'islam_community', level: 'B2', t: const Tr('der Scheich (religiöser Gelehrter)', 'sheikh (religious scholar)', 'shejk (religiös lärd)', 'sjeik (religieuze geleerde)')),
      LexemeSpec(id: 'lex_ustaz', am: 'ኡስታዝ', tr: 'ustaz', pos: 'noun', topic: 'islam_community', level: 'B2', t: const Tr('der Religionslehrer (Ustaz)', 'Islamic teacher (ustadh)', 'religionslärare (ustadh)', 'islamitische leraar (ustadh)')),
      LexemeSpec(id: 'lex_medresa', am: 'መድረሳ', tr: 'medresa', pos: 'noun', topic: 'islam_community', level: 'B2', t: const Tr('die Koranschule (Madrasa)', 'Islamic school (madrasa)', 'koranskola (madrasa)', 'koranschool (madrassa)')),
      LexemeSpec(id: 'lex_adj_halal', am: 'ሐላል', tr: 'halal', pos: 'adjective', topic: 'islam_community', level: 'B2', verified: true, t: const Tr('erlaubt, halal', 'permissible, halal', 'tillåten, halal', 'toegestaan, halal')),
      LexemeSpec(id: 'lex_adj_haram', am: 'ሐራም', tr: 'haram', pos: 'adjective', topic: 'islam_community', level: 'B2', verified: true, t: const Tr('verboten, haram', 'forbidden, haram', 'förbjuden, haram', 'verboden, haram')),
      LexemeSpec(id: 'lex_v_amen', am: 'ማመን', tr: 'mamen', pos: 'verb', topic: 'islam_community', level: 'B2', verified: true, t: const Tr('glauben', 'to believe', 'tro', 'geloven')),
      LexemeSpec(id: 'lex_hajji_title', am: 'ሐጂ', tr: 'haji', pos: 'noun', topic: 'islam_community', level: 'B2', t: const Tr('Hadschi (Titel für Mekka-Pilger)', 'Hajji (title for a Mecca pilgrim)', 'hadji (titel för Mecka-pilgrim)', 'hadji (titel voor Mekka-pelgrim)')),
    ],
    sentences: [],
  ));

  writeUnit(UnitSpec(
    id: 'unit_harar_islam_alltag',
    sectionId: 'sec_harar',
    level: 'B2',
    topic: 'islam_daily',
    title: const Tr('Islam: Alltag & Gruß', 'Islam: daily life & greetings', 'Islam: vardag & hälsning', 'Islam: dagelijks leven & groet'),
    lexemes: [
      LexemeSpec(id: 'lex_selam_alaykum', am: 'ሰላም ዓለይኩም', tr: 'selam alaykum', pos: 'phrase', topic: 'islam_daily', level: 'B2', verified: true, t: const Tr('Friede sei mit dir (islamischer Gruß)', 'peace be upon you (Islamic greeting)', 'fred vare med dig (islamisk hälsning)', 'vrede zij met u (islamitische groet)')),
      LexemeSpec(id: 'lex_wealaykum', am: 'ወዓለይኩም ሰላም', tr: 'wa alaykum selam', pos: 'phrase', topic: 'islam_daily', level: 'B2', verified: true, t: const Tr('und mit dir sei Friede (Antwort)', 'and upon you be peace (reply)', 'och över dig vare fred (svar)', 'en met u zij vrede (antwoord)')),
      LexemeSpec(id: 'lex_khutba', am: 'ኹጥባ', tr: 'khutba', pos: 'noun', topic: 'islam_daily', level: 'B2', t: const Tr('die Freitagspredigt', 'the Friday sermon', 'fredagspredikan', 'de vrijdagpreek')),
      LexemeSpec(id: 'lex_v_mesibek', am: 'መስበክ', tr: 'mesibek', pos: 'verb', topic: 'islam_daily', level: 'B2', verified: true, t: const Tr('predigen', 'to preach', 'predika', 'preken')),
      LexemeSpec(id: 'lex_adj_islamawi', am: 'እስላማዊ', tr: 'isilamawi', pos: 'adjective', topic: 'islam_daily', level: 'B2', verified: true, t: const Tr('islamisch', 'Islamic', 'islamisk', 'islamitisch')),
      LexemeSpec(id: 'lex_adj_haymanotegna', am: 'ሃይማኖተኛ', tr: 'haymanotegna', pos: 'adjective', topic: 'islam_daily', level: 'B2', verified: true, t: const Tr('religiös, fromm', 'religious, devout', 'religiös, from', 'religieus, vroom')),
    ],
    sentences: [],
  ));
}

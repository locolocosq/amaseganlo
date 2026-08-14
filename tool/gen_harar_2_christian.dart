// Harar, Kapitel 2 (Etappe 24 Nachtrag 2): christliches (v.a.
// äthiopisch-orthodoxes) Vokabular. Builds past what's already known by
// this point: "das Gebet"/ጸሎት, "das Fasten"/ጾም, "der Feiertag"/በዓል, "der
// Segen"/በረከት, "das Kreuz"/መስቀል, "der Weihrauch"/ዕጣን, "das
// Kloster"/ገዳም (sec_b1's lexemes_religion_kultur.json) and "die
// Kirche"/ቤተ ክርስቲያን (A1.2's lexemes_in_der_stadt.json) - so this goes a
// level more specific (clergy, scripture, named feasts, sacraments)
// instead of re-teaching those.
import 'content_lib.dart';

void main() {
  writeUnit(UnitSpec(
    id: 'unit_harar_christian_grundlagen',
    sectionId: 'sec_harar',
    level: 'B2',
    topic: 'christian_basics',
    title: const Tr('Christentum: Grundbegriffe', 'Christianity: basic terms', 'Kristendom: grundbegrepp', 'Christendom: basisbegrippen'),
    lexemes: [
      LexemeSpec(id: 'lex_kidase', am: 'ቅዳሴ', tr: "k'idase", pos: 'noun', topic: 'christian_basics', level: 'B2', verified: true, t: const Tr('die Liturgie, die Messe', 'the liturgy, mass', 'liturgin, mässan', 'de liturgie, de mis')),
      LexemeSpec(id: 'lex_kahin', am: 'ካህን', tr: 'kahin', pos: 'noun', topic: 'christian_basics', level: 'B2', verified: true, t: const Tr('der Priester', 'priest', 'präst', 'priester')),
      LexemeSpec(id: 'lex_papase', am: 'ጳጳስ', tr: 'papase', pos: 'noun', topic: 'christian_basics', level: 'B2', verified: true, t: const Tr('der Bischof, der Patriarch', 'bishop, patriarch', 'biskop, patriark', 'bisschop, patriarch')),
      LexemeSpec(id: 'lex_menekuse', am: 'መነኩሴ', tr: 'menekuse', pos: 'noun', topic: 'christian_basics', level: 'B2', verified: true, t: const Tr('der Mönch', 'monk', 'munk', 'monnik')),
      LexemeSpec(id: 'lex_menekusit', am: 'መነኩሲት', tr: 'menekusit', pos: 'noun', topic: 'christian_basics', level: 'B2', t: const Tr('die Nonne', 'nun', 'nunna', 'non')),
      LexemeSpec(id: 'lex_wongel', am: 'ወንጌል', tr: 'wongel', pos: 'noun', topic: 'christian_basics', level: 'B2', verified: true, t: const Tr('das Evangelium', 'gospel', 'evangelium', 'evangelie')),
      LexemeSpec(id: 'lex_metsihaf_kidus', am: 'መጽሐፍ ቅዱስ', tr: "metsihaf k'idus", pos: 'noun', topic: 'christian_basics', level: 'B2', verified: true, t: const Tr('die Bibel', 'the Bible', 'Bibeln', 'de Bijbel')),
      LexemeSpec(id: 'lex_adj_kidus', am: 'ቅዱስ', tr: "k'idus", pos: 'adjective', topic: 'christian_basics', level: 'B2', verified: true, t: const Tr('heilig', 'holy, saint', 'helig', 'heilig')),
    ],
    sentences: [],
  ));

  writeUnit(UnitSpec(
    id: 'unit_harar_christian_feste',
    sectionId: 'sec_harar',
    level: 'B2',
    topic: 'christian_feasts',
    title: const Tr('Christentum: Feste & Riten', 'Christianity: feasts & rites', 'Kristendom: högtider & riter', 'Christendom: feesten & riten'),
    lexemes: [
      LexemeSpec(id: 'lex_fasika', am: 'ፋሲካ', tr: 'fasika', pos: 'noun', topic: 'christian_feasts', level: 'B2', verified: true, t: const Tr('Ostern', 'Easter', 'påsk', 'Pasen')),
      LexemeSpec(id: 'lex_gena', am: 'ገና', tr: 'gena', pos: 'noun', topic: 'christian_feasts', level: 'B2', verified: true, t: const Tr('Weihnachten', 'Christmas', 'jul', 'Kerstmis')),
      LexemeSpec(id: 'lex_timket', am: 'ጥምቀት', tr: "t'imk'et", pos: 'noun', topic: 'christian_feasts', level: 'B2', verified: true, t: const Tr('die Taufe, Timkat (Epiphaniasfest)', 'baptism, Timkat (Epiphany)', 'dopet, Timkat (trettondagen)', 'de doop, Timkat (Epifanie)')),
      LexemeSpec(id: 'lex_v_matimek', am: 'ማጥመቅ', tr: "mat'imek'", pos: 'verb', topic: 'christian_feasts', level: 'B2', verified: true, t: const Tr('taufen', 'to baptize', 'döpa', 'dopen')),
      LexemeSpec(id: 'lex_v_mebarek', am: 'መባረክ', tr: 'mebarek', pos: 'verb', topic: 'christian_feasts', level: 'B2', verified: true, t: const Tr('segnen', 'to bless', 'välsigna', 'zegenen')),
      LexemeSpec(id: 'lex_v_menazez', am: 'መናዘዝ', tr: 'menazez', pos: 'verb', topic: 'christian_feasts', level: 'B2', verified: true, t: const Tr('beichten', 'to confess', 'bikta', 'biechten')),
      LexemeSpec(id: 'lex_hatiat', am: 'ኃጢአት', tr: "hat'i'at", pos: 'noun', topic: 'christian_feasts', level: 'B2', verified: true, t: const Tr('die Sünde', 'sin', 'synd', 'zonde')),
    ],
    sentences: [],
  ));

  writeUnit(UnitSpec(
    id: 'unit_harar_christian_glauben',
    sectionId: 'sec_harar',
    level: 'B2',
    topic: 'christian_faith',
    title: const Tr('Christentum: Glaube', 'Christianity: faith', 'Kristendom: tro', 'Christendom: geloof'),
    lexemes: [
      LexemeSpec(id: 'lex_iyesus', am: 'ኢየሱስ ክርስቶስ', tr: 'iyesus kirstos', pos: 'noun', topic: 'christian_faith', level: 'B2', verified: true, t: const Tr('Jesus Christus', 'Jesus Christ', 'Jesus Kristus', 'Jezus Christus')),
      LexemeSpec(id: 'lex_maryam', am: 'ማርያም', tr: 'maryam', pos: 'noun', topic: 'christian_faith', level: 'B2', verified: true, t: const Tr('Maria (Mutter Jesu)', "Mary (Jesus's mother)", 'Maria (Jesu mor)', 'Maria (moeder van Jezus)')),
      LexemeSpec(id: 'lex_melak', am: 'መልአክ', tr: "mel'ak", pos: 'noun', topic: 'christian_faith', level: 'B2', verified: true, t: const Tr('der Engel', 'angel', 'ängel', 'engel')),
      LexemeSpec(id: 'lex_nefis', am: 'ነፍስ', tr: 'nefis', pos: 'noun', topic: 'christian_faith', level: 'B2', verified: true, t: const Tr('die Seele', 'soul', 'själ', 'ziel')),
      LexemeSpec(id: 'lex_gehanem', am: 'ገሃነም', tr: 'gehanem', pos: 'noun', topic: 'christian_faith', level: 'B2', verified: true, t: const Tr('die Hölle', 'hell', 'helvetet', 'de hel')),
      LexemeSpec(id: 'lex_adj_semayawi', am: 'ሰማያዊ', tr: 'semayawi', pos: 'adjective', topic: 'christian_faith', level: 'B2', verified: true, t: const Tr('himmlisch', 'heavenly', 'himmelsk', 'hemels')),
      LexemeSpec(id: 'lex_haleluya', am: 'ሃሌሉያ', tr: 'haleluya', pos: 'interjection', topic: 'christian_faith', level: 'B2', verified: true, t: const Tr('Halleluja', 'Hallelujah', 'halleluja', 'halleluja')),
    ],
    sentences: [],
  ));
}

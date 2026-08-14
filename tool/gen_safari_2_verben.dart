// Safari, zweite Welle (Etappe 24 Nachtrag 3): weitere Mann/Frau-
// Unterschiede über den ersten Kopula-Kontrast (ነው/ናት/ነህ/ነሽ) hinaus -
// Verbkonjugation (Präsens und Perfekt von "gehen") und Possessivpronomen
// (sein/ihr). Wie in Unit 1 sind Pronomen und Inhaltswörter ausschließlich
// bereits bekannte Lexeme (lex_ante/lex_anchi/lex_issu/lex_iswa aus
// unit_ich_und_du, lex_haus aus unit_zuhause) - neu sind nur die
// konjugierten Verbformen selbst und die zwei Possessivpronomen, weil genau
// das die "Unterschiede" sind, die diese Station lehren soll. Die
// Verbformen sind unverified (Amharic-Konjugation ist komplexer als die
// Kopula und verdient eine menschliche Gegenprüfung), die Possessivformen
// und die Perfektformen sind hingegen Standardmuster mit hoher Konfidenz.
import 'content_lib.dart';

void main() {
  writeUnit(UnitSpec(
    id: 'unit_safari_verben_possessiv',
    sectionId: 'sec_safari',
    level: 'B2',
    topic: 'gender_grammar_2',
    title: const Tr('Sie und er: Verben & Besitz', 'She and he: verbs & possession', 'Hon och han: verb & ägande', 'Zij en hij: werkwoorden & bezit'),
    lexemes: [
      LexemeSpec(
        id: 'lex_v_tihedaleh',
        am: 'ትሄዳለህ',
        tr: 'tihedaleh',
        pos: 'verb',
        topic: 'gender_grammar_2',
        level: 'B2',
        t: const Tr('du gehst (männlich)', 'you go (masc.)', 'du går (maskulinum)', 'jij gaat (mannelijk)'),
      ),
      LexemeSpec(
        id: 'lex_v_tihejalesh',
        am: 'ትሄጃለሽ',
        tr: 'tihejalesh',
        pos: 'verb',
        topic: 'gender_grammar_2',
        level: 'B2',
        t: const Tr('du gehst (weiblich)', 'you go (fem.)', 'du går (femininum)', 'jij gaat (vrouwelijk)'),
      ),
      LexemeSpec(
        id: 'lex_v_yihedal',
        am: 'ይሄዳል',
        tr: 'yihedal',
        pos: 'verb',
        topic: 'gender_grammar_2',
        level: 'B2',
        t: const Tr('er geht', 'he goes', 'han går', 'hij gaat'),
      ),
      LexemeSpec(
        id: 'lex_v_tihedalech',
        am: 'ትሄዳለች',
        tr: 'tihedalech',
        pos: 'verb',
        topic: 'gender_grammar_2',
        level: 'B2',
        t: const Tr('sie geht', 'she goes', 'hon går', 'zij gaat'),
      ),
      LexemeSpec(
        id: 'lex_v_hede',
        am: 'ሄደ',
        tr: 'hede',
        pos: 'verb',
        topic: 'gender_grammar_2',
        level: 'B2',
        verified: true,
        t: const Tr('er ging', 'he went', 'han gick', 'hij ging'),
      ),
      LexemeSpec(
        id: 'lex_v_hedech',
        am: 'ሄደች',
        tr: 'hedech',
        pos: 'verb',
        topic: 'gender_grammar_2',
        level: 'B2',
        verified: true,
        t: const Tr('sie ging', 'she went', 'hon gick', 'zij ging'),
      ),
      LexemeSpec(
        id: 'lex_poss_yeissu',
        am: 'የእሱ',
        tr: 'yeissu',
        pos: 'particle',
        topic: 'gender_grammar_2',
        level: 'B2',
        verified: true,
        t: const Tr('sein, seine (Possessivpronomen)', 'his', 'hans', 'zijn'),
      ),
      LexemeSpec(
        id: 'lex_poss_yeiswa',
        am: 'የእሷ',
        tr: 'yeiswa',
        pos: 'particle',
        topic: 'gender_grammar_2',
        level: 'B2',
        verified: true,
        t: const Tr('ihr, ihre (Possessivpronomen)', 'her', 'hennes', 'haar'),
      ),
    ],
    sentences: [
      SentenceSpec(
        id: 'sen_safari_ante_tihedaleh',
        am: 'አንተ ትሄዳለህ።',
        tr: 'ante tihedaleh.',
        level: 'B2',
        uses: const ['lex_ante', 'lex_v_tihedaleh'],
        t: const Tr('Du (männlich) gehst.', 'You (masc.) go.', 'Du (maskulinum) går.', 'Jij (mannelijk) gaat.'),
        chunks: const ['ante', 'tihedaleh'],
      ),
      SentenceSpec(
        id: 'sen_safari_anchi_tihejalesh',
        am: 'አንቺ ትሄጃለሽ።',
        tr: 'anchi tihejalesh.',
        level: 'B2',
        uses: const ['lex_anchi', 'lex_v_tihejalesh'],
        t: const Tr('Du (weiblich) gehst.', 'You (fem.) go.', 'Du (femininum) går.', 'Jij (vrouwelijk) gaat.'),
        chunks: const ['anchi', 'tihejalesh'],
      ),
      SentenceSpec(
        id: 'sen_safari_issu_yihedal',
        am: 'እሱ ይሄዳል።',
        tr: 'issu yihedal.',
        level: 'B2',
        uses: const ['lex_issu', 'lex_v_yihedal'],
        t: const Tr('Er geht.', 'He goes.', 'Han går.', 'Hij gaat.'),
        chunks: const ['issu', 'yihedal'],
      ),
      SentenceSpec(
        id: 'sen_safari_iswa_tihedalech',
        am: 'እሷ ትሄዳለች።',
        tr: 'iswa tihedalech.',
        level: 'B2',
        uses: const ['lex_iswa', 'lex_v_tihedalech'],
        t: const Tr('Sie geht.', 'She goes.', 'Hon går.', 'Zij gaat.'),
        chunks: const ['iswa', 'tihedalech'],
      ),
      SentenceSpec(
        id: 'sen_safari_issu_hede',
        am: 'እሱ ሄደ።',
        tr: 'issu hede.',
        level: 'B2',
        uses: const ['lex_issu', 'lex_v_hede'],
        t: const Tr('Er ging.', 'He went.', 'Han gick.', 'Hij ging.'),
        chunks: const ['issu', 'hede'],
      ),
      SentenceSpec(
        id: 'sen_safari_iswa_hedech',
        am: 'እሷ ሄደች።',
        tr: 'iswa hedech.',
        level: 'B2',
        uses: const ['lex_iswa', 'lex_v_hedech'],
        t: const Tr('Sie ging.', 'She went.', 'Hon gick.', 'Zij ging.'),
        chunks: const ['iswa', 'hedech'],
      ),
      SentenceSpec(
        id: 'sen_safari_yeissu_bet',
        am: 'የእሱ ቤት ትልቅ ነው።',
        tr: "yeissu bet tilik' new.",
        level: 'B2',
        uses: const ['lex_poss_yeissu', 'lex_haus', 'lex_gross', 'lex_copula_new'],
        t: const Tr('Sein Haus ist groß.', 'His house is big.', 'Hans hus är stort.', 'Zijn huis is groot.'),
        chunks: const ['yeissu', 'bet', "tilik'", 'new'],
      ),
      SentenceSpec(
        id: 'sen_safari_yeiswa_bet',
        am: 'የእሷ ቤት ትልቅ ነው።',
        tr: "yeiswa bet tilik' new.",
        level: 'B2',
        uses: const ['lex_poss_yeiswa', 'lex_haus', 'lex_gross', 'lex_copula_new'],
        t: const Tr('Ihr Haus ist groß.', 'Her house is big.', 'Hennes hus är stort.', 'Haar huis is groot.'),
        chunks: const ['yeiswa', 'bet', "tilik'", 'new'],
      ),
    ],
  ));
}

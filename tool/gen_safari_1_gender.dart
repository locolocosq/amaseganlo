// Safari (Etappe 24 Nachtrag 2): the final, capstone station. Unlike every
// other unit in this app, this one introduces almost no new *vocabulary* -
// on request, it should teach only the male/female differences (how they're
// pronounced, how they change a sentence), built entirely out of words
// every earlier station already taught. The only genuinely new items are
// the four copula/"to be" forms themselves (ነው/ናት/ነህ/ነሽ) - these are the
// actual "difference" being taught, not vocabulary in the usual sense, and
// every content word around them (አንተ/አንቺ, እሱ/እሷ, and every adjective) is
// reused via its existing lexeme id from earlier stations. Amharic
// adjectives themselves do NOT change for gender - only the pronoun and the
// copula do - and that contrast is exactly what these five sentence pairs
// are built to make visible.
import 'content_lib.dart';

void main() {
  writeUnit(UnitSpec(
    id: 'unit_safari_frau_mann',
    sectionId: 'sec_safari',
    level: 'B2',
    topic: 'gender_grammar',
    title: const Tr('Sie und er: die Unterschiede', 'She and he: the differences', 'Hon och han: skillnaderna', 'Zij en hij: de verschillen'),
    lexemes: [
      LexemeSpec(
        id: 'lex_copula_new',
        am: 'ነው',
        tr: 'new',
        pos: 'particle',
        topic: 'gender_grammar',
        level: 'B2',
        verified: true,
        t: const Tr('ist (er/es - männlich oder allgemein)', 'is (he/it - masculine or generic)', 'är (han/det - maskulinum eller generiskt)', 'is (hij/het - mannelijk of algemeen)'),
      ),
      LexemeSpec(
        id: 'lex_copula_nat',
        am: 'ናት',
        tr: 'nat',
        pos: 'particle',
        topic: 'gender_grammar',
        level: 'B2',
        verified: true,
        t: const Tr('ist (sie - weiblich)', 'is (she - feminine)', 'är (hon - feminimum)', 'is (zij - vrouwelijk)'),
      ),
      LexemeSpec(
        id: 'lex_copula_neh',
        am: 'ነህ',
        tr: 'neh',
        pos: 'particle',
        topic: 'gender_grammar',
        level: 'B2',
        verified: true,
        t: const Tr('bist (du - männlich)', 'are (you - masculine)', 'är (du - maskulinum)', 'ben (jij - mannelijk)'),
      ),
      LexemeSpec(
        id: 'lex_copula_nesh',
        am: 'ነሽ',
        tr: 'nesh',
        pos: 'particle',
        topic: 'gender_grammar',
        level: 'B2',
        verified: true,
        t: const Tr('bist (du - weiblich)', 'are (you - feminine)', 'är (du - femininum)', 'ben (jij - vrouwelijk)'),
      ),
    ],
    sentences: [
      SentenceSpec(
        id: 'sen_safari_issu_deg',
        am: 'እሱ ደግ ነው።',
        tr: 'issu deg new.',
        level: 'B2',
        uses: const ['lex_issu', 'lex_nett', 'lex_copula_new'],
        t: const Tr('Er ist nett.', 'He is kind.', 'Han är snäll.', 'Hij is aardig.'),
        chunks: const ['issu', 'deg', 'new'],
      ),
      SentenceSpec(
        id: 'sen_safari_iswa_deg',
        am: 'እሷ ደግ ናት።',
        tr: 'iswa deg nat.',
        level: 'B2',
        uses: const ['lex_iswa', 'lex_nett', 'lex_copula_nat'],
        t: const Tr('Sie ist nett.', 'She is kind.', 'Hon är snäll.', 'Zij is aardig.'),
        chunks: const ['iswa', 'deg', 'nat'],
      ),
      SentenceSpec(
        id: 'sen_safari_ante_desitegna',
        am: 'አንተ ደስተኛ ነህ።',
        tr: "ante desitegna neh.",
        level: 'B2',
        uses: const ['lex_ante', 'lex_gluecklich', 'lex_copula_neh'],
        t: const Tr('Du (männlich) bist glücklich.', 'You (masc.) are happy.', 'Du (maskulinum) är glad.', 'Jij (mannelijk) bent gelukkig.'),
        chunks: const ['ante', 'desitegna', 'neh'],
      ),
      SentenceSpec(
        id: 'sen_safari_anchi_desitegna',
        am: 'አንቺ ደስተኛ ነሽ።',
        tr: 'anchi desitegna nesh.',
        level: 'B2',
        uses: const ['lex_anchi', 'lex_gluecklich', 'lex_copula_nesh'],
        t: const Tr('Du (weiblich) bist glücklich.', 'You (fem.) are happy.', 'Du (femininum) är glad.', 'Jij (vrouwelijk) bent gelukkig.'),
        chunks: const ['anchi', 'desitegna', 'nesh'],
      ),
      SentenceSpec(
        id: 'sen_safari_issu_tilik',
        am: 'እሱ ትልቅ ነው።',
        tr: "issu tilik' new.",
        level: 'B2',
        uses: const ['lex_issu', 'lex_gross', 'lex_copula_new'],
        t: const Tr('Er ist groß.', 'He is big/tall.', 'Han är stor.', 'Hij is groot.'),
        chunks: const ['issu', "tilik'", 'new'],
      ),
      SentenceSpec(
        id: 'sen_safari_iswa_tilik',
        am: 'እሷ ትልቅ ናት።',
        tr: "iswa tilik' nat.",
        level: 'B2',
        uses: const ['lex_iswa', 'lex_gross', 'lex_copula_nat'],
        t: const Tr('Sie ist groß.', 'She is big/tall.', 'Hon är stor.', 'Zij is groot.'),
        chunks: const ['iswa', "tilik'", 'nat'],
      ),
      SentenceSpec(
        id: 'sen_safari_ante_bilih',
        am: 'አንተ ብልህ ነህ።',
        tr: 'ante bilih neh.',
        level: 'B2',
        uses: const ['lex_ante', 'lex_weise', 'lex_copula_neh'],
        t: const Tr('Du (männlich) bist klug.', 'You (masc.) are smart.', 'Du (maskulinum) är smart.', 'Jij (mannelijk) bent slim.'),
        chunks: const ['ante', 'bilih', 'neh'],
      ),
      SentenceSpec(
        id: 'sen_safari_anchi_bilih',
        am: 'አንቺ ብልህ ነሽ።',
        tr: 'anchi bilih nesh.',
        level: 'B2',
        uses: const ['lex_anchi', 'lex_weise', 'lex_copula_nesh'],
        t: const Tr('Du (weiblich) bist klug.', 'You (fem.) are smart.', 'Du (femininum) är smart.', 'Jij (vrouwelijk) bent slim.'),
        chunks: const ['anchi', 'bilih', 'nesh'],
      ),
      SentenceSpec(
        id: 'sen_safari_issu_tinish',
        am: 'እሱ ትንሽ ነው።',
        tr: 'issu tinish new.',
        level: 'B2',
        uses: const ['lex_issu', 'lex_klein', 'lex_copula_new'],
        t: const Tr('Er ist klein.', 'He is small.', 'Han är liten.', 'Hij is klein.'),
        chunks: const ['issu', 'tinish', 'new'],
      ),
      SentenceSpec(
        id: 'sen_safari_iswa_tinish',
        am: 'እሷ ትንሽ ናት።',
        tr: 'iswa tinish nat.',
        level: 'B2',
        uses: const ['lex_iswa', 'lex_klein', 'lex_copula_nat'],
        t: const Tr('Sie ist klein.', 'She is small.', 'Hon är liten.', 'Zij is klein.'),
        chunks: const ['iswa', 'tinish', 'nat'],
      ),
    ],
  ));
}

import 'content_lib.dart';

void main() {
  ensureSection(
    id: 'sec_b1',
    level: 'B1',
    title: const Tr('Niveau B1 — freier sprechen', 'Level B1 — speaking more freely', 'Nivå B1 — tala friare', 'Niveau B1 — vrijer spreken'),
  );

  writeUnit(UnitSpec(
    id: 'unit_gefuehle_meinung',
    sectionId: 'sec_b1',
    level: 'B1',
    topic: 'feelings',
    title: const Tr('Gefühle & Meinung', 'Feelings & opinion', 'Känslor & åsikt', 'Gevoelens & mening'),
    lexemes: [
      LexemeSpec(id: 'lex_gluecklich', am: 'ደስተኛ', tr: 'destegna', pos: 'adjective', topic: 'feelings', level: 'B1', emoji: '😊', verified: true, t: const Tr('glücklich, froh', 'happy', 'glad', 'gelukkig')),
      LexemeSpec(id: 'lex_traurig_phrase', am: 'አዝኛለሁ', tr: 'azegnalehu', pos: 'phrase', topic: 'feelings', level: 'B1', t: const Tr('Ich bin traurig', 'I am sad', 'Jag är ledsen', 'Ik ben verdrietig')),
      LexemeSpec(id: 'lex_wuetend_phrase', am: 'ተቆጥቻለሁ', tr: "tek'ot'chalehu", pos: 'phrase', topic: 'feelings', level: 'B1', t: const Tr('Ich bin wütend', 'I am angry', 'Jag är arg', 'Ik ben boos')),
      LexemeSpec(id: 'lex_angst_phrase', am: 'ፈርቻለሁ', tr: 'ferchalehu', pos: 'phrase', topic: 'feelings', level: 'B1', t: const Tr('Ich habe Angst', 'I am afraid', 'Jag är rädd', 'Ik ben bang')),
      LexemeSpec(id: 'lex_liebe_noun', am: 'ፍቅር', tr: 'fikir', pos: 'noun', topic: 'feelings', level: 'B1', emoji: '❤️', verified: true, t: const Tr('die Liebe', 'love', 'kärlek', 'liefde')),
      LexemeSpec(id: 'lex_freude', am: 'ደስታ', tr: 'desta', pos: 'noun', topic: 'feelings', level: 'B1', verified: true, t: const Tr('die Freude, das Glück', 'joy, happiness', 'glädje', 'vreugde')),
      LexemeSpec(id: 'lex_traurigkeit', am: 'ሀዘን', tr: 'hazen', pos: 'noun', topic: 'feelings', level: 'B1', verified: true, t: const Tr('die Traurigkeit', 'sadness', 'sorg', 'verdriet')),
      LexemeSpec(id: 'lex_meinung', am: 'አስተያየት', tr: 'astyayet', pos: 'noun', topic: 'feelings', level: 'B1', t: const Tr('die Meinung', 'opinion', 'åsikt', 'mening')),
      LexemeSpec(id: 'lex_es_scheint_mir', am: 'ይመስለኛል', tr: 'yimeslegnal', pos: 'phrase', topic: 'feelings', level: 'B1', t: const Tr('Ich denke, dass... (es scheint mir)', 'I think that... (it seems to me)', 'Jag tycker att... (det verkar för mig)', 'Ik denk dat... (het lijkt mij)')),
      LexemeSpec(id: 'lex_gefuehl', am: 'ስሜት', tr: 'simet', pos: 'noun', topic: 'feelings', level: 'B1', verified: true, t: const Tr('das Gefühl', 'feeling', 'känsla', 'gevoel')),
      LexemeSpec(id: 'lex_hoffnung', am: 'ተስፋ', tr: 'tesfa', pos: 'noun', topic: 'feelings', level: 'B1', verified: true, t: const Tr('die Hoffnung', 'hope', 'hopp', 'hoop')),
      LexemeSpec(id: 'lex_angst_noun', am: 'ፍርሃት', tr: 'firhat', pos: 'noun', topic: 'feelings', level: 'B1', t: const Tr('die Angst', 'fear', 'rädsla', 'angst')),
      LexemeSpec(id: 'lex_stolz', am: 'ኩራት', tr: 'kurat', pos: 'noun', topic: 'feelings', level: 'B1', t: const Tr('der Stolz', 'pride', 'stolthet', 'trots')),
      LexemeSpec(id: 'lex_schwierig', am: 'ከባድ', tr: 'kebad', pos: 'adjective', topic: 'feelings', level: 'B1', verified: true, t: const Tr('schwierig, schwer', 'difficult, heavy', 'svår, tung', 'moeilijk, zwaar')),
      LexemeSpec(id: 'lex_einfach', am: 'ቀላል', tr: 'kelal', pos: 'adjective', topic: 'feelings', level: 'B1', verified: true, t: const Tr('einfach, leicht', 'easy, simple', 'lätt, enkel', 'makkelijk, eenvoudig')),
      LexemeSpec(id: 'lex_interessant', am: 'አስደሳች', tr: 'asdesach', pos: 'adjective', topic: 'feelings', level: 'B1', t: const Tr('interessant', 'interesting', 'intressant', 'interessant')),
      LexemeSpec(id: 'lex_langweilig', am: 'አሰልቺ', tr: 'aselchi', pos: 'adjective', topic: 'feelings', level: 'B1', t: const Tr('langweilig', 'boring', 'tråkig', 'saai')),
      LexemeSpec(id: 'lex_wichtig', am: 'አስፈላጊ', tr: 'asfelagi', pos: 'adjective', topic: 'feelings', level: 'B1', verified: true, t: const Tr('wichtig', 'important', 'viktig', 'belangrijk')),
      LexemeSpec(id: 'lex_vielleicht', am: 'ይሆናል', tr: 'yihonal', pos: 'adverb', topic: 'feelings', level: 'B1', t: const Tr('vielleicht', 'maybe', 'kanske', 'misschien')),
      LexemeSpec(id: 'lex_natuerlich', am: 'በርግጥ', tr: "bergit'", pos: 'adverb', topic: 'feelings', level: 'B1', t: const Tr('natürlich, sicherlich', 'of course, certainly', 'självklart', 'natuurlijk')),
      LexemeSpec(id: 'lex_richtig', am: 'ትክክል', tr: 'tikikil', pos: 'adjective', topic: 'feelings', level: 'B1', verified: true, t: const Tr('richtig, korrekt', 'correct, right', 'rätt, korrekt', 'juist, correct')),
      LexemeSpec(id: 'lex_falsch', am: 'ስህተት', tr: 'sihtet', pos: 'noun', topic: 'feelings', level: 'B1', verified: true, t: const Tr('falsch, der Fehler', 'wrong, mistake', 'fel', 'fout')),
    ],
    sentences: [
      SentenceSpec(id: 'sen_destegna_negn', am: 'እኔ ደስተኛ ነኝ።', tr: 'ine destegna negn.', level: 'B1', uses: ['lex_ine', 'lex_gluecklich'], chunks: ['ine', 'destegna', 'negn'], t: const Tr('Ich bin glücklich.', 'I am happy.', 'Jag är glad.', 'Ik ben gelukkig.')),
      SentenceSpec(id: 'sen_fikir_kilki_new', am: 'ፍቅር ቁልፍ ነው።', tr: 'fikir kulf new.', level: 'B1', uses: ['lex_liebe_noun', 'lex_schluessel'], chunks: ['fikir', 'kulf', 'new'], t: const Tr('Liebe ist ein Schlüssel.', 'Love is a key.', 'Kärlek är en nyckel.', 'Liefde is een sleutel.'), verified: false),
    ],
  ));

  writeUnit(UnitSpec(
    id: 'unit_zukunft_wuensche',
    sectionId: 'sec_b1',
    level: 'B1',
    topic: 'future_wishes',
    title: const Tr('Zukunft & Wünsche', 'Future & wishes', 'Framtid & önskningar', 'Toekomst & wensen'),
    lexemes: [
      LexemeSpec(id: 'lex_ich_moechte', am: 'እፈልጋለሁ', tr: 'ifeligalehu', pos: 'phrase', topic: 'future_wishes', level: 'B1', t: const Tr('ich möchte, ich will', 'I want', 'jag vill', 'ik wil')),
      LexemeSpec(id: 'lex_plan', am: 'ፕላን', tr: 'plan', pos: 'noun', topic: 'future_wishes', level: 'B1', verified: true, t: const Tr('der Plan', 'plan', 'plan', 'plan')),
      LexemeSpec(id: 'lex_traum', am: 'ህልም', tr: 'hilm', pos: 'noun', topic: 'future_wishes', level: 'B1', emoji: '💭', verified: true, t: const Tr('der Traum', 'dream', 'dröm', 'droom')),
      LexemeSpec(id: 'lex_wunsch', am: 'ምኞት', tr: 'minyot', pos: 'noun', topic: 'future_wishes', level: 'B1', t: const Tr('der Wunsch', 'wish', 'önskan', 'wens')),
      LexemeSpec(id: 'lex_ziel', am: 'ግብ', tr: 'gib', pos: 'noun', topic: 'future_wishes', level: 'B1', t: const Tr('das Ziel', 'goal', 'mål', 'doel')),
      LexemeSpec(id: 'lex_eines_tages', am: 'በአንድ ቀን', tr: 'beand ken', pos: 'phrase', topic: 'future_wishes', level: 'B1', t: const Tr('eines Tages', 'one day', 'en dag', 'ooit')),
      LexemeSpec(id: 'lex_zukunft', am: 'ወደፊት', tr: 'wedefit', pos: 'noun', topic: 'future_wishes', level: 'B1', t: const Tr('die Zukunft, in Zukunft', 'the future, ahead', 'framtiden, framöver', 'de toekomst, voortaan')),
      LexemeSpec(id: 'lex_erfolg', am: 'ስኬት', tr: 'sikiet', pos: 'noun', topic: 'future_wishes', level: 'B1', t: const Tr('der Erfolg', 'success', 'framgång', 'succes')),
      LexemeSpec(id: 'lex_v_versuchen', am: 'መሞከር', tr: 'memoker', pos: 'verb', topic: 'future_wishes', level: 'B1', t: const Tr('versuchen', 'to try', 'försöka', 'proberen')),
      LexemeSpec(id: 'lex_v_entscheiden', am: 'መወሰን', tr: 'meweosen', pos: 'verb', topic: 'future_wishes', level: 'B1', t: const Tr('entscheiden', 'to decide', 'besluta', 'beslissen')),
      LexemeSpec(id: 'lex_v_aendern', am: 'መቀየር', tr: 'mekeyer', pos: 'verb', topic: 'future_wishes', level: 'B1', t: const Tr('ändern', 'to change', 'ändra', 'veranderen')),
      LexemeSpec(id: 'lex_v_hoffen', am: 'ተስፋ ማድረግ', tr: 'tesfa madirege', pos: 'verb', topic: 'future_wishes', level: 'B1', t: const Tr('hoffen', 'to hope', 'hoppas', 'hopen')),
    ],
    sentences: [
      SentenceSpec(id: 'sen_hilm_alegn', am: 'ትልቅ ህልም አለኝ።', tr: 'tilik hilm alegn.', level: 'B1', uses: ['lex_gross', 'lex_traum'], chunks: ['tilik', 'hilm', 'alegn'], t: const Tr('Ich habe einen großen Traum.', 'I have a big dream.', 'Jag har en stor dröm.', 'Ik heb een grote droom.'), verified: false),
    ],
  ));

  writeUnit(UnitSpec(
    id: 'unit_hoeflichkeit_kultur',
    sectionId: 'sec_b1',
    level: 'B1',
    topic: 'culture',
    title: const Tr('Höflichkeit & Kultur', 'Politeness & culture', 'Artighet & kultur', 'Beleefdheid & cultuur'),
    lexemes: [
      LexemeSpec(id: 'lex_kaffeezeremonie', am: 'የቡና ሥርዓት', tr: 'yebuna sirat', pos: 'noun', topic: 'culture', level: 'B1', emoji: '☕', t: const Tr('die Kaffeezeremonie', 'coffee ceremony', 'kaffeceremoni', 'koffieceremonie')),
      LexemeSpec(id: 'lex_feiertag', am: 'በዓል', tr: "be'al", pos: 'noun', topic: 'culture', level: 'B1', emoji: '🎉', verified: true, t: const Tr('der Feiertag, das Fest', 'holiday, festival', 'helgdag, högtid', 'feestdag')),
      LexemeSpec(id: 'lex_gast', am: 'እንግዳ', tr: 'ingida', pos: 'noun', topic: 'culture', level: 'B1', verified: true, t: const Tr('der Gast', 'guest', 'gäst', 'gast')),
      LexemeSpec(id: 'lex_willkommen', am: 'እንኳን ደህና መጣህ', tr: 'inkuan dehna metah', pos: 'phrase', topic: 'culture', level: 'B1', t: const Tr('Willkommen (zu einem Mann)', 'Welcome (to a man)', 'Välkommen (till en man)', 'Welkom (tegen een man)')),
      LexemeSpec(id: 'lex_kultur', am: 'ባህል', tr: 'bahil', pos: 'noun', topic: 'culture', level: 'B1', verified: true, t: const Tr('die Kultur', 'culture', 'kultur', 'cultuur')),
      LexemeSpec(id: 'lex_tradition', am: 'ልማድ', tr: 'limad', pos: 'noun', topic: 'culture', level: 'B1', t: const Tr('die Tradition, der Brauch', 'tradition, custom', 'tradition', 'traditie')),
      LexemeSpec(id: 'lex_religion', am: 'ሃይማኖት', tr: 'haymanot', pos: 'noun', topic: 'culture', level: 'B1', verified: true, t: const Tr('die Religion', 'religion', 'religion', 'religie')),
      LexemeSpec(id: 'lex_geschenk', am: 'ስጦታ', tr: "sit'ota", pos: 'noun', topic: 'culture', level: 'B1', emoji: '🎁', verified: true, t: const Tr('das Geschenk', 'gift', 'present', 'cadeau')),
      LexemeSpec(id: 'lex_hochzeit', am: 'ሰርግ', tr: 'serg', pos: 'noun', topic: 'culture', level: 'B1', emoji: '💒', verified: true, t: const Tr('die Hochzeit', 'wedding', 'bröllop', 'bruiloft')),
      LexemeSpec(id: 'lex_geburtstag', am: 'የልደት ቀን', tr: 'yelidet ken', pos: 'noun', topic: 'culture', level: 'B1', emoji: '🎂', t: const Tr('der Geburtstag', 'birthday', 'födelsedag', 'verjaardag')),
      LexemeSpec(id: 'lex_respekt', am: 'አክብሮት', tr: 'akbirot', pos: 'noun', topic: 'culture', level: 'B1', t: const Tr('der Respekt', 'respect', 'respekt', 'respect')),
      LexemeSpec(id: 'lex_gastgeber', am: 'አስተናጋጅ', tr: 'astenagaj', pos: 'noun', topic: 'culture', level: 'B1', t: const Tr('der Gastgeber', 'host', 'värd', 'gastheer')),
      LexemeSpec(id: 'lex_fest', am: 'ድግስ', tr: 'digis', pos: 'noun', topic: 'culture', level: 'B1', emoji: '🎊', t: const Tr('das Fest, die Feier', 'party, feast', 'fest', 'feest')),
      LexemeSpec(id: 'lex_enkutatash', am: 'እንቁጣጣሽ', tr: 'inkutatash', pos: 'noun', topic: 'culture', level: 'B1', t: const Tr('das äthiopische Neujahr', 'Ethiopian New Year', 'etiopiskt nyår', 'Ethiopisch nieuwjaar')),
      LexemeSpec(id: 'lex_meskel', am: 'መስቀል', tr: 'meskel', pos: 'noun', topic: 'culture', level: 'B1', verified: true, t: const Tr('Meskel (Kreuzesfest), das Kreuz', 'Meskel (finding of the cross), cross', 'Meskel (korsets högtid), kors', 'Meskel (kruisvindingsfeest), kruis')),
      LexemeSpec(id: 'lex_timkat', am: 'ጥምቀት', tr: "timk'et", pos: 'noun', topic: 'culture', level: 'B1', t: const Tr('Timkat (äthiopisches Dreikönigsfest)', 'Timkat (Ethiopian Epiphany)', 'Timkat (etiopisk trettondag)', 'Timkat (Ethiopisch Driekoningen)')),
    ],
    sentences: [
      SentenceSpec(id: 'sen_ingida_konjo', am: 'እንግዳው ደስተኛ ነው።', tr: 'ingidaw destegna new.', level: 'B1', uses: ['lex_gast', 'lex_gluecklich'], chunks: ['ingidaw', 'destegna', 'new'], t: const Tr('Der Gast ist glücklich.', 'The guest is happy.', 'Gästen är glad.', 'De gast is blij.'), verified: false),
    ],
  ));

  writeUnit(UnitSpec(
    id: 'unit_erzaehlen',
    sectionId: 'sec_b1',
    level: 'B1',
    topic: 'storytelling',
    title: const Tr('Erzählen', 'Storytelling', 'Att berätta', 'Vertellen'),
    lexemes: [
      LexemeSpec(id: 'lex_geschichte', am: 'ታሪክ', tr: 'tarik', pos: 'noun', topic: 'storytelling', level: 'B1', emoji: '📜', verified: true, t: const Tr('die Geschichte', 'story, history', 'historia, berättelse', 'verhaal, geschiedenis')),
      LexemeSpec(id: 'lex_es_war_einmal', am: 'አንድ ጊዜ', tr: 'and gize', pos: 'phrase', topic: 'storytelling', level: 'B1', t: const Tr('es war einmal, einmal', 'once upon a time', 'det var en gång', 'er was eens')),
      LexemeSpec(id: 'lex_ende', am: 'መጨረሻ', tr: 'mecheresha', pos: 'noun', topic: 'storytelling', level: 'B1', t: const Tr('das Ende', 'end', 'slut', 'einde')),
      LexemeSpec(id: 'lex_anfang', am: 'መጀመሪያ', tr: 'mejemeria', pos: 'noun', topic: 'storytelling', level: 'B1', verified: true, t: const Tr('der Anfang', 'beginning', 'början', 'begin')),
      LexemeSpec(id: 'lex_held', am: 'ጀግና', tr: 'jegna', pos: 'noun', topic: 'storytelling', level: 'B1', emoji: '🦸', verified: true, t: const Tr('der Held', 'hero', 'hjälte', 'held')),
      LexemeSpec(id: 'lex_koenig', am: 'ንጉስ', tr: 'nigus', pos: 'noun', topic: 'storytelling', level: 'B1', emoji: '👑', verified: true, t: const Tr('der König', 'king', 'kung', 'koning')),
      LexemeSpec(id: 'lex_koenigin', am: 'ንግስት', tr: 'nigist', pos: 'noun', topic: 'storytelling', level: 'B1', emoji: '👑', verified: true, t: const Tr('die Königin', 'queen', 'drottning', 'koningin')),
      LexemeSpec(id: 'lex_maerchen', am: 'ተረት', tr: 'teret', pos: 'noun', topic: 'storytelling', level: 'B1', verified: true, t: const Tr('das Märchen, die Fabel', 'fable, tale', 'saga', 'fabel, sprookje')),
      LexemeSpec(id: 'lex_v_erzaehlen', am: 'መተረት', tr: 'meteret', pos: 'verb', topic: 'storytelling', level: 'B1', t: const Tr('erzählen', 'to tell (a story)', 'berätta', 'vertellen')),
      LexemeSpec(id: 'lex_v_zuhoeren', am: 'ማዳመጥ', tr: "madamet'", pos: 'verb', topic: 'storytelling', level: 'B1', t: const Tr('zuhören', 'to listen', 'lyssna', 'luisteren')),
      LexemeSpec(id: 'lex_frage_noun', am: 'ጥያቄ', tr: "t'iyak'e", pos: 'noun', topic: 'storytelling', level: 'B1', verified: true, t: const Tr('die Frage', 'question', 'fråga', 'vraag')),
      LexemeSpec(id: 'lex_antwort_noun', am: 'መልስ', tr: 'mels', pos: 'noun', topic: 'storytelling', level: 'B1', verified: true, t: const Tr('die Antwort', 'answer', 'svar', 'antwoord')),
      LexemeSpec(id: 'lex_wort', am: 'ቃል', tr: "k'al", pos: 'noun', topic: 'storytelling', level: 'B1', verified: true, t: const Tr('das Wort', 'word', 'ord', 'woord')),
      LexemeSpec(id: 'lex_sprache', am: 'ቋንቋ', tr: "k'wank'wa", pos: 'noun', topic: 'storytelling', level: 'B1', verified: true, t: const Tr('die Sprache', 'language', 'språk', 'taal')),
      LexemeSpec(id: 'lex_weise', am: 'ብልህ', tr: 'bilih', pos: 'adjective', topic: 'storytelling', level: 'B1', t: const Tr('weise, klug', 'wise, clever', 'vis, klok', 'wijs, slim')),
      LexemeSpec(id: 'lex_dumm', am: 'ሞኝ', tr: 'mogn', pos: 'adjective', topic: 'storytelling', level: 'B1', t: const Tr('dumm', 'foolish', 'dum', 'dom')),
      LexemeSpec(id: 'lex_wahr', am: 'እውነት', tr: 'iwinet', pos: 'noun', topic: 'storytelling', level: 'B1', verified: true, t: const Tr('wahr, die Wahrheit', 'true, truth', 'sann, sanning', 'waar, waarheid')),
      LexemeSpec(id: 'lex_luege', am: 'ውሸት', tr: 'wishet', pos: 'noun', topic: 'storytelling', level: 'B1', verified: true, t: const Tr('die Lüge', 'lie', 'lögn', 'leugen')),
    ],
    sentences: [
      SentenceSpec(id: 'sen_and_gize_nigus', am: 'አንድ ጊዜ አንድ ንጉስ ነበረ።', tr: 'and gize and nigus nebere.', level: 'B1', uses: ['lex_es_war_einmal', 'lex_koenig'], chunks: ['and', 'gize', 'and', 'nigus', 'nebere'], t: const Tr('Es war einmal ein König.', 'Once upon a time there was a king.', 'Det var en gång en kung.', 'Er was eens een koning.'), verified: false),
    ],
  ));
}

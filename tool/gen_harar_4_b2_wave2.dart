// Harar B2, zweite Welle (Etappe 24 Nachtrag 3): weiteres "restliches B2"-
// Vokabular. Jedes Wort wurde einzeln per grep gegen alle bestehenden
// lexemes_*.json geprüft, bevor es hier aufgenommen wurde - dabei stellte
// sich heraus, dass mehrere ursprünglich geplante Themen (Naturkatastrophen,
// Wissenschaft, Konjunktionen/Diskursverbindungen, Kunst & Musik, Recht)
// bereits vollständig eigene Units haben (lexemes_naturkatastrophen.json,
// lexemes_wissenschaft.json, lexemes_konjunktionen.json,
// lexemes_kunst_musik_mehr.json, plus "recht_justiz" aus gen_supplement_e),
// weshalb diese Welle gezielt in die verbleibenden Lücken geht: Diplomatie,
// Gesellschaft/Menschenrechte, Gesundheit (vertieft), Bildungssystem,
// zusätzliche Diskursverbindungen (die "ስለዚህ"/deshalb schon kennen, aber
// nicht "ሆኖም"/jedoch, "ለምሳሌ"/zum Beispiel usw.), Geschichte & Erbe,
// Infrastruktur, Wirtschaft (vertieft), Umwelt (vertieft) und Technologie
// (vertieft).
import 'content_lib.dart';

void main() {
  writeUnit(UnitSpec(
    id: 'unit_harar_diplomatie',
    sectionId: 'sec_harar',
    level: 'B2',
    topic: 'diplomacy',
    title: const Tr('Diplomatie', 'Diplomacy', 'Diplomati', 'Diplomatie'),
    lexemes: [
      LexemeSpec(id: 'lex_embasi', am: 'ኤምባሲ', tr: 'embasi', pos: 'noun', topic: 'diplomacy', level: 'B2', verified: true, t: const Tr('die Botschaft (diplomatisch)', 'embassy', 'ambassaden', 'de ambassade')),
      LexemeSpec(id: 'lex_ambasader', am: 'አምባሳደር', tr: 'ambasader', pos: 'noun', topic: 'diplomacy', level: 'B2', verified: true, t: const Tr('der Botschafter, die Botschafterin', 'ambassador', 'ambassadör', 'ambassadeur')),
      LexemeSpec(id: 'lex_siminet', am: 'ስምምነት', tr: 'siminet', pos: 'noun', topic: 'diplomacy', level: 'B2', verified: true, t: const Tr('das Abkommen, der Vertrag', 'agreement, treaty', 'avtal, fördrag', 'overeenkomst, verdrag')),
      LexemeSpec(id: 'lex_diridir', am: 'ድርድር', tr: 'diridir', pos: 'noun', topic: 'diplomacy', level: 'B2', verified: true, t: const Tr('die Verhandlung', 'negotiation', 'förhandling', 'onderhandeling')),
      LexemeSpec(id: 'lex_timiret', am: 'ጥምረት', tr: "t'imiret", pos: 'noun', topic: 'diplomacy', level: 'B2', verified: true, t: const Tr('das Bündnis', 'alliance', 'allians', 'alliantie')),
      LexemeSpec(id: 'lex_v_mederader', am: 'መደራደር', tr: 'mederader', pos: 'verb', topic: 'diplomacy', level: 'B2', verified: true, t: const Tr('verhandeln', 'to negotiate', 'förhandla', 'onderhandelen')),
    ],
    sentences: [],
  ));

  writeUnit(UnitSpec(
    id: 'unit_harar_gesellschaft',
    sectionId: 'sec_harar',
    level: 'B2',
    topic: 'society_rights',
    title: const Tr('Gesellschaft & Menschenrechte', 'Society & human rights', 'Samhälle & mänskliga rättigheter', 'Maatschappij & mensenrechten'),
    lexemes: [
      LexemeSpec(id: 'lex_ikulinet', am: 'እኩልነት', tr: 'ikulinet', pos: 'noun', topic: 'society_rights', level: 'B2', verified: true, t: const Tr('die Gleichheit', 'equality', 'jämlikhet', 'gelijkheid')),
      LexemeSpec(id: 'lex_medilewo', am: 'መድልዎ', tr: 'medilewo', pos: 'noun', topic: 'society_rights', level: 'B2', t: const Tr('die Diskriminierung', 'discrimination', 'diskriminering', 'discriminatie')),
      LexemeSpec(id: 'lex_anasa', am: 'አናሳ', tr: 'anasa', pos: 'noun', topic: 'society_rights', level: 'B2', t: const Tr('die Minderheit', 'minority', 'minoritet', 'minderheid')),
      LexemeSpec(id: 'lex_sidetegna', am: 'ስደተኛ', tr: 'sidetegna', pos: 'noun', topic: 'society_rights', level: 'B2', verified: true, t: const Tr('der Flüchtling, der Migrant', 'refugee, migrant', 'flykting, migrant', 'vluchteling, migrant')),
      LexemeSpec(id: 'lex_adj_fitihawi', am: 'ፍትሃዊ', tr: 'fitihawi', pos: 'adjective', topic: 'society_rights', level: 'B2', verified: true, t: const Tr('gerecht, fair', 'just, fair', 'rättvis', 'rechtvaardig')),
      LexemeSpec(id: 'lex_adj_ifitihawi', am: 'ኢፍትሃዊ', tr: 'ifitihawi', pos: 'adjective', topic: 'society_rights', level: 'B2', verified: true, t: const Tr('ungerecht, unfair', 'unjust, unfair', 'orättvis', 'onrechtvaardig')),
    ],
    sentences: [],
  ));

  writeUnit(UnitSpec(
    id: 'unit_harar_gesundheit2',
    sectionId: 'sec_harar',
    level: 'B2',
    topic: 'health_advanced',
    title: const Tr('Gesundheit (vertieft)', 'Health (advanced)', 'Hälsa (fördjupat)', 'Gezondheid (verdiept)'),
    lexemes: [
      LexemeSpec(id: 'lex_mirmera', am: 'ምርመራ', tr: 'mirmera', pos: 'noun', topic: 'health_advanced', level: 'B2', verified: true, t: const Tr('die Diagnose, die Untersuchung', 'diagnosis, examination', 'diagnos, undersökning', 'diagnose, onderzoek')),
      LexemeSpec(id: 'lex_hikimina', am: 'ህክምና', tr: 'hikimina', pos: 'noun', topic: 'health_advanced', level: 'B2', verified: true, t: const Tr('die Behandlung, die Medizin', 'treatment, medicine', 'behandling, medicin', 'behandeling, geneeskunde')),
      LexemeSpec(id: 'lex_kedo_tigena', am: 'ቀዶ ጥገና', tr: "k'edo t'igena", pos: 'noun', topic: 'health_advanced', level: 'B2', t: const Tr('die Operation', 'surgery', 'operation', 'operatie')),
      LexemeSpec(id: 'lex_milikit', am: 'ምልክት', tr: 'milikit', pos: 'noun', topic: 'health_advanced', level: 'B2', verified: true, t: const Tr('das Symptom, das Zeichen', 'symptom, sign', 'symtom, tecken', 'symptoom, teken')),
      LexemeSpec(id: 'lex_adj_siryesedede', am: 'ስር የሰደደ', tr: 'sir yesedede', pos: 'adjective', topic: 'health_advanced', level: 'B2', t: const Tr('chronisch', 'chronic', 'kronisk', 'chronisch')),
      LexemeSpec(id: 'lex_v_makem', am: 'ማከም', tr: 'makem', pos: 'verb', topic: 'health_advanced', level: 'B2', verified: true, t: const Tr('behandeln (medizinisch)', 'to treat (medically)', 'behandla (medicinskt)', 'behandelen (medisch)')),
    ],
    sentences: [],
  ));

  writeUnit(UnitSpec(
    id: 'unit_harar_bildung',
    sectionId: 'sec_harar',
    level: 'B2',
    topic: 'education_system',
    title: const Tr('Bildungssystem', 'Education system', 'Utbildningssystem', 'Onderwijssysteem'),
    lexemes: [
      LexemeSpec(id: 'lex_digiri', am: 'ዲግሪ', tr: 'digiri', pos: 'noun', topic: 'education_system', level: 'B2', verified: true, t: const Tr('der Abschluss, der Grad', 'degree', 'examen, grad', 'diploma, graad')),
      LexemeSpec(id: 'lex_temeraki', am: 'ተመራቂ', tr: 'temeraki', pos: 'noun', topic: 'education_system', level: 'B2', t: const Tr('der Absolvent, die Absolventin', 'graduate', 'utexaminerad', 'afgestudeerde')),
      LexemeSpec(id: 'lex_skolarship', am: 'ስኮላርሺፕ', tr: 'skolarship', pos: 'noun', topic: 'education_system', level: 'B2', t: const Tr('das Stipendium', 'scholarship', 'stipendium', 'studiebeurs')),
      LexemeSpec(id: 'lex_sirate_timihirt', am: 'ሥርዓተ ትምህርት', tr: 'sirate timihirt', pos: 'noun', topic: 'education_system', level: 'B2', t: const Tr('der Lehrplan', 'curriculum', 'läroplan', 'curriculum')),
      LexemeSpec(id: 'lex_v_memerek', am: 'መመረቅ', tr: 'memerek', pos: 'verb', topic: 'education_system', level: 'B2', t: const Tr('graduieren, den Abschluss machen', 'to graduate', 'ta examen', 'afstuderen')),
    ],
    sentences: [],
  ));

  writeUnit(UnitSpec(
    id: 'unit_harar_diskurs2',
    sectionId: 'sec_harar',
    level: 'B2',
    topic: 'discourse_connectors_2',
    title: const Tr('Diskursverbindungen (2)', 'Discourse connectors (2)', 'Diskursmarkörer (2)', 'Discoursemarkers (2)'),
    lexemes: [
      LexemeSpec(id: 'lex_honom', am: 'ሆኖም', tr: 'honom', pos: 'conjunction', topic: 'discourse_connectors_2', level: 'B2', verified: true, t: const Tr('jedoch, allerdings', 'however', 'dock, emellertid', 'echter, evenwel')),
      LexemeSpec(id: 'lex_lemisale', am: 'ለምሳሌ', tr: 'lemisale', pos: 'conjunction', topic: 'discourse_connectors_2', level: 'B2', verified: true, t: const Tr('zum Beispiel', 'for example', 'till exempel', 'bijvoorbeeld')),
      LexemeSpec(id: 'lex_beatekalay', am: 'በአጠቃላይ', tr: "be'atek'alay", pos: 'conjunction', topic: 'discourse_connectors_2', level: 'B2', verified: true, t: const Tr('im Allgemeinen, insgesamt', 'generally, overall', 'i allmänhet', 'over het algemeen')),
      LexemeSpec(id: 'lex_bematekaleya', am: 'በማጠቃለያ', tr: "bemat'ek'aleya", pos: 'conjunction', topic: 'discourse_connectors_2', level: 'B2', t: const Tr('abschließend, zusammenfassend', 'in conclusion', 'sammanfattningsvis', 'tot slot')),
      LexemeSpec(id: 'lex_kezih_betechemari', am: 'ከዚህ በተጨማሪ', tr: 'kezih betechemari', pos: 'conjunction', topic: 'discourse_connectors_2', level: 'B2', t: const Tr('außerdem, zusätzlich dazu', 'in addition, furthermore', 'dessutom', 'bovendien')),
    ],
    sentences: [],
  ));

  writeUnit(UnitSpec(
    id: 'unit_harar_geschichte',
    sectionId: 'sec_harar',
    level: 'B2',
    topic: 'history_heritage',
    title: const Tr('Geschichte & Erbe', 'History & heritage', 'Historia & arv', 'Geschiedenis & erfgoed'),
    lexemes: [
      LexemeSpec(id: 'lex_tewifit', am: 'ትውፊት', tr: 'tewifit', pos: 'noun', topic: 'history_heritage', level: 'B2', t: const Tr('die Tradition (überliefert)', 'tradition (handed down)', 'tradition (nedärvd)', 'traditie (overgeleverd)')),
      LexemeSpec(id: 'lex_kirs', am: 'ቅርስ', tr: 'kirs', pos: 'noun', topic: 'history_heritage', level: 'B2', verified: true, t: const Tr('das Erbe (kulturell)', 'heritage', 'kulturarv', 'erfgoed')),
      LexemeSpec(id: 'lex_maninet', am: 'ማንነት', tr: 'maninet', pos: 'noun', topic: 'history_heritage', level: 'B2', verified: true, t: const Tr('die Identität', 'identity', 'identitet', 'identiteit')),
      LexemeSpec(id: 'lex_kidime_ayat', am: 'ቅድመ አያት', tr: 'kidime ayat', pos: 'noun', topic: 'history_heritage', level: 'B2', t: const Tr('der Vorfahre', 'ancestor', 'förfader', 'voorouder')),
      LexemeSpec(id: 'lex_zemen', am: 'ዘመን', tr: 'zemen', pos: 'noun', topic: 'history_heritage', level: 'B2', verified: true, t: const Tr('die Epoche, das Zeitalter', 'era, age', 'era, tidsålder', 'tijdperk')),
    ],
    sentences: [],
  ));

  writeUnit(UnitSpec(
    id: 'unit_harar_infrastruktur',
    sectionId: 'sec_harar',
    level: 'B2',
    topic: 'infrastructure',
    title: const Tr('Infrastruktur & Stadt', 'Infrastructure & the city', 'Infrastruktur & staden', 'Infrastructuur & de stad'),
    lexemes: [
      LexemeSpec(id: 'lex_awra_godana', am: 'አውራ ጎዳና', tr: 'awra godana', pos: 'noun', topic: 'infrastructure', level: 'B2', t: const Tr('die Hauptstraße, die Autobahn', 'highway, main road', 'huvudväg, motorväg', 'hoofdweg, snelweg')),
      LexemeSpec(id: 'lex_trafik_mechinanek', am: 'ትራፊክ መጨናነቅ', tr: "trafik mechinanek'", pos: 'noun', topic: 'infrastructure', level: 'B2', t: const Tr('der Stau', 'traffic jam', 'trafikstockning', 'file')),
      LexemeSpec(id: 'lex_ginibata', am: 'ግንባታ', tr: 'ginibata', pos: 'noun', topic: 'infrastructure', level: 'B2', verified: true, t: const Tr('der Bau, die Konstruktion', 'construction', 'byggande', 'bouw')),
      LexemeSpec(id: 'lex_yeketema_plan', am: 'የከተማ ፕላን', tr: 'yeketema plan', pos: 'noun', topic: 'infrastructure', level: 'B2', t: const Tr('die Stadtplanung', 'urban planning', 'stadsplanering', 'stadsplanning')),
      LexemeSpec(id: 'lex_meserete_limat', am: 'መሠረተ ልማት', tr: 'meserete limat', pos: 'noun', topic: 'infrastructure', level: 'B2', verified: true, t: const Tr('die Infrastruktur', 'infrastructure', 'infrastruktur', 'infrastructuur')),
      LexemeSpec(id: 'lex_v_megenibat', am: 'መገንባት', tr: 'megenibat', pos: 'verb', topic: 'infrastructure', level: 'B2', verified: true, t: const Tr('bauen, errichten', 'to build, to construct', 'bygga', 'bouwen')),
    ],
    sentences: [],
  ));

  writeUnit(UnitSpec(
    id: 'unit_harar_wirtschaft3',
    sectionId: 'sec_harar',
    level: 'B2',
    topic: 'economy_advanced',
    title: const Tr('Wirtschaft (vertieft)', 'Economy (advanced)', 'Ekonomi (fördjupat)', 'Economie (verdiept)'),
    lexemes: [
      LexemeSpec(id: 'lex_tirif', am: 'ትርፍ', tr: 'tirif', pos: 'noun', topic: 'economy_advanced', level: 'B2', verified: true, t: const Tr('der Gewinn, der Profit', 'profit, gain', 'vinst', 'winst')),
      LexemeSpec(id: 'lex_kisara', am: 'ኪሳራ', tr: 'kisara', pos: 'noun', topic: 'economy_advanced', level: 'B2', verified: true, t: const Tr('der Verlust', 'loss', 'förlust', 'verlies')),
      LexemeSpec(id: 'lex_investiment', am: 'ኢንቨስትመንት', tr: 'investiment', pos: 'noun', topic: 'economy_advanced', level: 'B2', verified: true, t: const Tr('die Investition', 'investment', 'investering', 'investering')),
      LexemeSpec(id: 'lex_yeaksiyon_gebeya', am: 'የአክሲዮን ገበያ', tr: "ye'aksiyon gebeya", pos: 'noun', topic: 'economy_advanced', level: 'B2', t: const Tr('die Börse', 'stock market', 'börsen', 'de aandelenmarkt')),
      LexemeSpec(id: 'lex_yewaga_gishibet', am: 'የዋጋ ግሽበት', tr: 'yewaga gishibet', pos: 'noun', topic: 'economy_advanced', level: 'B2', t: const Tr('die Inflation', 'inflation', 'inflation', 'inflatie')),
    ],
    sentences: [],
  ));

  writeUnit(UnitSpec(
    id: 'unit_harar_umwelt2',
    sectionId: 'sec_harar',
    level: 'B2',
    topic: 'environment_2',
    title: const Tr('Umwelt (vertieft)', 'Environment (advanced)', 'Miljö (fördjupat)', 'Milieu (verdiept)'),
    lexemes: [
      LexemeSpec(id: 'lex_dagim_tikim', am: 'ዳግም ጥቅም ላይ ማዋል', tr: "dagim t'ikim lay mawal", pos: 'noun', topic: 'environment_2', level: 'B2', t: const Tr('das Recycling', 'recycling', 'återvinning', 'recycling')),
      LexemeSpec(id: 'lex_bizha_hiyiwet', am: 'ብዝሃ ሕይወት', tr: 'bizha hiyiwet', pos: 'noun', topic: 'environment_2', level: 'B2', t: const Tr('die biologische Vielfalt', 'biodiversity', 'biologisk mångfald', 'biodiversiteit')),
      LexemeSpec(id: 'lex_v_metifat', am: 'መጥፋት', tr: "met'ifat", pos: 'verb', topic: 'environment_2', level: 'B2', verified: true, t: const Tr('aussterben, verschwinden', 'to become extinct, to disappear', 'dö ut, försvinna', 'uitsterven, verdwijnen')),
      LexemeSpec(id: 'lex_sine_mihidar', am: 'ስነ ምህዳር', tr: 'sine mihidar', pos: 'noun', topic: 'environment_2', level: 'B2', t: const Tr('das Ökosystem', 'ecosystem', 'ekosystem', 'ecosysteem')),
      LexemeSpec(id: 'lex_zelakinet', am: 'ዘላቂነት', tr: 'zelakinet', pos: 'noun', topic: 'environment_2', level: 'B2', verified: true, t: const Tr('die Nachhaltigkeit', 'sustainability', 'hållbarhet', 'duurzaamheid')),
    ],
    sentences: [],
  ));

  writeUnit(UnitSpec(
    id: 'unit_harar_technologie2',
    sectionId: 'sec_harar',
    level: 'B2',
    topic: 'technology_2',
    title: const Tr('Technologie (vertieft)', 'Technology (advanced)', 'Teknik (fördjupat)', 'Technologie (verdiept)'),
    lexemes: [
      LexemeSpec(id: 'lex_sew_serash', am: 'ሰው ሰራሽ አስተውሎት', tr: 'sew serash astewilot', pos: 'noun', topic: 'technology_2', level: 'B2', t: const Tr('die künstliche Intelligenz', 'artificial intelligence', 'artificiell intelligens', 'kunstmatige intelligentie')),
      LexemeSpec(id: 'lex_wihib', am: 'ውሂብ', tr: 'wihib', pos: 'noun', topic: 'technology_2', level: 'B2', verified: true, t: const Tr('die Daten', 'data', 'data', 'gegevens')),
      LexemeSpec(id: 'lex_yeyilef_kal', am: 'የይለፍ ቃል', tr: "yeyilef k'al", pos: 'noun', topic: 'technology_2', level: 'B2', verified: true, t: const Tr('das Passwort', 'password', 'lösenord', 'wachtwoord')),
      LexemeSpec(id: 'lex_dihire_gets', am: 'ድህረ ገጽ', tr: "dihire gets'", pos: 'noun', topic: 'technology_2', level: 'B2', verified: true, t: const Tr('die Website', 'website', 'webbplats', 'website')),
    ],
    sentences: [],
  ));
}

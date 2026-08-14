// Harar, ab Kapitel 3 (Etappe 24 Nachtrag 2): restliches B2-Vokabular, das
// in keiner früheren Station schon vorkam - Politik, Umwelt, Technologie,
// Wirtschaft, Medien, abstraktes Denken. Checked against every existing
// lexemes_*.json before writing (grep for the exact Amharic word) to avoid
// re-teaching what's already known, e.g. "ኢንተርኔት"/Internet, "ስልክ"/Telefon,
// "ገበያ"/Markt (elektronik_kontinente, zahlen_einkaufen), "ሰላም" as the A1.1
// greeting, "ባህል"/Kultur and "ሃይማኖት"/Religion (hoeflichkeit_kultur).
// First of several planned "restliches B2" batches - more topics/units can
// be added the same way via further gen_harar_3_b2_*.dart scripts, exactly
// the "still extensible via a later update" requirement for this station.
import 'content_lib.dart';

void main() {
  writeUnit(UnitSpec(
    id: 'unit_harar_politik',
    sectionId: 'sec_harar',
    level: 'B2',
    topic: 'politics',
    title: const Tr('Politik & Staat', 'Politics & government', 'Politik & stat', 'Politiek & staat'),
    lexemes: [
      LexemeSpec(id: 'lex_mengist', am: 'መንግስት', tr: 'mengist', pos: 'noun', topic: 'politics', level: 'B2', verified: true, t: const Tr('die Regierung, der Staat', 'government, state', 'regeringen, staten', 'de regering, de staat')),
      LexemeSpec(id: 'lex_president', am: 'ፕሬዚዳንት', tr: 'president', pos: 'noun', topic: 'politics', level: 'B2', verified: true, t: const Tr('der Präsident', 'president', 'president', 'president')),
      LexemeSpec(id: 'lex_teklay_minister', am: 'ጠቅላይ ሚኒስትር', tr: "t'ek'ilay minister", pos: 'noun', topic: 'politics', level: 'B2', verified: true, t: const Tr('der Premierminister', 'prime minister', 'premiärminister', 'premier')),
      LexemeSpec(id: 'lex_parlama', am: 'ፓርላማ', tr: 'parlama', pos: 'noun', topic: 'politics', level: 'B2', verified: true, t: const Tr('das Parlament', 'parliament', 'parlamentet', 'het parlement')),
      LexemeSpec(id: 'lex_mircha', am: 'ምርጫ', tr: 'mircha', pos: 'noun', topic: 'politics', level: 'B2', verified: true, t: const Tr('die Wahl (Politik)', 'election', 'val (politik)', 'verkiezing')),
      LexemeSpec(id: 'lex_hige_mengist', am: 'ህገ መንግስት', tr: 'hige mengist', pos: 'noun', topic: 'politics', level: 'B2', verified: true, t: const Tr('die Verfassung', 'constitution', 'grundlagen', 'grondwet')),
      LexemeSpec(id: 'lex_zega', am: 'ዜጋ', tr: 'zega', pos: 'noun', topic: 'politics', level: 'B2', verified: true, t: const Tr('der Bürger, die Bürgerin', 'citizen', 'medborgare', 'burger')),
      LexemeSpec(id: 'lex_siltan', am: 'ስልጣን', tr: 'siltan', pos: 'noun', topic: 'politics', level: 'B2', verified: true, t: const Tr('die Macht, die Amtsgewalt', 'power, authority', 'makt, myndighet', 'macht, gezag')),
      LexemeSpec(id: 'lex_v_memiret', am: 'መምረጥ', tr: "memiret'", pos: 'verb', topic: 'politics', level: 'B2', verified: true, t: const Tr('wählen, auswählen', 'to elect, to choose', 'välja, rösta fram', 'kiezen, verkiezen')),
      LexemeSpec(id: 'lex_adj_dimokrasiyawi', am: 'ዲሞክራሲያዊ', tr: 'dimokrasiyawi', pos: 'adjective', topic: 'politics', level: 'B2', verified: true, t: const Tr('demokratisch', 'democratic', 'demokratisk', 'democratisch')),
    ],
    sentences: [],
  ));

  writeUnit(UnitSpec(
    id: 'unit_harar_umwelt',
    sectionId: 'sec_harar',
    level: 'B2',
    topic: 'environment',
    title: const Tr('Umwelt & Klima', 'Environment & climate', 'Miljö & klimat', 'Milieu & klimaat'),
    lexemes: [
      LexemeSpec(id: 'lex_akababi', am: 'አካባቢ', tr: 'akababi', pos: 'noun', topic: 'environment', level: 'B2', verified: true, t: const Tr('die Umwelt, die Umgebung', 'environment, surroundings', 'miljön, omgivningen', 'omgeving, milieu')),
      LexemeSpec(id: 'lex_ayer_nibret_lewit', am: 'የአየር ንብረት ለውጥ', tr: 'ye ayer nibret lewit\'', pos: 'noun', topic: 'environment', level: 'B2', verified: true, t: const Tr('der Klimawandel', 'climate change', 'klimatförändringen', 'klimaatverandering')),
      LexemeSpec(id: 'lex_bikilet', am: 'ብክለት', tr: 'bikilet', pos: 'noun', topic: 'environment', level: 'B2', verified: true, t: const Tr('die Verschmutzung', 'pollution', 'föroreningen', 'vervuiling')),
      LexemeSpec(id: 'lex_v_mekelakel', am: 'መከላከል', tr: 'mekelakel', pos: 'verb', topic: 'environment', level: 'B2', verified: true, t: const Tr('schützen, verhindern', 'to protect, to prevent', 'skydda, förhindra', 'beschermen, voorkomen')),
      LexemeSpec(id: 'lex_taddis_mekera', am: 'ታዳሽ ኃይል', tr: 'tadash hail', pos: 'noun', topic: 'environment', level: 'B2', t: const Tr('die erneuerbare Energie', 'renewable energy', 'förnybar energi', 'hernieuwbare energie')),
      LexemeSpec(id: 'lex_adj_asfelagi', am: 'አስፈላጊ', tr: 'asfelagi', pos: 'adjective', topic: 'environment', level: 'B2', verified: true, t: const Tr('notwendig, wichtig', 'necessary, important', 'nödvändig, viktig', 'noodzakelijk, belangrijk')),
      LexemeSpec(id: 'lex_kelil', am: 'ክልል', tr: 'kelil', pos: 'noun', topic: 'environment', level: 'B2', verified: true, t: const Tr('die Region, das Bundesland', 'region, state (federal)', 'region, delstat', 'regio, deelstaat')),
    ],
    sentences: [],
  ));

  writeUnit(UnitSpec(
    id: 'unit_harar_technologie',
    sectionId: 'sec_harar',
    level: 'B2',
    topic: 'technology',
    title: const Tr('Technologie & Digitales', 'Technology & digital life', 'Teknik & det digitala', 'Technologie & digitaal leven'),
    lexemes: [
      LexemeSpec(id: 'lex_metegiberiya', am: 'መተግበሪያ', tr: 'metegiberiya', pos: 'noun', topic: 'technology', level: 'B2', verified: true, t: const Tr('die App, die Anwendung', 'app, application', 'app, applikation', 'app, applicatie')),
      LexemeSpec(id: 'lex_teknoloji', am: 'ቴክኖሎጂ', tr: 'teknoloji', pos: 'noun', topic: 'technology', level: 'B2', verified: true, t: const Tr('die Technologie', 'technology', 'teknik', 'technologie')),
      LexemeSpec(id: 'lex_tsehifet_media', am: 'ማህበራዊ ሚዲያ', tr: 'mahiberawi midiya', pos: 'noun', topic: 'technology', level: 'B2', verified: true, t: const Tr('die sozialen Medien', 'social media', 'sociala medier', 'sociale media')),
      LexemeSpec(id: 'lex_v_mewered', am: 'ማውረድ', tr: 'mawered', pos: 'verb', topic: 'technology', level: 'B2', verified: true, t: const Tr('herunterladen', 'to download', 'ladda ner', 'downloaden')),
      LexemeSpec(id: 'lex_v_mekotater', am: 'መቆጣጠር', tr: "mek'ot'at'er", pos: 'verb', topic: 'technology', level: 'B2', verified: true, t: const Tr('kontrollieren, steuern', 'to control', 'kontrollera, styra', 'controleren, besturen')),
      LexemeSpec(id: 'lex_mereja', am: 'መረብ', tr: 'mereb', pos: 'noun', topic: 'technology', level: 'B2', verified: true, t: const Tr('das Netzwerk, das Netz', 'network', 'nätverk', 'netwerk')),
      LexemeSpec(id: 'lex_adj_zemenawi', am: 'ዘመናዊ', tr: 'zemenawi', pos: 'adjective', topic: 'technology', level: 'B2', verified: true, t: const Tr('modern', 'modern', 'modern', 'modern')),
    ],
    sentences: [],
  ));

  writeUnit(UnitSpec(
    id: 'unit_harar_wirtschaft2',
    sectionId: 'sec_harar',
    level: 'B2',
    topic: 'economy_2',
    title: const Tr('Wirtschaft & Handel', 'Economy & trade', 'Ekonomi & handel', 'Economie & handel'),
    lexemes: [
      LexemeSpec(id: 'lex_ikonomi', am: 'ኢኮኖሚ', tr: 'ikonomi', pos: 'noun', topic: 'economy_2', level: 'B2', verified: true, t: const Tr('die Wirtschaft', 'economy', 'ekonomin', 'de economie')),
      LexemeSpec(id: 'lex_nigid', am: 'ንግድ', tr: 'nigid', pos: 'noun', topic: 'economy_2', level: 'B2', verified: true, t: const Tr('der Handel, das Geschäft', 'trade, business', 'handel, affär', 'handel, zaken')),
      LexemeSpec(id: 'lex_v_meishach', am: 'መሸጥ', tr: "meshet'", pos: 'verb', topic: 'economy_2', level: 'B2', verified: true, t: const Tr('verkaufen', 'to sell', 'sälja', 'verkopen')),
      LexemeSpec(id: 'lex_v_madeg', am: 'ማደግ', tr: 'madeg', pos: 'verb', topic: 'economy_2', level: 'B2', verified: true, t: const Tr('wachsen, sich entwickeln', 'to grow, to develop', 'växa, utvecklas', 'groeien, zich ontwikkelen')),
      LexemeSpec(id: 'lex_kiray', am: 'ኪራይ', tr: 'kiray', pos: 'noun', topic: 'economy_2', level: 'B2', verified: true, t: const Tr('die Miete', 'rent', 'hyra', 'huur')),
      LexemeSpec(id: 'lex_mewuadederiya', am: 'ውድድር', tr: 'widider', pos: 'noun', topic: 'economy_2', level: 'B2', verified: true, t: const Tr('der Wettbewerb', 'competition', 'konkurrens', 'concurrentie')),
      LexemeSpec(id: 'lex_adj_rikash', am: 'ርካሽ', tr: 'rikash', pos: 'adjective', topic: 'economy_2', level: 'B2', verified: true, t: const Tr('billig, preiswert', 'cheap, inexpensive', 'billig', 'goedkoop')),
    ],
    sentences: [],
  ));

  writeUnit(UnitSpec(
    id: 'unit_harar_medien',
    sectionId: 'sec_harar',
    level: 'B2',
    topic: 'media',
    title: const Tr('Medien & Öffentlichkeit', 'Media & the public', 'Medier & allmänheten', 'Media & publiek'),
    lexemes: [
      LexemeSpec(id: 'lex_gazeta', am: 'ጋዜጣ', tr: 'gazeta', pos: 'noun', topic: 'media', level: 'B2', verified: true, t: const Tr('die Zeitung', 'newspaper', 'tidningen', 'de krant')),
      LexemeSpec(id: 'lex_gazetegna', am: 'ጋዜጠኛ', tr: 'gazetegna', pos: 'noun', topic: 'media', level: 'B2', verified: true, t: const Tr('der Journalist, die Journalistin', 'journalist', 'journalist', 'journalist')),
      LexemeSpec(id: 'lex_zena', am: 'ዜና', tr: 'zena', pos: 'noun', topic: 'media', level: 'B2', verified: true, t: const Tr('die Nachricht (Medien)', 'news', 'nyheter', 'nieuws')),
      LexemeSpec(id: 'lex_v_meglets', am: 'ማስታወቅ', tr: 'masitawek\'', pos: 'verb', topic: 'media', level: 'B2', verified: true, t: const Tr('bekannt geben, ankündigen', 'to announce', 'tillkännage', 'aankondigen')),
      LexemeSpec(id: 'lex_akera_hasab', am: 'የህዝብ አስተያየት', tr: 'yehizib astayayet', pos: 'noun', topic: 'media', level: 'B2', t: const Tr('die öffentliche Meinung', 'public opinion', 'allmänna opinionen', 'publieke opinie')),
      LexemeSpec(id: 'lex_adj_iwnet', am: 'እውነተኛ', tr: 'iwinetegna', pos: 'adjective', topic: 'media', level: 'B2', verified: true, t: const Tr('wahr, echt, glaubwürdig', 'true, real, credible', 'sann, äkta, trovärdig', 'waar, echt, geloofwaardig')),
    ],
    sentences: [],
  ));

  writeUnit(UnitSpec(
    id: 'unit_harar_denken',
    sectionId: 'sec_harar',
    level: 'B2',
    topic: 'abstract_thought',
    title: const Tr('Denken & Meinung', 'Thought & opinion', 'Tanke & åsikt', 'Denken & mening'),
    lexemes: [
      LexemeSpec(id: 'lex_hasab', am: 'ሃሳብ', tr: 'hasab', pos: 'noun', topic: 'abstract_thought', level: 'B2', verified: true, t: const Tr('die Idee, der Gedanke', 'idea, thought', 'idé, tanke', 'idee, gedachte')),
      LexemeSpec(id: 'lex_v_maseb', am: 'ማሰብ', tr: 'maseb', pos: 'verb', topic: 'abstract_thought', level: 'B2', verified: true, t: const Tr('denken, nachdenken', 'to think', 'tänka', 'denken')),
      LexemeSpec(id: 'lex_v_mekerakeri', am: 'መከራከር', tr: 'mekeraker', pos: 'verb', topic: 'abstract_thought', level: 'B2', t: const Tr('argumentieren, streiten', 'to argue', 'argumentera', 'argumenteren')),
      LexemeSpec(id: 'lex_v_meteret', am: 'መተርጎም', tr: 'meterigom', pos: 'verb', topic: 'abstract_thought', level: 'B2', verified: true, t: const Tr('interpretieren, übersetzen, erklären', 'to interpret, to translate', 'tolka, översätta', 'interpreteren, vertalen')),
      LexemeSpec(id: 'lex_adj_asrachi', am: 'አሳማኝ', tr: 'asamagn', pos: 'adjective', topic: 'abstract_thought', level: 'B2', verified: true, t: const Tr('überzeugend', 'convincing', 'övertygande', 'overtuigend')),
      LexemeSpec(id: 'lex_mikinyat', am: 'ምክንያት', tr: 'mikinyat', pos: 'noun', topic: 'abstract_thought', level: 'B2', verified: true, t: const Tr('der Grund, die Ursache', 'reason, cause', 'anledning, orsak', 'reden, oorzaak')),
    ],
    sentences: [],
  ));
}

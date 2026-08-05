import 'content_lib.dart';

void main() {
  writeUnit(UnitSpec(
    id: 'unit_gefuehle_mehr',
    sectionId: 'sec_a2',
    level: 'A2',
    topic: 'emotions',
    title: const Tr('Gefühle (mehr)', 'Feelings (more)', 'Känslor (mer)', 'Gevoelens (meer)'),
    lexemes: [
      LexemeSpec(id: 'lex_eifersuechtig', am: 'ቀናተኛ', tr: 'kenategna', pos: 'adjective', topic: 'emotions', level: 'A2', t: const Tr('eifersüchtig', 'jealous', 'jalousk', 'jaloers')),
      LexemeSpec(id: 'lex_v_erstaunt', am: 'መገረም', tr: 'megerem', pos: 'verb', topic: 'emotions', level: 'A2', t: const Tr('erstaunt sein, sich wundern', 'to be amazed', 'bli förvånad', 'verbaasd zijn')),
      LexemeSpec(id: 'lex_v_besorgt', am: 'መጨነቅ', tr: "mechenek'", pos: 'verb', topic: 'emotions', level: 'A2', t: const Tr('besorgt sein, sich sorgen', 'to worry', 'oroa sig', 'zich zorgen maken')),
      LexemeSpec(id: 'lex_v_verlegen', am: 'ማፈር', tr: 'mafer', pos: 'verb', topic: 'emotions', level: 'A2', t: const Tr('verlegen/beschämt sein', 'to be embarrassed', 'skämmas', 'zich schamen')),
      LexemeSpec(id: 'lex_einsamkeit', am: 'ብቸኝነት', tr: 'bichegninet', pos: 'noun', topic: 'emotions', level: 'A2', t: const Tr('die Einsamkeit', 'loneliness', 'ensamhet', 'eenzaamheid')),
      LexemeSpec(id: 'lex_v_verwirrt', am: 'መደናገር', tr: 'medenager', pos: 'verb', topic: 'emotions', level: 'A2', t: const Tr('verwirrt sein', 'to be confused', 'bli förvirrad', 'in de war zijn')),
      LexemeSpec(id: 'lex_v_zufrieden', am: 'መርካት', tr: 'merkat', pos: 'verb', topic: 'emotions', level: 'A2', t: const Tr('zufrieden sein', 'to be satisfied', 'vara nöjd', 'tevreden zijn')),
      LexemeSpec(id: 'lex_ruhig', am: 'ጸጥ ያለ', tr: "tset' yale", pos: 'adjective', topic: 'emotions', level: 'A2', t: const Tr('ruhig, still', 'calm, quiet', 'lugn, tyst', 'kalm, stil')),
      LexemeSpec(id: 'lex_neugier', am: 'ጉጉት', tr: 'guggit', pos: 'noun', topic: 'emotions', level: 'A2', t: const Tr('die Neugier', 'curiosity', 'nyfikenhet', 'nieuwsgierigheid')),
    ],
    sentences: [],
  ));

  writeUnit(UnitSpec(
    id: 'unit_persoenlichkeit',
    sectionId: 'sec_a2',
    level: 'A2',
    topic: 'personality',
    title: const Tr('Persönlichkeit', 'Personality', 'Personlighet', 'Persoonlijkheid'),
    lexemes: [
      LexemeSpec(id: 'lex_intelligent', am: 'አስተዋይ', tr: 'astewai', pos: 'adjective', topic: 'personality', level: 'A2', t: const Tr('intelligent, klug', 'intelligent, clever', 'intelligent', 'intelligent')),
      LexemeSpec(id: 'lex_faul', am: 'ስንፍተኛ', tr: 'sinfitegna', pos: 'adjective', topic: 'personality', level: 'A2', t: const Tr('faul', 'lazy', 'lat', 'lui')),
      LexemeSpec(id: 'lex_fleissig', am: 'ታታሪ', tr: 'tatari', pos: 'adjective', topic: 'personality', level: 'A2', t: const Tr('fleißig', 'hardworking', 'flitig', 'hardwerkend')),
      LexemeSpec(id: 'lex_ehrlich', am: 'ታማኝ', tr: 'tamagn', pos: 'adjective', topic: 'personality', level: 'A2', verified: true, t: const Tr('ehrlich, treu', 'honest, loyal', 'ärlig, trogen', 'eerlijk, trouw')),
      LexemeSpec(id: 'lex_grossherzig', am: 'ቸር', tr: 'cher', pos: 'adjective', topic: 'personality', level: 'A2', t: const Tr('großherzig, gütig', 'generous, kind', 'generös', 'gul')),
      LexemeSpec(id: 'lex_lustig', am: 'ቀልደኛ', tr: "k'elidegna", pos: 'adjective', topic: 'personality', level: 'A2', t: const Tr('lustig, witzig', 'funny', 'rolig, kul', 'grappig')),
      LexemeSpec(id: 'lex_ernst', am: 'ጠንካራ ስሜት ያለው', tr: "tenkara sime't yalew", pos: 'adjective', topic: 'personality', level: 'A2', t: const Tr('ernst', 'serious', 'allvarlig', 'serieus')),
      LexemeSpec(id: 'lex_schuechtern', am: 'አፈርፋሪ', tr: 'aferfari', pos: 'adjective', topic: 'personality', level: 'A2', t: const Tr('schüchtern', 'shy', 'blyg', 'schuchter')),
      LexemeSpec(id: 'lex_mutig', am: 'ደፋር', tr: 'defar', pos: 'adjective', topic: 'personality', level: 'A2', verified: true, t: const Tr('mutig', 'brave', 'modig', 'moedig')),
      LexemeSpec(id: 'lex_geduldig', am: 'ታጋሽ', tr: 'tagash', pos: 'adjective', topic: 'personality', level: 'A2', t: const Tr('geduldig', 'patient', 'tålmodig', 'geduldig')),
      LexemeSpec(id: 'lex_stur', am: 'ግትር', tr: 'gitir', pos: 'adjective', topic: 'personality', level: 'A2', t: const Tr('stur, hartnäckig', 'stubborn', 'envis', 'koppig')),
    ],
    sentences: [],
  ));

  writeUnit(UnitSpec(
    id: 'unit_wetter_mehr',
    sectionId: 'sec_a1_2',
    level: 'A1.2',
    topic: 'weather_more',
    title: const Tr('Wetter (mehr)', 'Weather (more)', 'Väder (mer)', 'Weer (meer)'),
    lexemes: [
      LexemeSpec(id: 'lex_sturm', am: 'ኃይለኛ ንፋስ', tr: 'hailegna nifas', pos: 'noun', topic: 'weather_more', level: 'A1.2', emoji: '🌬️', t: const Tr('der Sturm', 'storm', 'storm', 'storm')),
      LexemeSpec(id: 'lex_blitz', am: 'መብረቅ', tr: 'mebrek\'', pos: 'noun', topic: 'weather_more', level: 'A1.2', emoji: '⚡', t: const Tr('der Blitz', 'lightning', 'blixt', 'bliksem')),
      LexemeSpec(id: 'lex_donner', am: 'ነጎድጓድ', tr: 'negodgwad', pos: 'noun', topic: 'weather_more', level: 'A1.2', t: const Tr('der Donner', 'thunder', 'åska', 'donder')),
      LexemeSpec(id: 'lex_feucht', am: 'እርጥበት ያለው', tr: "irt'ibet yalew", pos: 'adjective', topic: 'weather_more', level: 'A1.2', t: const Tr('feucht', 'humid', 'fuktig', 'vochtig')),
      LexemeSpec(id: 'lex_nebel', am: 'ጭጋግ', tr: "chigag", pos: 'noun', topic: 'weather_more', level: 'A1.2', emoji: '🌫️', t: const Tr('der Nebel', 'fog', 'dimma', 'mist')),
      LexemeSpec(id: 'lex_hagel', am: 'በረዶ', tr: 'beredo', pos: 'noun', topic: 'weather_more', level: 'A1.2', t: const Tr('der Hagel, das Eis', 'hail, ice', 'hagel, is', 'hagel, ijs')),
      LexemeSpec(id: 'lex_nieselregen', am: 'ትንሽ ዝናብ', tr: 'tinish zinab', pos: 'noun', topic: 'weather_more', level: 'A1.2', t: const Tr('der Nieselregen', 'drizzle', 'duggregn', 'motregen')),
    ],
    sentences: [],
  ));

  writeUnit(UnitSpec(
    id: 'unit_tiere_mehr',
    sectionId: 'sec_a1_2',
    level: 'A1.2',
    topic: 'animals_more',
    title: const Tr('Tiere (mehr)', 'Animals (more)', 'Djur (mer)', 'Dieren (meer)'),
    lexemes: [
      LexemeSpec(id: 'lex_kuh', am: 'ላም', tr: 'lam', pos: 'noun', topic: 'animals_more', level: 'A1.2', emoji: '🐄', verified: true, t: const Tr('die Kuh', 'cow', 'ko', 'koe')),
      LexemeSpec(id: 'lex_ziege', am: 'ፍየል', tr: 'fiyel', pos: 'noun', topic: 'animals_more', level: 'A1.2', emoji: '🐐', verified: true, t: const Tr('die Ziege', 'goat', 'get', 'geit')),
      LexemeSpec(id: 'lex_schaf', am: 'በግ', tr: 'beg', pos: 'noun', topic: 'animals_more', level: 'A1.2', emoji: '🐑', verified: true, t: const Tr('das Schaf', 'sheep', 'får', 'schaap')),
      LexemeSpec(id: 'lex_esel', am: 'አህያ', tr: 'ahiya', pos: 'noun', topic: 'animals_more', level: 'A1.2', emoji: '🐴', verified: true, t: const Tr('der Esel', 'donkey', 'åsna', 'ezel')),
      LexemeSpec(id: 'lex_kamel', am: 'ግመል', tr: 'gimel', pos: 'noun', topic: 'animals_more', level: 'A1.2', emoji: '🐫', verified: true, t: const Tr('das Kamel', 'camel', 'kamel', 'kameel')),
      LexemeSpec(id: 'lex_maus', am: 'አይጥ', tr: "ayit'", pos: 'noun', topic: 'animals_more', level: 'A1.2', emoji: '🐁', verified: true, t: const Tr('die Maus', 'mouse', 'mus', 'muis')),
      LexemeSpec(id: 'lex_fuchs', am: 'ቀበሮ', tr: 'kebero', pos: 'noun', topic: 'animals_more', level: 'A1.2', emoji: '🦊', verified: true, t: const Tr('der Fuchs', 'fox', 'räv', 'vos')),
      LexemeSpec(id: 'lex_wolf', am: 'ተኩላ', tr: 'tekula', pos: 'noun', topic: 'animals_more', level: 'A1.2', emoji: '🐺', t: const Tr('der Wolf', 'wolf', 'varg', 'wolf')),
      LexemeSpec(id: 'lex_hirsch', am: 'አንኮሌ', tr: 'ankole', pos: 'noun', topic: 'animals_more', level: 'A1.2', t: const Tr('der Hirsch', 'deer', 'hjort', 'hert')),
      LexemeSpec(id: 'lex_schildkroete', am: 'ኤሊ', tr: 'eli', pos: 'noun', topic: 'animals_more', level: 'A1.2', emoji: '🐢', verified: true, t: const Tr('die Schildkröte', 'turtle', 'sköldpadda', 'schildpad')),
      LexemeSpec(id: 'lex_frosch', am: 'ዉራጭ', tr: 'wurach', pos: 'noun', topic: 'animals_more', level: 'A1.2', emoji: '🐸', t: const Tr('der Frosch', 'frog', 'groda', 'kikker')),
      LexemeSpec(id: 'lex_krokodil', am: 'አዞ', tr: 'azo', pos: 'noun', topic: 'animals_more', level: 'A1.2', emoji: '🐊', verified: true, t: const Tr('das Krokodil', 'crocodile', 'krokodil', 'krokodil')),
      LexemeSpec(id: 'lex_hyaene', am: 'ጅብ', tr: 'jib', pos: 'noun', topic: 'animals_more', level: 'A1.2', emoji: '🐾', verified: true, t: const Tr('die Hyäne', 'hyena', 'hyena', 'hyena')),
    ],
    sentences: [],
  ));

  writeUnit(UnitSpec(
    id: 'unit_berufe_mehr',
    sectionId: 'sec_a2',
    level: 'A2',
    topic: 'professions_more',
    title: const Tr('Berufe (mehr)', 'Professions (more)', 'Yrken (mer)', 'Beroepen (meer)'),
    lexemes: [
      LexemeSpec(id: 'lex_richter', am: 'ዳኛ', tr: 'dagna', pos: 'noun', topic: 'professions_more', level: 'A2', verified: true, t: const Tr('der Richter', 'judge', 'domare', 'rechter')),
      LexemeSpec(id: 'lex_priester', am: 'ቄስ', tr: "k'es", pos: 'noun', topic: 'professions_more', level: 'A2', verified: true, t: const Tr('der Priester', 'priest', 'präst', 'priester')),
      LexemeSpec(id: 'lex_schneider', am: 'ልብስ ስፌት', tr: 'libs sifet', pos: 'noun', topic: 'professions_more', level: 'A2', t: const Tr('der Schneider', 'tailor', 'skräddare', 'kleermaker')),
      LexemeSpec(id: 'lex_zimmermann', am: 'ጣውላ ሰራተኛ', tr: "t'awila serategna", pos: 'noun', topic: 'professions_more', level: 'A2', t: const Tr('der Zimmermann, Schreiner', 'carpenter', 'snickare', 'timmerman')),
      LexemeSpec(id: 'lex_sekretaer', am: 'ፀሐፊ', tr: "tsehafi", pos: 'noun', topic: 'professions_more', level: 'A2', t: const Tr('der/die Sekretär(in)', 'secretary', 'sekreterare', 'secretaresse')),
      LexemeSpec(id: 'lex_journalist', am: 'ጋዜጠኛ', tr: 'gazetegna', pos: 'noun', topic: 'professions_more', level: 'A2', verified: true, t: const Tr('der/die Journalist(in)', 'journalist', 'journalist', 'journalist')),
      LexemeSpec(id: 'lex_fotograf', am: 'ፎቶ አንሺ', tr: 'foto anshi', pos: 'noun', topic: 'professions_more', level: 'A2', t: const Tr('der/die Fotograf(in)', 'photographer', 'fotograf', 'fotograaf')),
    ],
    sentences: [],
  ));

  writeUnit(UnitSpec(
    id: 'unit_einkaufen_mehr',
    sectionId: 'sec_a2',
    level: 'A2',
    topic: 'shopping_more',
    title: const Tr('Einkaufen (mehr)', 'Shopping (more)', 'Shopping (mer)', 'Winkelen (meer)'),
    lexemes: [
      LexemeSpec(id: 'lex_rabatt', am: 'ቅናሽ', tr: "k'inash", pos: 'noun', topic: 'shopping_more', level: 'A2', t: const Tr('der Rabatt', 'discount', 'rabatt', 'korting')),
      LexemeSpec(id: 'lex_quittung', am: 'ደረሰኝ', tr: 'deresegn', pos: 'noun', topic: 'shopping_more', level: 'A2', t: const Tr('die Quittung', 'receipt', 'kvitto', 'bon')),
      LexemeSpec(id: 'lex_bargeld', am: 'ጥሬ ገንዘብ', tr: "t'ire genzeb", pos: 'noun', topic: 'shopping_more', level: 'A2', t: const Tr('das Bargeld', 'cash', 'kontanter', 'contant geld')),
      LexemeSpec(id: 'lex_kreditkarte', am: 'ክሬዲት ካርድ', tr: 'kredit kard', pos: 'noun', topic: 'shopping_more', level: 'A2', emoji: '💳', t: const Tr('die Kreditkarte', 'credit card', 'kreditkort', 'creditcard')),
      LexemeSpec(id: 'lex_geldbeutel', am: 'ቦርሳ ገንዘብ', tr: 'borsa genzeb', pos: 'noun', topic: 'shopping_more', level: 'A2', t: const Tr('der Geldbeutel', 'wallet', 'plånbok', 'portemonnee')),
      LexemeSpec(id: 'lex_wechselgeld', am: 'ተመላሽ ገንዘብ', tr: 'temelash genzeb', pos: 'noun', topic: 'shopping_more', level: 'A2', t: const Tr('das Wechselgeld', 'change (money)', 'växel', 'wisselgeld')),
      LexemeSpec(id: 'lex_kunde', am: 'ደንበኛ', tr: 'denbegna', pos: 'noun', topic: 'shopping_more', level: 'A2', verified: true, t: const Tr('der/die Kunde/Kundin', 'customer', 'kund', 'klant')),
      LexemeSpec(id: 'lex_v_handeln', am: 'መደራደር', tr: 'mederader', pos: 'verb', topic: 'shopping_more', level: 'A2', t: const Tr('handeln, verhandeln', 'to bargain', 'pruta', 'afdingen')),
    ],
    sentences: [],
  ));

  writeUnit(UnitSpec(
    id: 'unit_verkehr_mehr',
    sectionId: 'sec_a2',
    level: 'A2',
    topic: 'traffic_more',
    title: const Tr('Verkehr (mehr)', 'Traffic (more)', 'Trafik (mer)', 'Verkeer (meer)'),
    lexemes: [
      LexemeSpec(id: 'lex_ampel', am: 'የመንገድ መብራት', tr: 'yemenged mebrat', pos: 'noun', topic: 'traffic_more', level: 'A2', emoji: '🚦', t: const Tr('die Ampel', 'traffic light', 'trafikljus', 'verkeerslicht')),
      LexemeSpec(id: 'lex_fahrkarte', am: 'ትኬት', tr: 'tiket', pos: 'noun', topic: 'traffic_more', level: 'A2', verified: true, t: const Tr('die Fahrkarte, das Ticket', 'ticket', 'biljett', 'ticket')),
      LexemeSpec(id: 'lex_bushaltestelle', am: 'የአውቶብስ ማቆሚያ', tr: 'yeawtobis mak\'omiya', pos: 'noun', topic: 'traffic_more', level: 'A2', emoji: '🚏', t: const Tr('die Bushaltestelle', 'bus stop', 'busshållplats', 'bushalte')),
      LexemeSpec(id: 'lex_fuehrerschein', am: 'የመንጃ ፍቃድ', tr: 'yemenja fik\'ad', pos: 'noun', topic: 'traffic_more', level: 'A2', t: const Tr('der Führerschein', "driver's license", 'körkort', 'rijbewijs')),
      LexemeSpec(id: 'lex_tankstelle', am: 'ነዳጅ ማደያ', tr: 'nedaj madeya', pos: 'noun', topic: 'traffic_more', level: 'A2', emoji: '⛽', t: const Tr('die Tankstelle', 'gas station', 'bensinstation', 'tankstation')),
    ],
    sentences: [],
  ));

  writeUnit(UnitSpec(
    id: 'unit_richtungen',
    sectionId: 'sec_a2',
    level: 'A2',
    topic: 'directions',
    title: const Tr('Richtungen', 'Directions', 'Riktningar', 'Richtingen'),
    lexemes: [
      LexemeSpec(id: 'lex_nah', am: 'የቀረበ', tr: 'yekerebe', pos: 'adjective', topic: 'directions', level: 'A2', t: const Tr('nah', 'near', 'nära', 'dichtbij')),
      LexemeSpec(id: 'lex_fern', am: 'የራቀ', tr: 'yerak\'e', pos: 'adjective', topic: 'directions', level: 'A2', t: const Tr('fern, weit', 'far', 'långt bort', 'ver')),
      LexemeSpec(id: 'lex_ecke', am: 'ኩርንችት', tr: 'kurunchit', pos: 'noun', topic: 'directions', level: 'A2', t: const Tr('die Ecke', 'corner', 'hörn', 'hoek')),
    ],
    sentences: [],
  ));

  writeUnit(UnitSpec(
    id: 'unit_sport_mehr',
    sectionId: 'sec_a2',
    level: 'A2',
    topic: 'sports_more',
    title: const Tr('Sport (mehr)', 'Sports (more)', 'Sport (mer)', 'Sport (meer)'),
    lexemes: [
      LexemeSpec(id: 'lex_basketball', am: 'ባስኬትቦል', tr: 'basketbol', pos: 'noun', topic: 'sports_more', level: 'A2', emoji: '🏀', verified: true, t: const Tr('der Basketball', 'basketball', 'basket', 'basketbal')),
      LexemeSpec(id: 'lex_schwimmen', am: 'ውኃ ዋና', tr: "wiha wana", pos: 'noun', topic: 'sports_more', level: 'A2', emoji: '🏊', t: const Tr('das Schwimmen', 'swimming', 'simning', 'zwemmen')),
      LexemeSpec(id: 'lex_laufen_sport', am: 'ሩጫ', tr: 'rucha', pos: 'noun', topic: 'sports_more', level: 'A2', emoji: '🏃', verified: true, t: const Tr('das Laufen (Sport)', 'running', 'löpning', 'hardlopen')),
      LexemeSpec(id: 'lex_team', am: 'ቡድን', tr: 'budin', pos: 'noun', topic: 'sports_more', level: 'A2', verified: true, t: const Tr('das Team, die Mannschaft', 'team', 'lag', 'team')),
      LexemeSpec(id: 'lex_schiedsrichter', am: 'ዳኛ (ስፖርት)', tr: 'dagna (sport)', pos: 'noun', topic: 'sports_more', level: 'A2', t: const Tr('der Schiedsrichter', 'referee', 'domare', 'scheidsrechter')),
      LexemeSpec(id: 'lex_tor_sport', am: 'ጎል', tr: 'gol', pos: 'noun', topic: 'sports_more', level: 'A2', verified: true, t: const Tr('das Tor (Sport)', 'goal', 'mål', 'doelpunt')),
      LexemeSpec(id: 'lex_tennis', am: 'ቴኒስ', tr: 'tenis', pos: 'noun', topic: 'sports_more', level: 'A2', emoji: '🎾', verified: true, t: const Tr('das Tennis', 'tennis', 'tennis', 'tennis')),
      LexemeSpec(id: 'lex_volleyball', am: 'ቮሊቦል', tr: 'volibol', pos: 'noun', topic: 'sports_more', level: 'A2', emoji: '🏐', verified: true, t: const Tr('der Volleyball', 'volleyball', 'volleyboll', 'volleybal')),
      LexemeSpec(id: 'lex_radfahren', am: 'ብስክሌት መንዳት', tr: 'bisiklet mendat', pos: 'noun', topic: 'sports_more', level: 'A2', emoji: '🚴', t: const Tr('das Radfahren', 'cycling', 'cykling', 'fietsen')),
      LexemeSpec(id: 'lex_fitness', am: 'የሰውነት ማጎልመሻ', tr: 'yesewinet magolmesha', pos: 'noun', topic: 'sports_more', level: 'A2', emoji: '🏋️', t: const Tr('das Fitnessstudio', 'gym, fitness', 'gym', 'sportschool')),
    ],
    sentences: [],
  ));

  writeUnit(UnitSpec(
    id: 'unit_natur_mehr',
    sectionId: 'sec_a2',
    level: 'A2',
    topic: 'nature_more',
    title: const Tr('Natur (mehr)', 'Nature (more)', 'Natur (mer)', 'Natuur (meer)'),
    lexemes: [
      LexemeSpec(id: 'lex_ozean', am: 'ውቅያኖስ', tr: "wik'yanos", pos: 'noun', topic: 'nature_more', level: 'A2', emoji: '🌊', verified: true, t: const Tr('der Ozean', 'ocean', 'ocean', 'oceaan')),
      LexemeSpec(id: 'lex_tal', am: 'ሸለቆ', tr: "sheleko'", pos: 'noun', topic: 'nature_more', level: 'A2', t: const Tr('das Tal', 'valley', 'dal', 'vallei')),
      LexemeSpec(id: 'lex_insel', am: 'ደሴት', tr: 'deset', pos: 'noun', topic: 'nature_more', level: 'A2', emoji: '🏝️', verified: true, t: const Tr('die Insel', 'island', 'ö', 'eiland')),
      LexemeSpec(id: 'lex_huegel', am: 'ኮረብታ', tr: 'korebita', pos: 'noun', topic: 'nature_more', level: 'A2', t: const Tr('der Hügel', 'hill', 'kulle', 'heuvel')),
      LexemeSpec(id: 'lex_hoehle', am: 'ዋሻ', tr: 'washa', pos: 'noun', topic: 'nature_more', level: 'A2', emoji: '🕳️', verified: true, t: const Tr('die Höhle', 'cave', 'grotta', 'grot')),
      LexemeSpec(id: 'lex_wasserfall', am: 'ፏፏቴ', tr: 'fwafwate', pos: 'noun', topic: 'nature_more', level: 'A2', emoji: '💦', verified: true, t: const Tr('der Wasserfall', 'waterfall', 'vattenfall', 'waterval')),
    ],
    sentences: [],
  ));

  writeUnit(UnitSpec(
    id: 'unit_haushalt_mehr',
    sectionId: 'sec_a1_2',
    level: 'A1.2',
    topic: 'household_more',
    title: const Tr('Haushalt (mehr)', 'Household (more)', 'Hushåll (mer)', 'Huishouden (meer)'),
    lexemes: [
      LexemeSpec(id: 'lex_wanduhr', am: 'ሰዓት (ግድግዳ)', tr: "se'at (gidgida)", pos: 'noun', topic: 'household_more', level: 'A1.2', emoji: '🕐', t: const Tr('die Wanduhr', 'wall clock', 'väggklocka', 'wandklok')),
      LexemeSpec(id: 'lex_decke_bett', am: 'ብርድ ልብስ', tr: 'birid libs', pos: 'noun', topic: 'household_more', level: 'A1.2', t: const Tr('die Bettdecke', 'blanket', 'täcke', 'deken')),
      LexemeSpec(id: 'lex_besen', am: 'ጥራሪ', tr: "t'irari", pos: 'noun', topic: 'household_more', level: 'A1.2', t: const Tr('der Besen', 'broom', 'kvast', 'bezem')),
      LexemeSpec(id: 'lex_eimer', am: 'ባልዲ', tr: 'baldi', pos: 'noun', topic: 'household_more', level: 'A1.2', emoji: '🪣', verified: true, t: const Tr('der Eimer', 'bucket', 'hink', 'emmer')),
      LexemeSpec(id: 'lex_kerze', am: 'ሻማ', tr: 'shama', pos: 'noun', topic: 'household_more', level: 'A1.2', emoji: '🕯️', verified: true, t: const Tr('die Kerze', 'candle', 'ljus', 'kaars')),
    ],
    sentences: [],
  ));

  writeUnit(UnitSpec(
    id: 'unit_landwirtschaft',
    sectionId: 'sec_a2',
    level: 'A2',
    topic: 'agriculture',
    title: const Tr('Landwirtschaft', 'Agriculture', 'Jordbruk', 'Landbouw'),
    lexemes: [
      LexemeSpec(id: 'lex_ernte', am: 'መከር', tr: 'mekker', pos: 'noun', topic: 'agriculture', level: 'A2', verified: true, t: const Tr('die Ernte', 'harvest', 'skörd', 'oogst')),
      LexemeSpec(id: 'lex_samen', am: 'ዘር', tr: 'zer', pos: 'noun', topic: 'agriculture', level: 'A2', verified: true, t: const Tr('der Same(n)', 'seed', 'frö', 'zaad')),
      LexemeSpec(id: 'lex_boden_erde', am: 'አፈር', tr: 'afer', pos: 'noun', topic: 'agriculture', level: 'A2', verified: true, t: const Tr('der Boden, die Erde', 'soil', 'jord', 'grond')),
      LexemeSpec(id: 'lex_pflug', am: 'ማረሻ', tr: 'maresha', pos: 'noun', topic: 'agriculture', level: 'A2', t: const Tr('der Pflug', 'plow', 'plog', 'ploeg')),
      LexemeSpec(id: 'lex_feldfrucht', am: 'ምርት', tr: 'mirt', pos: 'noun', topic: 'agriculture', level: 'A2', verified: true, t: const Tr('die Feldfrucht, das Erzeugnis', 'crop', 'gröda', 'gewas')),
      LexemeSpec(id: 'lex_viehbestand', am: 'እንስሳት', tr: 'inisisat', pos: 'noun', topic: 'agriculture', level: 'A2', verified: true, t: const Tr('das Vieh, die Tiere', 'livestock', 'boskap', 'vee')),
      LexemeSpec(id: 'lex_scheune', am: 'ጎተራ', tr: 'gotera', pos: 'noun', topic: 'agriculture', level: 'A2', t: const Tr('die Scheune', 'barn', 'lada', 'schuur')),
      LexemeSpec(id: 'lex_brunnen', am: 'ጉድጓድ ውኃ', tr: "gudgwad wiha", pos: 'noun', topic: 'agriculture', level: 'A2', t: const Tr('der Brunnen', 'well', 'brunn', 'put')),
    ],
    sentences: [],
  ));

  writeUnit(UnitSpec(
    id: 'unit_religion_kultur',
    sectionId: 'sec_b1',
    level: 'B1',
    topic: 'religion_culture',
    title: const Tr('Religion & Kultur', 'Religion & culture', 'Religion & kultur', 'Religie & cultuur'),
    lexemes: [
      LexemeSpec(id: 'lex_gebet', am: 'ጸሎት', tr: "tselot", pos: 'noun', topic: 'religion_culture', level: 'B1', verified: true, t: const Tr('das Gebet', 'prayer', 'bön', 'gebed')),
      LexemeSpec(id: 'lex_feiertag_fest', am: 'በዓል', tr: "be'al", pos: 'noun', topic: 'religion_culture', level: 'B1', verified: true, t: const Tr('der Feiertag, das Fest', 'holiday, festival', 'högtid, fest', 'feestdag')),
      LexemeSpec(id: 'lex_fasten', am: 'ጾም', tr: "tsom", pos: 'noun', topic: 'religion_culture', level: 'B1', verified: true, t: const Tr('das Fasten', 'fasting', 'fasta', 'vasten')),
      LexemeSpec(id: 'lex_pilgerfahrt', am: 'ጉዞ ወደ ቅዱስ ቦታ', tr: "guzo wede k'idus bota", pos: 'noun', topic: 'religion_culture', level: 'B1', t: const Tr('die Pilgerfahrt', 'pilgrimage', 'pilgrimsfärd', 'pelgrimstocht')),
      LexemeSpec(id: 'lex_segen', am: 'በረከት', tr: 'bereket', pos: 'noun', topic: 'religion_culture', level: 'B1', verified: true, t: const Tr('der Segen', 'blessing', 'välsignelse', 'zegen')),
      LexemeSpec(id: 'lex_kreuz', am: 'መስቀል', tr: "meskel", pos: 'noun', topic: 'religion_culture', level: 'B1', emoji: '✝️', verified: true, t: const Tr('das Kreuz', 'cross', 'kors', 'kruis')),
      LexemeSpec(id: 'lex_weihrauch', am: 'ዕጣን', tr: "i'tan", pos: 'noun', topic: 'religion_culture', level: 'B1', t: const Tr('der Weihrauch', 'incense', 'rökelse', 'wierook')),
      LexemeSpec(id: 'lex_kloster', am: 'ገዳም', tr: 'gedam', pos: 'noun', topic: 'religion_culture', level: 'B1', verified: true, t: const Tr('das Kloster', 'monastery', 'kloster', 'klooster')),
    ],
    sentences: [],
  ));

  writeUnit(UnitSpec(
    id: 'unit_gesundheit_mehr2',
    sectionId: 'sec_a2',
    level: 'A2',
    topic: 'health_more2',
    title: const Tr('Gesundheit (mehr)', 'Health (more)', 'Hälsa (mer)', 'Gezondheid (meer)'),
    lexemes: [
      LexemeSpec(id: 'lex_medizin', am: 'መድሃኒት', tr: 'medhanit', pos: 'noun', topic: 'health_more2', level: 'A2', verified: true, t: const Tr('die Medizin, das Medikament', 'medicine', 'medicin', 'medicijn')),
      LexemeSpec(id: 'lex_spritze', am: 'መርፍ', tr: 'merfe', pos: 'noun', topic: 'health_more2', level: 'A2', t: const Tr('die Spritze, Injektion', 'injection', 'injektion', 'injectie')),
      LexemeSpec(id: 'lex_verband', am: 'ፋሻ', tr: 'fasha', pos: 'noun', topic: 'health_more2', level: 'A2', t: const Tr('der Verband', 'bandage', 'bandage', 'verband')),
      LexemeSpec(id: 'lex_wunde', am: 'ቁስል', tr: "k'usil", pos: 'noun', topic: 'health_more2', level: 'A2', verified: true, t: const Tr('die Wunde', 'wound', 'sår', 'wond')),
      LexemeSpec(id: 'lex_allergie', am: 'አለርጂ', tr: 'alerji', pos: 'noun', topic: 'health_more2', level: 'A2', verified: true, t: const Tr('die Allergie', 'allergy', 'allergi', 'allergie')),
      LexemeSpec(id: 'lex_kopfschmerz', am: 'ራስ ምታት', tr: 'ras mitat', pos: 'noun', topic: 'health_more2', level: 'A2', verified: true, t: const Tr('die Kopfschmerzen', 'headache', 'huvudvärk', 'hoofdpijn')),
    ],
    sentences: [],
  ));

  writeUnit(UnitSpec(
    id: 'unit_zeit_adverbien',
    sectionId: 'sec_a2',
    level: 'A2',
    topic: 'time_adverbs',
    title: const Tr('Häufigkeit & Zeit-Adverbien', 'Frequency & time adverbs', 'Frekvens- & tidsadverb', 'Frequentie- & tijdsbijwoorden'),
    lexemes: [
      LexemeSpec(id: 'lex_selten', am: 'አልፎ አልፎ', tr: 'alfo alfo', pos: 'adverb', topic: 'time_adverbs', level: 'A2', t: const Tr('selten', 'rarely', 'sällan', 'zelden')),
      LexemeSpec(id: 'lex_normalerweise', am: 'እንደ ልማድ', tr: 'inde limad', pos: 'adverb', topic: 'time_adverbs', level: 'A2', t: const Tr('normalerweise, gewöhnlich', 'usually', 'vanligtvis', 'meestal')),
      LexemeSpec(id: 'lex_sofort', am: 'አሁኑኑ', tr: 'ahununu', pos: 'adverb', topic: 'time_adverbs', level: 'A2', verified: true, t: const Tr('sofort', 'immediately', 'omedelbart', 'onmiddellijk')),
      LexemeSpec(id: 'lex_spaeter', am: 'በኋላ', tr: 'behwala', pos: 'adverb', topic: 'time_adverbs', level: 'A2', verified: true, t: const Tr('später', 'later', 'senare', 'later')),
      LexemeSpec(id: 'lex_bereits', am: 'አስቀድሞ', tr: "asik'edmo", pos: 'adverb', topic: 'time_adverbs', level: 'A2', t: const Tr('bereits, schon', 'already', 'redan', 'al')),
      LexemeSpec(id: 'lex_noch', am: 'አሁንም', tr: 'ahunim', pos: 'adverb', topic: 'time_adverbs', level: 'A2', t: const Tr('noch, immer noch', 'still', 'fortfarande', 'nog steeds')),
    ],
    sentences: [],
  ));

  writeUnit(UnitSpec(
    id: 'unit_konjunktionen',
    sectionId: 'sec_a2',
    level: 'A2',
    topic: 'conjunctions',
    title: const Tr('Konjunktionen', 'Conjunctions', 'Konjunktioner', 'Voegwoorden'),
    lexemes: [
      LexemeSpec(id: 'lex_obwohl', am: 'ምንም እንኳን', tr: 'minim inikwan', pos: 'conjunction', topic: 'conjunctions', level: 'A2', verified: true, t: const Tr('obwohl', 'although', 'även om', 'hoewel')),
      LexemeSpec(id: 'lex_wenn_falls', am: 'ከ...ቢ', tr: 'ke...bi', pos: 'conjunction', topic: 'conjunctions', level: 'A2', t: const Tr('wenn, falls', 'if', 'om', 'als')),
      LexemeSpec(id: 'lex_wann_konj', am: 'ስንት ጊዜ', tr: 'sinit gize', pos: 'conjunction', topic: 'conjunctions', level: 'A2', t: const Tr('wann (als)', 'when', 'när', 'wanneer')),
      LexemeSpec(id: 'lex_waehrend', am: 'እያለ', tr: 'iyale', pos: 'conjunction', topic: 'conjunctions', level: 'A2', t: const Tr('während', 'while', 'medan', 'terwijl')),
      LexemeSpec(id: 'lex_seit_konj', am: 'ከ...ጀምሮ', tr: 'ke...jemro', pos: 'conjunction', topic: 'conjunctions', level: 'A2', verified: true, t: const Tr('seit, seitdem', 'since', 'sedan', 'sinds')),
      LexemeSpec(id: 'lex_deshalb', am: 'ስለዚህ', tr: 'silezih', pos: 'conjunction', topic: 'conjunctions', level: 'A2', verified: true, t: const Tr('deshalb, deswegen', 'therefore', 'därför', 'daarom')),
      LexemeSpec(id: 'lex_ausser_wenn', am: 'ካልሆነ በስተቀር', tr: 'kalhone besitek\'er', pos: 'conjunction', topic: 'conjunctions', level: 'A2', t: const Tr('außer wenn, es sei denn', 'unless', 'om inte', 'tenzij')),
    ],
    sentences: [],
  ));

  writeUnit(UnitSpec(
    id: 'unit_verben_bewegung',
    sectionId: 'sec_a2',
    level: 'A2',
    topic: 'verbs_motion',
    title: const Tr('Bewegungsverben', 'Motion verbs', 'Rörelseverb', 'Bewegingswerkwoorden'),
    lexemes: [
      LexemeSpec(id: 'lex_v_rennen', am: 'መሮጥ', tr: "meroT'", pos: 'verb', topic: 'verbs_motion', level: 'A2', verified: true, t: const Tr('rennen, laufen', 'to run', 'springa', 'rennen')),
      LexemeSpec(id: 'lex_v_klettern', am: 'መውጣት', tr: "mewt'at", pos: 'verb', topic: 'verbs_motion', level: 'A2', t: const Tr('klettern, hinaufsteigen', 'to climb', 'klättra', 'klimmen')),
      LexemeSpec(id: 'lex_v_schieben', am: 'መግፍት', tr: 'megfit', pos: 'verb', topic: 'verbs_motion', level: 'A2', t: const Tr('schieben', 'to push', 'skjuta på', 'duwen')),
      LexemeSpec(id: 'lex_v_werfen', am: 'መወርወር', tr: 'mewerwer', pos: 'verb', topic: 'verbs_motion', level: 'A2', verified: true, t: const Tr('werfen', 'to throw', 'kasta', 'gooien')),
      LexemeSpec(id: 'lex_v_verstecken', am: 'መደበቅ', tr: "medebek'", pos: 'verb', topic: 'verbs_motion', level: 'A2', t: const Tr('verstecken', 'to hide', 'gömma', 'verstoppen')),
      LexemeSpec(id: 'lex_v_folgen', am: 'መከተል', tr: 'meketel', pos: 'verb', topic: 'verbs_motion', level: 'A2', verified: true, t: const Tr('folgen', 'to follow', 'följa', 'volgen')),
      LexemeSpec(id: 'lex_v_fuehren', am: 'መምራት', tr: 'memrat', pos: 'verb', topic: 'verbs_motion', level: 'A2', verified: true, t: const Tr('führen, leiten', 'to lead', 'leda', 'leiden')),
      LexemeSpec(id: 'lex_v_abreisen', am: 'መነሳት', tr: 'menesat', pos: 'verb', topic: 'verbs_motion', level: 'A2', t: const Tr('abreisen, aufbrechen', 'to depart', 'avresa', 'vertrekken')),
    ],
    sentences: [],
  ));

  writeUnit(UnitSpec(
    id: 'unit_substantive_mehr',
    sectionId: 'sec_b1',
    level: 'B1',
    topic: 'nouns_more',
    title: const Tr('Substantive (mehr)', 'Nouns (more)', 'Substantiv (mer)', 'Zelfstandige naamwoorden (meer)'),
    lexemes: [
      LexemeSpec(id: 'lex_gelegenheit', am: 'አጋጣሚ', tr: 'agatami', pos: 'noun', topic: 'nouns_more', level: 'B1', verified: true, t: const Tr('die Gelegenheit', 'opportunity', 'tillfälle', 'gelegenheid')),
      LexemeSpec(id: 'lex_erfahrung', am: 'ልምድ', tr: 'limid', pos: 'noun', topic: 'nouns_more', level: 'B1', verified: true, t: const Tr('die Erfahrung', 'experience', 'erfarenhet', 'ervaring')),
      LexemeSpec(id: 'lex_erinnerung_n', am: 'መታሰቢያ', tr: 'metasebiya', pos: 'noun', topic: 'nouns_more', level: 'B1', t: const Tr('die Erinnerung (Andenken)', 'memory (keepsake)', 'minne', 'herinnering')),
      LexemeSpec(id: 'lex_geheimnis', am: 'ምስጢር', tr: "misit'ir", pos: 'noun', topic: 'nouns_more', level: 'B1', verified: true, t: const Tr('das Geheimnis', 'secret', 'hemlighet', 'geheim')),
      LexemeSpec(id: 'lex_versprechen_n', am: 'ቃል', tr: "k'al", pos: 'noun', topic: 'nouns_more', level: 'B1', verified: true, t: const Tr('das Versprechen', 'promise', 'löfte', 'belofte')),
      LexemeSpec(id: 'lex_ueberraschung', am: 'መደነቅ', tr: 'medenek\'', pos: 'noun', topic: 'nouns_more', level: 'B1', t: const Tr('die Überraschung', 'surprise', 'överraskning', 'verrassing')),
      LexemeSpec(id: 'lex_chance', am: 'ዕድል', tr: "i'dil", pos: 'noun', topic: 'nouns_more', level: 'B1', verified: true, t: const Tr('die Chance, das Los', 'chance, luck', 'chans, lycka', 'kans, geluk')),
      LexemeSpec(id: 'lex_abenteuer', am: 'ጀብድ', tr: 'jebid', pos: 'noun', topic: 'nouns_more', level: 'B1', t: const Tr('das Abenteuer', 'adventure', 'äventyr', 'avontuur')),
      LexemeSpec(id: 'lex_vertrauen', am: 'እምነት', tr: 'imnet', pos: 'noun', topic: 'nouns_more', level: 'B1', verified: true, t: const Tr('das Vertrauen', 'trust', 'förtroende', 'vertrouwen')),
      LexemeSpec(id: 'lex_muehe_aufwand', am: 'ጥረት', tr: "t'iret", pos: 'noun', topic: 'nouns_more', level: 'B1', verified: true, t: const Tr('die Mühe, der Aufwand', 'effort', 'ansträngning', 'moeite')),
      LexemeSpec(id: 'lex_risiko', am: 'አደጋ (ስጋት)', tr: 'adega (sigat)', pos: 'noun', topic: 'nouns_more', level: 'B1', t: const Tr('das Risiko', 'risk', 'risk', 'risico')),
      LexemeSpec(id: 'lex_mut', am: 'ጀግንነት', tr: 'jeginnet', pos: 'noun', topic: 'nouns_more', level: 'B1', verified: true, t: const Tr('der Mut', 'courage', 'mod', 'moed')),
      LexemeSpec(id: 'lex_geduld_n', am: 'ትዕግስት', tr: "ti'igist", pos: 'noun', topic: 'nouns_more', level: 'B1', verified: true, t: const Tr('die Geduld', 'patience', 'tålamod', 'geduld')),
    ],
    sentences: [],
  ));

  writeUnit(UnitSpec(
    id: 'unit_kleidung_mehr',
    sectionId: 'sec_a1_2',
    level: 'A1.2',
    topic: 'clothing_more',
    title: const Tr('Kleidung (mehr)', 'Clothing (more)', 'Kläder (mer)', 'Kleding (meer)'),
    lexemes: [
      LexemeSpec(id: 'lex_stiefel', am: 'ቦት ጫማ', tr: 'bot chama', pos: 'noun', topic: 'clothing_more', level: 'A1.2', emoji: '🥾', t: const Tr('der Stiefel', 'boots', 'stövlar', 'laarzen')),
      LexemeSpec(id: 'lex_schmuck', am: 'ጌጣጌጥ', tr: "geTagéT'", pos: 'noun', topic: 'clothing_more', level: 'A1.2', emoji: '💍', t: const Tr('der Schmuck', 'jewelry', 'smycken', 'sieraden')),
      LexemeSpec(id: 'lex_handschuhe', am: 'ጓንት', tr: 'gwanit', pos: 'noun', topic: 'clothing_more', level: 'A1.2', emoji: '🧤', verified: true, t: const Tr('die Handschuhe', 'gloves', 'handskar', 'handschoenen')),
      LexemeSpec(id: 'lex_sonnenbrille', am: 'የፀሐይ መነጽር', tr: "yetsehai menetsir", pos: 'noun', topic: 'clothing_more', level: 'A1.2', emoji: '🕶️', t: const Tr('die Sonnenbrille', 'sunglasses', 'solglasögon', 'zonnebril')),
      LexemeSpec(id: 'lex_regenschirm', am: 'ጃንጥላ', tr: "jant'ila", pos: 'noun', topic: 'clothing_more', level: 'A1.2', emoji: '☂️', verified: true, t: const Tr('der Regenschirm', 'umbrella', 'paraply', 'paraplu')),
    ],
    sentences: [],
  ));

  writeUnit(UnitSpec(
    id: 'unit_kuechenwerkzeuge',
    sectionId: 'sec_a1_2',
    level: 'A1.2',
    topic: 'kitchen_tools',
    title: const Tr('Küchenwerkzeuge', 'Kitchen tools', 'Köksredskap', 'Keukengereedschap'),
    lexemes: [
      LexemeSpec(id: 'lex_pfanne', am: 'ምጥ', tr: "mit'", pos: 'noun', topic: 'kitchen_tools', level: 'A1.2', emoji: '🍳', t: const Tr('die Pfanne', 'pan', 'stekpanna', 'pan')),
      LexemeSpec(id: 'lex_schneidebrett', am: 'የመቁረጫ ሰሌዳ', tr: "yemek'urecha seleda", pos: 'noun', topic: 'kitchen_tools', level: 'A1.2', t: const Tr('das Schneidebrett', 'cutting board', 'skärbräda', 'snijplank')),
      LexemeSpec(id: 'lex_schoepfloeffel', am: 'ማንኪያ ትልቅ', tr: 'mankiya tilik\'', pos: 'noun', topic: 'kitchen_tools', level: 'A1.2', t: const Tr('der Schöpflöffel', 'ladle', 'slev', 'soeplepel')),
      LexemeSpec(id: 'lex_reibe', am: 'መፋቂያ', tr: "mefak'iya", pos: 'noun', topic: 'kitchen_tools', level: 'A1.2', t: const Tr('die Reibe', 'grater', 'rivjärn', 'rasp')),
      LexemeSpec(id: 'lex_sieb', am: 'ማጣሪያ', tr: "mat'ariya", pos: 'noun', topic: 'kitchen_tools', level: 'A1.2', t: const Tr('das Sieb', 'sieve', 'sil', 'zeef')),
    ],
    sentences: [],
  ));

  writeUnit(UnitSpec(
    id: 'unit_camping_wandern',
    sectionId: 'sec_a2',
    level: 'A2',
    topic: 'camping',
    title: const Tr('Camping & Wandern', 'Camping & hiking', 'Camping & vandring', 'Kamperen & wandelen'),
    lexemes: [
      LexemeSpec(id: 'lex_zelt', am: 'ድንኳን', tr: 'dinkwan', pos: 'noun', topic: 'camping', level: 'A2', emoji: '⛺', verified: true, t: const Tr('das Zelt', 'tent', 'tält', 'tent')),
      LexemeSpec(id: 'lex_schlafsack', am: 'የመተኛ ቦርሳ', tr: 'yemetegna borsa', pos: 'noun', topic: 'camping', level: 'A2', t: const Tr('der Schlafsack', 'sleeping bag', 'sovsäck', 'slaapzak')),
      LexemeSpec(id: 'lex_rucksack', am: 'ቦርሳ (ጀርባ)', tr: 'borsa (jerba)', pos: 'noun', topic: 'camping', level: 'A2', emoji: '🎒', verified: true, t: const Tr('der Rucksack', 'backpack', 'ryggsäck', 'rugzak')),
      LexemeSpec(id: 'lex_lagerfeuer', am: 'የካምፕ እሳት', tr: 'yekamp isat', pos: 'noun', topic: 'camping', level: 'A2', emoji: '🔥', t: const Tr('das Lagerfeuer', 'campfire', 'lägereld', 'kampvuur')),
      LexemeSpec(id: 'lex_angeln', am: 'ማጥመድ', tr: "mat'imed", pos: 'noun', topic: 'camping', level: 'A2', emoji: '🎣', t: const Tr('das Angeln', 'fishing', 'fiske', 'vissen')),
      LexemeSpec(id: 'lex_wandern', am: 'የእግር ጉዞ', tr: 'yeigir guzo', pos: 'noun', topic: 'camping', level: 'A2', emoji: '🥾', t: const Tr('das Wandern', 'hiking', 'vandring', 'wandelen')),
      LexemeSpec(id: 'lex_kompass', am: 'ኮምፓስ', tr: 'kompas', pos: 'noun', topic: 'camping', level: 'A2', emoji: '🧭', verified: true, t: const Tr('der Kompass', 'compass', 'kompass', 'kompas')),
      LexemeSpec(id: 'lex_taschenlampe', am: 'የኪስ ባትሪ', tr: 'yekis batri', pos: 'noun', topic: 'camping', level: 'A2', emoji: '🔦', t: const Tr('die Taschenlampe', 'flashlight', 'ficklampa', 'zaklamp')),
    ],
    sentences: [],
  ));

  writeUnit(UnitSpec(
    id: 'unit_kunst_musik_mehr',
    sectionId: 'sec_b1',
    level: 'B1',
    topic: 'art_music_more',
    title: const Tr('Kunst & Musik (mehr)', 'Art & music (more)', 'Konst & musik (mer)', 'Kunst & muziek (meer)'),
    lexemes: [
      LexemeSpec(id: 'lex_gemaelde', am: 'ስዕል', tr: "si'il", pos: 'noun', topic: 'art_music_more', level: 'B1', emoji: '🖼️', verified: true, t: const Tr('das Gemälde, das Bild', 'painting', 'målning', 'schilderij')),
      LexemeSpec(id: 'lex_zeichnung', am: 'ንድፍ', tr: 'nidif', pos: 'noun', topic: 'art_music_more', level: 'B1', t: const Tr('die Zeichnung', 'drawing', 'teckning', 'tekening')),
      LexemeSpec(id: 'lex_skulptur', am: 'ቅርፃቅርፅ', tr: "k'irtsak'irts'", pos: 'noun', topic: 'art_music_more', level: 'B1', t: const Tr('die Skulptur', 'sculpture', 'skulptur', 'sculptuur')),
      LexemeSpec(id: 'lex_theater', am: 'ቲያትር', tr: 'tiyatir', pos: 'noun', topic: 'art_music_more', level: 'B1', verified: true, t: const Tr('das Theater', 'theater', 'teater', 'theater')),
      LexemeSpec(id: 'lex_gedicht', am: 'ቅኔ', tr: "k'ine", pos: 'noun', topic: 'art_music_more', level: 'B1', t: const Tr('das Gedicht', 'poem', 'dikt', 'gedicht')),
      LexemeSpec(id: 'lex_roman', am: 'ልብ ወለድ', tr: 'lib weled', pos: 'noun', topic: 'art_music_more', level: 'B1', verified: true, t: const Tr('der Roman', 'novel', 'roman', 'roman')),
      LexemeSpec(id: 'lex_rhythmus', am: 'ምት', tr: 'mit', pos: 'noun', topic: 'art_music_more', level: 'B1', t: const Tr('der Rhythmus', 'rhythm', 'rytm', 'ritme')),
      LexemeSpec(id: 'lex_melodie', am: 'ዜማ', tr: 'zema', pos: 'noun', topic: 'art_music_more', level: 'B1', verified: true, t: const Tr('die Melodie', 'melody', 'melodi', 'melodie')),
    ],
    sentences: [],
  ));

  writeUnit(UnitSpec(
    id: 'unit_wissenschaft',
    sectionId: 'sec_b1',
    level: 'B1',
    topic: 'science',
    title: const Tr('Wissenschaft & Bildung', 'Science & education', 'Vetenskap & utbildning', 'Wetenschap & onderwijs'),
    lexemes: [
      LexemeSpec(id: 'lex_wissenschaft', am: 'ሳይንስ', tr: 'sayins', pos: 'noun', topic: 'science', level: 'B1', verified: true, t: const Tr('die Wissenschaft', 'science', 'vetenskap', 'wetenschap')),
      LexemeSpec(id: 'lex_experiment', am: 'ሙከራ', tr: 'mukera', pos: 'noun', topic: 'science', level: 'B1', verified: true, t: const Tr('das Experiment', 'experiment', 'experiment', 'experiment')),
      LexemeSpec(id: 'lex_forschung', am: 'ጥናት', tr: "t'inat", pos: 'noun', topic: 'science', level: 'B1', verified: true, t: const Tr('die Forschung', 'research', 'forskning', 'onderzoek')),
      LexemeSpec(id: 'lex_mathematik', am: 'ሂሳብ', tr: 'hisab', pos: 'noun', topic: 'science', level: 'B1', verified: true, t: const Tr('die Mathematik', 'mathematics', 'matematik', 'wiskunde')),
      LexemeSpec(id: 'lex_physik', am: 'ፊዚክስ', tr: 'fizikis', pos: 'noun', topic: 'science', level: 'B1', verified: true, t: const Tr('die Physik', 'physics', 'fysik', 'natuurkunde')),
      LexemeSpec(id: 'lex_chemie', am: 'ኬሚስትሪ', tr: 'kemistiri', pos: 'noun', topic: 'science', level: 'B1', verified: true, t: const Tr('die Chemie', 'chemistry', 'kemi', 'chemie')),
      LexemeSpec(id: 'lex_biologie', am: 'ባዮሎጂ', tr: 'baayoloji', pos: 'noun', topic: 'science', level: 'B1', verified: true, t: const Tr('die Biologie', 'biology', 'biologi', 'biologie')),
      LexemeSpec(id: 'lex_geographie', am: 'ጂኦግራፊ', tr: "ge'ografi", pos: 'noun', topic: 'science', level: 'B1', verified: true, t: const Tr('die Geographie', 'geography', 'geografi', 'aardrijkskunde')),
    ],
    sentences: [],
  ));

  writeUnit(UnitSpec(
    id: 'unit_werkzeuge',
    sectionId: 'sec_a2',
    level: 'A2',
    topic: 'tools',
    title: const Tr('Werkzeuge', 'Tools', 'Verktyg', 'Gereedschap'),
    lexemes: [
      LexemeSpec(id: 'lex_hammer', am: 'መጠቅ', tr: "met'ek'", pos: 'noun', topic: 'tools', level: 'A2', emoji: '🔨', t: const Tr('der Hammer', 'hammer', 'hammare', 'hamer')),
      LexemeSpec(id: 'lex_nagel', am: 'ችንካር', tr: 'chinikar', pos: 'noun', topic: 'tools', level: 'A2', t: const Tr('der Nagel', 'nail', 'spik', 'spijker')),
      LexemeSpec(id: 'lex_schraube', am: 'ብሎን', tr: 'bilon', pos: 'noun', topic: 'tools', level: 'A2', t: const Tr('die Schraube', 'screw', 'skruv', 'schroef')),
      LexemeSpec(id: 'lex_saege', am: 'መጋዝ', tr: 'megaz', pos: 'noun', topic: 'tools', level: 'A2', emoji: '🪚', t: const Tr('die Säge', 'saw', 'såg', 'zaag')),
      LexemeSpec(id: 'lex_bohrer', am: 'መብሳት', tr: 'mebisat', pos: 'noun', topic: 'tools', level: 'A2', t: const Tr('der Bohrer', 'drill', 'borr', 'boor')),
      LexemeSpec(id: 'lex_schraubenschluessel', am: 'ቁልፍ (መፍቻ)', tr: "k'ulf (mefich'a)", pos: 'noun', topic: 'tools', level: 'A2', t: const Tr('der Schraubenschlüssel', 'wrench', 'skiftnyckel', 'moersleutel')),
      LexemeSpec(id: 'lex_leiter', am: 'መሰላል', tr: 'meselal', pos: 'noun', topic: 'tools', level: 'A2', emoji: '🪜', verified: true, t: const Tr('die Leiter', 'ladder', 'stege', 'ladder')),
      LexemeSpec(id: 'lex_seil', am: 'ገመድ', tr: 'gemed', pos: 'noun', topic: 'tools', level: 'A2', verified: true, t: const Tr('das Seil', 'rope', 'rep', 'touw')),
      LexemeSpec(id: 'lex_klebeband', am: 'ማጣበቂያ', tr: "mat'abek'iya", pos: 'noun', topic: 'tools', level: 'A2', t: const Tr('das Klebeband', 'tape', 'tejp', 'plakband')),
      LexemeSpec(id: 'lex_leim', am: 'ሙጫ', tr: 'mucha', pos: 'noun', topic: 'tools', level: 'A2', verified: true, t: const Tr('der Leim, Klebstoff', 'glue', 'lim', 'lijm')),
    ],
    sentences: [],
  ));

  writeUnit(UnitSpec(
    id: 'unit_buerobedarf',
    sectionId: 'sec_a1_2',
    level: 'A1.2',
    topic: 'office_supplies',
    title: const Tr('Bürobedarf', 'Office supplies', 'Kontorsmaterial', 'Kantoorbenodigdheden'),
    lexemes: [
      LexemeSpec(id: 'lex_bleistift', am: 'እርሳስ', tr: 'irsas', pos: 'noun', topic: 'office_supplies', level: 'A1.2', emoji: '✏️', verified: true, t: const Tr('der Bleistift', 'pencil', 'blyertspenna', 'potlood')),
      LexemeSpec(id: 'lex_radiergummi', am: 'ማጥፊያ', tr: "mat'ifiya", pos: 'noun', topic: 'office_supplies', level: 'A1.2', t: const Tr('der Radiergummi', 'eraser', 'suddgummi', 'gum')),
      LexemeSpec(id: 'lex_lineal', am: 'መስመሪያ', tr: 'mesimeriya', pos: 'noun', topic: 'office_supplies', level: 'A1.2', emoji: '📏', t: const Tr('das Lineal', 'ruler', 'linjal', 'liniaal')),
      LexemeSpec(id: 'lex_hefter', am: 'ስቴፕለር', tr: 'steplar', pos: 'noun', topic: 'office_supplies', level: 'A1.2', emoji: '📎', t: const Tr('der Hefter, Tacker', 'stapler', 'häftapparat', 'nietmachine')),
      LexemeSpec(id: 'lex_schere', am: 'መቀስ', tr: "mek'es", pos: 'noun', topic: 'office_supplies', level: 'A1.2', emoji: '✂️', verified: true, t: const Tr('die Schere', 'scissors', 'sax', 'schaar')),
      LexemeSpec(id: 'lex_umschlag', am: 'ፖስታ', tr: 'posta', pos: 'noun', topic: 'office_supplies', level: 'A1.2', emoji: '✉️', verified: true, t: const Tr('der Umschlag', 'envelope', 'kuvert', 'envelop')),
      LexemeSpec(id: 'lex_briefmarke', am: 'ቴምብር', tr: 'tembir', pos: 'noun', topic: 'office_supplies', level: 'A1.2', emoji: '📮', verified: true, t: const Tr('die Briefmarke', 'stamp', 'frimärke', 'postzegel')),
    ],
    sentences: [],
  ));

  writeUnit(UnitSpec(
    id: 'unit_adjektive_mehr3',
    sectionId: 'sec_b1',
    level: 'B1',
    topic: 'adjectives_more3',
    title: const Tr('Mehr Adjektive (3)', 'More adjectives (3)', 'Fler adjektiv (3)', 'Meer bijvoeglijke naamwoorden (3)'),
    lexemes: [
      LexemeSpec(id: 'lex_schwer_gewicht', am: 'ከባድ', tr: 'kebad', pos: 'adjective', topic: 'adjectives_more3', level: 'B1', verified: true, t: const Tr('schwer (Gewicht)', 'heavy', 'tung', 'zwaar')),
      LexemeSpec(id: 'lex_leicht_gewicht', am: 'ቀላል', tr: 'kelal', pos: 'adjective', topic: 'adjectives_more3', level: 'B1', verified: true, t: const Tr('leicht (Gewicht)', 'light (weight)', 'lätt', 'licht')),
      LexemeSpec(id: 'lex_tief', am: 'ጥልቅ', tr: "t'ilik'", pos: 'adjective', topic: 'adjectives_more3', level: 'B1', verified: true, t: const Tr('tief', 'deep', 'djup', 'diep')),
      LexemeSpec(id: 'lex_flach', am: 'ጥልቀት የለው', tr: "t'ilik'et yelew", pos: 'adjective', topic: 'adjectives_more3', level: 'B1', t: const Tr('flach, seicht', 'shallow', 'grund', 'ondiep')),
      LexemeSpec(id: 'lex_breit', am: 'ሰፊ', tr: 'sefi', pos: 'adjective', topic: 'adjectives_more3', level: 'B1', verified: true, t: const Tr('breit, weit', 'wide', 'bred', 'breed')),
      LexemeSpec(id: 'lex_eng', am: 'ጠባብ', tr: 'tebab', pos: 'adjective', topic: 'adjectives_more3', level: 'B1', verified: true, t: const Tr('eng, schmal', 'narrow', 'trång, smal', 'nauw, smal')),
      LexemeSpec(id: 'lex_dick', am: 'ወፍራም', tr: 'wefram', pos: 'adjective', topic: 'adjectives_more3', level: 'B1', verified: true, t: const Tr('dick', 'thick', 'tjock', 'dik')),
      LexemeSpec(id: 'lex_duenn', am: 'ቀጭን', tr: "k'echin", pos: 'adjective', topic: 'adjectives_more3', level: 'B1', verified: true, t: const Tr('dünn', 'thin', 'tunn', 'dun')),
      LexemeSpec(id: 'lex_rund', am: 'ክብ', tr: 'kib', pos: 'adjective', topic: 'adjectives_more3', level: 'B1', verified: true, t: const Tr('rund', 'round', 'rund', 'rond')),
      LexemeSpec(id: 'lex_gerade_form', am: 'ቀጥ ያለ', tr: "k'et' yale", pos: 'adjective', topic: 'adjectives_more3', level: 'B1', t: const Tr('gerade (Form)', 'straight', 'rak', 'recht')),
      LexemeSpec(id: 'lex_glatt', am: 'ልስልስ', tr: 'lisilis', pos: 'adjective', topic: 'adjectives_more3', level: 'B1', t: const Tr('glatt', 'smooth', 'jämn, glatt', 'glad')),
      LexemeSpec(id: 'lex_rau', am: 'ሻካራ', tr: 'shakara', pos: 'adjective', topic: 'adjectives_more3', level: 'B1', verified: true, t: const Tr('rau, uneben', 'rough', 'ojämn, rå', 'ruw')),
    ],
    sentences: [],
  ));

  writeUnit(UnitSpec(
    id: 'unit_naturkatastrophen',
    sectionId: 'sec_b1',
    level: 'B1',
    topic: 'disasters',
    title: const Tr('Naturkatastrophen', 'Natural disasters', 'Naturkatastrofer', 'Natuurrampen'),
    lexemes: [
      LexemeSpec(id: 'lex_erdbeben', am: 'የመሬት መንቀጥቀጥ', tr: "yemeret menk'et'ik'et'", pos: 'noun', topic: 'disasters', level: 'B1', t: const Tr('das Erdbeben', 'earthquake', 'jordbävning', 'aardbeving')),
      LexemeSpec(id: 'lex_flut', am: 'ጎርፍ', tr: 'gorif', pos: 'noun', topic: 'disasters', level: 'B1', verified: true, t: const Tr('die Flut, Überschwemmung', 'flood', 'översvämning', 'overstroming')),
      LexemeSpec(id: 'lex_duerre', am: 'ድርቅ', tr: 'dirik\'', pos: 'noun', topic: 'disasters', level: 'B1', verified: true, t: const Tr('die Dürre', 'drought', 'torka', 'droogte')),
      LexemeSpec(id: 'lex_wirbelsturm', am: 'ትልቅ ዐውሎ ንፋስ', tr: "tilik' awlo nifas", pos: 'noun', topic: 'disasters', level: 'B1', t: const Tr('der Wirbelsturm, Orkan', 'hurricane', 'orkan', 'orkaan')),
      LexemeSpec(id: 'lex_vulkan', am: 'እሳተ ገሞራ', tr: 'isate gemora', pos: 'noun', topic: 'disasters', level: 'B1', emoji: '🌋', verified: true, t: const Tr('der Vulkan', 'volcano', 'vulkan', 'vulkaan')),
      LexemeSpec(id: 'lex_erdrutsch', am: 'የመሬት መንሸራተት', tr: 'yemeret mesheratet', pos: 'noun', topic: 'disasters', level: 'B1', t: const Tr('der Erdrutsch', 'landslide', 'jordskred', 'aardverschuiving')),
    ],
    sentences: [],
  ));

  writeUnit(UnitSpec(
    id: 'unit_zahlen_teile',
    sectionId: 'sec_a2',
    level: 'A2',
    topic: 'fractions',
    title: const Tr('Brüche & Mengen', 'Fractions & quantities', 'Bråk & mängder', 'Breuken & hoeveelheden'),
    lexemes: [
      LexemeSpec(id: 'lex_viertel', am: 'ሩብ', tr: 'rub', pos: 'noun', topic: 'fractions', level: 'A2', verified: true, t: const Tr('das Viertel', 'quarter', 'fjärdedel', 'kwart')),
      LexemeSpec(id: 'lex_drittel', am: 'ሲሶ', tr: 'siso', pos: 'noun', topic: 'fractions', level: 'A2', verified: true, t: const Tr('das Drittel', 'third', 'tredjedel', 'derde')),
      LexemeSpec(id: 'lex_prozent', am: 'በመቶ', tr: 'bemeto', pos: 'noun', topic: 'fractions', level: 'A2', verified: true, t: const Tr('das Prozent', 'percent', 'procent', 'procent')),
      LexemeSpec(id: 'lex_doppelt', am: 'ሁለት እጥፍ', tr: "hulet it'if", pos: 'adjective', topic: 'fractions', level: 'A2', t: const Tr('doppelt', 'double', 'dubbel', 'dubbel')),
      LexemeSpec(id: 'lex_dutzend', am: 'ደርዘን', tr: 'derzen', pos: 'noun', topic: 'fractions', level: 'A2', verified: true, t: const Tr('das Dutzend', 'dozen', 'dussin', 'dozijn')),
    ],
    sentences: [],
  ));
}

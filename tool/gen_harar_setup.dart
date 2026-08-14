// One-time setup: creates the two new B2 sections (Etappe 24 Nachtrag 2).
// Must run before any gen_harar_*.dart / gen_safari_*.dart script, and
// Harar must be created before Safari so the two land in the curriculum's
// `sections` array in the same order as WorldMapLayout.order (harar then
// safari) - that positional coupling is what makes each one show up as the
// right map stop instead of a "coming soon" placeholder.
import 'content_lib.dart';

void main() {
  ensureSection(
    id: 'sec_harar',
    level: 'B2',
    region: 'harar',
    title: const Tr(
      'Station 5: Harar — die Stadt der Minarette',
      'Stop 5: Harar — the city of minarets',
      'Stopp 5: Harar — minareternas stad',
      'Stop 5: Harar — de stad van de minaretten',
    ),
  );
  ensureSection(
    id: 'sec_safari',
    level: 'B2',
    region: 'safari',
    title: const Tr(
      'Station 6: Safari — sie und er',
      'Stop 6: Safari — she and he',
      'Stopp 6: Safari — hon och han',
      'Stop 6: Safari — zij en hij',
    ),
  );
}

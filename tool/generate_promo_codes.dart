// One-off generator for Amaseganlo Premium gift/promo codes (Etappe 13).
// Run with: dart run tool/generate_promo_codes.dart [count]
// (plain `dart run` works here - unlike the icon/audio-manifest tools,
// this needs no Flutter engine, just pure Dart + the crypto package.)
//
// Every printed code is valid forever and works offline on any install of
// this exact app (same embedded secret) - there is no server to mark a
// code as "already used" elsewhere, see ENTSCHEIDUNGEN.md for why that's
// an accepted limitation. Keep the generated codes somewhere safe; anyone
// who has one can redeem it on any device.
import 'package:amaseganlo/core/promo_codes.dart';

void main(List<String> args) {
  final count = args.isNotEmpty ? int.parse(args[0]) : 10;
  for (var i = 0; i < count; i++) {
    // ignore: avoid_print
    print(generateRandomPromoCode());
  }
}

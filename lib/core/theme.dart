import 'package:flutter/cupertino.dart' show CupertinoPageTransitionsBuilder;
import 'package:flutter/material.dart';

import '../models/settings.dart';

/// The app's fixed brand palette (Etappe 19) - no more user-selectable
/// accent colors, only light/dark mode is a choice now. The three colors
/// are chosen to echo the Ethiopian flag (grün/gelb/rot) as a recurring
/// motif across icons, badges and section accents throughout the app,
/// without ever painting large areas in literal flag colors.
///
/// [gold] deliberately equals [successColor] - the flag's yellow already
/// doubled as the "richtig!"-accent, so reusing it here ties the brand
/// palette and the feedback color together instead of adding a fourth hue.
/// [terracotta] is intentionally NOT [errorColor]: a warm, muted brick-red
/// reads as "Ethiopia" without ever being mistaken for a mistake/danger
/// state, which stays reserved for [errorColor] alone.
class AppBrandColors {
  static const Color green = Color(0xFF0F7A3D);
  static const Color gold = successColor;
  static const Color terracotta = Color(0xFFB8492E);
}

const Color successColor = Color(0xFFD4A017); // yellow, for success accents
const Color errorColor = Color(0xFFC62828); // red, reserved for mistakes only

class AppTheme {
  // The "Schriftgröße" setting is deliberately NOT implemented by scaling
  // TextTheme here (see git history for the removed attempt): Material 3's
  // default TextTheme/primaryTextTheme leave `fontSize` unset on every
  // style until Flutter's own Theme/Typography machinery fills them in
  // further down the widget tree, and `TextStyle.apply(fontSizeFactor: x)`
  // asserts/crashes on a null fontSize for any x != 1.0 - so this reliably
  // crashed the whole app for every non-"Normal" choice (found via the
  // "Schriftgröße" settings option). Font scaling is applied once, safely,
  // via `MediaQuery`'s `TextScaler` in `app.dart` instead - the officially
  // supported, render-level way to scale all text app-wide regardless of
  // which of its style fields happen to be set.
  static ThemeData build({required Brightness brightness}) {
    // Single-seed (green) rather than wiring AppBrandColors.gold/terracotta
    // into ColorScheme.secondary/tertiary directly: Material derives every
    // "on"/container color from the seed's own tonal palette, so forcing an
    // unrelated hue into just one slot would leave e.g. secondaryContainer
    // mismatched everywhere that role is used app-wide. Gold/terracotta are
    // applied by hand instead, only at the specific spots (Etappe 19:
    // AppShell, Onboarding, Settings) chosen to carry them - a safer,
    // more deliberate way to make "grün/gelb/rot wiederkehrend" true
    // without accidentally reskinning every stock widget in the app.
    final colorScheme = ColorScheme.fromSeed(
      seedColor: AppBrandColors.green,
      brightness: brightness,
      error: errorColor,
    );

    final base = ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      brightness: brightness,
      visualDensity: VisualDensity.standard,
    );

    return base.copyWith(
      // fontFamilyFallback (not fontFamily) so Latin text keeps the default
      // Material font - NotoSansEthiopic only kicks in for the Ge'ez-script
      // characters the primary font doesn't cover (Abschnitt C5/Etappe 11).
      // No fontSizeFactor here - see the class doc above.
      textTheme: base.textTheme.apply(
        fontFamilyFallback: const ['NotoSansEthiopic'],
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
        elevation: 0,
        scrolledUnderElevation: 2,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          minimumSize: const Size(48, 48),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: const Size(48, 48),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(minimumSize: const Size(48, 48)),
      ),
      iconButtonTheme: IconButtonThemeData(
        style: IconButton.styleFrom(minimumSize: const Size(48, 48)),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: colorScheme.surface,
        indicatorColor: colorScheme.primaryContainer,
      ),
      cardTheme: CardThemeData(
        // A little lift instead of dead-flat (Etappe 19: "sieht zu einfach
        // aus") - subtle enough to still read as calm, not busy.
        elevation: 2,
        shadowColor: colorScheme.shadow.withValues(alpha: 0.25),
        color: colorScheme.surfaceContainerLow,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
      pageTransitionsTheme: PageTransitionsTheme(
        builders: {
          TargetPlatform.android: FadeForwardsPageTransitionsBuilder(),
          TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
          TargetPlatform.windows: FadeForwardsPageTransitionsBuilder(),
          TargetPlatform.macOS: FadeForwardsPageTransitionsBuilder(),
          TargetPlatform.linux: FadeForwardsPageTransitionsBuilder(),
        },
      ),
    );
  }

  static Brightness resolveBrightness(AppThemeMode mode, Brightness platformBrightness) {
    switch (mode) {
      case AppThemeMode.light:
        return Brightness.light;
      case AppThemeMode.dark:
        return Brightness.dark;
      case AppThemeMode.system:
        return platformBrightness;
    }
  }
}

const Duration screenTransitionDuration = Duration(milliseconds: 250);

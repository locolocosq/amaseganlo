import 'package:flutter/cupertino.dart' show CupertinoPageTransitionsBuilder;
import 'package:flutter/material.dart';

import '../models/settings.dart';

/// Accent color choices. Deliberately no pure red - red is reserved for
/// error feedback throughout the app, never a selectable brand color.
///
/// The first [freeCount] are available to everyone; the rest are the
/// Premium-only "Reise"-colors (Abschnitt Design/Etappe 12) - themed after
/// things encountered on the Äthiopien-Reise rather than being an arbitrary
/// paywall.
class AppAccentColors {
  static const int freeCount = 6;

  static const List<Color> values = [
    Color(0xFF0F7A3D), // green (default, nods to Ethiopia without being the flag)
    Color(0xFF1565C0), // blue
    Color(0xFF00796B), // teal
    Color(0xFF6A1B9A), // purple
    Color(0xFFE65100), // orange
    Color(0xFF3949AB), // indigo
    Color(0xFF6F4E37), // "Kaffee" - Premium
    Color(0xFF1B5E7A), // "Blauer Nil" - Premium
  ];

  static Color of(int index) => values[index.clamp(0, values.length - 1)];

  static bool isPremium(int index) => index >= freeCount;
}

const Color successColor = Color(0xFFD4A017); // yellow, for success accents
const Color errorColor = Color(0xFFC62828); // red, reserved for mistakes only

class AppTheme {
  static ThemeData build({
    required Brightness brightness,
    required int accentColorIndex,
    required double fontScale,
  }) {
    final seed = AppAccentColors.of(accentColorIndex);
    final colorScheme = ColorScheme.fromSeed(
      seedColor: seed,
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
      textTheme: base.textTheme.apply(
        fontSizeFactor: fontScale,
        fontFamilyFallback: const ['NotoSansEthiopic'],
      ),
      primaryTextTheme: base.primaryTextTheme.apply(
        fontSizeFactor: fontScale,
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
        elevation: 0,
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

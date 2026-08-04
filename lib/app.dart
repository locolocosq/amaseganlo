import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'core/router.dart';
import 'core/theme.dart';
import 'l10n/app_localizations.dart';
import 'models/settings.dart';
import 'state/settings_provider.dart';

class AmaseganloApp extends StatelessWidget {
  const AmaseganloApp({super.key});

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsProvider>().settings;
    final platformBrightness = MediaQuery.platformBrightnessOf(context);
    final brightness = AppTheme.resolveBrightness(settings.themeMode, platformBrightness);

    return MaterialApp.router(
      title: 'Amaseganlo',
      debugShowCheckedModeBanner: false,
      routerConfig: appRouter,
      theme: AppTheme.build(
        brightness: Brightness.light,
        accentColorIndex: settings.accentColorIndex,
        fontScale: settings.fontSize.scale,
      ),
      darkTheme: AppTheme.build(
        brightness: Brightness.dark,
        accentColorIndex: settings.accentColorIndex,
        fontScale: settings.fontSize.scale,
      ),
      themeMode: brightness == Brightness.dark ? ThemeMode.dark : ThemeMode.light,
      locale: settings.localeCode != null ? Locale(settings.localeCode!) : null,
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
    );
  }
}

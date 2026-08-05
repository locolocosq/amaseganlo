import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'core/audio_service.dart';
import 'core/theme.dart';
import 'l10n/app_localizations.dart';
import 'models/settings.dart';
import 'state/settings_provider.dart';

class AmaseganloApp extends StatefulWidget {
  final GoRouter router;

  const AmaseganloApp({super.key, required this.router});

  @override
  State<AmaseganloApp> createState() => _AmaseganloAppState();
}

class _AmaseganloAppState extends State<AmaseganloApp> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  /// Abschnitt C3: stop any TTS/chime playback the moment the app leaves
  /// the foreground, instead of letting it keep talking into a backgrounded
  /// app; and force a rebuild on return so "today"/streak displays that
  /// were computed from `DateTime.now()` before a midnight rollover show
  /// the new day immediately instead of waiting for an unrelated rebuild.
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state != AppLifecycleState.resumed) {
      context.read<AudioService>().stop();
    } else if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final router = widget.router;
    final settings = context.watch<SettingsProvider>().settings;
    final platformBrightness = MediaQuery.platformBrightnessOf(context);
    final brightness = AppTheme.resolveBrightness(
      settings.themeMode,
      platformBrightness,
    );

    return MaterialApp.router(
      title: 'Amaseganlo',
      debugShowCheckedModeBanner: false,
      routerConfig: router,
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
      themeMode: brightness == Brightness.dark
          ? ThemeMode.dark
          : ThemeMode.light,
      locale: settings.localeCode != null ? Locale(settings.localeCode!) : null,
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
    );
  }
}

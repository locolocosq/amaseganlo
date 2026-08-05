import 'package:flutter/material.dart';

/// The last line of defense against a blank/crashed screen (Abschnitt C6):
/// installed as `ErrorWidget.builder`, so it must never itself depend on
/// anything that could be missing when a widget fails to build - no
/// `AppLocalizations.of(context)` (there may be no `Localizations` ancestor
/// at all if the failure happened high up the tree), no Provider lookups.
/// Text is therefore hardcoded and bilingual rather than looked up.
class CrashFallbackView extends StatelessWidget {
  final FlutterErrorDetails details;

  const CrashFallbackView({super.key, required this.details});

  @override
  Widget build(BuildContext context) {
    // Deliberately no Theme.of(context)/AppLocalizations.of(context) here -
    // see the class doc. Hardcoded colors, not themed ones.
    return const Material(
      color: Colors.white,
      child: Center(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.error_outline, size: 48, color: Colors.redAccent),
              SizedBox(height: 16),
              Text(
                'Da ist etwas schiefgelaufen.\nSomething went wrong.',
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              SizedBox(height: 8),
              Text(
                'Dein Fortschritt ist gespeichert.\nYour progress is saved.',
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

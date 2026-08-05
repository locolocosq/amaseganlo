import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../l10n/app_localizations.dart';
import '../../models/fidel_char.dart';
import '../../state/content_provider.dart';
import '../../widgets/common/fidel_order_row.dart';

/// Stufe 2's single, thorough explainer lesson: what a syllable sign is,
/// two worked examples (ha/la), the special 6th-order note, and the honest
/// "not every row is regular" note.
class FidelVowelExplainerScreen extends StatefulWidget {
  final VoidCallback onFinished;

  const FidelVowelExplainerScreen({super.key, required this.onFinished});

  @override
  State<FidelVowelExplainerScreen> createState() => _FidelVowelExplainerScreenState();
}

class _FidelVowelExplainerScreenState extends State<FidelVowelExplainerScreen> {
  int _page = 0;
  static const _pageCount = 5;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final repo = context.watch<ContentProvider>().repository;
    final haChars = repo.fidelCharsForGroup('ha');
    final laChars = repo.fidelCharsForGroup('la');
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: LinearProgressIndicator(value: (_page + 1) / _pageCount),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: switch (_page) {
                    0 => _TextPage(title: l10n.fidelVowelExplainerTitle, body: l10n.fidelVowelExplainerIntro),
                    1 => _RowPage(title: l10n.fidelVowelExplainerRow1Title, body: l10n.fidelVowelExplainerRow1Body, chars: haChars),
                    2 => _RowPage(title: l10n.fidelVowelExplainerRow2Title, body: l10n.fidelVowelExplainerRow2Body, chars: laChars),
                    3 => _TextPage(title: l10n.fidelVowelExplainerOrder6Title, body: l10n.fidelVowelExplainerOrder6Body),
                    _ => _TextPage(title: l10n.fidelVowelExplainerExceptionTitle, body: l10n.fidelVowelExplainerExceptionBody),
                  },
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: () {
                    if (_page < _pageCount - 1) {
                      setState(() => _page++);
                    } else {
                      widget.onFinished();
                    }
                  },
                  child: Text(l10n.fidelExplainerContinue),
                ),
              ),
            ],
          ),
        ),
      ),
      backgroundColor: theme.colorScheme.surface,
    );
  }
}

class _TextPage extends StatelessWidget {
  final String title;
  final String body;
  const _TextPage({required this.title, required this.body});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: theme.textTheme.headlineSmall),
        const SizedBox(height: 16),
        Text(body, style: theme.textTheme.bodyLarge),
      ],
    );
  }
}

class _RowPage extends StatelessWidget {
  final String title;
  final String body;
  final List<FidelChar> chars;
  const _RowPage({required this.title, required this.body, required this.chars});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: theme.textTheme.headlineSmall),
        const SizedBox(height: 12),
        Text(body, style: theme.textTheme.bodyLarge),
        const SizedBox(height: 24),
        FidelOrderRow(chars: chars),
      ],
    );
  }
}

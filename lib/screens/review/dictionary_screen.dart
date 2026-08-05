import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/plural.dart';
import '../../l10n/app_localizations.dart';
import '../../models/lexeme.dart';
import '../../state/content_provider.dart';
import '../../state/progress_provider.dart';
import '../../state/settings_provider.dart';
import '../../widgets/common/empty_state.dart';

/// A searchable/filterable list of every word the learner has already
/// encountered - not the full 1000+ word database, since browsing words
/// you haven't reached yet would spoil the learning path.
class DictionaryScreen extends StatefulWidget {
  const DictionaryScreen({super.key});

  @override
  State<DictionaryScreen> createState() => _DictionaryScreenState();
}

class _DictionaryScreenState extends State<DictionaryScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _query = '';
  String? _selectedLevel;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final content = context.watch<ContentProvider>().repository;
    final progress = context.watch<ProgressProvider>();
    final settings = context.watch<SettingsProvider>().settings;
    final locale = settings.localeCode ?? Localizations.localeOf(context).languageCode;

    final learned = progress
        .learnedLexemeIds()
        .map(content.lexeme)
        .whereType<Lexeme>()
        .toList()
      ..sort((a, b) => a.tr.compareTo(b.tr));

    if (learned.isEmpty) {
      return EmptyState(icon: Icons.menu_book_outlined, title: l10n.dictionaryTitle, body: l10n.dictionaryEmpty);
    }

    final levels = learned.map((l) => l.level).where((l) => l.isNotEmpty).toSet().toList()..sort();

    final query = _query.trim().toLowerCase();
    final filtered = learned.where((l) {
      if (_selectedLevel != null && l.level != _selectedLevel) return false;
      if (query.isEmpty) return true;
      return l.am.toLowerCase().contains(query) ||
          l.tr.toLowerCase().contains(query) ||
          (l.t[locale]?.toLowerCase().contains(query) ?? false) ||
          l.topic.toLowerCase().contains(query);
    }).toList();

    return Scaffold(
      appBar: AppBar(title: Text(l10n.dictionaryTitle)),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 8),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: l10n.dictionarySearchHint,
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                ),
                onChanged: (v) => setState(() => _query = v),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: SizedBox(
                height: 40,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: ChoiceChip(
                        label: Text(l10n.dictionaryFilterAll),
                        selected: _selectedLevel == null,
                        onSelected: (_) => setState(() => _selectedLevel = null),
                      ),
                    ),
                    for (final level in levels)
                      Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: ChoiceChip(
                          label: Text(level),
                          selected: _selectedLevel == level,
                          onSelected: (_) => setState(() => _selectedLevel = level),
                        ),
                      ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 4),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  wordCountLabel(l10n, filtered.length),
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
                ),
              ),
            ),
            Expanded(
              child: filtered.isEmpty
                  ? Center(child: Text(l10n.dictionarySearchNoResults))
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                      itemCount: filtered.length,
                      itemBuilder: (context, index) {
                        final lexeme = filtered[index];
                        return _DictionaryRow(lexeme: lexeme, locale: locale);
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DictionaryRow extends StatelessWidget {
  final Lexeme lexeme;
  final String locale;

  const _DictionaryRow({required this.lexeme, required this.locale});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Material(
        color: theme.colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(14),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              if (lexeme.emoji.isNotEmpty) Padding(padding: const EdgeInsets.only(right: 12), child: Text(lexeme.emoji, style: const TextStyle(fontSize: 24))),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(lexeme.am, style: theme.textTheme.titleMedium),
                    Text(lexeme.tr, style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Text(lexeme.t[locale] ?? '', style: theme.textTheme.bodyMedium, textAlign: TextAlign.right),
            ],
          ),
        ),
      ),
    );
  }
}

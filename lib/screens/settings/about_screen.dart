import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../core/purchase_service.dart';
import '../../l10n/app_localizations.dart';

const _appVersion = '1.2.1';
// No CI pipeline stamps a real build timestamp yet - set by hand at release
// time, same as _appVersion.
const _buildDate = '2026-08-09';

/// How many consecutive taps on the version line reveal the hidden
/// developer-code dialog (Etappe 24) - the same "tap the build number"
/// pattern Android's own Settings app uses to reveal Developer Options, so
/// nothing on screen ever hints that tapping here does anything at all.
const _tapsToRevealDevCode = 7;

class AboutScreen extends StatefulWidget {
  const AboutScreen({super.key});

  @override
  State<AboutScreen> createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {
  int _versionTapCount = 0;

  void _onVersionTap() {
    _versionTapCount++;
    if (_versionTapCount >= _tapsToRevealDevCode) {
      _versionTapCount = 0;
      _showDevCodeDialog();
    }
  }

  Future<void> _showDevCodeDialog() async {
    final l10n = AppLocalizations.of(context);
    final controller = TextEditingController();
    final code = await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.devUnlockDialogTitle),
        content: TextField(
          controller: controller,
          autofocus: true,
          obscureText: true,
          onSubmitted: (value) => Navigator.pop(ctx, value),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: Text(l10n.commonCancel)),
          FilledButton(onPressed: () => Navigator.pop(ctx, controller.text), child: Text(l10n.devUnlockButton)),
        ],
      ),
    );
    if (code == null || !mounted) return;

    final ok = context.read<PurchaseService>().redeemDevCode(code);
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(ok ? l10n.devUnlockSuccess : l10n.devUnlockInvalid)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          tooltip: l10n.commonBack,
          onPressed: () => context.pop(),
        ),
        title: Text(l10n.settingsAbout),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Center(
            child: Column(
              children: [
                Icon(
                  Icons.translate,
                  size: 56,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(height: 12),
                Text(
                  l10n.appTitle,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 4),
                GestureDetector(
                  onTap: _onVersionTap,
                  child: Text('${l10n.aboutVersion} $_appVersion'),
                ),
                Text(
                  '${l10n.aboutBuildDate}: $_buildDate',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Text(l10n.aboutPrivacy),
            ),
          ),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.aboutShortcuts,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  Text(l10n.aboutShortcutsAnswer),
                  Text(l10n.aboutShortcutsNext),
                  Text(l10n.aboutShortcutsCancel),
                  Text(l10n.aboutShortcutsAudio),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          ListTile(
            leading: const Icon(Icons.description_outlined),
            title: Text(l10n.aboutLicenses),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => showLicensePage(
              context: context,
              applicationName: l10n.appTitle,
              applicationVersion: _appVersion,
            ),
          ),
        ],
      ),
    );
  }
}

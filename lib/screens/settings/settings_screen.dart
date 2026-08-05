import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../core/theme.dart';
import '../../l10n/app_localizations.dart';
import '../../models/settings.dart';
import '../../state/settings_provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final settingsProvider = context.watch<SettingsProvider>();
    final settings = settingsProvider.settings;

    void savedSnack() {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.settingsSaved), duration: const Duration(seconds: 1)),
      );
    }

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => context.pop()),
        title: Text(l10n.settingsTitle),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 8),
        children: [
          _SectionHeader(l10n.settingsLanguage),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: DropdownButtonFormField<String>(
              initialValue: settings.localeCode,
              items: [
                DropdownMenuItem(value: null, child: Text(l10n.appearanceSystem)),
                for (final code in supportedLocaleCodes)
                  DropdownMenuItem(value: code, child: Text(_languageName(code))),
              ],
              onChanged: (code) {
                settingsProvider.setLocaleCode(code);
                savedSnack();
              },
            ),
          ),
          const Divider(height: 32),
          _SectionHeader(l10n.settingsAppearance),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: SegmentedButton<AppThemeMode>(
              segments: [
                ButtonSegment(value: AppThemeMode.light, label: Text(l10n.appearanceLight), icon: const Icon(Icons.light_mode_outlined)),
                ButtonSegment(value: AppThemeMode.dark, label: Text(l10n.appearanceDark), icon: const Icon(Icons.dark_mode_outlined)),
                ButtonSegment(value: AppThemeMode.system, label: Text(l10n.appearanceSystem), icon: const Icon(Icons.brightness_auto_outlined)),
              ],
              selected: {settings.themeMode},
              onSelectionChanged: (s) => settingsProvider.setThemeMode(s.first),
            ),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(l10n.settingsAccentColor, style: Theme.of(context).textTheme.labelLarge),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Wrap(
              spacing: 12,
              children: List.generate(AppAccentColors.values.length, (i) {
                final selected = settings.accentColorIndex == i;
                return InkWell(
                  borderRadius: BorderRadius.circular(24),
                  onTap: () => settingsProvider.setAccentColorIndex(i),
                  child: Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: AppAccentColors.of(i),
                      shape: BoxShape.circle,
                      border: selected
                          ? Border.all(color: Theme.of(context).colorScheme.onSurface, width: 3)
                          : null,
                    ),
                    child: selected ? const Icon(Icons.check, color: Colors.white) : null,
                  ),
                );
              }),
            ),
          ),
          const Divider(height: 32),
          _SectionHeader(l10n.settingsFontSize),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: SegmentedButton<FontSizeOption>(
              segments: [
                ButtonSegment(value: FontSizeOption.small, label: Text(l10n.fontSizeSmall)),
                ButtonSegment(value: FontSizeOption.normal, label: Text(l10n.fontSizeNormal)),
                ButtonSegment(value: FontSizeOption.large, label: Text(l10n.fontSizeLarge)),
                ButtonSegment(value: FontSizeOption.extraLarge, label: Text(l10n.fontSizeExtraLarge)),
              ],
              showSelectedIcon: false,
              selected: {settings.fontSize},
              onSelectionChanged: (s) => settingsProvider.setFontSize(s.first),
            ),
          ),
          const Divider(height: 32),
          _SectionHeader(l10n.settingsShowFidelInMainPath),
          RadioGroup<FidelDisplayMode>(
            groupValue: settings.fidelDisplayMode,
            onChanged: (v) {
              if (v != null) settingsProvider.setFidelDisplayMode(v);
            },
            child: Column(
              children: [
                RadioListTile<FidelDisplayMode>(
                  title: Text(l10n.fidelDisplayNever),
                  value: FidelDisplayMode.never,
                ),
                RadioListTile<FidelDisplayMode>(
                  title: Text(l10n.fidelDisplayBelow),
                  value: FidelDisplayMode.below,
                ),
                RadioListTile<FidelDisplayMode>(
                  title: Text(l10n.fidelDisplayInstead),
                  value: FidelDisplayMode.instead,
                ),
              ],
            ),
          ),
          const Divider(height: 32),
          _SectionHeader(l10n.settingsFidelLearningPath),
          RadioGroup<FidelLearningPath>(
            groupValue: settings.fidelLearningPath,
            onChanged: (v) {
              if (v != null) settingsProvider.setFidelLearningPath(v);
            },
            child: Column(
              children: [
                RadioListTile<FidelLearningPath>(
                  title: Text(l10n.fidelPathTraditional),
                  value: FidelLearningPath.traditional,
                ),
                RadioListTile<FidelLearningPath>(
                  title: Text(l10n.fidelPathFast),
                  value: FidelLearningPath.fast,
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(l10n.settingsHahuTempo, style: Theme.of(context).textTheme.labelLarge),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: SegmentedButton<HahuTempo>(
              segments: [
                ButtonSegment(value: HahuTempo.slow, label: Text(l10n.hahuTempoSlow)),
                ButtonSegment(value: HahuTempo.normal, label: Text(l10n.hahuTempoNormal)),
                ButtonSegment(value: HahuTempo.fast, label: Text(l10n.hahuTempoFast)),
              ],
              selected: {settings.hahuTempo},
              onSelectionChanged: (s) => settingsProvider.setHahuTempo(s.first),
            ),
          ),
          const Divider(height: 32),
          _SectionHeader(l10n.settingsSound),
          SwitchListTile(
            title: Text(l10n.settingsSound),
            value: settings.soundEnabled,
            onChanged: settingsProvider.setSoundEnabled,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                const Icon(Icons.volume_down),
                Expanded(
                  child: Slider(
                    value: settings.volume,
                    onChanged: settings.soundEnabled ? settingsProvider.setVolume : null,
                  ),
                ),
                const Icon(Icons.volume_up),
              ],
            ),
          ),
          SwitchListTile(
            title: Text(l10n.settingsAutoPlayNewWords),
            value: settings.autoPlayNewWords,
            onChanged: settingsProvider.setAutoPlayNewWords,
          ),
          const Divider(height: 32),
          _SectionHeader(l10n.settingsDailyGoal),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: SegmentedButton<DailyGoal>(
              segments: [
                ButtonSegment(value: DailyGoal.relaxed, label: Text(l10n.dailyGoalRelaxed)),
                ButtonSegment(value: DailyGoal.normal, label: Text(l10n.dailyGoalNormal)),
                ButtonSegment(value: DailyGoal.ambitious, label: Text(l10n.dailyGoalAmbitious)),
              ],
              selected: {settings.dailyGoal},
              onSelectionChanged: (s) => settingsProvider.setDailyGoal(s.first),
            ),
          ),
          const Divider(height: 32),
          SwitchListTile(
            title: Text(l10n.settingsUseHearts),
            value: settings.useHearts,
            onChanged: settingsProvider.setUseHearts,
          ),
          SwitchListTile(
            title: Text(l10n.settingsDailyReminder),
            subtitle: Text(l10n.commonComingSoon),
            value: settings.dailyReminderEnabled,
            onChanged: settingsProvider.setDailyReminderEnabled,
          ),
          SwitchListTile(
            title: Text(l10n.settingsAllLessonsUnlocked),
            value: settings.allLessonsUnlocked,
            onChanged: settingsProvider.setAllLessonsUnlocked,
          ),
          SwitchListTile(
            title: Text(l10n.settingsReduceMotion),
            value: settings.reduceMotion,
            onChanged: settingsProvider.setReduceMotion,
          ),
          const Divider(height: 32),
          ListTile(
            leading: const Icon(Icons.cloud_upload_outlined),
            title: Text(l10n.settingsBackupProgress),
            subtitle: Text(l10n.commonComingSoon),
            enabled: false,
          ),
          ListTile(
            leading: const Icon(Icons.cloud_download_outlined),
            title: Text(l10n.settingsRestoreProgress),
            subtitle: Text(l10n.commonComingSoon),
            enabled: false,
          ),
          ListTile(
            leading: Icon(Icons.delete_outline, color: Theme.of(context).colorScheme.error),
            title: Text(l10n.settingsResetProgress),
            onTap: () => _confirmReset(context, l10n),
          ),
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: Text(l10n.settingsAbout),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => context.push('/settings/about'),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  String _languageName(String code) {
    switch (code) {
      case 'de':
        return 'Deutsch';
      case 'en':
        return 'English';
      case 'sv':
        return 'Svenska';
      case 'nl':
        return 'Nederlands';
      default:
        return code;
    }
  }

  Future<void> _confirmReset(BuildContext context, AppLocalizations l10n) async {
    final firstConfirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.resetProgressTitle),
        content: Text(l10n.resetProgressWarning),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: Text(l10n.commonCancel)),
          FilledButton(onPressed: () => Navigator.pop(ctx, true), child: Text(l10n.commonConfirm)),
        ],
      ),
    );
    if (firstConfirm != true || !context.mounted) return;

    final controller = TextEditingController();
    final secondConfirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.resetProgressTitle),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l10n.resetProgressTypeWord),
            const SizedBox(height: 12),
            TextField(controller: controller, autofocus: true),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: Text(l10n.commonCancel)),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: Theme.of(ctx).colorScheme.error),
            onPressed: () => Navigator.pop(
              ctx,
              controller.text.trim().toLowerCase() == l10n.resetProgressConfirmWord.toLowerCase(),
            ),
            child: Text(l10n.settingsResetProgress),
          ),
        ],
      ),
    );
    if (secondConfirm != true || !context.mounted) return;

    await context.read<SettingsProvider>().setOnboardingCompleted(false);
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.resetProgressDone)));
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader(this.title);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleSmall?.copyWith(color: Theme.of(context).colorScheme.primary),
      ),
    );
  }
}

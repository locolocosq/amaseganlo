import 'dart:convert';
import 'dart:typed_data';

import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../core/language_names.dart';
import '../../core/purchase_service.dart';
import '../../core/theme.dart';
import '../../l10n/app_localizations.dart';
import '../../models/settings.dart';
import '../../state/progress_provider.dart';
import '../../state/settings_provider.dart';

const _backupTypeGroup = XTypeGroup(label: 'json', extensions: ['json']);

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final settingsProvider = context.watch<SettingsProvider>();
    final settings = settingsProvider.settings;
    final purchaseService = context.watch<PurchaseService>();

    void savedSnack() {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.settingsSaved), duration: const Duration(seconds: 1)),
      );
    }

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(icon: const Icon(Icons.arrow_back), tooltip: l10n.commonBack, onPressed: () => context.pop()),
        title: Text(l10n.settingsTitle),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(0, 12, 0, 24),
        children: [
          _SettingsSection(
            icon: Icons.language,
            color: AppBrandColors.green,
            title: l10n.settingsLanguage,
            children: [
              DropdownButtonFormField<String>(
                initialValue: settings.localeCode,
                items: [
                  DropdownMenuItem(value: null, child: Text(l10n.appearanceSystem)),
                  for (final code in supportedLocaleCodes)
                    DropdownMenuItem(value: code, child: Text(languageDisplayName(code))),
                ],
                onChanged: (code) {
                  settingsProvider.setLocaleCode(code);
                  savedSnack();
                },
              ),
            ],
          ),
          _SettingsSection(
            icon: Icons.brightness_6_outlined,
            color: AppBrandColors.gold,
            title: l10n.settingsAppearance,
            children: [
              SegmentedButton<AppThemeMode>(
                segments: [
                  ButtonSegment(value: AppThemeMode.light, label: Text(l10n.appearanceLight), icon: const Icon(Icons.light_mode_outlined)),
                  ButtonSegment(value: AppThemeMode.dark, label: Text(l10n.appearanceDark), icon: const Icon(Icons.dark_mode_outlined)),
                  ButtonSegment(value: AppThemeMode.system, label: Text(l10n.appearanceSystem), icon: const Icon(Icons.brightness_auto_outlined)),
                ],
                selected: {settings.themeMode},
                onSelectionChanged: (s) => settingsProvider.setThemeMode(s.first),
              ),
            ],
          ),
          _SettingsSection(
            icon: Icons.text_fields,
            color: AppBrandColors.terracotta,
            title: l10n.settingsFontSize,
            children: [
              SegmentedButton<FontSizeOption>(
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
            ],
          ),
          _SettingsSection(
            icon: Icons.abc,
            color: AppBrandColors.green,
            title: l10n.settingsShowFidelInMainPath,
            children: [
              RadioGroup<FidelDisplayMode>(
                groupValue: settings.fidelDisplayMode,
                onChanged: (v) {
                  if (v != null) settingsProvider.setFidelDisplayMode(v);
                },
                child: Column(
                  children: [
                    RadioListTile<FidelDisplayMode>(
                      contentPadding: EdgeInsets.zero,
                      title: Text(l10n.fidelDisplayNever),
                      value: FidelDisplayMode.never,
                    ),
                    RadioListTile<FidelDisplayMode>(
                      contentPadding: EdgeInsets.zero,
                      title: Text(l10n.fidelDisplayBelow),
                      value: FidelDisplayMode.below,
                    ),
                    RadioListTile<FidelDisplayMode>(
                      contentPadding: EdgeInsets.zero,
                      title: Text(l10n.fidelDisplayInstead),
                      value: FidelDisplayMode.instead,
                    ),
                  ],
                ),
              ),
            ],
          ),
          _SettingsSection(
            icon: Icons.speed_outlined,
            color: AppBrandColors.gold,
            title: l10n.settingsFidelLearningPath,
            children: [
              RadioGroup<FidelLearningPath>(
                groupValue: settings.fidelLearningPath,
                onChanged: (v) {
                  if (v != null) settingsProvider.setFidelLearningPath(v);
                },
                child: Column(
                  children: [
                    RadioListTile<FidelLearningPath>(
                      contentPadding: EdgeInsets.zero,
                      title: Text(l10n.fidelPathTraditional),
                      value: FidelLearningPath.traditional,
                    ),
                    RadioListTile<FidelLearningPath>(
                      contentPadding: EdgeInsets.zero,
                      title: Text(l10n.fidelPathFast),
                      value: FidelLearningPath.fast,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              Text(l10n.settingsHahuTempo, style: Theme.of(context).textTheme.labelLarge),
              const SizedBox(height: 8),
              SegmentedButton<HahuTempo>(
                segments: [
                  ButtonSegment(value: HahuTempo.slow, label: Text(l10n.hahuTempoSlow)),
                  ButtonSegment(value: HahuTempo.normal, label: Text(l10n.hahuTempoNormal)),
                  ButtonSegment(value: HahuTempo.fast, label: Text(l10n.hahuTempoFast)),
                ],
                selected: {settings.hahuTempo},
                onSelectionChanged: (s) => settingsProvider.setHahuTempo(s.first),
              ),
            ],
          ),
          _SettingsSection(
            icon: Icons.volume_up_outlined,
            color: AppBrandColors.terracotta,
            title: l10n.settingsSound,
            children: [
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(l10n.settingsSound),
                value: settings.soundEnabled,
                onChanged: settingsProvider.setSoundEnabled,
              ),
              Row(
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
              const SizedBox(height: 4),
              Text(l10n.settingsSpeechRate, style: Theme.of(context).textTheme.labelLarge),
              const SizedBox(height: 8),
              SegmentedButton<SpeechRate>(
                segments: [
                  ButtonSegment(value: SpeechRate.slow, label: Text(l10n.speechRateSlow)),
                  ButtonSegment(value: SpeechRate.medium, label: Text(l10n.speechRateMedium)),
                  ButtonSegment(value: SpeechRate.normal, label: Text(l10n.speechRateNormal)),
                ],
                selected: {settings.speechRate},
                onSelectionChanged: settings.soundEnabled ? (s) => settingsProvider.setSpeechRate(s.first) : null,
              ),
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(l10n.settingsAutoPlayNewWords),
                value: settings.autoPlayNewWords,
                onChanged: settingsProvider.setAutoPlayNewWords,
              ),
            ],
          ),
          _SettingsSection(
            icon: Icons.flag_outlined,
            color: AppBrandColors.green,
            title: l10n.settingsDailyGoal,
            children: [
              SegmentedButton<DailyGoal>(
                segments: [
                  ButtonSegment(value: DailyGoal.relaxed, label: Text(l10n.dailyGoalRelaxed)),
                  ButtonSegment(value: DailyGoal.normal, label: Text(l10n.dailyGoalNormal)),
                  ButtonSegment(value: DailyGoal.ambitious, label: Text(l10n.dailyGoalAmbitious)),
                ],
                selected: {settings.dailyGoal},
                onSelectionChanged: (s) => settingsProvider.setDailyGoal(s.first),
              ),
            ],
          ),
          _SettingsSection(
            icon: Icons.tune,
            color: AppBrandColors.gold,
            title: l10n.settingsMoreOptions,
            children: [
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(l10n.settingsUseHearts),
                value: settings.useHearts,
                onChanged: settingsProvider.setUseHearts,
              ),
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(l10n.settingsDailyReminder),
                subtitle: Text(l10n.commonComingSoon),
                value: settings.dailyReminderEnabled,
                onChanged: settingsProvider.setDailyReminderEnabled,
              ),
            ],
          ),
          _SettingsSection(
            icon: Icons.workspace_premium_outlined,
            color: AppBrandColors.terracotta,
            title: l10n.settingsPremiumSection,
            children: [
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(l10n.settingsPremium),
                subtitle: Text(purchaseService.isPremium ? l10n.settingsPremiumActive : l10n.settingsPremiumHint),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => context.push('/settings/premium'),
              ),
            ],
          ),
          _SettingsSection(
            icon: Icons.storage_outlined,
            color: AppBrandColors.green,
            title: l10n.settingsDataSection,
            children: [
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.cloud_upload_outlined),
                title: Text(l10n.settingsBackupProgress),
                onTap: () => _backupProgress(context, l10n),
              ),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.cloud_download_outlined),
                title: Text(l10n.settingsRestoreProgress),
                onTap: () => _restoreProgress(context, l10n),
              ),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Icon(Icons.delete_outline, color: Theme.of(context).colorScheme.error),
                title: Text(l10n.settingsResetProgress),
                onTap: () => _confirmReset(context, l10n),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: ListTile(
              leading: const Icon(Icons.info_outline),
              title: Text(l10n.settingsAbout),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => context.push('/settings/about'),
            ),
          ),
        ],
      ),
    );
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

  /// Exports the current progress as a JSON file. Uses the same
  /// [XFile.saveTo] call on every platform: on Web this triggers a browser
  /// download (the [FileSaveLocation.path] is ignored there), on
  /// Android/iOS it writes to the path the user picked - see
  /// ENTSCHEIDUNGEN.md Etappe 10 for why this works without `dart:io`.
  Future<void> _backupProgress(BuildContext context, AppLocalizations l10n) async {
    final progress = context.read<ProgressProvider>();
    try {
      final location = await getSaveLocation(
        suggestedName: 'habesha_speak_backup.json',
        acceptedTypeGroups: const [_backupTypeGroup],
      );
      if (location == null) return;
      final bytes = Uint8List.fromList(utf8.encode(progress.exportJson()));
      final file = XFile.fromData(bytes, name: 'habesha_speak_backup.json', mimeType: 'application/json');
      await file.saveTo(location.path);
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.backupProgressDone)));
    } catch (_) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.backupProgressError)));
    }
  }

  Future<void> _restoreProgress(BuildContext context, AppLocalizations l10n) async {
    final file = await openFile(acceptedTypeGroups: const [_backupTypeGroup]);
    if (file == null || !context.mounted) return;

    String contents;
    try {
      contents = await file.readAsString();
    } catch (_) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.restoreProgressInvalidFile)));
      return;
    }
    if (!context.mounted) return;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.restoreProgressTitle),
        content: Text(l10n.restoreProgressWarning),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: Text(l10n.commonCancel)),
          FilledButton(onPressed: () => Navigator.pop(ctx, true), child: Text(l10n.commonConfirm)),
        ],
      ),
    );
    if (confirmed != true || !context.mounted) return;

    try {
      await context.read<ProgressProvider>().importJson(contents);
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.restoreProgressDone)));
    } catch (_) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.restoreProgressInvalidFile)));
    }
  }
}

/// A grouped settings card with a colored icon badge header (Etappe 19:
/// replaces the old flat list + section-label + divider look). Each
/// section is handed one of the three recurring brand colors so they show
/// up "immer wieder" while scrolling, without ever covering a whole card.
class _SettingsSection extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String title;
  final List<Widget> children;

  const _SettingsSection({
    required this.icon,
    required this.color,
    required this.title,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: 0.16),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(icon, size: 20, color: color),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              ...children,
            ],
          ),
        ),
      ),
    );
  }
}

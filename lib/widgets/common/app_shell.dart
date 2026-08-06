import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../core/theme.dart';
import '../../l10n/app_localizations.dart';
import '../../state/progress_provider.dart';

/// The four main areas (Learn, Fidel, Review, Profile) live in a
/// [StatefulShellRoute], so switching tabs preserves each tab's scroll
/// position and navigation state instead of rebuilding it from scratch.
class AppShell extends StatefulWidget {
  final StatefulNavigationShell navigationShell;

  const AppShell({super.key, required this.navigationShell});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  DateTime? _lastBackPress;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final isHome = widget.navigationShell.currentIndex == 0;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        if (!isHome) {
          widget.navigationShell.goBranch(0);
          return;
        }
        final now = DateTime.now();
        if (_lastBackPress != null && now.difference(_lastBackPress!) < const Duration(seconds: 2)) {
          SystemNavigatorPopHelper.pop();
          return;
        }
        _lastBackPress = now;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.exitAppConfirm), duration: const Duration(seconds: 2)),
        );
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(_titleFor(widget.navigationShell.currentIndex, l10n)),
          actions: [
            const _StreakXpBadges(),
            IconButton(
              icon: const Icon(Icons.settings_outlined),
              tooltip: l10n.settingsTitle,
              onPressed: () => context.push('/settings'),
            ),
            const SizedBox(width: 4),
          ],
          bottom: const _FlagAccentStripe(),
        ),
        body: SafeArea(
          top: false,
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 600),
              child: widget.navigationShell,
            ),
          ),
        ),
        bottomNavigationBar: NavigationBar(
          elevation: 6,
          selectedIndex: widget.navigationShell.currentIndex,
          onDestinationSelected: (index) => widget.navigationShell.goBranch(
            index,
            initialLocation: index == widget.navigationShell.currentIndex,
          ),
          destinations: [
            NavigationDestination(icon: const Icon(Icons.route_outlined), selectedIcon: const Icon(Icons.route), label: l10n.navLearn),
            NavigationDestination(icon: const Icon(Icons.abc_outlined), selectedIcon: const Icon(Icons.abc), label: l10n.navFidel),
            NavigationDestination(icon: const Icon(Icons.refresh_outlined), selectedIcon: const Icon(Icons.refresh), label: l10n.navReview),
            NavigationDestination(icon: const Icon(Icons.person_outline), selectedIcon: const Icon(Icons.person), label: l10n.navProfile),
          ],
        ),
      ),
    );
  }

  String _titleFor(int index, AppLocalizations l10n) {
    switch (index) {
      case 0:
        return l10n.navLearn;
      case 1:
        return l10n.navFidel;
      case 2:
        return l10n.navReview;
      case 3:
        return l10n.navProfile;
      default:
        return l10n.appTitle;
    }
  }
}

/// Thin wrapper so tests can run without a real platform channel for
/// SystemNavigator.pop().
class SystemNavigatorPopHelper {
  static void Function() pop = SystemNavigator.pop;
}

/// Always-visible streak/XP glance (Etappe 19: "wie eine App von einem
/// großen Hersteller") - the two stats a learner checks most often, now one
/// tap closer instead of buried in the Profil tab. Doubles as a home for
/// the gold/terracotta brand accents outside the settings/onboarding
/// screens they were originally added for.
class _StreakXpBadges extends StatelessWidget {
  const _StreakXpBadges();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final progress = context.watch<ProgressProvider>().progress;
    return Padding(
      padding: const EdgeInsets.only(right: 4),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _Badge(
            icon: Icons.local_fire_department_outlined,
            color: AppBrandColors.terracotta,
            value: progress.currentStreak,
            tooltip: l10n.profileCurrentStreak,
          ),
          const SizedBox(width: 6),
          _Badge(
            icon: Icons.bolt_outlined,
            color: AppBrandColors.gold,
            value: progress.xpTotal,
            tooltip: l10n.profileTotalXp,
          ),
        ],
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  final IconData icon;
  final Color color;
  final int value;
  final String tooltip;

  const _Badge({
    required this.icon,
    required this.color,
    required this.value,
    required this.tooltip,
  });

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.16),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 18, color: color),
            const SizedBox(width: 4),
            Text(
              '$value',
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: color,
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}

/// A thin, three-color underline below the app bar - a deliberately small,
/// recurring nod to the Ethiopian flag rather than repainting whole app
/// surfaces green/gelb/rot (Etappe 19: "aber nicht übertreiben").
class _FlagAccentStripe extends StatelessWidget implements PreferredSizeWidget {
  const _FlagAccentStripe();

  @override
  Size get preferredSize => const Size.fromHeight(3);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 3,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [AppBrandColors.green, AppBrandColors.gold, AppBrandColors.terracotta],
          stops: [0.0, 0.5, 1.0],
        ),
      ),
    );
  }
}

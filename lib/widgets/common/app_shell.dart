import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

import '../../l10n/app_localizations.dart';

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
            IconButton(
              icon: const Icon(Icons.settings_outlined),
              tooltip: l10n.settingsTitle,
              onPressed: () => context.push('/settings'),
            ),
          ],
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

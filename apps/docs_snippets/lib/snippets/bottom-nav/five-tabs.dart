// ignore_for_file: file_names // hyphenated name required by snippet manifest convention
import 'package:docs_snippets/src/demo.dart';
import 'package:flutter/material.dart';
import 'package:liqkit_ui/liqkit_ui.dart';

/// Snippet builder consumed by `apps/docs_snippets/lib/src/routes.g.dart`.
Widget bottomNavFiveTabsBuilder(BuildContext context) {
  return Align(
    heightFactor: 1,
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: LiqDemo<int>(
        initial: 0,
        builder:
            (i, set) => SizedBox(
              width: 360,
              // {@highlight}
              child: LiqBottomNavBar(
                currentIndex: i,
                onChanged: set,
                items: const <LiqBottomNavItem>[
                  LiqBottomNavItem(icon: Icons.home_filled, label: 'Home'),
                  LiqBottomNavItem(icon: Icons.search, label: 'Search'),
                  LiqBottomNavItem(icon: Icons.notifications, label: 'Inbox'),
                  LiqBottomNavItem(
                    icon: Icons.person_outline,
                    label: 'Profile',
                  ),
                  LiqBottomNavItem(icon: Icons.settings, label: 'Settings'),
                ],
              ),
              // {@endhighlight}
            ),
      ),
    ),
  );
}

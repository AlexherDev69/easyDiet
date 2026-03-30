import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'app_router.dart';

/// Bottom navigation bar item definition.
class _NavItem {
  const _NavItem({
    required this.label,
    required this.selectedIcon,
    required this.unselectedIcon,
    required this.path,
  });

  final String label;
  final IconData selectedIcon;
  final IconData unselectedIcon;
  final String path;
}

const _navItems = [
  _NavItem(
    label: 'Accueil',
    selectedIcon: Icons.dashboard,
    unselectedIcon: Icons.dashboard_outlined,
    path: AppRoutes.dashboard,
  ),
  _NavItem(
    label: 'Repas',
    selectedIcon: Icons.restaurant_menu,
    unselectedIcon: Icons.restaurant_menu_outlined,
    path: AppRoutes.mealPlan,
  ),
  _NavItem(
    label: 'Courses',
    selectedIcon: Icons.shopping_bag,
    unselectedIcon: Icons.shopping_bag_outlined,
    path: AppRoutes.shoppingList,
  ),
  _NavItem(
    label: 'Recettes',
    selectedIcon: Icons.menu_book,
    unselectedIcon: Icons.menu_book_outlined,
    path: AppRoutes.recipeList,
  ),
  _NavItem(
    label: 'Poids',
    selectedIcon: Icons.monitor_weight,
    unselectedIcon: Icons.monitor_weight_outlined,
    path: AppRoutes.weightLog,
  ),
];

/// Duration for the icon switch and scale bounce animation.
const _kIconAnimationDuration = Duration(milliseconds: 250);

/// Animated icon that bounces to filled when selected and fades to outlined
/// when deselected. Uses [AnimatedSwitcher] so no [StatefulWidget] is needed.
class _AnimatedNavIcon extends StatelessWidget {
  const _AnimatedNavIcon({required this.item, required this.isSelected});

  final _NavItem item;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: _kIconAnimationDuration,
      // Scale bounce on entry: overshoots to 1.25 then settles at 1.0.
      transitionBuilder: (child, animation) {
        final scaleAnimation = Tween<double>(begin: 0.6, end: 1.0).animate(
          CurvedAnimation(parent: animation, curve: Curves.elasticOut),
        );
        return ScaleTransition(scale: scaleAnimation, child: child);
      },
      child: Icon(
        isSelected ? item.selectedIcon : item.unselectedIcon,
        // ValueKey ensures AnimatedSwitcher detects the state change.
        key: ValueKey<bool>(isSelected),
      ),
    );
  }
}

/// Shell scaffold with a bottom navigation bar for the 5 main tabs.
class ScaffoldWithNavBar extends StatelessWidget {
  const ScaffoldWithNavBar({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final selectedIndex = _calculateSelectedIndex(context);
    return Scaffold(
      // FadeThroughTransition equivalent: AnimatedSwitcher with a cross-fade
      // between tabs. ValueKey on the route path ensures the animation fires
      // on every top-level tab change while sub-route pushes (e.g. recipe
      // detail) are handled by the nested navigator and don't re-trigger it.
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: KeyedSubtree(
          key: ValueKey(GoRouterState.of(context).uri.path),
          child: child,
        ),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: selectedIndex,
        onDestinationSelected: (index) => context.go(_navItems[index].path),
        destinations: [
          for (var i = 0; i < _navItems.length; i++)
            NavigationDestination(
              icon: _AnimatedNavIcon(item: _navItems[i], isSelected: false),
              selectedIcon: _AnimatedNavIcon(item: _navItems[i], isSelected: true),
              label: _navItems[i].label,
            ),
        ],
      ),
    );
  }

  int _calculateSelectedIndex(BuildContext context) {
    final location = GoRouterState.of(context).uri.path;
    for (var i = 0; i < _navItems.length; i++) {
      if (location.startsWith(_navItems[i].path)) return i;
    }
    return 0;
  }
}

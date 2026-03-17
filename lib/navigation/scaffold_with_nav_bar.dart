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
    selectedIcon: Icons.fitness_center,
    unselectedIcon: Icons.fitness_center_outlined,
    path: AppRoutes.weightLog,
  ),
];

/// Shell scaffold with a bottom navigation bar for the 5 main tabs.
class ScaffoldWithNavBar extends StatelessWidget {
  const ScaffoldWithNavBar({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _calculateSelectedIndex(context),
        onTap: (index) => _onItemTapped(index, context),
        items: _navItems
            .map(
              (item) => BottomNavigationBarItem(
                icon: Icon(item.unselectedIcon),
                activeIcon: Icon(item.selectedIcon),
                label: item.label,
              ),
            )
            .toList(),
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

  void _onItemTapped(int index, BuildContext context) {
    context.go(_navItems[index].path);
  }
}

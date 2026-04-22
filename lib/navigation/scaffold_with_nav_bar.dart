import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../core/theme/app_colors.dart';
import 'app_router.dart';

class _NavItem {
  const _NavItem({
    required this.label,
    required this.icon,
    required this.path,
  });

  final String label;
  final IconData icon;
  final String path;
}

const _navItems = [
  _NavItem(
    label: 'Accueil',
    icon: LucideIcons.house,
    path: AppRoutes.dashboard,
  ),
  _NavItem(
    label: 'Repas',
    icon: LucideIcons.utensils,
    path: AppRoutes.mealPlan,
  ),
  _NavItem(
    label: 'Courses',
    icon: LucideIcons.shoppingBag,
    path: AppRoutes.shoppingList,
  ),
  _NavItem(
    label: 'Recettes',
    icon: LucideIcons.bookOpen,
    path: AppRoutes.recipeList,
  ),
  _NavItem(
    label: 'Poids',
    icon: LucideIcons.circleGauge,
    path: AppRoutes.weightLog,
  ),
];

const _kAnimationDuration = Duration(milliseconds: 260);

/// Shell scaffold with a floating pill-style bottom navigation bar.
class ScaffoldWithNavBar extends StatelessWidget {
  const ScaffoldWithNavBar({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final selectedIndex = _calculateSelectedIndex(context);
    return Scaffold(
      extendBody: true,
      body: child,
      bottomNavigationBar: _FloatingNavBar(
        selectedIndex: selectedIndex,
        onItemTapped: (index) => context.go(_navItems[index].path),
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

/// Floating, pill-shaped nav bar with glass blur, layered shadow, gradient
/// border, and a subtle idle float animation.
class _FloatingNavBar extends StatefulWidget {
  const _FloatingNavBar({
    required this.selectedIndex,
    required this.onItemTapped,
  });

  final int selectedIndex;
  final ValueChanged<int> onItemTapped;

  @override
  State<_FloatingNavBar> createState() => _FloatingNavBarState();
}

class _FloatingNavBarState extends State<_FloatingNavBar>
    with SingleTickerProviderStateMixin {
  late final AnimationController _float;

  @override
  void initState() {
    super.initState();
    _float = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3200),
    )..repeat(reverse: true);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (MediaQuery.of(context).disableAnimations) {
      _float.stop();
      _float.value = 0.5;
    }
  }

  @override
  void dispose() {
    _float.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // RepaintBoundary isolates the whole bar so the float animation never
    // marks the scrolling page body dirty, and vice-versa.
    return RepaintBoundary(
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
          child: AnimatedBuilder(
            animation: _float,
            builder: (context, child) {
              final t = Curves.easeInOut.transform(_float.value);
              final dy = -2.0 + t * -2.0;
              return Transform.translate(
                offset: Offset(0, dy),
                child: child,
              );
            },
            child: DecoratedBox(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(28),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.10),
                    blurRadius: 24,
                    offset: const Offset(0, 10),
                  ),
                  BoxShadow(
                    color: AppColors.emeraldPrimary.withValues(alpha: 0.08),
                    blurRadius: 32,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.white.withValues(alpha: 0.96),
                      Colors.white.withValues(alpha: 0.88),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(28),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.9),
                    width: 1.2,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 8,
                  ),
                  child: Row(
                    children: [
                      for (var i = 0; i < _navItems.length; i++)
                        _FloatingNavItem(
                          item: _navItems[i],
                          isSelected: widget.selectedIndex == i,
                          onTap: () => widget.onItemTapped(i),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _FloatingNavItem extends StatelessWidget {
  const _FloatingNavItem({
    required this.item,
    required this.isSelected,
    required this.onTap,
  });

  final _NavItem item;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    const selectedColor = AppColors.emeraldPrimary;
    const unselectedColor = Color(0xFF64748B);
    final itemColor = isSelected ? selectedColor : unselectedColor;

    return Expanded(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AnimatedContainer(
                  duration: _kAnimationDuration,
                  curve: Curves.easeOutCubic,
                  width: 44,
                  height: 32,
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.emeraldPrimary.withValues(alpha: 0.14)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  alignment: Alignment.center,
                  child: Icon(
                    item.icon,
                    size: 20,
                    color: itemColor,
                  ),
                ),
                const SizedBox(height: 4),
                AnimatedDefaultTextStyle(
                  duration: _kAnimationDuration,
                  style: GoogleFonts.nunito(
                    fontSize: 11,
                    fontWeight:
                        isSelected ? FontWeight.w800 : FontWeight.w600,
                    color: itemColor,
                    letterSpacing: -0.1,
                  ),
                  child: Text(item.label),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

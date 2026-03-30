import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'core/theme/app_theme.dart';

/// Root widget for EasyDiet.
class EasyDietApp extends StatelessWidget {
  const EasyDietApp({required this.router, super.key});

  final GoRouter router;

  @override
  Widget build(BuildContext context) {
    return ExtendedColorsProvider(
      colors: AppTheme.extendedColors,
      child: MaterialApp.router(
        title: 'EasyDiet',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light(),
        darkTheme: AppTheme.dark(),
        themeMode: ThemeMode.system,
        routerConfig: router,
      ),
    );
  }
}

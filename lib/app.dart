import 'package:flutter/material.dart';

import 'core/theme/app_theme.dart';
import 'navigation/app_router.dart';

/// Root widget for EasyDiet.
class EasyDietApp extends StatelessWidget {
  const EasyDietApp({super.key});

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
        routerConfig: appRouter,
      ),
    );
  }
}

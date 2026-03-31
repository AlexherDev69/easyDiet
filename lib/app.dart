import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
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
        locale: const Locale('fr', 'FR'),
        supportedLocales: const [Locale('fr', 'FR')],
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        routerConfig: router,
      ),
    );
  }
}

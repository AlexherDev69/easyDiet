import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'app.dart';
import 'core/di/injection.dart';
import 'core/theme/app_colors.dart';
import 'features/settings/domain/repositories/user_profile_repository.dart';
import 'navigation/app_router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize French locale for date formatting
  await initializeDateFormatting('fr_FR', null);

  // Show splash while DI + seeding + profile check runs
  runApp(const _SplashLoader());
}

class _SplashLoader extends StatefulWidget {
  const _SplashLoader();

  @override
  State<_SplashLoader> createState() => _SplashLoaderState();
}

class _SplashLoaderState extends State<_SplashLoader> {
  Widget? _app;

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    await configureDependencies();

    // Determine start screen before building the router
    final profile = await getIt<UserProfileRepository>().getProfile();
    final initialRoute = (profile?.onboardingCompleted == true)
        ? AppRoutes.dashboard
        : AppRoutes.onboarding;

    if (mounted) {
      setState(() {
        _app = EasyDietApp(router: createAppRouter(initialRoute));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_app != null) return _app!;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: AppColors.emeraldPrimary,
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.restaurant, size: 64, color: Colors.white.withValues(alpha: 0.9)),
              const SizedBox(height: 24),
              const Text(
                'EasyDiet',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 16),
              const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

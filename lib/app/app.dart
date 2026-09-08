import 'package:flutter/material.dart';
import '../core/constants/app_constants.dart';
import '../routes/app_routes.dart';
import '../theme/app_theme.dart';
import '../theme/theme_controller.dart';

/// Root Application Widget configuring Material 3 themes, theme switching, and responsive routing.
class ZenerLabApp extends StatelessWidget {
  const ZenerLabApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: ThemeController.instance,
      builder: (context, themeMode, _) {
        return MaterialApp(
          title: AppConstants.appName,
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: themeMode,
          initialRoute: AppRoutes.mainShell,
          onGenerateRoute: AppRoutes.onGenerateRoute,
        );
      },
    );
  }
}

import 'package:flutter/material.dart';
import '../features/experience/presentation/immersive_lab_screen.dart';

/// App routes constants and route generation logic.
class AppRoutes {
  AppRoutes._();

  static const String mainShell = '/';

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    return MaterialPageRoute(
      builder: (_) => const ImmersiveLabScreen(),
      settings: settings,
    );
  }
}

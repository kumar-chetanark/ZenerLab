import 'package:flutter/material.dart';
import '../core/constants/app_constants.dart';
import '../core/utils/responsive_layout.dart';
import '../core/widgets/status_indicator.dart';
import '../features/analysis/presentation/analysis_screen.dart';
import '../features/dashboard/presentation/dashboard_screen.dart';
import '../features/experiment/presentation/experiment_screen.dart';
import '../features/quiz/presentation/quiz_screen.dart';
import '../features/simulator/presentation/simulator_screen.dart';
import '../features/theory/presentation/theory_screen.dart';
import '../theme/app_colors.dart';
import '../theme/theme_controller.dart';

/// Main Application Navigation Shell managing top app bar, responsive side rail/bottom bar, and smooth animated page switches.
class MainShellScreen extends StatefulWidget {
  const MainShellScreen({super.key});

  @override
  State<MainShellScreen> createState() => _MainShellScreenState();
}

class _MainShellScreenState extends State<MainShellScreen> {
  int _currentIndex = 0;

  final List<_DestinationItem> _destinations = const [
    _DestinationItem(
      label: 'Dashboard',
      icon: Icons.dashboard_outlined,
      selectedIcon: Icons.dashboard_rounded,
    ),
    _DestinationItem(
      label: 'Simulator',
      icon: Icons.developer_board_outlined,
      selectedIcon: Icons.developer_board_rounded,
    ),
    _DestinationItem(
      label: 'Experiment',
      icon: Icons.science_outlined,
      selectedIcon: Icons.science_rounded,
    ),
    _DestinationItem(
      label: 'Theory',
      icon: Icons.menu_book_outlined,
      selectedIcon: Icons.menu_book_rounded,
    ),
    _DestinationItem(
      label: 'Analysis',
      icon: Icons.analytics_outlined,
      selectedIcon: Icons.analytics_rounded,
    ),
    _DestinationItem(
      label: 'Quiz',
      icon: Icons.quiz_outlined,
      selectedIcon: Icons.quiz_rounded,
    ),
  ];

  void _onTabSelected(int index) {
    if (_currentIndex != index) {
      setState(() {
        _currentIndex = index;
      });
    }
  }

  Widget _buildBody() {
    switch (_currentIndex) {
      case 0:
        return DashboardScreen(onNavigateToTab: _onTabSelected);
      case 1:
        return const SimulatorScreen();
      case 2:
        return const ExperimentScreen();
      case 3:
        return const TheoryScreen();
      case 4:
        return const AnalysisScreen();
      case 5:
        return const QuizScreen();
      default:
        return DashboardScreen(onNavigateToTab: _onTabSelected);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isMobile = ResponsiveLayout.isMobile(context);

    return Scaffold(
      appBar: AppBar(
        titleSpacing: isMobile ? AppConstants.spaceMd : AppConstants.spaceLg,
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(AppConstants.spaceSm - 2),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppColors.primary, AppColors.secondary],
                ),
                borderRadius: BorderRadius.circular(AppConstants.radiusSm),
              ),
              child: const Icon(
                Icons.bolt_rounded,
                color: Colors.white,
                size: 20,
              ),
            ),
            const SizedBox(width: AppConstants.spaceSm + 2),
            Text(
              AppConstants.appName,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w800,
                letterSpacing: -0.5,
              ),
            ),
            const SizedBox(width: AppConstants.spaceSm),
            if (!isMobile)
              Text(
                '|  ${_destinations[_currentIndex].label}',
                style: theme.textTheme.titleMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                  fontWeight: FontWeight.w500,
                ),
              ),
          ],
        ),
        actions: [
          // Live Lab Status Chip
          if (!isMobile) ...[
            const StatusIndicator(
              label: 'Local Lab Engine Active',
              type: StatusType.active,
            ),
            const SizedBox(width: AppConstants.spaceSm),
          ],

          // Dark/Light Mode Switcher
          ValueListenableBuilder<ThemeMode>(
            valueListenable: ThemeController.instance,
            builder: (context, mode, _) {
              final isDark = ThemeController.instance.isDarkMode(context);
              return IconButton(
                tooltip: isDark ? 'Switch to Light Mode' : 'Switch to Dark Mode',
                icon: Icon(
                  isDark ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                onPressed: () => ThemeController.instance.toggleTheme(context),
              );
            },
          ),
          const SizedBox(width: AppConstants.spaceSm),
        ],
      ),
      body: Row(
        children: [
          // Sidebar / Rail for Tablet and Desktop
          if (!isMobile)
            NavigationRail(
              selectedIndex: _currentIndex,
              onDestinationSelected: _onTabSelected,
              labelType: NavigationRailLabelType.all,
              minWidth: 76,
              destinations: _destinations.map((d) {
                return NavigationRailDestination(
                  icon: Icon(d.icon),
                  selectedIcon: Icon(d.selectedIcon),
                  label: Text(d.label),
                );
              }).toList(),
            ),

          // Main Content View with Animated Switcher Transition
          Expanded(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 240),
              switchInCurve: Curves.easeOutCubic,
              switchOutCurve: Curves.easeInCubic,
              transitionBuilder: (child, animation) {
                return FadeTransition(
                  opacity: animation,
                  child: SlideTransition(
                    position: Tween<Offset>(
                      begin: const Offset(0.01, 0),
                      end: Offset.zero,
                    ).animate(animation),
                    child: child,
                  ),
                );
              },
              child: KeyedSubtree(
                key: ValueKey<int>(_currentIndex),
                child: _buildBody(),
              ),
            ),
          ),
        ],
      ),
      // Bottom Navigation Bar for Mobile Phones
      bottomNavigationBar: isMobile
          ? NavigationBar(
              selectedIndex: _currentIndex,
              onDestinationSelected: _onTabSelected,
              destinations: _destinations.map((d) {
                return NavigationDestination(
                  icon: Icon(d.icon),
                  selectedIcon: Icon(d.selectedIcon),
                  label: d.label,
                );
              }).toList(),
            )
          : null,
    );
  }
}

class _DestinationItem {
  final String label;
  final IconData icon;
  final IconData selectedIcon;

  const _DestinationItem({
    required this.label,
    required this.icon,
    required this.selectedIcon,
  });
}

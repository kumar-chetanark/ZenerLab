import 'package:flutter/material.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/widgets/widgets.dart';
import '../../../../simulation/simulation.dart';
import '../../../../theme/app_colors.dart';
import 'widgets/kinetic_hero_3d_widget.dart';

/// Landing dashboard showing hero banner, live circuit metrics, "how it works", and lab shortcuts
class DashboardScreen extends StatelessWidget {
  final ValueChanged<int> onNavigateToTab;

  const DashboardScreen({
    super.key,
    required this.onNavigateToTab,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final controller = SimulatorController.instance;

    return ListenableBuilder(
      listenable: controller,
      builder: (context, _) {
        final result = controller.currentResult;

        return SingleChildScrollView(
          padding: const EdgeInsets.all(AppConstants.spaceLg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Hero Banner
              AppCard(
                color: theme.colorScheme.primaryContainer.withValues(alpha: 0.35),
                borderColor: theme.colorScheme.primary.withValues(alpha: 0.3),
                padding: const EdgeInsets.all(AppConstants.spaceLg),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final isWide = constraints.maxWidth > 750;
                    return Flex(
                      direction: isWide ? Axis.horizontal : Axis.vertical,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          flex: isWide ? 1 : 0,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    AppConstants.appName,
                                    style: theme.textTheme.displayMedium?.copyWith(
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                  const SizedBox(width: AppConstants.spaceSm),
                                  StatusIndicator(
                                    label: result.zenerState.displayName,
                                    type: result.isRegulating ? StatusType.active : StatusType.warning,
                                  ),
                                ],
                              ),
                              const SizedBox(height: AppConstants.spaceXs),
                              Text(
                                AppConstants.appTagline,
                                style: theme.textTheme.bodyLarge?.copyWith(
                                  color: theme.colorScheme.onSurfaceVariant,
                                ),
                              ),
                              const SizedBox(height: AppConstants.spaceLg),
                              Wrap(
                                spacing: AppConstants.spaceSm,
                                runSpacing: AppConstants.spaceSm,
                                children: [
                                  AppButton.primary(
                                    label: 'Start Simulation',
                                    icon: Icons.play_arrow_rounded,
                                    onPressed: () => onNavigateToTab(1), // Simulator tab
                                  ),
                                  AppButton.secondary(
                                    label: 'Run Experiment',
                                    icon: Icons.science_rounded,
                                    onPressed: () => onNavigateToTab(2), // Experiment tab
                                  ),
                                  AppButton.secondary(
                                    label: 'Learn Theory',
                                    icon: Icons.menu_book_rounded,
                                    onPressed: () => onNavigateToTab(3), // Theory tab
                                  ),
                                  AppButton.secondary(
                                    label: 'Take Quiz',
                                    icon: Icons.quiz_outlined,
                                    onPressed: () => onNavigateToTab(5), // Quiz tab
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        if (isWide) const SizedBox(width: AppConstants.spaceXl) else const SizedBox(height: AppConstants.spaceLg),
                        const KineticHero3DWidget(size: 210),
                      ],
                    );
                  },
                ),
              ),
              const SizedBox(height: AppConstants.spaceXl),

              // Quick Circuit Overview Cards displaying LIVE simulation engine values
              const SectionHeader(
                title: 'Live Circuit Baseline Readings',
                subtitle: 'Real-time parameters calculated directly from the simulation engine',
                icon: Icons.speed_rounded,
              ),
              LayoutBuilder(
                builder: (context, constraints) {
                  final width = constraints.maxWidth;
                  int columns = 1;
                  if (width >= 900) {
                    columns = 4;
                  } else if (width >= 500) {
                    columns = 2;
                  }

                  final itemWidth = (width - ((columns - 1) * AppConstants.spaceMd)) / columns;

                  return Wrap(
                    spacing: AppConstants.spaceMd,
                    runSpacing: AppConstants.spaceMd,
                    children: [
                      SizedBox(
                        width: itemWidth,
                        child: MetricCard(
                          label: 'Input Voltage (Vin)',
                          value: result.vin.toStringAsFixed(1),
                          unit: 'V',
                          icon: Icons.power_rounded,
                          accentColor: AppColors.voltageIn,
                          subtitle: 'DC Power Source',
                          onTap: () => onNavigateToTab(1),
                        ),
                      ),
                      SizedBox(
                        width: itemWidth,
                        child: MetricCard(
                          label: 'Zener Voltage (Vz)',
                          value: result.vz.toStringAsFixed(1),
                          unit: 'V',
                          icon: Icons.memory_rounded,
                          accentColor: AppColors.zenerVoltage,
                          subtitle: 'Breakdown Rating',
                          onTap: () => onNavigateToTab(1),
                        ),
                      ),
                      SizedBox(
                        width: itemWidth,
                        child: MetricCard(
                          label: 'Output Voltage (Vout)',
                          value: result.vout.toStringAsFixed(2),
                          unit: 'V',
                          icon: Icons.electric_bolt_rounded,
                          accentColor: AppColors.voltageOut,
                          subtitle: result.isBelowBreakdown ? 'Unregulated' : 'Regulated clamped',
                          onTap: () => onNavigateToTab(1),
                        ),
                      ),
                      SizedBox(
                        width: itemWidth,
                        child: MetricCard(
                          label: 'Zener Current (Iz)',
                          value: result.zenerCurrentMilliAmps.toStringAsFixed(2),
                          unit: 'mA',
                          icon: Icons.waves_rounded,
                          accentColor: AppColors.zenerCurrent,
                          subtitle: 'Pz = ${result.zenerPowerMilliWatts.toStringAsFixed(1)} mW',
                          onTap: () => onNavigateToTab(1),
                        ),
                      ),
                    ],
                  );
                },
              ),
              const SizedBox(height: AppConstants.spaceXl),

              // "How It Works" 3-step visual explanation
              const SectionHeader(
                title: 'How the Zener Regulator Works',
                subtitle: 'Core 3-step physical operation cycle',
                icon: Icons.lightbulb_outline_rounded,
              ),
              AppCard(
                padding: const EdgeInsets.all(AppConstants.spaceLg),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    LayoutBuilder(
                      builder: (context, constraints) {
                        final isWide = constraints.maxWidth > 750;
                        return Flex(
                          direction: isWide ? Axis.horizontal : Axis.vertical,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              flex: isWide ? 1 : 0,
                              child: const _ExplanationStep(
                                number: '1',
                                title: 'DC Input Applied',
                                description: 'Unregulated DC voltage Vin is applied across the series current-limiting resistor Rs.',
                                icon: Icons.input_rounded,
                                color: AppColors.voltageIn,
                              ),
                            ),
                            if (isWide) const SizedBox(width: AppConstants.spaceMd) else const SizedBox(height: AppConstants.spaceMd),
                            Expanded(
                              flex: isWide ? 1 : 0,
                              child: const _ExplanationStep(
                                number: '2',
                                title: 'Series Resistor Limits Is',
                                description: 'Rs limits current and drops excess voltage (Vin - Vout), protecting the diode from damage.',
                                icon: Icons.tune_rounded,
                                color: AppColors.primary,
                              ),
                            ),
                            if (isWide) const SizedBox(width: AppConstants.spaceMd) else const SizedBox(height: AppConstants.spaceMd),
                            Expanded(
                              flex: isWide ? 1 : 0,
                              child: const _ExplanationStep(
                                number: '3',
                                title: 'Zener Diode Clamps Vout',
                                description: 'Operating in reverse breakdown, the diode shunts excess current Iz to keep Vout steady at Vz.',
                                icon: Icons.lock_outline_rounded,
                                color: AppColors.voltageOut,
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppConstants.spaceXl),

              // Recent Experiments & Quick Navigation
              SectionHeader(
                title: 'Guided Laboratory Modules',
                subtitle: 'Jump straight into experiment benches and analysis charts',
                icon: Icons.explore_outlined,
                trailing: TextButton.icon(
                  onPressed: () => onNavigateToTab(4), // Analysis tab
                  icon: const Icon(Icons.arrow_forward_rounded, size: 16),
                  label: const Text('View All Analysis'),
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: AppCard(
                      onTap: () => onNavigateToTab(2),
                      padding: const EdgeInsets.all(AppConstants.spaceLg),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(AppConstants.spaceMd),
                            decoration: BoxDecoration(
                              color: AppColors.voltageOut.withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(AppConstants.radiusSm),
                            ),
                            child: const Icon(Icons.show_chart_rounded, color: AppColors.voltageOut, size: 28),
                          ),
                          const SizedBox(width: AppConstants.spaceMd),
                          const Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Line Regulation Lab', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                                SizedBox(height: 2),
                                Text('Vary input voltage and generate observation tables', style: TextStyle(fontSize: 12, color: Colors.grey)),
                              ],
                            ),
                          ),
                          const Icon(Icons.chevron_right_rounded),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: AppConstants.spaceMd),
                  Expanded(
                    child: AppCard(
                      onTap: () => onNavigateToTab(2),
                      padding: const EdgeInsets.all(AppConstants.spaceLg),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(AppConstants.spaceMd),
                            decoration: BoxDecoration(
                              color: AppColors.secondary.withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(AppConstants.radiusSm),
                            ),
                            child: const Icon(Icons.tune_rounded, color: AppColors.secondary, size: 28),
                          ),
                          const SizedBox(width: AppConstants.spaceMd),
                          const Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Load Regulation Lab', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                                SizedBox(height: 2),
                                Text('Vary load resistance and plot regulation curves', style: TextStyle(fontSize: 12, color: Colors.grey)),
                              ],
                            ),
                          ),
                          const Icon(Icons.chevron_right_rounded),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

class _ExplanationStep extends StatelessWidget {
  final String number;
  final String title;
  final String description;
  final IconData icon;
  final Color color;

  const _ExplanationStep({
    required this.number,
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(AppConstants.spaceMd),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(AppConstants.radiusSm),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 26,
                height: 26,
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    number,
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
                  ),
                ),
              ),
              const SizedBox(width: AppConstants.spaceSm),
              Icon(icon, size: 20, color: color),
            ],
          ),
          const SizedBox(height: AppConstants.spaceSm),
          Text(
            title,
            style: theme.textTheme.labelLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: AppConstants.space2xs),
          Text(
            description,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}

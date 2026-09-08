import 'package:flutter/material.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../simulation/simulation.dart';
import '../../../../theme/app_colors.dart';
import '../../../../theme/app_typography.dart';
import '../../../analysis/presentation/widgets/lab_chart_widget.dart';

/// Section 07 — Synchronized Laboratory Analysis Curves
class AnalysisCurvesSection extends StatelessWidget {
  const AnalysisCurvesSection({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = SimulatorController.instance;

    return ListenableBuilder(
      listenable: controller,
      builder: (context, _) {
        final result = controller.currentResult;
        final baseline = controller.parameters;

        // Generate dynamic sweeps for curves
        final vinSweep = controller.sweepService.sweep(
          baseline: baseline,
          configuration: const SweepConfiguration(
            parameter: SweepParameter.vin,
            start: 0,
            stop: 25,
            steps: 40,
          ),
        );

        final vinPoints = vinSweep.map((r) => GraphPoint(x: r.vin, y: r.vout)).toList();
        final currentVinPoint = GraphPoint(x: result.vin, y: result.vout);

        final rlSweep = controller.sweepService.sweep(
          baseline: baseline,
          configuration: const SweepConfiguration(
            parameter: SweepParameter.rl,
            start: 100,
            stop: 5000,
            steps: 40,
          ),
        );

        final rlPoints = rlSweep.map((r) => GraphPoint(x: r.rl, y: r.vout)).toList();
        final currentRlPoint = GraphPoint(x: result.rl, y: result.vout);

        return LayoutBuilder(
          builder: (context, constraints) {
            final isDesktop = constraints.maxWidth >= 960;

            return Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(
                horizontal: isDesktop ? AppConstants.spaceXl * 1.5 : AppConstants.spaceMd,
                vertical: 48,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '07 — MATHEMATICAL CHARACTERIZATION',
                    style: AppTypography.labelSmall.copyWith(
                      color: AppColors.primary,
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: AppConstants.spaceSm),
                  Text(
                    'SYNCHRONIZED ANALYSIS CURVES',
                    style: (isDesktop ? AppTypography.displayLarge : AppTypography.displayMedium).copyWith(
                      color: AppColors.darkTextPrimary,
                    ),
                  ),
                  const SizedBox(height: AppConstants.spaceSm),
                  Text(
                    'Observe how the physical operating point moves along the regulation plateau in real time.',
                    style: AppTypography.bodyLarge.copyWith(color: AppColors.darkTextSecondary),
                  ),
                  const SizedBox(height: AppConstants.spaceLg),

                  Flex(
                    direction: isDesktop ? Axis.horizontal : Axis.vertical,
                    children: [
                      // Line Regulation Plot
                      Expanded(
                        flex: isDesktop ? 1 : 0,
                        child: AppCard(
                          padding: const EdgeInsets.all(AppConstants.spaceLg),
                          color: AppColors.darkSurfaceContainer,
                          borderColor: AppColors.darkBorder,
                          child: LabChartWidget(
                            title: 'Line Regulation: Vin vs Vout',
                            xLabel: 'Input Potential (Vin)',
                            yLabel: 'Output Potential (Vout)',
                            xUnit: 'V',
                            yUnit: 'V',
                            points: vinPoints,
                            currentPoint: currentVinPoint,
                            lineColor: AppColors.primary,
                            interpretation: 'When Vin >= ${result.vz.toStringAsFixed(1)}V, Vout clamps horizontally to ${result.vz.toStringAsFixed(1)}V.',
                          ),
                        ),
                      ),
                      if (isDesktop) const SizedBox(width: AppConstants.spaceLg) else const SizedBox(height: AppConstants.spaceLg),

                      // Load Regulation Plot
                      Expanded(
                        flex: isDesktop ? 1 : 0,
                        child: AppCard(
                          padding: const EdgeInsets.all(AppConstants.spaceLg),
                          color: AppColors.darkSurfaceContainer,
                          borderColor: AppColors.darkBorder,
                          child: LabChartWidget(
                            title: 'Load Regulation: RL vs Vout',
                            xLabel: 'Load Resistance (RL)',
                            yLabel: 'Output Potential (Vout)',
                            xUnit: 'Ω',
                            yUnit: 'V',
                            points: rlPoints,
                            currentPoint: currentRlPoint,
                            lineColor: AppColors.voltageOut,
                            interpretation: 'Regulation holds steady across wide load variations until RL drops below the critical knee load.',
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
      },
    );
  }
}

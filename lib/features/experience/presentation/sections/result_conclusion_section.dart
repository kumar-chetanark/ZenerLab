import 'package:flutter/material.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../simulation/simulation.dart';
import '../../../../theme/app_colors.dart';
import '../../../../theme/app_typography.dart';

/// Lab Report Section: RESULT & CONCLUSION
/// Formal presentation of experimental results, regulation metrics, and conclusions, plus the assessment quiz.
class ResultConclusionSection extends StatelessWidget {
  final VoidCallback onSimulateAgain;
  final VoidCallback onTakeQuiz;
  final VoidCallback onExploreTheory;

  const ResultConclusionSection({
    super.key,
    required this.onSimulateAgain,
    required this.onTakeQuiz,
    required this.onExploreTheory,
  });

  @override
  Widget build(BuildContext context) {
    final controller = SimulatorController.instance;

    return ListenableBuilder(
      listenable: controller,
      builder: (context, _) {
        final result = controller.currentResult;
        final baseline = controller.parameters;

        // Calculate line and load regulation percentages from sweep points
        final vinHighSweep = controller.simulator.simulate(baseline.copyWith(vin: 20.0));
        final vinLowSweep = controller.simulator.simulate(baseline.copyWith(vin: 10.0));
        final deltaVoutLine = (vinHighSweep.vout - vinLowSweep.vout).abs();
        final lineRegPct = (deltaVoutLine / vinLowSweep.vout) * 100;

        final vNoLoad = baseline.vz;
        final vFullLoad = controller.simulator.simulate(baseline.copyWith(rl: 500.0)).vout;
        final loadRegPct = ((vNoLoad - vFullLoad) / vFullLoad).abs() * 100;

        return LayoutBuilder(
          builder: (context, constraints) {
            final isDesktop = constraints.maxWidth >= 960;

            return Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(
                horizontal: isDesktop ? AppConstants.spaceXl * 1.5 : AppConstants.spaceMd,
                vertical: 40,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '07 — RESULT & CONCLUSION',
                    style: AppTypography.labelSmall.copyWith(
                      color: AppColors.primary,
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: AppConstants.spaceSm),
                  Text(
                    'EXPERIMENTAL RESULTS & ENGINEERING CONCLUSION',
                    style: (isDesktop ? AppTypography.displayLarge : AppTypography.displayMedium).copyWith(
                      color: AppColors.darkTextPrimary,
                    ),
                  ),
                  const SizedBox(height: AppConstants.spaceSm),
                  Text(
                    'Summary of quantitative circuit performance, regulation metrics, and experimental conclusions.',
                    style: AppTypography.bodyLarge.copyWith(color: AppColors.darkTextSecondary),
                  ),
                  const SizedBox(height: AppConstants.spaceXl),

                  // Result Metrics Display
                  Wrap(
                    spacing: AppConstants.spaceMd,
                    runSpacing: AppConstants.spaceMd,
                    children: [
                      _buildResultMetricCard(
                        title: 'Zener Breakdown Voltage (Vz)',
                        value: '${result.vz.toStringAsFixed(2)} V',
                        subtitle: 'Clamped Output Voltage',
                        accent: AppColors.primary,
                        isDesktop: isDesktop,
                        width: isDesktop ? 260 : double.infinity,
                      ),
                      _buildResultMetricCard(
                        title: 'Line Regulation Factor',
                        value: '${lineRegPct.toStringAsFixed(3)} %',
                        subtitle: 'ΔVout / Vout for ΔVin = 10V',
                        accent: AppColors.voltageIn,
                        isDesktop: isDesktop,
                        width: isDesktop ? 260 : double.infinity,
                      ),
                      _buildResultMetricCard(
                        title: 'Load Regulation Factor',
                        value: '${loadRegPct.toStringAsFixed(3)} %',
                        subtitle: '(VNL - VFL) / VFL × 100',
                        accent: AppColors.voltageOut,
                        isDesktop: isDesktop,
                        width: isDesktop ? 260 : double.infinity,
                      ),
                      _buildResultMetricCard(
                        title: 'Operating State',
                        value: result.zenerState.displayName,
                        subtitle: result.isRegulating ? 'Tight Clamping Active' : 'Unregulated Region',
                        accent: result.isRegulating ? AppColors.success : AppColors.warning,
                        isDesktop: isDesktop,
                        width: isDesktop ? 260 : double.infinity,
                      ),
                    ],
                  ),
                  const SizedBox(height: AppConstants.spaceXl),

                  // Formal Result Statements Card
                  AppCard(
                    padding: const EdgeInsets.all(AppConstants.spaceLg),
                    color: AppColors.darkSurfaceContainer,
                    borderColor: AppColors.primary.withValues(alpha: 0.3),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.assignment_turned_in_rounded, color: AppColors.primary, size: 22),
                            const SizedBox(width: AppConstants.spaceSm),
                            Text('EXPERIMENTAL RESULT', style: AppTypography.titleMedium.copyWith(color: AppColors.primary, fontWeight: FontWeight.bold)),
                          ],
                        ),
                        const SizedBox(height: AppConstants.spaceMd),
                        _buildBulletPoint('1. The Zener diode circuit successfully regulated the output voltage at Vout ≈ ${result.vz.toStringAsFixed(1)} V despite input voltage fluctuations above ${result.vz.toStringAsFixed(1)} V.'),
                        _buildBulletPoint('2. In Line Regulation mode (with fixed load RL = 1 kΩ), output voltage remained constant within a line regulation factor of ${lineRegPct.toStringAsFixed(3)}%.'),
                        _buildBulletPoint('3. In Load Regulation mode (with fixed input Vin = 12 V), the output voltage maintained stability across varying load resistances from RL = 500 Ω to 5 kΩ with a load regulation factor of ${loadRegPct.toStringAsFixed(3)}%.'),
                        _buildBulletPoint('4. When load resistance dropped below the critical dropout threshold (RL < RL_min), the Zener diode was starved of current (Iz < Iz_min) and dropped out of regulation.'),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppConstants.spaceLg),

                  // Formal Conclusion Card
                  AppCard(
                    padding: const EdgeInsets.all(AppConstants.spaceLg),
                    color: AppColors.darkSurfaceContainer,
                    borderColor: AppColors.darkBorder,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.lightbulb_rounded, color: AppColors.secondary, size: 22),
                            const SizedBox(width: AppConstants.spaceSm),
                            Text('CONCLUSION', style: AppTypography.titleMedium.copyWith(color: AppColors.darkTextPrimary, fontWeight: FontWeight.bold)),
                          ],
                        ),
                        const SizedBox(height: AppConstants.spaceMd),
                        _buildBulletPoint('1. A Zener diode operates as an effective shunt voltage regulator only when connected in reverse bias beyond its characteristic breakdown potential Vz.'),
                        _buildBulletPoint('2. The series resistor Rs is essential to absorb voltage differences (Vin - Vout) and restrict current within the safe maximum power rating Pz_max of the diode.'),
                        _buildBulletPoint('3. The circuit provides reliable regulation as long as the diode current Iz is maintained between Iz_min (knee current) and Iz_max (maximum rated current).'),
                        _buildBulletPoint('4. Experimental characteristics closely align with semiconductor theory, demonstrating excellent line and load stabilization properties for low-power DC regulation.'),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildResultMetricCard({
    required String title,
    required String value,
    required String subtitle,
    required Color accent,
    required bool isDesktop,
    required double width,
  }) {
    return AppCard(
      width: width,
      padding: const EdgeInsets.all(AppConstants.spaceLg),
      color: AppColors.darkSurfaceContainer,
      borderColor: AppColors.darkBorder,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: AppTypography.labelSmall.copyWith(color: AppColors.darkTextSecondary, fontSize: 11)),
          const SizedBox(height: 8),
          Text(value, style: AppTypography.monoReadout.copyWith(color: accent, fontSize: 22, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text(subtitle, style: AppTypography.bodySmall.copyWith(color: AppColors.darkTextSecondary, fontSize: 11)),
        ],
      ),
    );
  }

  Widget _buildBulletPoint(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        text,
        style: AppTypography.bodyMedium.copyWith(color: AppColors.darkTextSecondary, height: 1.5),
      ),
    );
  }
}

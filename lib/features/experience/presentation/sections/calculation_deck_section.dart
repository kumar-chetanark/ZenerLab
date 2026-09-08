import 'package:flutter/material.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../simulation/simulation.dart';
import '../../../../theme/app_colors.dart';
import '../../../../theme/app_typography.dart';

/// Section 06 — Live Mathematical Derivation Deck
class CalculationDeckSection extends StatelessWidget {
  const CalculationDeckSection({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = SimulatorController.instance;

    return ListenableBuilder(
      listenable: controller,
      builder: (context, _) {
        final result = controller.currentResult;
        final vin = result.vin;
        final vz = result.vz;
        final rs = result.rs;
        final rl = result.rl;
        final voutUnreg = (vin * rl) / (rs + rl);

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
                    '06 — LIVE MATHEMATICAL DERIVATION',
                    style: AppTypography.labelSmall.copyWith(
                      color: AppColors.primary,
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: AppConstants.spaceSm),
                  Text(
                    'STEP-BY-STEP CALCULATION',
                    style: (isDesktop ? AppTypography.displayLarge : AppTypography.displayMedium).copyWith(
                      color: AppColors.darkTextPrimary,
                    ),
                  ),
                  const SizedBox(height: AppConstants.spaceSm),
                  Text(
                    'Every measurement on the workbench is solved deterministically from physical equations.',
                    style: AppTypography.bodyLarge.copyWith(color: AppColors.darkTextSecondary),
                  ),
                  const SizedBox(height: AppConstants.spaceLg),

                  _buildStepCard(
                    step: 1,
                    title: 'Unregulated Open-Circuit Potential',
                    formula: 'Vout_unreg = Vin × RL / (Rs + RL)',
                    substitution: '$vin × $rl / ($rs + $rl) = ${(vin * rl).toStringAsFixed(1)} / ${(rs + rl).toStringAsFixed(1)}',
                    result: '${voutUnreg.toStringAsFixed(3)} V',
                    condition: voutUnreg >= vz
                        ? '≥ Vz ($vz V) → Zener in Reverse Breakdown (Clamped to Vz)'
                        : '< Vz ($vz V) → Below Breakdown (Diode is OFF)',
                  ),
                  const SizedBox(height: AppConstants.spaceMd),

                  _buildStepCard(
                    step: 2,
                    title: 'Series Resistor Current (Is)',
                    formula: 'Is = (Vin - Vout) / Rs',
                    substitution: '($vin - ${result.vout.toStringAsFixed(2)}) / $rs',
                    result: '${(result.seriesCurrent * 1000).toStringAsFixed(2)} mA',
                  ),
                  const SizedBox(height: AppConstants.spaceMd),

                  _buildStepCard(
                    step: 3,
                    title: 'Load Current (IL)',
                    formula: 'IL = Vout / RL',
                    substitution: '${result.vout.toStringAsFixed(2)} / $rl',
                    result: '${(result.loadCurrent * 1000).toStringAsFixed(2)} mA',
                  ),
                  const SizedBox(height: AppConstants.spaceMd),

                  _buildStepCard(
                    step: 4,
                    title: 'Zener Diode Current (Iz)',
                    formula: 'Iz = Is - IL',
                    substitution: '${(result.seriesCurrent * 1000).toStringAsFixed(2)} - ${(result.loadCurrent * 1000).toStringAsFixed(2)}',
                    result: '${(result.zenerCurrent * 1000).toStringAsFixed(2)} mA',
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildStepCard({
    required int step,
    required String title,
    required String formula,
    required String substitution,
    required String result,
    String? condition,
  }) {
    return AppCard(
      padding: const EdgeInsets.all(AppConstants.spaceLg),
      color: AppColors.darkSurfaceContainer,
      borderColor: AppColors.darkBorder,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Center(
              child: Text(
                '$step',
                style: AppTypography.monoSub.copyWith(color: AppColors.primary, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          const SizedBox(width: AppConstants.spaceMd),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTypography.titleMedium.copyWith(color: AppColors.darkTextPrimary)),
                const SizedBox(height: 4),
                Text(formula, style: AppTypography.monoSub.copyWith(color: AppColors.voltageIn)),
                const SizedBox(height: 4),
                Text('Substitution: $substitution', style: AppTypography.monoSub.copyWith(color: AppColors.darkTextSecondary, fontSize: 12)),
                if (condition != null) ...[
                  const SizedBox(height: 4),
                  Text(condition, style: AppTypography.monoSub.copyWith(color: AppColors.primary, fontSize: 12)),
                ],
                const SizedBox(height: 6),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.darkBg,
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(color: AppColors.primary.withValues(alpha: 0.2)),
                  ),
                  child: Text(
                    'Result: $result',
                    style: AppTypography.monoSub.copyWith(color: AppColors.primary, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

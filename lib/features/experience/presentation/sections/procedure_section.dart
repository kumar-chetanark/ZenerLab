import 'package:flutter/material.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../theme/app_colors.dart';
import '../../../../theme/app_typography.dart';
import 'breakdown_moment_section.dart';

/// Lab Report Section: PROCEDURE
/// Detailed experimental instructions for Line Regulation and Load Regulation with interactive breakdown threshold testing.
class ProcedureSection extends StatelessWidget {
  const ProcedureSection({super.key});

  @override
  Widget build(BuildContext context) {
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
                '04 — PROCEDURE',
                style: AppTypography.labelSmall.copyWith(
                  color: AppColors.primary,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: AppConstants.spaceSm),
              Text(
                'STEP-BY-STEP LABORATORY INSTRUCTIONS',
                style: (isDesktop ? AppTypography.displayLarge : AppTypography.displayMedium).copyWith(
                  color: AppColors.darkTextPrimary,
                ),
              ),
              const SizedBox(height: AppConstants.spaceSm),
              Text(
                'Carefully execute the experimental steps below to characterize Line Regulation and Load Regulation.',
                style: AppTypography.bodyLarge.copyWith(color: AppColors.darkTextSecondary),
              ),
              const SizedBox(height: AppConstants.spaceXl),

              // Procedure 1 & 2 Cards
              Wrap(
                spacing: AppConstants.spaceLg,
                runSpacing: AppConstants.spaceLg,
                children: [
                  AppCard(
                    width: isDesktop ? (constraints.maxWidth - (AppConstants.spaceXl * 3) - AppConstants.spaceLg) / 2 : double.infinity,
                    padding: const EdgeInsets.all(AppConstants.spaceLg),
                    color: AppColors.darkSurfaceContainer,
                    borderColor: AppColors.darkBorder,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: AppColors.primary.withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text('PART A', style: AppTypography.monoSub.copyWith(color: AppColors.primary, fontWeight: FontWeight.bold)),
                            ),
                            const SizedBox(width: AppConstants.spaceSm),
                            Text('Line Regulation Procedure', style: AppTypography.titleMedium.copyWith(color: AppColors.darkTextPrimary)),
                          ],
                        ),
                        const SizedBox(height: AppConstants.spaceMd),
                        _buildStepItem('1', 'Connect the series resistor Rs (330 Ω) between the positive terminal of the DC power supply and the cathode of the Zener diode.'),
                        _buildStepItem('2', 'Connect the load resistor RL (fixed at 1 kΩ) in parallel across the Zener diode.'),
                        _buildStepItem('3', 'Connect digital milliammeters in series with the input line (Is) and Zener branch (Iz). Connect a voltmeter across RL (Vout).'),
                        _buildStepItem('4', 'Vary the input voltage Vin from 0 V to 20 V in steps of 1 V.'),
                        _buildStepItem('5', 'Record Vin, Vout, Is, and Iz at each step in Observation Table 1.'),
                        _buildStepItem('6', 'Observe that for Vin < Vz, Vout increases with Vin. Once Vin exceeds breakdown threshold, Vout clamps constant at Vz.'),
                      ],
                    ),
                  ),
                  AppCard(
                    width: isDesktop ? (constraints.maxWidth - (AppConstants.spaceXl * 3) - AppConstants.spaceLg) / 2 : double.infinity,
                    padding: const EdgeInsets.all(AppConstants.spaceLg),
                    color: AppColors.darkSurfaceContainer,
                    borderColor: AppColors.darkBorder,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: AppColors.voltageOut.withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text('PART B', style: AppTypography.monoSub.copyWith(color: AppColors.voltageOut, fontWeight: FontWeight.bold)),
                            ),
                            const SizedBox(width: AppConstants.spaceSm),
                            Text('Load Regulation Procedure', style: AppTypography.titleMedium.copyWith(color: AppColors.darkTextPrimary)),
                          ],
                        ),
                        const SizedBox(height: AppConstants.spaceMd),
                        _buildStepItem('1', 'Fix the input supply voltage Vin at a constant regulated level (e.g., Vin = 12.0 V).'),
                        _buildStepItem('2', 'Connect a variable resistance decade box as the load RL across the output terminals.'),
                        _buildStepItem('3', 'Vary load resistance RL from 100 Ω to 3000 Ω in discrete steps.'),
                        _buildStepItem('4', 'Measure and record load current IL, Zener current Iz, and output voltage Vout at each step in Observation Table 2.'),
                        _buildStepItem('5', 'Confirm that when RL is sufficiently large, Iz remains above knee current Iz(min) and Vout is tightly regulated.'),
                        _buildStepItem('6', 'Note down the minimum load resistance RL(min) below which regulation drops out due to diode starvation.'),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppConstants.spaceXl),

              // Interactive Diode Breakdown Macro Tester
              const BreakdownMomentSection(),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStepItem(String number, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 22,
            height: 22,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: AppColors.darkSurfaceHigh,
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.darkBorder),
            ),
            child: Text(
              number,
              style: AppTypography.monoSub.copyWith(fontSize: 11, color: AppColors.darkTextSecondary, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: AppTypography.bodyMedium.copyWith(color: AppColors.darkTextSecondary, height: 1.45),
            ),
          ),
        ],
      ),
    );
  }
}

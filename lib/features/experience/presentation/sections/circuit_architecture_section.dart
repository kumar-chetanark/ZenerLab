import 'package:flutter/material.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../theme/app_colors.dart';
import '../../../../theme/app_typography.dart';

/// Section 02 — Circuit Architecture (Camera Dolly In / Component Focus)
class CircuitArchitectureSection extends StatelessWidget {
  const CircuitArchitectureSection({super.key});

  @override
  Widget build(BuildContext context) {
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
              // Section index
              Text(
                '02 — PHYSICAL ARCHITECTURE',
                style: AppTypography.labelSmall.copyWith(
                  color: AppColors.primary,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: AppConstants.spaceSm),
              Text(
                'FOUR PHYSICAL STAGES',
                style: (isDesktop ? AppTypography.displayLarge : AppTypography.displayMedium).copyWith(
                  color: AppColors.darkTextPrimary,
                ),
              ),
              const SizedBox(height: AppConstants.spaceSm),
              Text(
                'The Zener voltage regulator consists of four precision stages interconnected in a closed loop.',
                style: AppTypography.bodyLarge.copyWith(color: AppColors.darkTextSecondary),
              ),
              const SizedBox(height: AppConstants.spaceXl),

              // 4 Stage Cards Grid
              LayoutBuilder(
                builder: (context, innerConstraints) {
                  final width = innerConstraints.maxWidth;
                  final columns = width >= 900 ? 4 : (width >= 500 ? 2 : 1);
                  final itemWidth = ((width - ((columns - 1) * AppConstants.spaceMd)) / columns).clamp(240.0, double.infinity);

                  return Wrap(
                    spacing: AppConstants.spaceMd,
                    runSpacing: AppConstants.spaceMd,
                    children: [
                      _buildComponentCard(
                        title: '01 / DC Input Source',
                        badge: 'Vin = 0 – 30V',
                        accent: AppColors.voltageIn,
                        icon: Icons.power_rounded,
                        description: 'Provides variable unregulated DC input voltage subject to upstream line fluctuations and ripple.',
                        width: itemWidth,
                      ),
                      _buildComponentCard(
                        title: '02 / Series Resistor',
                        badge: 'Rs (Current Limiter)',
                        accent: AppColors.secondary,
                        icon: Icons.compress_rounded,
                        description: 'Absorbs the excess voltage (Vin - Vout) and prevents excessive current from destroying the Zener diode.',
                        width: itemWidth,
                      ),
                      _buildComponentCard(
                        title: '03 / Zener Diode',
                        badge: 'Vz (Semiconductor Clamp)',
                        accent: AppColors.primary,
                        icon: Icons.electric_bolt_rounded,
                        description: 'Operates in reverse breakdown to clamp node voltage to Vz while shunting surplus current Iz into ground.',
                        width: itemWidth,
                      ),
                      _buildComponentCard(
                        title: '04 / Load Terminal',
                        badge: 'RL & Vout (Stable Output)',
                        accent: AppColors.voltageOut,
                        icon: Icons.output_rounded,
                        description: 'Delivers steady, regulated DC potential to connected electronics irrespective of load fluctuations.',
                        width: itemWidth,
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildComponentCard({
    required String title,
    required String badge,
    required Color accent,
    required IconData icon,
    required String description,
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
          Wrap(
            spacing: 8,
            runSpacing: 6,
            alignment: WrapAlignment.spaceBetween,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: accent.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Icon(icon, color: accent, size: 20),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: AppColors.darkSurfaceHigh,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  badge,
                  style: AppTypography.monoSub.copyWith(fontSize: 11, color: accent),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppConstants.spaceMd),
          Text(
            title,
            style: AppTypography.titleMedium.copyWith(color: AppColors.darkTextPrimary),
          ),
          const SizedBox(height: AppConstants.spaceSm),
          Text(
            description,
            style: AppTypography.bodySmall.copyWith(color: AppColors.darkTextSecondary, height: 1.5),
          ),
        ],
      ),
    );
  }
}

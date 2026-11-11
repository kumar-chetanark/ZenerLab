import 'package:flutter/material.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../theme/app_colors.dart';
import '../../../../theme/app_typography.dart';

/// Lab Report Section: APPARATUS REQUIRED
/// Lists all physical hardware, components, and instruments used in the experiment.
class ApparatusRequiredSection extends StatelessWidget {
  const ApparatusRequiredSection({super.key});

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
                '02 — APPARATUS REQUIRED',
                style: AppTypography.labelSmall.copyWith(
                  color: AppColors.primary,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: AppConstants.spaceSm),
              Text(
                'COMPONENTS & LABORATORY INSTRUMENTS',
                style: (isDesktop ? AppTypography.displayLarge : AppTypography.displayMedium).copyWith(
                  color: AppColors.darkTextPrimary,
                ),
              ),
              const SizedBox(height: AppConstants.spaceSm),
              Text(
                'The following components and test instruments are required to assemble and evaluate the Zener diode voltage regulator circuit.',
                style: AppTypography.bodyLarge.copyWith(color: AppColors.darkTextSecondary),
              ),
              const SizedBox(height: AppConstants.spaceXl),

              // Apparatus Grid
              LayoutBuilder(
                builder: (context, innerConstraints) {
                  final width = innerConstraints.maxWidth;
                  final columns = width >= 900 ? 3 : (width >= 560 ? 2 : 1);
                  final itemWidth = ((width - ((columns - 1) * AppConstants.spaceMd)) / columns).clamp(240.0, double.infinity);

                  return Wrap(
                    spacing: AppConstants.spaceMd,
                    runSpacing: AppConstants.spaceMd,
                    children: [
                      _buildApparatusCard(
                        title: 'Zener Diode (1N4733A / BZX55)',
                        specs: 'Vz = 5.1 V, Pz(max) = 500 mW, Iz(min) = 5 mA',
                        category: 'Active Voltage Clamp',
                        icon: Icons.electric_bolt_rounded,
                        accent: AppColors.primary,
                        width: itemWidth,
                      ),
                      _buildApparatusCard(
                        title: 'Regulated DC Power Supply',
                        specs: 'Range: 0 – 30 V DC (Continuously Variable)',
                        category: 'Power Source',
                        icon: Icons.power_rounded,
                        accent: AppColors.voltageIn,
                        width: itemWidth,
                      ),
                      _buildApparatusCard(
                        title: 'Series Resistor (Rs)',
                        specs: 'Value: 330 Ω (Tolerance ±5%, 1W Rated)',
                        category: 'Current Limiter',
                        icon: Icons.compress_rounded,
                        accent: AppColors.secondary,
                        width: itemWidth,
                      ),
                      _buildApparatusCard(
                        title: 'Load Resistor (RL Decade Box)',
                        specs: 'Variable: 100 Ω – 10 kΩ Decade Resistance',
                        category: 'Output Load',
                        icon: Icons.tune_rounded,
                        accent: AppColors.voltageOut,
                        width: itemWidth,
                      ),
                      _buildApparatusCard(
                        title: 'Digital Multimeter (DMM - Voltage)',
                        specs: '0 – 20 V DC Range, Resolution: 0.01 V',
                        category: 'Measuring Instrument',
                        icon: Icons.speed_rounded,
                        accent: AppColors.info,
                        width: itemWidth,
                      ),
                      _buildApparatusCard(
                        title: 'Digital Milliammeters (DMM - Current)',
                        specs: 'Dual Channel: 0 – 100 mA (Is and Iz/IL)',
                        category: 'Measuring Instrument',
                        icon: Icons.analytics_rounded,
                        accent: AppColors.warning,
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

  Widget _buildApparatusCard({
    required String title,
    required String specs,
    required String category,
    required IconData icon,
    required Color accent,
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                  category,
                  style: AppTypography.monoSub.copyWith(fontSize: 10, color: accent),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppConstants.spaceMd),
          Text(
            title,
            style: AppTypography.titleMedium.copyWith(color: AppColors.darkTextPrimary, fontSize: 14),
          ),
          const SizedBox(height: 6),
          Text(
            specs,
            style: AppTypography.bodySmall.copyWith(color: AppColors.darkTextSecondary, height: 1.4),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../theme/app_colors.dart';
import '../../../../theme/app_typography.dart';

/// Section 09 — Interactive Theory Textbook & Visual Formula Wall
class TheoryTextbookSection extends StatelessWidget {
  const TheoryTextbookSection({super.key});

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
              Text(
                '09 — THEORETICAL FOUNDATION',
                style: AppTypography.labelSmall.copyWith(
                  color: AppColors.primary,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: AppConstants.spaceSm),
              Text(
                'SEMICONDUCTOR PHYSICS & FORMULA WALL',
                style: (isDesktop ? AppTypography.displayLarge : AppTypography.displayMedium).copyWith(
                  color: AppColors.darkTextPrimary,
                ),
              ),
              const SizedBox(height: AppConstants.spaceLg),

              // Visual Formula Wall Grid
              Text('CORE GOVERNING FORMULAS', style: AppTypography.labelSmall.copyWith(color: AppColors.primary)),
              const SizedBox(height: AppConstants.spaceMd),
              LayoutBuilder(
                builder: (context, innerConstraints) {
                  final width = innerConstraints.maxWidth;
                  final columns = width >= 900 ? 3 : (width >= 500 ? 2 : 1);
                  final itemWidth = (width - ((columns - 1) * AppConstants.spaceMd)) / columns;

                  return Wrap(
                    spacing: AppConstants.spaceMd,
                    runSpacing: AppConstants.spaceMd,
                    children: [
                      _buildFormulaCard('Vout ≈ Vz', 'Regulated Output Voltage', 'When operating in reverse breakdown region', itemWidth),
                      _buildFormulaCard('Is = (Vin - Vout) / Rs', 'Series Limiter Current', 'Current flowing through protective resistor Rs', itemWidth),
                      _buildFormulaCard('IL = Vout / RL', 'Load Output Current', 'Current drawn by connected load resistor RL', itemWidth),
                      _buildFormulaCard('Iz = Is - IL', 'Zener Shunt Current', 'KCL current balance shunted into ground', itemWidth),
                      _buildFormulaCard('Pz = Vz × Iz', 'Zener Power Dissipation', 'Must remain strictly <= PzMax to avoid thermal runaway', itemWidth),
                      _buildFormulaCard('Is = IL + Iz', 'Node Current Conservation', 'Total incoming series current splits at output node', itemWidth),
                    ],
                  );
                },
              ),
              const SizedBox(height: AppConstants.spaceXl),

              // Theory Chapters
              _buildTheoryChapter(
                '1. What is a Zener Diode?',
                'A heavily doped silicon PN junction diode engineered specifically to operate in the reverse breakdown region without destruction. In reverse bias beyond Vz, high electric fields cause quantum mechanical tunneling (< 5V) or avalanche multiplication (> 6V), clamping the voltage across its terminals.',
              ),
              const SizedBox(height: AppConstants.spaceMd),
              _buildTheoryChapter(
                '2. Voltage Regulation Principle',
                'When connected in parallel with a load RL and series resistor Rs, any increase in unregulated Vin causes a proportional increase in series voltage drop VRs = Is × Rs while Iz absorbs the surplus current, holding load voltage rock-solid at Vz.',
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildFormulaCard(String formula, String title, String subtitle, double width) {
    return AppCard(
      width: width,
      padding: const EdgeInsets.all(AppConstants.spaceLg),
      color: AppColors.darkSurfaceContainer,
      borderColor: AppColors.primary.withValues(alpha: 0.3),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(formula, style: AppTypography.monoSub.copyWith(color: AppColors.primary, fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text(title, style: AppTypography.titleMedium.copyWith(color: AppColors.darkTextPrimary, fontSize: 13)),
          const SizedBox(height: 4),
          Text(subtitle, style: AppTypography.bodySmall.copyWith(color: AppColors.darkTextSecondary)),
        ],
      ),
    );
  }

  Widget _buildTheoryChapter(String title, String body) {
    return AppCard(
      padding: const EdgeInsets.all(AppConstants.spaceLg),
      color: AppColors.darkSurfaceContainer,
      borderColor: AppColors.darkBorder,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: AppTypography.titleMedium.copyWith(color: AppColors.darkTextPrimary)),
          const SizedBox(height: AppConstants.spaceSm),
          Text(body, style: AppTypography.bodyMedium.copyWith(color: AppColors.darkTextSecondary, height: 1.6)),
        ],
      ),
    );
  }
}

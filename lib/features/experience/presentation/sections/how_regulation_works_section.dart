import 'package:flutter/material.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../theme/app_colors.dart';
import '../../../../theme/app_typography.dart';

/// Section 03 — How Regulation Works (4-Step Animated Breakdown)
class HowRegulationWorksSection extends StatefulWidget {
  const HowRegulationWorksSection({super.key});

  @override
  State<HowRegulationWorksSection> createState() => _HowRegulationWorksSectionState();
}

class _HowRegulationWorksSectionState extends State<HowRegulationWorksSection> {
  int _activeStep = 0;

  final List<Map<String, String>> _steps = [
    {
      'num': 'STEP 01',
      'title': 'Input Voltage Applied',
      'formula': 'Vin applied across circuit',
      'desc': 'An unregulated DC voltage Vin is applied across the input terminals. Total current starts flowing through the series resistor Rs.',
    },
    {
      'num': 'STEP 02',
      'title': 'Series Voltage Drop',
      'formula': 'VRs = Vin - Vout = Is × Rs',
      'desc': 'Rs drops the surplus voltage (Vin - Vout) preventing destructive current spikes through the semiconductor junction.',
    },
    {
      'num': 'STEP 03',
      'title': 'Current Division at Node',
      'formula': 'Is = IL + Iz',
      'desc': 'At the output node, current divides: load current IL = Vout/RL supplies the application, while surplus current Iz enters the Zener branch.',
    },
    {
      'num': 'STEP 04',
      'title': 'Zener Voltage Clamping',
      'formula': 'Vout ≈ Vz  (When Iz > IzMin)',
      'desc': 'Operating in breakdown, the Zener diode dynamically absorbs any increase in Vin, keeping Vout rock-solid at Vz.',
    },
  ];

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
                '03 — PHYSICAL MECHANISM',
                style: AppTypography.labelSmall.copyWith(
                  color: AppColors.primary,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: AppConstants.spaceSm),
              Text(
                'HOW REGULATION WORKS',
                style: (isDesktop ? AppTypography.displayLarge : AppTypography.displayMedium).copyWith(
                  color: AppColors.darkTextPrimary,
                ),
              ),
              const SizedBox(height: AppConstants.spaceLg),

              // Step Tabs
              Wrap(
                spacing: AppConstants.spaceSm,
                runSpacing: AppConstants.spaceSm,
                children: List.generate(_steps.length, (index) {
                  final isSelected = _activeStep == index;
                  return InkWell(
                    onTap: () => setState(() => _activeStep = index),
                    borderRadius: BorderRadius.circular(AppConstants.radiusSm),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      decoration: BoxDecoration(
                        color: isSelected ? AppColors.primary : AppColors.darkSurfaceContainer,
                        borderRadius: BorderRadius.circular(AppConstants.radiusSm),
                        border: Border.all(
                          color: isSelected ? AppColors.primary : AppColors.darkBorder,
                        ),
                      ),
                      child: Text(
                        _steps[index]['num']!,
                        style: AppTypography.labelSmall.copyWith(
                          color: isSelected ? AppColors.darkBg : AppColors.darkTextPrimary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  );
                }),
              ),
              const SizedBox(height: AppConstants.spaceLg),

              // Animated Active Step Card with Giant Equation
              AppCard(
                padding: const EdgeInsets.all(AppConstants.spaceXl),
                color: AppColors.darkSurfaceContainer,
                borderColor: AppColors.primary.withValues(alpha: 0.4),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _steps[_activeStep]['title']!,
                      style: AppTypography.titleLarge.copyWith(color: AppColors.darkTextPrimary),
                    ),
                    const SizedBox(height: AppConstants.spaceLg),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 24),
                      decoration: BoxDecoration(
                        color: AppColors.darkBg,
                        borderRadius: BorderRadius.circular(AppConstants.radiusMd),
                        border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
                      ),
                      child: Center(
                        child: Text(
                          _steps[_activeStep]['formula']!,
                          style: (isDesktop ? AppTypography.displayMedium : AppTypography.titleLarge).copyWith(
                            color: AppColors.primary,
                            fontFamily: 'monospace',
                            fontWeight: FontWeight.w800,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    const SizedBox(height: AppConstants.spaceLg),
                    Text(
                      _steps[_activeStep]['desc']!,
                      style: AppTypography.bodyLarge.copyWith(color: AppColors.darkTextSecondary),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

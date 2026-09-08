import 'package:flutter/material.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/widgets/app_buttons.dart';
import '../../../../core/widgets/status_indicator.dart';
import '../../../../simulation/simulation.dart';
import '../../../../theme/app_colors.dart';
import '../../../../theme/app_typography.dart';
import '../../../simulator/presentation/widgets/circuit_diagram_widget.dart';
import '../../../simulator/presentation/widgets/rotary_knob_widget.dart';

/// Section 01 — Hero Experience
/// Cinematic wide-shot 3D virtual electronics laboratory with massive typography and live interactive power dial
class HeroSection extends StatelessWidget {
  final VoidCallback onExplore;
  final VoidCallback onStartSimulating;

  const HeroSection({
    super.key,
    required this.onExplore,
    required this.onStartSimulating,
  });

  @override
  Widget build(BuildContext context) {
    final controller = SimulatorController.instance;

    return ListenableBuilder(
      listenable: controller,
      builder: (context, _) {
        final result = controller.currentResult;

        return LayoutBuilder(
          builder: (context, constraints) {
            final isDesktop = constraints.maxWidth >= 960;

            return Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(
                horizontal: isDesktop ? AppConstants.spaceXl * 1.5 : AppConstants.spaceMd,
                vertical: isDesktop ? 60 : 32,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Over-title pill
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
                        ),
                        child: Text(
                          '01 — CINEMATIC LABORATORY',
                          style: AppTypography.labelSmall.copyWith(
                            color: AppColors.primary,
                            letterSpacing: 1.2,
                          ),
                        ),
                      ),
                      const SizedBox(width: AppConstants.spaceSm),
                      StatusIndicator(
                        label: result.zenerState.displayName,
                        type: result.isRegulating ? StatusType.active : StatusType.warning,
                      ),
                    ],
                  ),
                  const SizedBox(height: AppConstants.spaceLg),

                  // Giant Editorial Title
                  Text(
                    'ZENER LAB',
                    style: (isDesktop ? AppTypography.heroGiant : AppTypography.displayLarge).copyWith(
                      color: AppColors.darkTextPrimary,
                    ),
                  ),
                  Text(
                    'VOLTAGE REGULATION',
                    style: (isDesktop ? AppTypography.heroGiant.copyWith(color: AppColors.primary) : AppTypography.displayLarge.copyWith(color: AppColors.primary)),
                  ),
                  const SizedBox(height: AppConstants.spaceSm),
                  Text(
                    'SIMULATE. EXPERIMENT. UNDERSTAND THE PHYSICAL CIRCUIT.',
                    style: AppTypography.heroSub.copyWith(
                      color: AppColors.darkTextSecondary,
                    ),
                  ),
                  const SizedBox(height: AppConstants.spaceXl),

                  // 3D Suspended Circuit Studio Centerpiece (Clean Decoupled Layout)
                  Column(
                    children: [
                      Container(
                        width: double.infinity,
                        height: isDesktop ? 380 : (constraints.maxWidth * 0.58).clamp(180.0, 240.0),
                        decoration: BoxDecoration(
                          color: AppColors.darkSurface.withValues(alpha: 0.5),
                          borderRadius: BorderRadius.circular(AppConstants.radiusLg),
                          border: Border.all(color: AppColors.darkBorder),
                        ),
                        child: CircuitDiagramWidget(
                          result: result,
                          zoomScale: 1.0,
                        ),
                      ),
                      const SizedBox(height: AppConstants.spaceMd),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                        decoration: BoxDecoration(
                          color: AppColors.darkSurfaceContainer,
                          borderRadius: BorderRadius.circular(AppConstants.radiusMd),
                          border: Border.all(color: AppColors.darkBorder),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            RotaryKnobWidget(
                              value: result.vin,
                              min: 0,
                              max: 30,
                              label: 'INPUT POWER (VIN)',
                              unit: 'V',
                              accentColor: AppColors.voltageIn,
                              onChanged: (val) => controller.updateVin(val),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppConstants.spaceXl),

                  // Hero Action Row (Responsive Stacking)
                  if (isDesktop)
                    Row(
                      children: [
                        AppButton.primary(
                          label: 'Enter Live Simulator',
                          icon: Icons.bolt_rounded,
                          onPressed: onStartSimulating,
                        ),
                        const SizedBox(width: AppConstants.spaceMd),
                        AppButton.secondary(
                          label: 'Explore Physics Story',
                          icon: Icons.arrow_downward_rounded,
                          onPressed: onExplore,
                        ),
                      ],
                    )
                  else
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        AppButton.primary(
                          label: 'Enter Live Simulator',
                          icon: Icons.bolt_rounded,
                          isFullWidth: true,
                          onPressed: onStartSimulating,
                        ),
                        const SizedBox(height: AppConstants.spaceSm),
                        AppButton.secondary(
                          label: 'Explore Physics Story',
                          icon: Icons.arrow_downward_rounded,
                          isFullWidth: true,
                          onPressed: onExplore,
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

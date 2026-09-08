import 'package:flutter/material.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../simulation/simulation.dart';
import '../../../../theme/app_colors.dart';
import '../../../../theme/app_typography.dart';
import '../../../simulator/presentation/widgets/circuit_diagram_widget.dart';

/// Section 04 — Breakdown Moment (Diode Macro Focus & Activation)
class BreakdownMomentSection extends StatelessWidget {
  const BreakdownMomentSection({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = SimulatorController.instance;

    return ListenableBuilder(
      listenable: controller,
      builder: (context, _) {
        final result = controller.currentResult;
        final isBreakdown = result.isRegulating;

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
                    '04 — BREAKDOWN TRANSITION',
                    style: AppTypography.labelSmall.copyWith(
                      color: AppColors.primary,
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: AppConstants.spaceSm),
                  Text(
                    'THE MOMENT OF REGULATION',
                    style: (isDesktop ? AppTypography.displayLarge : AppTypography.displayMedium).copyWith(
                      color: AppColors.darkTextPrimary,
                    ),
                  ),
                  const SizedBox(height: AppConstants.spaceSm),
                  Text(
                    'When Vin crosses the critical threshold, the PN junction enters quantum tunneling / avalanche breakdown.',
                    style: AppTypography.bodyLarge.copyWith(color: AppColors.darkTextSecondary),
                  ),
                  const SizedBox(height: AppConstants.spaceLg),

                  // Side-by-side interactive transition preview
                  Flex(
                    direction: isDesktop ? Axis.horizontal : Axis.vertical,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Focused 3D Diode Circuit Canvas (Macro Zoom) with bounding clip
                      Expanded(
                        flex: isDesktop ? 1 : 0,
                        child: Container(
                          height: isDesktop ? 320 : (constraints.maxWidth * 0.58).clamp(180.0, 240.0),
                          clipBehavior: Clip.antiAlias,
                          decoration: BoxDecoration(
                            color: AppColors.darkSurfaceContainer,
                            borderRadius: BorderRadius.circular(AppConstants.radiusMd),
                            border: Border.all(
                              color: isBreakdown ? AppColors.primary : AppColors.darkBorder,
                              width: isBreakdown ? 1.5 : 1.0,
                            ),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(AppConstants.radiusMd),
                            child: CircuitDiagramWidget(
                              result: result,
                              zoomScale: 1.05,
                              focusOffsetX: 0,
                            ),
                          ),
                        ),
                      ),
                      if (isDesktop) const SizedBox(width: AppConstants.spaceLg) else const SizedBox(height: AppConstants.spaceLg),

                      // Interactive Threshold Slider & Status Card
                      Expanded(
                        flex: isDesktop ? 1 : 0,
                        child: AppCard(
                          padding: const EdgeInsets.all(AppConstants.spaceLg),
                          color: AppColors.darkSurfaceContainer,
                          borderColor: AppColors.darkBorder,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('THRESHOLD SLIDER', style: AppTypography.labelSmall.copyWith(color: AppColors.darkTextSecondary)),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                    decoration: BoxDecoration(
                                      color: isBreakdown ? AppColors.primary : AppColors.darkSurfaceHigh,
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: Text(
                                      isBreakdown ? 'BREAKDOWN ACTIVE' : 'BELOW BREAKDOWN',
                                      style: AppTypography.monoSub.copyWith(
                                        fontSize: 11,
                                        color: isBreakdown ? AppColors.darkBg : AppColors.darkTextSecondary,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: AppConstants.spaceMd),
                              SliderTheme(
                                data: SliderTheme.of(context).copyWith(
                                  activeTrackColor: AppColors.primary,
                                  inactiveTrackColor: AppColors.darkSurfaceHigh,
                                  thumbColor: AppColors.primary,
                                ),
                                child: Slider(
                                  value: result.vin,
                                  min: 0,
                                  max: 20,
                                  divisions: 40,
                                  onChanged: (val) => controller.updateVin(val),
                                ),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('Vin: ${result.vin.toStringAsFixed(1)}V', style: AppTypography.monoSub.copyWith(color: AppColors.voltageIn)),
                                  Text('Vz: ${result.vz.toStringAsFixed(1)}V', style: AppTypography.monoSub.copyWith(color: AppColors.primary)),
                                ],
                              ),
                              const SizedBox(height: AppConstants.spaceMd),
                              Text(
                                isBreakdown
                                    ? '✓ Current Iz is actively shunting into ground. Output is clamped to ${result.vout.toStringAsFixed(2)}V.'
                                    : '✕ Vin is insufficient to trigger reverse breakdown. Output tracks raw input potential.',
                                style: AppTypography.bodySmall.copyWith(
                                  color: isBreakdown ? AppColors.primary : AppColors.darkTextSecondary,
                                ),
                              ),
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
      },
    );
  }
}

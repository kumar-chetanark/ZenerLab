import 'package:flutter/material.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/status_indicator.dart';
import '../../../../simulation/simulation.dart';
import '../../../../theme/app_colors.dart';
import '../../../../theme/app_typography.dart';
import '../../../simulator/presentation/widgets/circuit_diagram_widget.dart';
import '../../../simulator/presentation/widgets/rotary_knob_widget.dart';

/// Section 05 — Live Simulator Workstation (Interactive Centerpiece Deck)
class LiveSimulatorSection extends StatelessWidget {
  const LiveSimulatorSection({super.key});

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
                vertical: 48,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Wrap(
                    spacing: AppConstants.spaceMd,
                    runSpacing: AppConstants.spaceSm,
                    alignment: WrapAlignment.spaceBetween,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '05 — LABORATORY WORKBENCH',
                            style: AppTypography.labelSmall.copyWith(
                              color: AppColors.primary,
                              letterSpacing: 1.2,
                            ),
                          ),
                          const SizedBox(height: AppConstants.spaceSm),
                          Text(
                            'LIVE INTERACTIVE SIMULATOR',
                            style: (isDesktop ? AppTypography.displayLarge : AppTypography.displayMedium).copyWith(
                              color: AppColors.darkTextPrimary,
                            ),
                          ),
                        ],
                      ),
                      StatusIndicator(
                        label: result.zenerState.displayName,
                        type: result.isRegulating ? StatusType.active : StatusType.warning,
                      ),
                    ],
                  ),
                  const SizedBox(height: AppConstants.spaceLg),

                  // Presets Row
                  Wrap(
                    spacing: AppConstants.spaceSm,
                    runSpacing: AppConstants.spaceSm,
                    children: [
                      Text('PRESETS: ', style: AppTypography.labelSmall.copyWith(color: AppColors.darkTextSecondary)),
                      ...CircuitPreset.all.take(4).map((preset) => _buildPresetChip(controller, preset.title, preset)),
                    ],
                  ),
                  const SizedBox(height: AppConstants.spaceLg),

                  // Main Workstation Layout: 3D Circuit (Left) + Instrument Deck (Right)
                  Flex(
                    direction: isDesktop ? Axis.horizontal : Axis.vertical,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Large 3D Circuit Visualizer
                      Expanded(
                        flex: isDesktop ? 6 : 0,
                        child: Container(
                          height: isDesktop ? 460 : 340,
                          decoration: BoxDecoration(
                            color: AppColors.darkSurfaceContainer,
                            borderRadius: BorderRadius.circular(AppConstants.radiusLg),
                            border: Border.all(color: AppColors.darkBorder),
                          ),
                          child: CircuitDiagramWidget(
                            result: result,
                            zoomScale: isDesktop ? 1.0 : 0.85,
                          ),
                        ),
                      ),
                      if (isDesktop) const SizedBox(width: AppConstants.spaceLg) else const SizedBox(height: AppConstants.spaceLg),

                      // Control Console Panel
                      Expanded(
                        flex: isDesktop ? 4 : 0,
                        child: AppCard(
                          padding: const EdgeInsets.all(AppConstants.spaceLg),
                          color: AppColors.darkSurfaceContainer,
                          borderColor: AppColors.darkBorder,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('INSTRUMENTATION CONTROLS', style: AppTypography.labelSmall.copyWith(color: AppColors.darkTextSecondary)),
                              const SizedBox(height: AppConstants.spaceLg),

                              // Rotary Dials Grid
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  RotaryKnobWidget(
                                    value: result.vin,
                                    min: 0,
                                    max: 30,
                                    label: 'INPUT VIN',
                                    unit: 'V',
                                    accentColor: AppColors.voltageIn,
                                    onChanged: (val) => controller.updateVin(val),
                                  ),
                                  RotaryKnobWidget(
                                    value: result.vz,
                                    min: 2.0,
                                    max: 15.0,
                                    label: 'ZENER VZ',
                                    unit: 'V',
                                    accentColor: AppColors.primary,
                                    onChanged: (val) => controller.updateVz(val),
                                  ),
                                  RotaryKnobWidget(
                                    value: result.rs,
                                    min: 50,
                                    max: 2000,
                                    label: 'SERIES RS',
                                    unit: 'Ω',
                                    accentColor: AppColors.secondary,
                                    onChanged: (val) => controller.updateRs(val),
                                  ),
                                ],
                              ),
                              const SizedBox(height: AppConstants.spaceLg),

                              // Load Resistor Continuous Slider
                              Text('LOAD RESISTANCE (RL)', style: AppTypography.labelSmall.copyWith(color: AppColors.voltageOut)),
                              SliderTheme(
                                data: SliderTheme.of(context).copyWith(
                                  activeTrackColor: AppColors.voltageOut,
                                  inactiveTrackColor: AppColors.darkSurfaceHigh,
                                  thumbColor: AppColors.voltageOut,
                                ),
                                child: Slider(
                                  value: result.rl.clamp(50, 10000),
                                  min: 50,
                                  max: 10000,
                                  divisions: 100,
                                  onChanged: (val) => controller.updateRl(val),
                                ),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('50 Ω', style: AppTypography.monoSub.copyWith(fontSize: 11, color: AppColors.darkTextSecondary)),
                                  Text(
                                    result.rl >= 1000 ? '${(result.rl / 1000).toStringAsFixed(2)} kΩ' : '${result.rl.toStringAsFixed(0)} Ω',
                                    style: AppTypography.monoSub.copyWith(color: AppColors.voltageOut),
                                  ),
                                  Text('10 kΩ', style: AppTypography.monoSub.copyWith(fontSize: 11, color: AppColors.darkTextSecondary)),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppConstants.spaceLg),

                  // Giant Digital Measurement Readout Strip
                  _buildTelemetryStrip(result),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildPresetChip(SimulatorController controller, String label, CircuitPreset preset) {
    return InkWell(
      onTap: () => controller.applyPreset(preset),
      borderRadius: BorderRadius.circular(4),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: AppColors.darkSurfaceHigh,
          borderRadius: BorderRadius.circular(4),
          border: Border.all(color: AppColors.darkBorder),
        ),
        child: Text(
          label,
          style: AppTypography.labelSmall.copyWith(color: AppColors.darkTextPrimary, fontSize: 11),
        ),
      ),
    );
  }

  Widget _buildTelemetryStrip(ZenerSimulationResult result) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final columns = width >= 900 ? 5 : (width >= 500 ? 3 : 2);
        final itemWidth = (width - ((columns - 1) * AppConstants.spaceMd)) / columns;

        return Wrap(
          spacing: AppConstants.spaceMd,
          runSpacing: AppConstants.spaceMd,
          children: [
            _buildMetricTile('OUTPUT POTENTIAL', 'Vout', result.vout.toStringAsFixed(2), 'V', AppColors.voltageOut, itemWidth),
            _buildMetricTile('SERIES CURRENT', 'Is', (result.seriesCurrent * 1000).toStringAsFixed(2), 'mA', AppColors.voltageIn, itemWidth),
            _buildMetricTile('LOAD CURRENT', 'IL', (result.loadCurrent * 1000).toStringAsFixed(2), 'mA', AppColors.voltageOut, itemWidth),
            _buildMetricTile('ZENER CURRENT', 'Iz', (result.zenerCurrent * 1000).toStringAsFixed(2), 'mA', AppColors.primary, itemWidth),
            _buildMetricTile('ZENER POWER', 'Pz', (result.zenerPower * 1000).toStringAsFixed(1), 'mW', result.zenerPower > result.parameters.pzMax ? AppColors.error : AppColors.secondary, itemWidth),
          ],
        );
      },
    );
  }

  Widget _buildMetricTile(String label, String code, String value, String unit, Color color, double width) {
    return AppCard(
      width: width,
      padding: const EdgeInsets.all(AppConstants.spaceMd),
      color: AppColors.darkSurfaceContainer,
      borderColor: AppColors.darkBorder,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: 4,
            alignment: WrapAlignment.spaceBetween,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Text(label, style: AppTypography.labelSmall.copyWith(fontSize: 10, color: AppColors.darkTextSecondary)),
              Text(code, style: AppTypography.monoSub.copyWith(fontSize: 11, color: color)),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(value, style: AppTypography.monoReadout.copyWith(color: AppColors.darkTextPrimary)),
              const SizedBox(width: 4),
              Text(unit, style: AppTypography.monoSub.copyWith(color: color)),
            ],
          ),
        ],
      ),
    );
  }
}

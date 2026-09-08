import 'package:flutter/material.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/widgets/widgets.dart';
import '../../../../simulation/simulation.dart';
import '../../../../theme/app_colors.dart';

/// Prominent multi-meter style live electrical readout panel
class LiveMeasurementsPanel extends StatelessWidget {
  final ZenerSimulationResult result;

  const LiveMeasurementsPanel({
    super.key,
    required this.result,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionHeader(
          title: 'Live Circuit Measurements',
          subtitle: 'Real-time node voltages, branch currents, and device powers',
          icon: Icons.electric_meter_outlined,
        ),

        // 3 Key Voltages
        LayoutBuilder(
          builder: (context, constraints) {
            final isWide = constraints.maxWidth > 550;
            final width = isWide ? (constraints.maxWidth - (2 * AppConstants.spaceMd)) / 3 : constraints.maxWidth;

            return Wrap(
              spacing: AppConstants.spaceMd,
              runSpacing: AppConstants.spaceMd,
              children: [
                SizedBox(
                  width: width,
                  child: MetricCard(
                    label: 'Input Voltage (Vin)',
                    value: result.vin.toStringAsFixed(2),
                    unit: 'V',
                    icon: Icons.power_rounded,
                    accentColor: AppColors.voltageIn,
                    subtitle: 'Unregulated DC source',
                  ),
                ),
                SizedBox(
                  width: width,
                  child: MetricCard(
                    label: 'Zener Voltage (Vz)',
                    value: result.vz.toStringAsFixed(2),
                    unit: 'V',
                    icon: Icons.memory_rounded,
                    accentColor: AppColors.zenerVoltage,
                    subtitle: 'Nominal rating',
                  ),
                ),
                SizedBox(
                  width: width,
                  child: MetricCard(
                    label: 'Output Voltage (Vout)',
                    value: result.vout.toStringAsFixed(2),
                    unit: 'V',
                    icon: Icons.electric_bolt_rounded,
                    accentColor: AppColors.voltageOut,
                    subtitle: result.isBelowBreakdown ? 'Unregulated divider' : 'Regulated clamped',
                  ),
                ),
              ],
            );
          },
        ),
        const SizedBox(height: AppConstants.spaceMd),

        // Branch Currents & Powers
        LayoutBuilder(
          builder: (context, constraints) {
            final isWide = constraints.maxWidth > 550;
            final width = isWide ? (constraints.maxWidth - (2 * AppConstants.spaceMd)) / 3 : constraints.maxWidth;

            return Wrap(
              spacing: AppConstants.spaceMd,
              runSpacing: AppConstants.spaceMd,
              children: [
                SizedBox(
                  width: width,
                  child: MetricCard(
                    label: 'Series Current (Is)',
                    value: result.seriesCurrentMilliAmps.toStringAsFixed(2),
                    unit: 'mA',
                    icon: Icons.arrow_forward_rounded,
                    accentColor: AppColors.voltageIn,
                    subtitle: 'Prs = ${(result.seriesResistorPowerMilliWatts).toStringAsFixed(1)} mW',
                  ),
                ),
                SizedBox(
                  width: width,
                  child: MetricCard(
                    label: 'Zener Current (Iz)',
                    value: result.zenerCurrentMilliAmps.toStringAsFixed(2),
                    unit: 'mA',
                    icon: Icons.vertical_align_bottom_rounded,
                    accentColor: AppColors.zenerCurrent,
                    subtitle: 'Pz = ${(result.zenerPowerMilliWatts).toStringAsFixed(1)} mW',
                  ),
                ),
                SizedBox(
                  width: width,
                  child: MetricCard(
                    label: 'Load Current (IL)',
                    value: result.loadCurrentMilliAmps.toStringAsFixed(2),
                    unit: 'mA',
                    icon: Icons.download_rounded,
                    accentColor: AppColors.voltageOut,
                    subtitle: 'PL = ${(result.loadPowerMilliWatts).toStringAsFixed(1)} mW',
                  ),
                ),
              ],
            );
          },
        ),
      ],
    );
  }
}

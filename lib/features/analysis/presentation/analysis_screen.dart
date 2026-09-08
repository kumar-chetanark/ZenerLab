import 'package:flutter/material.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/widgets/widgets.dart';
import '../../../../simulation/simulation.dart';
import '../../../../theme/app_colors.dart';
import 'widgets/lab_chart_widget.dart';
import 'widgets/surface_3d_chart_widget.dart';

enum ChartType {
  surface3D,
  vinVsVout,
  vinVsIz,
  vinVsPz,
  rlVsVout,
  rlVsIz,
  rsVsVout,
  rsVsIz,
}

/// Dedicated Analysis and Graphing Screen providing 7 interactive curves and operating limit meters
class AnalysisScreen extends StatefulWidget {
  const AnalysisScreen({super.key});

  @override
  State<AnalysisScreen> createState() => _AnalysisScreenState();
}

class _AnalysisScreenState extends State<AnalysisScreen> {
  final SimulatorController _controller = SimulatorController.instance;
  ChartType _selectedChart = ChartType.vinVsVout;

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onUpdated);
  }

  @override
  void dispose() {
    _controller.removeListener(_onUpdated);
    super.dispose();
  }

  void _onUpdated() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final result = _controller.currentResult;
    final params = _controller.parameters;
    final sweepService = _controller.sweepService;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppConstants.spaceLg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Header
          const SectionHeader(
            title: 'Analysis & Characterization Curves',
            subtitle: 'Parametric sweep curves, operating margins, and device load analysis',
            icon: Icons.analytics_outlined,
            trailing: StatusIndicator(
              label: 'Analysis Active',
              type: StatusType.active,
            ),
          ),

          // Operating Point Summary Card
          AppCard(
            padding: const EdgeInsets.all(AppConstants.spaceLg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Operating Point & Margins',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    StatusIndicator(
                      label: result.zenerState.displayName,
                      type: result.isRegulating ? StatusType.active : StatusType.warning,
                    ),
                  ],
                ),
                const SizedBox(height: AppConstants.spaceMd),

                // Limit Bars
                _LimitBar(
                  label: 'Zener Current Margin (Iz / IzMax)',
                  currentValue: result.zenerCurrentMilliAmps,
                  maxValue: params.izMax * 1000.0,
                  unit: 'mA',
                  color: AppColors.zenerCurrent,
                ),
                const SizedBox(height: AppConstants.spaceSm),
                _LimitBar(
                  label: 'Zener Power Margin (Pz / PzMax)',
                  currentValue: result.zenerPowerMilliWatts,
                  maxValue: params.pzMax * 1000.0,
                  unit: 'mW',
                  color: AppColors.error,
                ),
                const SizedBox(height: AppConstants.spaceSm),
                _LimitBar(
                  label: 'Regulation Efficiency (Load Power / Source Power)',
                  currentValue: result.efficiencyPercentage,
                  maxValue: 100.0,
                  unit: '%',
                  color: AppColors.voltageOut,
                ),
              ],
            ),
          ),
          const SizedBox(height: AppConstants.spaceXl),

          // Chart Selection Tabs
          const SectionHeader(
            title: 'Interactive Sweep Curves',
            subtitle: 'Select an electrical transfer characteristic to inspect',
            icon: Icons.show_chart_rounded,
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _ChartChip(
                  label: '🧊 3D Regulation Surface (Vin × RL → Vout)',
                  isSelected: _selectedChart == ChartType.surface3D,
                  onSelected: () => setState(() => _selectedChart = ChartType.surface3D),
                ),
                _ChartChip(
                  label: 'Vin vs Vout (Line Regulation)',
                  isSelected: _selectedChart == ChartType.vinVsVout,
                  onSelected: () => setState(() => _selectedChart = ChartType.vinVsVout),
                ),
                _ChartChip(
                  label: 'Vin vs Iz (Zener Current)',
                  isSelected: _selectedChart == ChartType.vinVsIz,
                  onSelected: () => setState(() => _selectedChart = ChartType.vinVsIz),
                ),
                _ChartChip(
                  label: 'Vin vs Pz (Power Dissipation)',
                  isSelected: _selectedChart == ChartType.vinVsPz,
                  onSelected: () => setState(() => _selectedChart = ChartType.vinVsPz),
                ),
                _ChartChip(
                  label: 'RL vs Vout (Load Regulation)',
                  isSelected: _selectedChart == ChartType.rlVsVout,
                  onSelected: () => setState(() => _selectedChart = ChartType.rlVsVout),
                ),
                _ChartChip(
                  label: 'RL vs Iz',
                  isSelected: _selectedChart == ChartType.rlVsIz,
                  onSelected: () => setState(() => _selectedChart = ChartType.rlVsIz),
                ),
                _ChartChip(
                  label: 'Rs vs Vout',
                  isSelected: _selectedChart == ChartType.rsVsVout,
                  onSelected: () => setState(() => _selectedChart = ChartType.rsVsVout),
                ),
                _ChartChip(
                  label: 'Rs vs Iz',
                  isSelected: _selectedChart == ChartType.rsVsIz,
                  onSelected: () => setState(() => _selectedChart = ChartType.rsVsIz),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppConstants.spaceMd),

          // Main Active Chart Card
          AppCard(
            padding: const EdgeInsets.all(AppConstants.spaceLg),
            child: _buildActiveChart(params, sweepService, result),
          ),
          const SizedBox(height: AppConstants.spaceXl),

          // Automatic Engineering Conclusions
          const SectionHeader(
            title: 'Automated Engineering Conclusions',
            subtitle: 'Rule-based analytical diagnosis of the active circuit operating point',
            icon: Icons.fact_check_outlined,
          ),
          _buildAnalyticalConclusions(result, params),
        ],
      ),
    );
  }

  Widget _buildActiveChart(ZenerParameters params, ParameterSweepService sweepService, ZenerSimulationResult result) {
    switch (_selectedChart) {
      case ChartType.surface3D:
        return Surface3DChartWidget(baseline: params);

      case ChartType.vinVsVout:
        final sweepData = sweepService.sweepVin(baseline: params, startVin: 0.0, stopVin: 25.0, steps: 51);
        return LabChartWidget(
          title: 'Line Regulation Characteristic: Vin vs Vout',
          xLabel: 'Input Voltage Vin',
          yLabel: 'Output Voltage Vout',
          xUnit: 'V',
          yUnit: 'V',
          lineColor: AppColors.voltageOut,
          points: sweepData.map((d) => GraphPoint(x: d.vin, y: d.vout)).toList(),
          currentPoint: GraphPoint(x: result.vin, y: result.vout),
          interpretation:
              'Observation: Below Vz (${params.vz}V), Vout increases linearly along the resistive divider slope. Once Vin exceeds the breakdown knee (~${((params.vz * (params.rs + params.rl)) / params.rl).toStringAsFixed(1)}V), Vout clamps horizontally at Vz.',
        );

      case ChartType.vinVsIz:
        final sweepData = sweepService.sweepVin(baseline: params, startVin: 0.0, stopVin: 25.0, steps: 51);
        return LabChartWidget(
          title: 'Zener Conduction Curve: Vin vs Iz',
          xLabel: 'Input Voltage Vin',
          yLabel: 'Zener Current Iz',
          xUnit: 'V',
          yUnit: 'mA',
          lineColor: AppColors.zenerCurrent,
          points: sweepData.map((d) => GraphPoint(x: d.vin, y: d.zenerCurrentMilliAmps)).toList(),
          currentPoint: GraphPoint(x: result.vin, y: result.zenerCurrentMilliAmps),
          interpretation:
              'Observation: Zener current remains 0mA while Vin is below breakdown. Beyond breakdown, Iz grows linearly with slope 1/Rs, absorbing incoming voltage variations.',
        );

      case ChartType.vinVsPz:
        final sweepData = sweepService.sweepVin(baseline: params, startVin: 0.0, stopVin: 25.0, steps: 51);
        return LabChartWidget(
          title: 'Thermal Dissipation Curve: Vin vs Pz',
          xLabel: 'Input Voltage Vin',
          yLabel: 'Zener Power Pz',
          xUnit: 'V',
          yUnit: 'mW',
          lineColor: AppColors.error,
          points: sweepData.map((d) => GraphPoint(x: d.vin, y: d.zenerPowerMilliWatts)).toList(),
          currentPoint: GraphPoint(x: result.vin, y: result.zenerPowerMilliWatts),
          interpretation:
              'Observation: Diode power dissipation Pz is proportional to Iz. High input voltages require heat sinks or higher Rs to avoid thermal runaway exceeding PzMax.',
        );

      case ChartType.rlVsVout:
        final sweepData = sweepService.sweepRl(baseline: params, startRl: 100.0, stopRl: 3000.0, steps: 50);
        return LabChartWidget(
          title: 'Load Regulation Characteristic: RL vs Vout',
          xLabel: 'Load Resistance RL',
          yLabel: 'Output Voltage Vout',
          xUnit: 'Ω',
          yUnit: 'V',
          lineColor: AppColors.primary,
          points: sweepData.map((d) => GraphPoint(x: d.rl, y: d.vout)).toList(),
          currentPoint: GraphPoint(x: result.rl, y: result.vout),
          interpretation:
              'Observation: Under heavy load (small RL), current starved from the Zener causes Vout to drop below Vz. For RL > RL_min, Vout stabilizes flatly at Vz.',
        );

      case ChartType.rlVsIz:
        final sweepData = sweepService.sweepRl(baseline: params, startRl: 100.0, stopRl: 3000.0, steps: 50);
        return LabChartWidget(
          title: 'Load Current Shunting: RL vs Iz',
          xLabel: 'Load Resistance RL',
          yLabel: 'Zener Current Iz',
          xUnit: 'Ω',
          yUnit: 'mA',
          lineColor: AppColors.zenerCurrent,
          points: sweepData.map((d) => GraphPoint(x: d.rl, y: d.zenerCurrentMilliAmps)).toList(),
          currentPoint: GraphPoint(x: result.rl, y: result.zenerCurrentMilliAmps),
          interpretation:
              'Observation: As load resistance RL increases, load current decreases, allowing more current to shunt safely through the Zener diode.',
        );

      case ChartType.rsVsVout:
        final sweepData = sweepService.sweepRs(baseline: params, startRs: 50.0, stopRs: 1000.0, steps: 50);
        return LabChartWidget(
          title: 'Series Resistor Influence: Rs vs Vout',
          xLabel: 'Series Resistance Rs',
          yLabel: 'Output Voltage Vout',
          xUnit: 'Ω',
          yUnit: 'V',
          lineColor: AppColors.voltageOut,
          points: sweepData.map((d) => GraphPoint(x: d.rs, y: d.vout)).toList(),
          currentPoint: GraphPoint(x: result.rs, y: result.vout),
          interpretation:
              'Observation: If Rs is excessively large, voltage drop across Rs is too high, starving the Zener and collapsing Vout below regulation.',
        );

      case ChartType.rsVsIz:
        final sweepData = sweepService.sweepRs(baseline: params, startRs: 50.0, stopRs: 1000.0, steps: 50);
        return LabChartWidget(
          title: 'Series Current Limiting: Rs vs Iz',
          xLabel: 'Series Resistance Rs',
          yLabel: 'Zener Current Iz',
          xUnit: 'Ω',
          yUnit: 'mA',
          lineColor: AppColors.zenerCurrent,
          points: sweepData.map((d) => GraphPoint(x: d.rs, y: d.zenerCurrentMilliAmps)).toList(),
          currentPoint: GraphPoint(x: result.rs, y: result.zenerCurrentMilliAmps),
          interpretation:
              'Observation: Decreasing series resistance Rs increases total series current Is, driving higher current Iz through the Zener diode.',
        );
    }
  }

  Widget _buildAnalyticalConclusions(ZenerSimulationResult result, ZenerParameters params) {
    final List<Widget> conclusions = [];

    if (result.isRegulating) {
      conclusions.add(const StateCallout(
        title: '✓ Optimal Regulation',
        message: 'The circuit is operating inside its safe, nominal breakdown envelope. Voltage regulation factor is ideal.',
        type: CalloutType.success,
      ));
    } else if (result.isBelowBreakdown) {
      conclusions.add(const StateCallout(
        title: '⚠ Diode Non-Conducting (Unregulated)',
        message: 'Output voltage is determined purely by the resistive divider ratio RL/(Rs+RL). Increase Vin or decrease Rs to achieve Zener breakdown.',
        type: CalloutType.warning,
      ));
    } else if (result.isLowZenerCurrent) {
      conclusions.add(const StateCallout(
        title: '⚠ Heavy Load Warning',
        message: 'Load current is high enough to reduce Iz below knee current IzMin. Increase load resistance RL or decrease series resistance Rs.',
        type: CalloutType.warning,
      ));
    } else if (result.isOverCurrent || result.isOverPower) {
      conclusions.add(const StateCallout(
        title: '⛔ Thermal Safety Limit Exceeded',
        message: 'Diode ratings are exceeded. Increase series resistance Rs or reduce input voltage Vin to prevent component destruction.',
        type: CalloutType.error,
      ));
    }

    return Column(children: conclusions);
  }
}

class _LimitBar extends StatelessWidget {
  final String label;
  final double currentValue;
  final double maxValue;
  final String unit;
  final Color color;

  const _LimitBar({
    required this.label,
    required this.currentValue,
    required this.maxValue,
    required this.unit,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final ratio = (currentValue / maxValue).clamp(0.0, 1.0);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: theme.textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w600),
            ),
            Text(
              '${currentValue.toStringAsFixed(1)} / ${maxValue.toStringAsFixed(1)} $unit  (${(ratio * 100).toStringAsFixed(0)}%)',
              style: const TextStyle(fontFamily: 'monospace', fontSize: 11, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        const SizedBox(height: 4),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: ratio,
            minHeight: 8,
            backgroundColor: theme.colorScheme.surfaceContainerHigh,
            valueColor: AlwaysStoppedAnimation<Color>(ratio > 0.9 ? AppColors.error : color),
          ),
        ),
      ],
    );
  }
}

class _ChartChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onSelected;

  const _ChartChip({
    required this.label,
    required this.isSelected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: FilterChip(
        selected: isSelected,
        label: Text(label),
        onSelected: (_) => onSelected(),
      ),
    );
  }
}

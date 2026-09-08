import 'package:flutter/material.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/widgets/widgets.dart';
import '../../../../simulation/simulation.dart';

/// Control panel containing primary parameter sliders, preset selector, and advanced parameters expander
class ParameterControlsWidget extends StatefulWidget {
  final ZenerParameters parameters;
  final ValueChanged<ZenerParameters> onParametersChanged;
  final VoidCallback onReset;

  const ParameterControlsWidget({
    super.key,
    required this.parameters,
    required this.onParametersChanged,
    required this.onReset,
  });

  @override
  State<ParameterControlsWidget> createState() => _ParameterControlsWidgetState();
}

class _ParameterControlsWidgetState extends State<ParameterControlsWidget> {
  bool _showAdvanced = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final params = widget.parameters;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Presets Selector Card
        AppCard(
          padding: const EdgeInsets.all(AppConstants.spaceMd),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Circuit Presets',
                    style: theme.textTheme.labelLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextButton.icon(
                    onPressed: widget.onReset,
                    icon: const Icon(Icons.restart_alt_rounded, size: 16),
                    label: const Text('Reset Defaults'),
                  ),
                ],
              ),
              const SizedBox(height: AppConstants.spaceSm),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: CircuitPreset.all.map((preset) {
                    final isSelected = params.vin == preset.parameters.vin &&
                        params.vz == preset.parameters.vz &&
                        params.rs == preset.parameters.rs &&
                        params.rl == preset.parameters.rl;

                    return Padding(
                      padding: const EdgeInsets.only(right: AppConstants.spaceSm),
                      child: FilterChip(
                        selected: isSelected,
                        label: Text(preset.title),
                        avatar: Icon(preset.icon, size: 16),
                        onSelected: (_) => widget.onParametersChanged(preset.parameters),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppConstants.spaceMd),

        // Primary Parameter 1: Input Voltage Vin
        ParameterCard(
          title: 'Input Voltage',
          symbol: 'Vin',
          value: params.vin,
          min: 0.0,
          max: 40.0,
          divisions: 80,
          unit: 'V',
          description: 'Unregulated DC power supply voltage.',
          onChanged: (val) => widget.onParametersChanged(params.copyWith(vin: val)),
        ),
        const SizedBox(height: AppConstants.spaceSm),

        // Primary Parameter 2: Zener Breakdown Voltage Vz
        ParameterCard(
          title: 'Zener Voltage',
          symbol: 'Vz',
          value: params.vz,
          min: 2.4,
          max: 15.0,
          divisions: 63,
          unit: 'V',
          description: 'Nominal reverse breakdown clamp potential.',
          onChanged: (val) => widget.onParametersChanged(params.copyWith(vz: val)),
        ),
        const SizedBox(height: AppConstants.spaceSm),

        // Primary Parameter 3: Series Resistor Rs
        ParameterCard(
          title: 'Series Resistor',
          symbol: 'Rs',
          value: params.rs,
          min: 50.0,
          max: 1000.0,
          divisions: 95,
          unit: 'Ω',
          description: 'Current-limiting series resistor.',
          onChanged: (val) => widget.onParametersChanged(params.copyWith(rs: val)),
        ),
        const SizedBox(height: AppConstants.spaceSm),

        // Primary Parameter 4: Load Resistor RL
        ParameterCard(
          title: 'Load Resistance',
          symbol: 'RL',
          value: params.rl,
          min: 100.0,
          max: 5000.0,
          divisions: 98,
          unit: 'Ω',
          description: 'Output parallel load resistor.',
          onChanged: (val) => widget.onParametersChanged(params.copyWith(rl: val)),
        ),
        const SizedBox(height: AppConstants.spaceMd),

        // Advanced Parameters Expander
        AppCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InkWell(
                onTap: () => setState(() => _showAdvanced = !_showAdvanced),
                child: Row(
                  children: [
                    Icon(
                      _showAdvanced ? Icons.expand_less_rounded : Icons.expand_more_rounded,
                      color: theme.colorScheme.primary,
                    ),
                    const SizedBox(width: AppConstants.spaceSm),
                    Expanded(
                      child: Text(
                        'Advanced Diode Thresholds & Limits',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          fontSize: 13.5,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: AppConstants.spaceSm),
                    StatusIndicator(
                      label: _showAdvanced ? 'Expanded' : 'Collapsed',
                      type: StatusType.info,
                      showDot: false,
                    ),
                  ],
                ),
              ),
              if (_showAdvanced) ...[
                const SizedBox(height: AppConstants.spaceMd),
                const Divider(),
                const SizedBox(height: AppConstants.spaceSm),
                ParameterCard(
                  title: 'Knee Current (IzMin)',
                  symbol: 'IzMin',
                  value: params.izMin * 1000.0,
                  min: 1.0,
                  max: 20.0,
                  divisions: 19,
                  unit: 'mA',
                  description: 'Minimum current needed for stable breakdown.',
                  onChanged: (val) => widget.onParametersChanged(params.copyWith(izMin: val / 1000.0)),
                ),
                const SizedBox(height: AppConstants.spaceSm),
                ParameterCard(
                  title: 'Max Continuous Current (IzMax)',
                  symbol: 'IzMax',
                  value: params.izMax * 1000.0,
                  min: 20.0,
                  max: 150.0,
                  divisions: 26,
                  unit: 'mA',
                  description: 'Maximum safe current rating before damage.',
                  onChanged: (val) => widget.onParametersChanged(params.copyWith(izMax: val / 1000.0)),
                ),
                const SizedBox(height: AppConstants.spaceSm),
                ParameterCard(
                  title: 'Max Power Rating (PzMax)',
                  symbol: 'PzMax',
                  value: params.pzMax * 1000.0,
                  min: 100.0,
                  max: 1000.0,
                  divisions: 18,
                  unit: 'mW',
                  description: 'Maximum allowable thermal power rating.',
                  onChanged: (val) => widget.onParametersChanged(params.copyWith(pzMax: val / 1000.0)),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/widgets/widgets.dart';
import '../../../../simulation/simulation.dart';
import 'widgets/calculation_steps_widget.dart';
import 'widgets/circuit_diagram_widget.dart';
import 'widgets/educational_why_widget.dart';
import 'widgets/live_measurements_panel.dart';
import 'widgets/parameter_controls_widget.dart';

/// Interactive Zener Diode Circuit Simulator Screen
class SimulatorScreen extends StatefulWidget {
  const SimulatorScreen({super.key});

  @override
  State<SimulatorScreen> createState() => _SimulatorScreenState();
}

class _SimulatorScreenState extends State<SimulatorScreen> {
  final SimulatorController _controller = SimulatorController.instance;

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onSimulatorUpdated);
  }

  @override
  void dispose() {
    _controller.removeListener(_onSimulatorUpdated);
    super.dispose();
  }

  void _onSimulatorUpdated() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final result = _controller.currentResult;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppConstants.spaceLg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Header with Circuit Status Pill
          SectionHeader(
            title: 'Interactive Circuit Simulator',
            subtitle: 'Live DC voltage regulator laboratory simulation',
            icon: Icons.developer_board_rounded,
            trailing: StatusIndicator(
              label: result.zenerState.displayName,
              type: _getStatusType(result.zenerState),
            ),
          ),

          // Operational Status Explanation Callout
          StateCallout(
            title: 'Operating State: ${result.zenerState.displayName}',
            message: result.message,
            type: _getCalloutType(result.zenerState),
          ),
          const SizedBox(height: AppConstants.spaceLg),

          // Two-column responsive layout for Circuit & Controls
          LayoutBuilder(
            builder: (context, constraints) {
              final isDesktop = constraints.maxWidth >= 950;

              if (isDesktop) {
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Left: Schematic & Current toggle
                    Expanded(
                      flex: 5,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AppCard(
                            padding: const EdgeInsets.all(AppConstants.spaceMd),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    const Expanded(
                                      child: Text(
                                        'Regulator Schematic Diagram',
                                        style: TextStyle(fontWeight: FontWeight.bold),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    const SizedBox(width: AppConstants.spaceSm),
                                    Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        const Text(
                                          'Flow',
                                          style: TextStyle(fontSize: 12),
                                        ),
                                        Switch(
                                          value: _controller.showCurrentFlow,
                                          onChanged: (_) => _controller.toggleCurrentFlow(),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                const Divider(),
                                CircuitDiagramWidget(
                                  result: result,
                                  showCurrentFlow: _controller.showCurrentFlow,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: AppConstants.spaceLg),
                          LiveMeasurementsPanel(result: result),
                        ],
                      ),
                    ),
                    const SizedBox(width: AppConstants.spaceLg),

                    // Right: Parameter Controls & Slider Panel
                    Expanded(
                      flex: 5,
                      child: ParameterControlsWidget(
                        parameters: _controller.parameters,
                        onParametersChanged: _controller.updateParameters,
                        onReset: _controller.resetToDefaults,
                      ),
                    ),
                  ],
                );
              } else {
                // Mobile & Tablet Stacked Layout
                return Column(
                  children: [
                    AppCard(
                      padding: const EdgeInsets.all(AppConstants.spaceMd),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Expanded(
                                child: Text(
                                  'Regulator Schematic Diagram',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              const SizedBox(width: AppConstants.spaceSm),
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Text(
                                    'Flow',
                                    style: TextStyle(fontSize: 12),
                                  ),
                                  Switch(
                                    value: _controller.showCurrentFlow,
                                    onChanged: (_) => _controller.toggleCurrentFlow(),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const Divider(),
                          CircuitDiagramWidget(
                            result: result,
                            showCurrentFlow: _controller.showCurrentFlow,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppConstants.spaceLg),
                    LiveMeasurementsPanel(result: result),
                    const SizedBox(height: AppConstants.spaceLg),
                    ParameterControlsWidget(
                      parameters: _controller.parameters,
                      onParametersChanged: _controller.updateParameters,
                      onReset: _controller.resetToDefaults,
                    ),
                  ],
                );
              }
            },
          ),
          const SizedBox(height: AppConstants.spaceXl),

          // Step-by-Step Live Calculation View
          CalculationStepsWidget(result: result),
          const SizedBox(height: AppConstants.spaceXl),

          // "Why?" Educational Physics Insight
          EducationalWhyWidget(result: result),
        ],
      ),
    );
  }

  StatusType _getStatusType(ZenerState state) {
    switch (state) {
      case ZenerState.regulating:
        return StatusType.active;
      case ZenerState.belowBreakdown:
        return StatusType.inactive;
      case ZenerState.lowZenerCurrent:
        return StatusType.warning;
      case ZenerState.overCurrent:
      case ZenerState.overPower:
      case ZenerState.invalidParameters:
        return StatusType.error;
    }
  }

  CalloutType _getCalloutType(ZenerState state) {
    switch (state) {
      case ZenerState.regulating:
        return CalloutType.success;
      case ZenerState.belowBreakdown:
        return CalloutType.info;
      case ZenerState.lowZenerCurrent:
        return CalloutType.warning;
      case ZenerState.overCurrent:
      case ZenerState.overPower:
      case ZenerState.invalidParameters:
        return CalloutType.error;
    }
  }
}

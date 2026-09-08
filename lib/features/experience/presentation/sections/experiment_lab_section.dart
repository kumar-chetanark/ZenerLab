import 'package:flutter/material.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/widgets/app_buttons.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../simulation/simulation.dart';
import '../../../../theme/app_colors.dart';
import '../../../../theme/app_typography.dart';
import '../../../analysis/presentation/widgets/lab_chart_widget.dart';

enum ExperimentType {
  lineRegulation,
  loadRegulation,
}

/// Section 08 — Virtual Experiment Laboratory Bench
class ExperimentLabSection extends StatefulWidget {
  const ExperimentLabSection({super.key});

  @override
  State<ExperimentLabSection> createState() => _ExperimentLabSectionState();
}

class _ExperimentLabSectionState extends State<ExperimentLabSection> {
  final SimulatorController _controller = SimulatorController.instance;
  ExperimentType _selectedExperiment = ExperimentType.lineRegulation;
  List<ZenerSimulationResult> _recordedReadings = [];

  final double _vinStart = 0.0;
  final double _vinStop = 20.0;
  final double _vinStep = 1.0;

  final double _rlStart = 100.0;
  final double _rlStop = 3000.0;
  final double _rlStep = 200.0;

  void _generateExperimentData() {
    final params = _controller.parameters;
    final List<ZenerSimulationResult> results = [];

    if (_selectedExperiment == ExperimentType.lineRegulation) {
      double currentVin = _vinStart;
      while (currentVin <= _vinStop + 0.001) {
        final p = params.copyWith(vin: currentVin);
        results.add(_controller.simulator.simulate(p));
        currentVin += _vinStep;
      }
    } else {
      double currentRl = _rlStart;
      while (currentRl <= _rlStop + 0.001) {
        final p = params.copyWith(rl: currentRl);
        results.add(_controller.simulator.simulate(p));
        currentRl += _rlStep;
      }
    }

    setState(() {
      _recordedReadings = results;
    });
  }

  void _recordSinglePoint() {
    setState(() {
      _recordedReadings.add(_controller.currentResult);
    });
  }

  void _clearReadings() {
    setState(() {
      _recordedReadings.clear();
    });
  }

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
                '08 — PRACTICAL EXPERIMENTATION',
                style: AppTypography.labelSmall.copyWith(
                  color: AppColors.primary,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: AppConstants.spaceSm),
              Text(
                'VIRTUAL ELECTRONICS LABORATORY BENCH',
                style: (isDesktop ? AppTypography.displayLarge : AppTypography.displayMedium).copyWith(
                  color: AppColors.darkTextPrimary,
                ),
              ),
              const SizedBox(height: AppConstants.spaceLg),

              // Experiment Selector Tabs
              Row(
                children: [
                  _buildTabButton('Experiment 1: Line Regulation (ΔVout / ΔVin)', ExperimentType.lineRegulation),
                  const SizedBox(width: AppConstants.spaceMd),
                  _buildTabButton('Experiment 2: Load Regulation (VNL - VFL) / VFL', ExperimentType.loadRegulation),
                ],
              ),
              const SizedBox(height: AppConstants.spaceLg),

              // Setup Objective Box
              AppCard(
                padding: const EdgeInsets.all(AppConstants.spaceLg),
                color: AppColors.darkSurfaceContainer,
                borderColor: AppColors.darkBorder,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _selectedExperiment == ExperimentType.lineRegulation
                          ? 'OBJECTIVE: Characterize Line Regulation factor (ΔVout / ΔVin) while maintaining constant load resistance RL.'
                          : 'OBJECTIVE: Characterize Load Regulation factor ((VNL - VFL) / VFL × 100%) while maintaining constant input voltage Vin.',
                      style: AppTypography.bodyMedium.copyWith(color: AppColors.darkTextPrimary, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: AppConstants.spaceMd),
                    Wrap(
                      spacing: AppConstants.spaceMd,
                      runSpacing: AppConstants.spaceSm,
                      children: [
                        AppButton.primary(
                          label: 'Generate Full Run Data',
                          icon: Icons.play_arrow_rounded,
                          onPressed: _generateExperimentData,
                        ),
                        AppButton.secondary(
                          label: 'Log Current Reading',
                          icon: Icons.add_circle_outline_rounded,
                          onPressed: _recordSinglePoint,
                        ),
                        AppButton.secondary(
                          label: 'Clear Observations',
                          icon: Icons.delete_outline_rounded,
                          onPressed: _clearReadings,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppConstants.spaceLg),

              // Observation Table
              if (_recordedReadings.isNotEmpty) ...[
                AppCard(
                  padding: const EdgeInsets.all(AppConstants.spaceLg),
                  color: AppColors.darkSurfaceContainer,
                  borderColor: AppColors.darkBorder,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('OBSERVATION TABLE & TELEMETRY LOG', style: AppTypography.labelSmall.copyWith(color: AppColors.primary)),
                      const SizedBox(height: AppConstants.spaceMd),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: DataTable(
                          columnSpacing: 24,
                          headingRowColor: WidgetStateProperty.all(AppColors.darkSurfaceHigh),
                          columns: const [
                            DataColumn(label: Text('Trial #')),
                            DataColumn(label: Text('Vin (V)')),
                            DataColumn(label: Text('RL (Ω)')),
                            DataColumn(label: Text('Vout (V)')),
                            DataColumn(label: Text('Is (mA)')),
                            DataColumn(label: Text('Iz (mA)')),
                            DataColumn(label: Text('IL (mA)')),
                            DataColumn(label: Text('State')),
                          ],
                          rows: _recordedReadings.asMap().entries.map((entry) {
                            final idx = entry.key + 1;
                            final r = entry.value;
                            return DataRow(
                              cells: [
                                DataCell(Text('$idx')),
                                DataCell(Text(r.vin.toStringAsFixed(1))),
                                DataCell(Text(r.rl.toStringAsFixed(0))),
                                DataCell(Text(r.vout.toStringAsFixed(2))),
                                DataCell(Text((r.seriesCurrent * 1000).toStringAsFixed(2))),
                                DataCell(Text((r.zenerCurrent * 1000).toStringAsFixed(2))),
                                DataCell(Text((r.loadCurrent * 1000).toStringAsFixed(2))),
                                DataCell(Text(r.zenerState.displayName, style: TextStyle(color: r.isRegulating ? AppColors.primary : AppColors.warning))),
                              ],
                            );
                          }).toList(),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppConstants.spaceLg),

                // Calculation & Report
                AppCard(
                  padding: const EdgeInsets.all(AppConstants.spaceLg),
                  color: AppColors.darkSurfaceContainer,
                  borderColor: AppColors.primary.withValues(alpha: 0.3),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _selectedExperiment == ExperimentType.lineRegulation
                            ? 'Line Regulation Calculation & Report'
                            : 'Load Regulation Calculation & Report',
                        style: AppTypography.titleMedium.copyWith(color: AppColors.darkTextPrimary),
                      ),
                      const SizedBox(height: AppConstants.spaceSm),
                      Text(
                        _selectedExperiment == ExperimentType.lineRegulation
                            ? 'Line Regulation = ΔVout / ΔVin = 0.000 V/V across regulation range.'
                            : 'Load Regulation = ((VNL - VFL) / VFL) × 100% = 0.00% under ideal Zener breakdown.',
                        style: AppTypography.monoSub.copyWith(color: AppColors.primary),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppConstants.spaceLg),

                // Experiment Curve
                AppCard(
                  padding: const EdgeInsets.all(AppConstants.spaceLg),
                  color: AppColors.darkSurfaceContainer,
                  borderColor: AppColors.darkBorder,
                  child: LabChartWidget(
                    title: _selectedExperiment == ExperimentType.lineRegulation
                        ? 'Experiment Curve: Line Regulation (Vin vs Vout)'
                        : 'Experiment Curve: Load Regulation (RL vs Vout)',
                    xLabel: _selectedExperiment == ExperimentType.lineRegulation ? 'Input Potential (Vin)' : 'Load Resistance (RL)',
                    yLabel: 'Output Potential (Vout)',
                    xUnit: _selectedExperiment == ExperimentType.lineRegulation ? 'V' : 'Ω',
                    yUnit: 'V',
                    points: _recordedReadings.map((r) => GraphPoint(
                      x: _selectedExperiment == ExperimentType.lineRegulation ? r.vin : r.rl,
                      y: r.vout,
                    )).toList(),
                    lineColor: AppColors.primary,
                  ),
                ),
              ],
            ],
          ),
        );
      },
    );
  }

  Widget _buildTabButton(String label, ExperimentType type) {
    final isSelected = _selectedExperiment == type;
    return InkWell(
      onTap: () {
        setState(() {
          _selectedExperiment = type;
          _recordedReadings.clear();
        });
      },
      borderRadius: BorderRadius.circular(AppConstants.radiusSm),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : AppColors.darkSurfaceContainer,
          borderRadius: BorderRadius.circular(AppConstants.radiusSm),
          border: Border.all(color: isSelected ? AppColors.primary : AppColors.darkBorder),
        ),
        child: Text(
          label,
          style: AppTypography.labelSmall.copyWith(
            color: isSelected ? AppColors.darkBg : AppColors.darkTextPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

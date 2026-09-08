import 'package:flutter/material.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/widgets/widgets.dart';
import '../../../../simulation/simulation.dart';

/// Step-by-step substitution and solution breakdown showing actual numerical evaluation
class CalculationStepsWidget extends StatelessWidget {
  final ZenerSimulationResult result;

  const CalculationStepsWidget({
    super.key,
    required this.result,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    if (result.isInvalid) {
      return StateCallout(
        title: 'Cannot Compute Steps',
        message: result.message,
        type: CalloutType.error,
      );
    }

    final vin = result.vin;
    final vz = result.vz;
    final rs = result.rs;
    final rl = result.rl;
    final voutUnregulated = (vin * rl) / (rs + rl);

    return AppCard(
      padding: const EdgeInsets.all(AppConstants.spaceLg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Live Mathematical Derivation',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              StatusIndicator(
                label: result.isBelowBreakdown ? 'Resistive Divider Mode' : 'Breakdown Clamping Mode',
                type: result.isBelowBreakdown ? StatusType.inactive : StatusType.active,
              ),
            ],
          ),
          const SizedBox(height: AppConstants.spaceMd),

          // Step 1: Breakdown test
          _StepCard(
            stepNumber: 1,
            title: 'Unregulated Open-Circuit Potential Check',
            formula: 'Vout_unreg = Vin × RL / (Rs + RL)',
            substitution: '$vin × $rl / ($rs + $rl) = ${(vin * rl).toStringAsFixed(1)} / ${(rs + rl).toStringAsFixed(1)}',
            result: '${voutUnregulated.toStringAsFixed(3)} V',
            isCondition: true,
            conditionOutcome: voutUnregulated >= vz
                ? '≥ Vz ($vz V) → Zener reaches Reverse Breakdown! Output clamps to Vz.'
                : '< Vz ($vz V) → Below Breakdown! Diode is OFF (Iz = 0).',
            isDark: isDark,
          ),
          const SizedBox(height: AppConstants.spaceSm),

          if (result.isBelowBreakdown) ...[
            _StepCard(
              stepNumber: 2,
              title: 'Output Voltage & Series Current',
              formula: 'Vout = Vout_unreg,  Is = Vin / (Rs + RL)',
              substitution: 'Is = $vin / ($rs + $rl) = $vin / ${(rs + rl).toStringAsFixed(1)}',
              result: 'Vout = ${result.vout.toStringAsFixed(3)} V,  Is = ${result.seriesCurrentMilliAmps.toStringAsFixed(2)} mA',
              isDark: isDark,
            ),
          ] else ...[
            _StepCard(
              stepNumber: 2,
              title: 'Series Resistor Current (Is)',
              formula: 'Is = (Vin - Vout) / Rs',
              substitution: '($vin - ${result.vout.toStringAsFixed(2)}) / $rs = ${(vin - result.vout).toStringAsFixed(2)} / $rs',
              result: '${result.seriesCurrent.toStringAsFixed(6)} A  (${result.seriesCurrentMilliAmps.toStringAsFixed(2)} mA)',
              isDark: isDark,
            ),
            const SizedBox(height: AppConstants.spaceSm),
            _StepCard(
              stepNumber: 3,
              title: 'Load Resistor Current (IL)',
              formula: 'IL = Vout / RL',
              substitution: '${result.vout.toStringAsFixed(2)} / $rl',
              result: '${result.loadCurrent.toStringAsFixed(6)} A  (${result.loadCurrentMilliAmps.toStringAsFixed(2)} mA)',
              isDark: isDark,
            ),
            const SizedBox(height: AppConstants.spaceSm),
            _StepCard(
              stepNumber: 4,
              title: 'Zener Diode Current (Iz via KCL)',
              formula: 'Iz = Is - IL',
              substitution: '${result.seriesCurrentMilliAmps.toStringAsFixed(2)} mA - ${result.loadCurrentMilliAmps.toStringAsFixed(2)} mA',
              result: '${result.zenerCurrentMilliAmps.toStringAsFixed(2)} mA  (${result.zenerCurrent.toStringAsFixed(6)} A)',
              isDark: isDark,
            ),
            const SizedBox(height: AppConstants.spaceSm),
            _StepCard(
              stepNumber: 5,
              title: 'Zener Power Dissipation (Pz)',
              formula: 'Pz = Vz × Iz',
              substitution: '$vz V × ${result.zenerCurrent.toStringAsFixed(6)} A',
              result: '${result.zenerPowerMilliWatts.toStringAsFixed(2)} mW',
              isDark: isDark,
            ),
          ],
        ],
      ),
    );
  }
}

class _StepCard extends StatelessWidget {
  final int stepNumber;
  final String title;
  final String formula;
  final String substitution;
  final String result;
  final bool isCondition;
  final String? conditionOutcome;
  final bool isDark;

  const _StepCard({
    required this.stepNumber,
    required this.title,
    required this.formula,
    required this.substitution,
    required this.result,
    this.isCondition = false,
    this.conditionOutcome,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(AppConstants.spaceMd),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(AppConstants.radiusSm),
        border: Border.all(
          color: theme.colorScheme.outlineVariant.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 22,
                height: 22,
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    '$stepNumber',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: AppConstants.spaceSm),
              Text(
                title,
                style: theme.textTheme.labelLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppConstants.spaceSm),
          Text(
            'Formula:  $formula',
            style: const TextStyle(
              fontFamily: 'monospace',
              fontSize: 12.5,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: AppConstants.space2xs),
          Text(
            'Substitution:  $substitution',
            style: TextStyle(
              fontFamily: 'monospace',
              fontSize: 12,
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: AppConstants.space2xs),
          Row(
            children: [
              const Text(
                'Result:  ',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12.5),
              ),
              Text(
                result,
                style: TextStyle(
                  fontFamily: 'monospace',
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.primary,
                ),
              ),
            ],
          ),
          if (conditionOutcome != null) ...[
            const SizedBox(height: AppConstants.spaceXs),
            Container(
              padding: const EdgeInsets.all(AppConstants.spaceSm),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(AppConstants.radiusXs),
              ),
              child: Text(
                conditionOutcome!,
                style: TextStyle(
                  fontSize: 11.5,
                  fontWeight: FontWeight.w600,
                  color: theme.colorScheme.onSurface,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

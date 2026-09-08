import 'package:flutter/material.dart';
import '../../../../core/widgets/widgets.dart';
import '../../../../simulation/simulation.dart';

/// Contextual "Why?" educational cards dynamically tailoring explanations to the active electrical state
class EducationalWhyWidget extends StatelessWidget {
  final ZenerSimulationResult result;

  const EducationalWhyWidget({
    super.key,
    required this.result,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionHeader(
          title: 'Understanding the Circuit Physics ("Why?")',
          subtitle: 'Contextual physics reasoning for the current operating point',
          icon: Icons.psychology_outlined,
        ),
        _buildContextualCard(context),
      ],
    );
  }

  Widget _buildContextualCard(BuildContext context) {
    switch (result.zenerState) {
      case ZenerState.belowBreakdown:
        return const StateCallout(
          title: 'Why is the Zener diode OFF?',
          message:
              'The input voltage (Vin) is lower than required to produce Vz across the load in the resistive voltage divider. Because the reverse bias voltage is below the Zener breakdown threshold, electric field strength across the PN junction is insufficient to trigger quantum tunneling or avalanche breakdown. Hence, the diode acts as an open circuit (Iz = 0A).',
          type: CalloutType.info,
        );

      case ZenerState.regulating:
        return const StateCallout(
          title: 'Why does Vout remain constant despite changes in Vin?',
          message:
              'In the reverse breakdown region, the Zener diode exhibits extremely low dynamic impedance. When Vin rises, the series resistor (Rs) drops the excess voltage (Vin - Vz) as series current (Is) increases. By Kirchhoff’s Current Law (Iz = Is - IL), the Zener diode automatically shunts this extra current to ground, keeping load current (IL) and load voltage (Vout) locked at Vz.',
          type: CalloutType.success,
        );

      case ZenerState.lowZenerCurrent:
        return const StateCallout(
          title: 'Why is regulation unstable under heavy load?',
          message:
              'A heavy load (low RL) draws significant current (IL = Vz / RL). Since total series current Is is fixed by (Vin - Vz)/Rs, the load steals current away from the Zener. When Iz drops below the knee threshold (IzMin), the diode leaves the steep breakdown region, causing voltage stability to degrade.',
          type: CalloutType.warning,
        );

      case ZenerState.overCurrent:
        return const StateCallout(
          title: 'Why is Zener current excessive (Over-Current)?',
          message:
              'The combination of a high input voltage (Vin) and low series resistance (Rs) forces a large current Is into the junction. With light load (high RL), almost all of this excess current flows through the diode, exceeding IzMax.',
          type: CalloutType.error,
        );

      case ZenerState.overPower:
        return const StateCallout(
          title: 'Why is power dissipation dangerous (Over-Power)?',
          message:
              'Power generated inside the semiconductor is Pz = Vz × Iz. High current at the breakdown potential causes intense Joule heating. When Pz exceeds PzMax, thermal runaway occurs, which physically destroys the PN junction.',
          type: CalloutType.error,
        );

      case ZenerState.invalidParameters:
        return StateCallout(
          title: 'Circuit Error',
          message: result.message,
          type: CalloutType.error,
        );
    }
  }
}

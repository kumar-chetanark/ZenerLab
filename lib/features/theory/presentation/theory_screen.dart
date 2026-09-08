import 'package:flutter/material.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/widgets/widgets.dart';
import '../../../../simulation/simulation.dart';

/// Comprehensive Undergraduate Electronics Theory & Physics Textbook Module
class TheoryScreen extends StatelessWidget {
  const TheoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppConstants.spaceLg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          const SectionHeader(
            title: 'Zener Diode Physics & Regulation Theory',
            subtitle: 'Complete textbook reference, breakdown mechanics, and circuit analysis for lab vivas and coursework',
            icon: Icons.menu_book_rounded,
          ),

          // Topic 1: What is a Zener Diode?
          const _TheoryTopicCard(
            title: '1. What is a Zener Diode?',
            keyIdea: 'Heavily doped silicon PN junction diode engineered to operate in the reverse breakdown region.',
            content:
                'A Zener diode is a specialized silicon PN junction semiconductor device. Unlike standard rectifier diodes which are permanently damaged by high reverse breakdown currents, a Zener diode is heavily doped so that its depletion region is extremely narrow (~10⁻⁸ m). When reverse biased beyond its breakdown potential (Vz), it conducts significant reverse current without destructive heating as long as its rated wattage (PzMax) is observed.',
            equations: [
              'Vout ≈ Vz  (during reverse breakdown)',
            ],
          ),
          const SizedBox(height: AppConstants.spaceMd),

          // Topic 2: Avalanche Breakdown vs Zener Breakdown
          const _TheoryTopicCard(
            title: '2. Zener Breakdown vs Avalanche Breakdown & Temperature Effects',
            keyIdea: 'Quantum mechanical tunneling (< 5V) vs impact ionization (> 6V).',
            content:
                'Two distinct physical mechanisms cause reverse breakdown in semiconductor PN junctions:\n\n'
                '• Zener Breakdown (typically Vz < 5V): Occurs in very heavily doped diodes with a narrow junction. High electric fields (> 10⁷ V/m) directly pull valence electrons across the bandgap into the conduction band via quantum mechanical tunneling. The breakdown voltage typically decreases with temperature (negative temperature coefficient).\n\n'
                '• Avalanche Breakdown (typically Vz > 6V): Occurs in lightly or moderately doped diodes with a wider depletion region. Thermally generated minority carriers accelerate under the high electric field, collide with silicon lattice atoms, and liberate secondary electron-hole pairs (impact ionization). Increased lattice vibrations at higher temperatures cause more scattering, typically requiring a higher voltage to achieve breakdown (positive temperature coefficient).\n\n'
                '• Near ~5.1V to 5.6V: Both mechanisms can operate simultaneously with opposing temperature coefficients, resulting in diodes with very low overall temperature drift.\n\n'
                '• Modeling Note: Real Zener diodes exhibit temperature-dependent breakdown voltages. The sign and magnitude of the temperature coefficient depend on the specific device and breakdown mechanism. Temperature variation is not dynamically modeled in this educational simulator.',
          ),
          const SizedBox(height: AppConstants.spaceMd),

          // Topic 3: Voltage Regulation Working Principle
          const _TheoryTopicCard(
            title: '3. Voltage Regulator Working Principle',
            keyIdea: 'Series current adjusts across Rs to keep load voltage locked at Vz.',
            content:
                'In a voltage regulator, the Zener diode is connected in parallel with the load (RL) and in series with a current-limiting resistor (Rs).\n\n'
                '1. When input voltage (Vin) rises, the series current Is = (Vin - Vz)/Rs increases.\n'
                '2. Because load voltage Vout is clamped at Vz, the load current IL = Vz/RL remains constant.\n'
                '3. By Kirchhoff’s Current Law (Iz = Is - IL), the entire surge in current is safely shunted through the Zener diode to ground.\n'
                '4. Consequently, the load sees a rock-solid, regulated DC voltage equal to Vz.',
            equations: [
              'Is = (Vin - Vout) / Rs',
              'IL = Vout / RL',
              'Iz = Is - IL',
            ],
          ),
          const SizedBox(height: AppConstants.spaceMd),

          // Topic 4: Line Regulation and Load Regulation
          const _TheoryTopicCard(
            title: '4. Line Regulation & Load Regulation',
            keyIdea: 'Measures of output stability against input line fluctuations and load draw variations.',
            content:
                '• Line Regulation: Characterizes the sensitivity of output voltage to changes in unregulated input voltage across the regulating range. Common textbook and laboratory definitions include:\n'
                '   1. Standard differential format: Line Reg = ΔVout / ΔVin (expressed in V/V or mV/V)\n'
                '   2. Normalized percentage format: Line Reg (%/V) = [(ΔVout / Vout) ÷ ΔVin] × 100%\n\n'
                '• Regulating Region Behavior: Within the idealized regulating region (Rz = 0Ω), ΔVout = 0V, producing 0.000 V/V line regulation. Real diodes have finite dynamic resistance Rz = ΔVz / ΔIz, giving slight non-zero slope.\n\n'
                '• Load Regulation: Measures the change in output voltage when load current varies from no-load (NL) to full-load (FL):\n'
                '   Load Regulation (%) = [(V_NL - V_FL) / V_FL] × 100%',
            equations: [
              'Line Regulation = ΔVout / ΔVin  (V/V or mV/V)',
              'Line Regulation (%/V) = [(ΔVout / Vout) ÷ ΔVin] × 100%',
              'Load Regulation (%) = [(V_NL - V_FL) / V_FL] × 100%',
            ],
          ),
          const SizedBox(height: AppConstants.spaceMd),

          // Topic 5: Selection of Series Resistor Rs & Critical Limits
          const _TheoryTopicCard(
            title: '5. Selection of Series Resistor (Rs) & Operating Limits',
            keyIdea: 'Rs must balance between starving the diode at minimum Vin and exceeding PzMax at maximum Vin.',
            content:
                'To maintain continuous regulation without destroying the diode:\n\n'
                '• Maximum Rs (Rs_max): At minimum input voltage (Vin_min) and maximum load current (IL_max), current through the Zener must not drop below IzMin:\n'
                'Rs_max = (Vin_min - Vz) / (IL_max + IzMin)\n\n'
                '• Minimum Rs (Rs_min): At maximum input voltage (Vin_max) and minimum load current (IL_min), current through the Zener must not exceed IzMax:\n'
                'Rs_min = (Vin_max - Vz) / (IL_min + IzMax)\n\n'
                '• Power rating of Rs must satisfy: Prs = Is² × Rs.',
            equations: [
              'Rs_max = (Vin_min - Vz) / (IL_max + IzMin)',
              'Rs_min = (Vin_max - Vz) / (IL_min + IzMax)',
              'Pz = Vz × Iz  (Must be ≤ PzMax)',
            ],
          ),
          const SizedBox(height: AppConstants.spaceMd),

          // Topic 6: Formula Reference Directory
          const SectionHeader(
            title: 'Interactive Formula Reference Directory',
            subtitle: 'Standard equations referenced throughout curriculum simulations',
            icon: Icons.functions_rounded,
          ),
          ...ZenerFormulas.all.map((formula) {
            return Padding(
              padding: const EdgeInsets.only(bottom: AppConstants.spaceSm),
              child: ValueDisplay(
                label: formula.title,
                value: formula.formula,
                unit: '',
                formula: formula.description,
                icon: Icons.calculate_outlined,
              ),
            );
          }),
        ],
      ),
    );
  }
}

class _TheoryTopicCard extends StatelessWidget {
  final String title;
  final String keyIdea;
  final String content;
  final List<String>? equations;

  const _TheoryTopicCard({
    required this.title,
    required this.keyIdea,
    required this.content,
    this.equations,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AppCard(
      padding: const EdgeInsets.all(AppConstants.spaceLg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: AppConstants.spaceXs),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              'Key Idea: $keyIdea',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: theme.colorScheme.primary,
              ),
            ),
          ),
          const SizedBox(height: AppConstants.spaceMd),
          Text(
            content,
            style: theme.textTheme.bodyMedium?.copyWith(
              height: 1.6,
            ),
          ),
          if (equations != null && equations!.isNotEmpty) ...[
            const SizedBox(height: AppConstants.spaceMd),
            Container(
              padding: const EdgeInsets.all(AppConstants.spaceMd),
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerHigh,
                borderRadius: BorderRadius.circular(AppConstants.radiusSm),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Key Mathematical Equations:',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                  ),
                  const SizedBox(height: 4),
                  ...equations!.map(
                    (eq) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 2),
                      child: Text(
                        '•  $eq',
                        style: const TextStyle(
                          fontFamily: 'monospace',
                          fontWeight: FontWeight.w600,
                          fontSize: 12.5,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

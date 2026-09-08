/// Formula definitions, explanations, and LaTeX representations for the Zener diode voltage regulation circuit.
class ZenerFormulaInfo {
  final String title;
  final String formula;
  final String description;
  final String latex;

  const ZenerFormulaInfo({
    required this.title,
    required this.formula,
    required this.description,
    required this.latex,
  });
}

class ZenerFormulas {
  ZenerFormulas._();

  static const ZenerFormulaInfo unregulatedDivider = ZenerFormulaInfo(
    title: 'Unregulated Output Voltage',
    formula: 'Vout_unregulated = Vin × RL / (Rs + RL)',
    description: 'Output voltage across the load when the Zener diode is off (before reverse breakdown).',
    latex: r'V_{out} = V_{in} \cdot \frac{R_L}{R_s + R_L}',
  );

  static const ZenerFormulaInfo breakdownCondition = ZenerFormulaInfo(
    title: 'Breakdown Condition',
    formula: 'Vin × RL / (Rs + RL) >= Vz',
    description: 'Condition required for the Zener diode to enter the reverse breakdown region.',
    latex: r'V_{in} \cdot \frac{R_L}{R_s + R_L} \ge V_z',
  );

  static const ZenerFormulaInfo regulatedOutput = ZenerFormulaInfo(
    title: 'Regulated Output Voltage',
    formula: 'Vout ≈ Vz',
    description: 'Output voltage clamped across the parallel load when the diode is in reverse breakdown.',
    latex: r'V_{out} \approx V_z',
  );

  static const ZenerFormulaInfo seriesCurrent = ZenerFormulaInfo(
    title: 'Series Resistor Current',
    formula: 'Is = (Vin - Vout) / Rs',
    description: 'Total current drawn from the input source through the current-limiting series resistor.',
    latex: r'I_s = \frac{V_{in} - V_{out}}{R_s}',
  );

  static const ZenerFormulaInfo loadCurrent = ZenerFormulaInfo(
    title: 'Load Current',
    formula: 'IL = Vout / RL',
    description: 'Current consumed by the parallel connected load resistor.',
    latex: r'I_L = \frac{V_{out}}{R_L}',
  );

  static const ZenerFormulaInfo zenerCurrent = ZenerFormulaInfo(
    title: 'Zener Diode Current',
    formula: 'Iz = Is - IL',
    description: 'Current shunted through the Zener diode by Kirchhoff’s Current Law (KCL).',
    latex: r'I_z = I_s - I_L',
  );

  static const ZenerFormulaInfo zenerPower = ZenerFormulaInfo(
    title: 'Zener Power Dissipation',
    formula: 'Pz = Vz × Iz',
    description: 'Power dissipated by the Zener diode in reverse breakdown.',
    latex: r'P_z = V_z \cdot I_z',
  );

  static const ZenerFormulaInfo seriesResistorPower = ZenerFormulaInfo(
    title: 'Series Resistor Power',
    formula: 'Prs = Is² × Rs = (Vin - Vout) × Is',
    description: 'Power dissipated as heat in the current-limiting series resistor.',
    latex: r'P_{Rs} = I_s^2 \cdot R_s',
  );

  static const ZenerFormulaInfo loadPower = ZenerFormulaInfo(
    title: 'Load Power Dissipation',
    formula: 'Pl = Vout² / RL = Vout × IL',
    description: 'Useful electrical power delivered to the output load.',
    latex: r'P_L = \frac{V_{out}^2}{R_L}',
  );

  static const ZenerFormulaInfo minimumLoadResistance = ZenerFormulaInfo(
    title: 'Minimum Load Resistance (RL_min)',
    formula: 'RL_min = (Vz × Rs) / (Vin - Vz - IzMin × Rs)',
    description: 'Minimum load resistance below which load current steals too much current, dropping Iz below IzMin.',
    latex: r'R_{L(min)} = \frac{V_z \cdot R_s}{V_{in} - V_z - I_{z(min)} \cdot R_s}',
  );

  static const ZenerFormulaInfo lineRegulation = ZenerFormulaInfo(
    title: 'Line Regulation',
    formula: 'Line Reg = ΔVout / ΔVin (V/V or mV/V)',
    description: 'Sensitivity of output voltage to changes in input voltage within the regulating breakdown zone.',
    latex: r'\text{Line Reg} = \frac{\Delta V_{out}}{\Delta V_{in}}',
  );

  static const ZenerFormulaInfo loadRegulation = ZenerFormulaInfo(
    title: 'Load Regulation (%)',
    formula: 'Load Reg (%) = [(V_NL - V_FL) / V_FL] × 100%',
    description: 'Percentage change in output voltage from open-circuit no-load (NL) to rated full-load (FL).',
    latex: r'\text{Load Reg (\%)} = \frac{V_{NL} - V_{FL}}{V_{FL}} \times 100\%',
  );

  /// All educational formula models as an ordered list for UI inspection.
  static const List<ZenerFormulaInfo> all = [
    unregulatedDivider,
    breakdownCondition,
    regulatedOutput,
    seriesCurrent,
    loadCurrent,
    zenerCurrent,
    zenerPower,
    seriesResistorPower,
    loadPower,
    minimumLoadResistance,
    lineRegulation,
    loadRegulation,
  ];
}

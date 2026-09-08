import 'package:flutter/material.dart';
import '../../simulation/simulation.dart';

/// Central state provider for real-time circuit simulation across ZenerLab
class SimulatorController extends ChangeNotifier {
  SimulatorController._();
  static final SimulatorController instance = SimulatorController._();

  final ZenerSimulator _simulator = const ZenerSimulator();
  final ParameterSweepService _sweepService = const ParameterSweepService();

  ZenerParameters _parameters = const ZenerParameters(
    vin: ZenerParameters.defaultVin,
    vz: ZenerParameters.defaultVz,
    rs: ZenerParameters.defaultRs,
    rl: ZenerParameters.defaultRl,
    izMin: ZenerParameters.defaultIzMin,
    izMax: ZenerParameters.defaultIzMax,
    pzMax: ZenerParameters.defaultPzMax,
  );

  bool _showCurrentFlow = true;

  ZenerParameters get parameters => _parameters;
  bool get showCurrentFlow => _showCurrentFlow;

  ZenerSimulationResult get currentResult => _simulator.simulate(_parameters);
  ZenerSimulator get simulator => _simulator;
  ParameterSweepService get sweepService => _sweepService;

  void toggleCurrentFlow() {
    _showCurrentFlow = !_showCurrentFlow;
    notifyListeners();
  }

  void updateParameters(ZenerParameters newParams) {
    _parameters = newParams;
    notifyListeners();
  }

  void updateVin(double vin) {
    _parameters = _parameters.copyWith(vin: vin);
    notifyListeners();
  }

  void updateVz(double vz) {
    _parameters = _parameters.copyWith(vz: vz);
    notifyListeners();
  }

  void updateRs(double rs) {
    _parameters = _parameters.copyWith(rs: rs);
    notifyListeners();
  }

  void updateRl(double rl) {
    _parameters = _parameters.copyWith(rl: rl);
    notifyListeners();
  }

  void updateIzMin(double izMin) {
    _parameters = _parameters.copyWith(izMin: izMin);
    notifyListeners();
  }

  void updateIzMax(double izMax) {
    _parameters = _parameters.copyWith(izMax: izMax);
    notifyListeners();
  }

  void updatePzMax(double pzMax) {
    _parameters = _parameters.copyWith(pzMax: pzMax);
    notifyListeners();
  }

  void resetToDefaults() {
    _parameters = const ZenerParameters(
      vin: ZenerParameters.defaultVin,
      vz: ZenerParameters.defaultVz,
      rs: ZenerParameters.defaultRs,
      rl: ZenerParameters.defaultRl,
      izMin: ZenerParameters.defaultIzMin,
      izMax: ZenerParameters.defaultIzMax,
      pzMax: ZenerParameters.defaultPzMax,
    );
    notifyListeners();
  }

  void applyPreset(CircuitPreset preset) {
    _parameters = preset.parameters;
    notifyListeners();
  }
}

/// Educational Circuit Presets demonstrating distinct physical operating regimes
class CircuitPreset {
  final String title;
  final String subtitle;
  final String explanation;
  final ZenerParameters parameters;
  final IconData icon;

  const CircuitPreset({
    required this.title,
    required this.subtitle,
    required this.explanation,
    required this.parameters,
    required this.icon,
  });

  static const List<CircuitPreset> all = [
    CircuitPreset(
      title: 'Standard 5.1V Regulator',
      subtitle: 'Normal safe regulation',
      explanation: 'Typical bench setup with Vin=12V, Vz=5.1V, Rs=330Ω, RL=1kΩ. Diode safely maintains ~5.1V across load with Iz ~15.8mA.',
      parameters: ZenerParameters(
        vin: 12.0,
        vz: 5.1,
        rs: 330.0,
        rl: 1000.0,
      ),
      icon: Icons.check_circle_outline_rounded,
    ),
    CircuitPreset(
      title: 'Below Breakdown (Unregulated)',
      subtitle: 'Input voltage insufficient',
      explanation: 'With Vin=4.5V (< Vz), the resistive divider produces ~3.38V. The Zener is completely OFF (Iz=0mA) and regulation does not occur.',
      parameters: ZenerParameters(
        vin: 4.5,
        vz: 5.1,
        rs: 330.0,
        rl: 1000.0,
      ),
      icon: Icons.power_off_rounded,
    ),
    CircuitPreset(
      title: 'Low Voltage 3.3V Logic Supply',
      subtitle: 'Microcontroller power rail',
      explanation: 'Generates a stable 3.3V rail from a 9V battery with Rs=220Ω and RL=470Ω.',
      parameters: ZenerParameters(
        vin: 9.0,
        vz: 3.3,
        rs: 220.0,
        rl: 470.0,
      ),
      icon: Icons.memory_rounded,
    ),
    CircuitPreset(
      title: 'Heavy Load (Near Knee Current)',
      subtitle: 'Load draws almost all series current',
      explanation: 'RL is dropped to 260Ω. Load draws ~19.6mA, starving the Zener diode down to Iz ~1.3mA (< IzMin 5mA), making regulation weak.',
      parameters: ZenerParameters(
        vin: 12.0,
        vz: 5.1,
        rs: 330.0,
        rl: 260.0,
      ),
      icon: Icons.warning_amber_rounded,
    ),
    CircuitPreset(
      title: 'Light Load / No-Load Regulation',
      subtitle: 'High load resistance (RL=10kΩ)',
      explanation: 'Load current drops to ~0.5mA. Almost all series current passes through the Zener (Iz ~20.4mA) while maintaining stable 5.1V.',
      parameters: ZenerParameters(
        vin: 12.0,
        vz: 5.1,
        rs: 330.0,
        rl: 10000.0,
      ),
      icon: Icons.lightbulb_outline_rounded,
    ),
    CircuitPreset(
      title: 'High Input / Near Limit',
      subtitle: 'High input DC voltage (Vin=24V)',
      explanation: 'Input surge raises series current to ~57.3mA. Zener shunts ~52.2mA at ~266mW, demonstrating high power absorption.',
      parameters: ZenerParameters(
        vin: 24.0,
        vz: 5.1,
        rs: 330.0,
        rl: 1000.0,
      ),
      icon: Icons.bolt_rounded,
    ),
    CircuitPreset(
      title: 'Over-Power / Thermal Risk',
      subtitle: 'Exceeds diode maximum wattage (Pz > 500mW)',
      explanation: 'Extreme input voltage (Vin=38V) drives Iz > 94mA and Pz > 500mW, warning student of catastrophic thermal breakdown.',
      parameters: ZenerParameters(
        vin: 38.0,
        vz: 5.1,
        rs: 330.0,
        rl: 1000.0,
        pzMax: 0.400,
      ),
      icon: Icons.error_outline_rounded,
    ),
  ];
}

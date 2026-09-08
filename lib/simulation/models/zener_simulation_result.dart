import 'zener_parameters.dart';
import 'zener_state.dart';

/// Immutable output record representing the full electrical state of a Zener regulation circuit.
/// All physical quantities are in SI units (Volts, Amperes, Watts, Ohms).
class ZenerSimulationResult {
  /// Input parameters that produced this result.
  final ZenerParameters parameters;

  /// Effective voltage across the load RL (Volts).
  final double vout;

  /// Total current flowing through the series resistor Rs (Amperes).
  final double seriesCurrent;

  /// Current drawn by the load RL (Amperes).
  final double loadCurrent;

  /// Reverse breakdown current passing through the Zener diode (Amperes).
  final double zenerCurrent;

  /// Power dissipated in the Zener diode (Watts).
  final double zenerPower;

  /// Power dissipated in the series current-limiting resistor Rs (Watts).
  final double seriesResistorPower;

  /// Power delivered to the load resistor RL (Watts).
  final double loadPower;

  /// Operational state of the Zener regulation circuit.
  final ZenerState zenerState;

  /// Detailed human-readable explanation, warning, or error message.
  final String message;

  const ZenerSimulationResult({
    required this.parameters,
    required this.vout,
    required this.seriesCurrent,
    required this.loadCurrent,
    required this.zenerCurrent,
    required this.zenerPower,
    required this.seriesResistorPower,
    required this.loadPower,
    required this.zenerState,
    required this.message,
  });

  /// Factory constructor for invalid circuit parameters.
  factory ZenerSimulationResult.invalid({
    required ZenerParameters parameters,
    required String errorMessage,
  }) {
    return ZenerSimulationResult(
      parameters: parameters,
      vout: 0.0,
      seriesCurrent: 0.0,
      loadCurrent: 0.0,
      zenerCurrent: 0.0,
      zenerPower: 0.0,
      seriesResistorPower: 0.0,
      loadPower: 0.0,
      zenerState: ZenerState.invalidParameters,
      message: errorMessage,
    );
  }

  // Convenient parameter accessors
  double get vin => parameters.vin;
  double get vz => parameters.vz;
  double get rs => parameters.rs;
  double get rl => parameters.rl;

  // Convenience boolean helpers
  bool get isRegulating => zenerState == ZenerState.regulating;
  bool get isBelowBreakdown => zenerState == ZenerState.belowBreakdown;
  bool get isOverCurrent => zenerState == ZenerState.overCurrent;
  bool get isOverPower => zenerState == ZenerState.overPower;
  bool get isLowZenerCurrent => zenerState == ZenerState.lowZenerCurrent;
  bool get isInvalid => zenerState == ZenerState.invalidParameters;

  // Convenient unit conversions for display
  double get seriesCurrentMilliAmps => seriesCurrent * 1000.0;
  double get loadCurrentMilliAmps => loadCurrent * 1000.0;
  double get zenerCurrentMilliAmps => zenerCurrent * 1000.0;
  double get zenerPowerMilliWatts => zenerPower * 1000.0;
  double get seriesResistorPowerMilliWatts => seriesResistorPower * 1000.0;
  double get loadPowerMilliWatts => loadPower * 1000.0;

  /// Total power drawn from the DC supply (Watts).
  double get totalSourcePower => vin * seriesCurrent;

  /// Electrical efficiency of the regulation circuit (Load Power / Total Input Power).
  double get efficiencyPercentage {
    if (totalSourcePower <= 0) return 0.0;
    return (loadPower / totalSourcePower) * 100.0;
  }

  @override
  String toString() =>
      'ZenerSimulationResult(Vout: ${vout.toStringAsFixed(3)}V, Is: ${seriesCurrentMilliAmps.toStringAsFixed(2)}mA, IL: ${loadCurrentMilliAmps.toStringAsFixed(2)}mA, Iz: ${zenerCurrentMilliAmps.toStringAsFixed(2)}mA, Pz: ${zenerPowerMilliWatts.toStringAsFixed(1)}mW, State: ${zenerState.name})';
}

import '../models/zener_parameters.dart';
import '../models/zener_simulation_result.dart';
import '../models/zener_state.dart';

/// Core physics and electrical simulation engine for Zener diode voltage regulation.
class ZenerSimulator {
  const ZenerSimulator();

  /// Simulates a Zener diode voltage regulator given a set of circuit parameters.
  /// Pure function with zero side effects.
  ZenerSimulationResult simulate(ZenerParameters params) {
    // 1. Parameter Validation
    final validationError = params.validate();
    if (validationError != null) {
      return ZenerSimulationResult.invalid(
        parameters: params,
        errorMessage: validationError,
      );
    }

    final double vin = params.vin;
    final double vz = params.vz;
    final double rs = params.rs;
    final double rl = params.rl;
    final double izMin = params.izMin;
    final double izMax = params.izMax;
    final double pzMax = params.pzMax;

    // 2. Compute unregulated voltage divider output (when Zener is non-conducting)
    // Vout_unregulated = Vin * RL / (Rs + RL)
    final double voutUnregulated = (vin * rl) / (rs + rl);

    // 3. Check if circuit has reached reverse breakdown: Vout_unregulated >= Vz
    if (voutUnregulated < vz) {
      // Condition A: Below Breakdown Region
      // Diode is OFF, acting as an open circuit (Iz = 0).
      final double vout = voutUnregulated;
      const double iz = 0.0;
      final double is_ = vin / (rs + rl);
      final double il = vout / rl; // Equivalently is_
      const double pz = 0.0;
      final double prs = is_ * is_ * rs;
      final double pl = (vout * vout) / rl;

      return ZenerSimulationResult(
        parameters: params,
        vout: vout,
        seriesCurrent: is_,
        loadCurrent: il,
        zenerCurrent: iz,
        zenerPower: pz,
        seriesResistorPower: prs,
        loadPower: pl,
        zenerState: ZenerState.belowBreakdown,
        message:
            'Input voltage is insufficient to reach Zener breakdown (${vout.toStringAsFixed(2)}V < ${vz.toStringAsFixed(2)}V). Circuit operates as an unregulated resistive voltage divider.',
      );
    }

    // Condition B: Breakdown Region (Zener is conducting)
    // Output voltage is clamped at the Zener breakdown potential: Vout ≈ Vz
    final double vout = vz;
    final double is_ = (vin - vz) / rs;
    final double il = vz / rl;
    final double iz = is_ - il;
    final double pz = vz * iz;
    final double prs = is_ * is_ * rs;
    final double pl = (vout * vout) / rl;

    // Determine specific operating state & safety boundaries
    if (pz > pzMax) {
      return ZenerSimulationResult(
        parameters: params,
        vout: vout,
        seriesCurrent: is_,
        loadCurrent: il,
        zenerCurrent: iz,
        zenerPower: pz,
        seriesResistorPower: prs,
        loadPower: pl,
        zenerState: ZenerState.overPower,
        message:
            'Zener power dissipation (${(pz * 1000).toStringAsFixed(1)}mW) exceeds maximum rated power (${(pzMax * 1000).toStringAsFixed(1)}mW). Diode is at risk of thermal destruction.',
      );
    }

    if (iz > izMax) {
      return ZenerSimulationResult(
        parameters: params,
        vout: vout,
        seriesCurrent: is_,
        loadCurrent: il,
        zenerCurrent: iz,
        zenerPower: pz,
        seriesResistorPower: prs,
        loadPower: pl,
        zenerState: ZenerState.overCurrent,
        message:
            'Zener current (${(iz * 1000).toStringAsFixed(2)}mA) exceeds maximum safe continuous current (${(izMax * 1000).toStringAsFixed(2)}mA).',
      );
    }

    if (iz < izMin) {
      return ZenerSimulationResult(
        parameters: params,
        vout: vout,
        seriesCurrent: is_,
        loadCurrent: il,
        zenerCurrent: iz,
        zenerPower: pz,
        seriesResistorPower: prs,
        loadPower: pl,
        zenerState: ZenerState.lowZenerCurrent,
        message:
            'Zener current (${(iz * 1000).toStringAsFixed(2)}mA) is below recommended knee current (${(izMin * 1000).toStringAsFixed(2)}mA). Regulation may be unstable.',
      );
    }

    // Normal, stable regulation
    return ZenerSimulationResult(
      parameters: params,
      vout: vout,
      seriesCurrent: is_,
      loadCurrent: il,
      zenerCurrent: iz,
      zenerPower: pz,
      seriesResistorPower: prs,
      loadPower: pl,
      zenerState: ZenerState.regulating,
      message:
          'Zener diode is actively and safely regulating the load voltage at ${vout.toStringAsFixed(2)}V (Iz = ${(iz * 1000).toStringAsFixed(2)}mA).',
    );
  }
}

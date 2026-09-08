import 'package:flutter_test/flutter_test.dart';
import 'package:zener_lab/simulation/simulation.dart';

void main() {
  const simulator = ZenerSimulator();

  group('Zener Diode Simulation Engine Tests', () {
    // 1. Normal regulation test case
    test('1. Normal Regulation with standard parameters (Vin=12V, Vz=5.1V, Rs=330Ω, RL=1kΩ)', () {
      const params = ZenerParameters(
        vin: 12.0,
        vz: 5.1,
        rs: 330.0,
        rl: 1000.0,
        izMin: 0.005, // 5 mA
        izMax: 0.050, // 50 mA
        pzMax: 0.500, // 500 mW
      );

      final result = simulator.simulate(params);

      // Verify Operating State
      expect(result.zenerState, equals(ZenerState.regulating));
      expect(result.isRegulating, isTrue);

      // Verify Vout = Vz = 5.1 V
      expect(result.vout, closeTo(5.1, 0.0001));

      // Series current: Is = (12 - 5.1) / 330 = 6.9 / 330 = 0.020909 A (20.91 mA)
      expect(result.seriesCurrent, closeTo(6.9 / 330.0, 0.0001));
      expect(result.seriesCurrentMilliAmps, closeTo(20.909, 0.01));

      // Load current: IL = 5.1 / 1000 = 0.0051 A (5.1 mA)
      expect(result.loadCurrent, closeTo(0.0051, 0.0001));
      expect(result.loadCurrentMilliAmps, closeTo(5.1, 0.01));

      // Zener current: Iz = Is - IL = 0.020909 - 0.0051 = 0.015809 A (15.81 mA)
      const expectedIz = (6.9 / 330.0) - 0.0051;
      expect(result.zenerCurrent, closeTo(expectedIz, 0.0001));
      expect(result.zenerCurrentMilliAmps, closeTo(15.809, 0.01));

      // Zener power: Pz = 5.1 * 0.015809 = 0.080626 W (80.63 mW)
      expect(result.zenerPower, closeTo(5.1 * expectedIz, 0.0001));
      expect(result.zenerPowerMilliWatts, closeTo(80.63, 0.05));

      // Series resistor power: Prs = Is^2 * Rs = (0.020909)^2 * 330 = 0.14421 W (144.21 mW)
      expect(result.seriesResistorPower, closeTo(result.seriesCurrent * result.seriesCurrent * 330.0, 0.0001));

      // Load power: Pl = Vout^2 / RL = 5.1^2 / 1000 = 0.02601 W (26.01 mW)
      expect(result.loadPower, closeTo(0.02601, 0.0001));
    });

    // 2. Below-breakdown condition test
    test('2. Below-Breakdown condition (Vin=5.0V, Vz=5.1V, Rs=330Ω, RL=1kΩ)', () {
      const params = ZenerParameters(
        vin: 5.0,
        vz: 5.1,
        rs: 330.0,
        rl: 1000.0,
      );

      // Unregulated Vout divider = 5.0 * 1000 / (330 + 1000) = 5000 / 1330 = 3.7594 V (< 5.1 V)
      final result = simulator.simulate(params);

      expect(result.zenerState, equals(ZenerState.belowBreakdown));
      expect(result.isRegulating, isFalse);
      expect(result.vout, closeTo(5000.0 / 1330.0, 0.0001));
      expect(result.vout < params.vz, isTrue);
      expect(result.zenerCurrent, equals(0.0));
      expect(result.zenerPower, equals(0.0));

      // Series current equals total divider current = 5.0 / (330 + 1000)
      expect(result.seriesCurrent, closeTo(5.0 / 1330.0, 0.0001));
      expect(result.loadCurrent, closeTo(result.seriesCurrent, 0.0001));
    });

    // 3. Increasing Vin test (Verifying Vout clamp & increasing Iz)
    test('3. Increasing Vin maintains Vout clamp and increases Zener current', () {
      const baseParams = ZenerParameters(
        vin: 10.0,
        vz: 5.1,
        rs: 330.0,
        rl: 1000.0,
      );

      final res10V = simulator.simulate(baseParams.copyWith(vin: 10.0));
      final res15V = simulator.simulate(baseParams.copyWith(vin: 15.0));
      final res20V = simulator.simulate(baseParams.copyWith(vin: 20.0));

      // Vout remains clamped at Vz for all regulating levels
      expect(res10V.vout, closeTo(5.1, 0.0001));
      expect(res15V.vout, closeTo(5.1, 0.0001));
      expect(res20V.vout, closeTo(5.1, 0.0001));

      // Load current remains constant (IL = 5.1V / 1000Ω = 5.1 mA)
      expect(res10V.loadCurrent, closeTo(0.0051, 0.0001));
      expect(res15V.loadCurrent, closeTo(0.0051, 0.0001));
      expect(res20V.loadCurrent, closeTo(0.0051, 0.0001));

      // Zener current strictly increases as Vin increases
      expect(res15V.zenerCurrent > res10V.zenerCurrent, isTrue);
      expect(res20V.zenerCurrent > res15V.zenerCurrent, isTrue);
    });

    // 4. Increasing load resistance (RL) test
    test('4. Increasing load resistance decreases load current and increases Zener current', () {
      const baseParams = ZenerParameters(
        vin: 12.0,
        vz: 5.1,
        rs: 330.0,
        rl: 500.0,
      );

      final res500 = simulator.simulate(baseParams.copyWith(rl: 500.0));
      final res1000 = simulator.simulate(baseParams.copyWith(rl: 1000.0));
      final res2000 = simulator.simulate(baseParams.copyWith(rl: 2000.0));

      // IL decreases as RL increases
      expect(res1000.loadCurrent < res500.loadCurrent, isTrue);
      expect(res2000.loadCurrent < res1000.loadCurrent, isTrue);

      // Iz increases as RL increases (since Is is constant for fixed Vin and Rs)
      expect(res1000.zenerCurrent > res500.zenerCurrent, isTrue);
      expect(res2000.zenerCurrent > res1000.zenerCurrent, isTrue);
    });

    // 5. Heavy load (low Zener current) test
    test('5. Heavy Load condition detects low Zener current (below knee current IzMin)', () {
      // Is = (12 - 5.1) / 330 = 20.91 mA
      // If RL = 260 Ω, IL = 5.1 / 260 = 19.61 mA
      // Iz = 20.91 - 19.61 = 1.30 mA (< 5 mA IzMin)
      const params = ZenerParameters(
        vin: 12.0,
        vz: 5.1,
        rs: 330.0,
        rl: 260.0,
        izMin: 0.005, // 5 mA
      );

      final result = simulator.simulate(params);

      expect(result.zenerState, equals(ZenerState.lowZenerCurrent));
      expect(result.isLowZenerCurrent, isTrue);
      expect(result.isRegulating, isFalse);
      expect(result.zenerCurrent < params.izMin, isTrue);
      expect(result.zenerCurrent > 0, isTrue);
    });

    // 6. Over-current test
    test('6. Over-Current condition when Iz exceeds IzMax', () {
      // With Vin = 30V, Is = (30 - 5.1) / 330 = 75.45 mA
      // IL = 5.1 / 1000 = 5.1 mA -> Iz = 70.35 mA (> 50 mA IzMax)
      // Set pzMax large so overCurrent is tested independently
      const params = ZenerParameters(
        vin: 30.0,
        vz: 5.1,
        rs: 330.0,
        rl: 1000.0,
        izMax: 0.050, // 50 mA
        pzMax: 2.0, // 2 W (high enough to not trigger overPower first)
      );

      final result = simulator.simulate(params);

      expect(result.zenerState, equals(ZenerState.overCurrent));
      expect(result.isOverCurrent, isTrue);
      expect(result.zenerCurrent > params.izMax, isTrue);
    });

    // 7. Over-power test
    test('7. Over-Power condition when Pz exceeds PzMax', () {
      // With Vin = 30V, Iz = 70.35 mA, Pz = 5.1 * 0.07035 = 358.8 mW
      // Set PzMax to 200 mW
      const params = ZenerParameters(
        vin: 30.0,
        vz: 5.1,
        rs: 330.0,
        rl: 1000.0,
        pzMax: 0.200, // 200 mW
      );

      final result = simulator.simulate(params);

      expect(result.zenerState, equals(ZenerState.overPower));
      expect(result.isOverPower, isTrue);
      expect(result.zenerPower > params.pzMax, isTrue);
    });

    // 8. Invalid resistance test cases
    test('8. Invalid resistance parameter validation (zero or negative resistance)', () {
      const zeroRs = ZenerParameters(vin: 12.0, vz: 5.1, rs: 0.0, rl: 1000.0);
      const negativeRs = ZenerParameters(vin: 12.0, vz: 5.1, rs: -10.0, rl: 1000.0);
      const zeroRl = ZenerParameters(vin: 12.0, vz: 5.1, rs: 330.0, rl: 0.0);
      const negativeRl = ZenerParameters(vin: 12.0, vz: 5.1, rs: 330.0, rl: -100.0);

      expect(simulator.simulate(zeroRs).zenerState, equals(ZenerState.invalidParameters));
      expect(simulator.simulate(negativeRs).zenerState, equals(ZenerState.invalidParameters));
      expect(simulator.simulate(zeroRl).zenerState, equals(ZenerState.invalidParameters));
      expect(simulator.simulate(negativeRl).zenerState, equals(ZenerState.invalidParameters));
    });

    // 9. Invalid voltage test cases
    test('9. Invalid voltage parameter validation (negative Vin, non-positive Vz, NaN, Infinity)', () {
      const negativeVin = ZenerParameters(vin: -5.0, vz: 5.1, rs: 330.0, rl: 1000.0);
      const zeroVz = ZenerParameters(vin: 12.0, vz: 0.0, rs: 330.0, rl: 1000.0);
      const nanVin = ZenerParameters(vin: double.nan, vz: 5.1, rs: 330.0, rl: 1000.0);
      const infRs = ZenerParameters(vin: 12.0, vz: 5.1, rs: double.infinity, rl: 1000.0);

      expect(simulator.simulate(negativeVin).zenerState, equals(ZenerState.invalidParameters));
      expect(simulator.simulate(zeroVz).zenerState, equals(ZenerState.invalidParameters));
      expect(simulator.simulate(nanVin).zenerState, equals(ZenerState.invalidParameters));
      expect(simulator.simulate(infRs).zenerState, equals(ZenerState.invalidParameters));
    });

    // 10. Sweep simulation tests
    test('10. ParameterSweepService sweeps Vin, RL, and Rs without duplicating logic', () {
      const sweepService = ParameterSweepService(simulator: simulator);
      const baseline = ZenerParameters(
        vin: 12.0,
        vz: 5.1,
        rs: 330.0,
        rl: 1000.0,
      );

      // Vin Sweep (0V to 20V in 21 steps)
      final vinResults = sweepService.sweepVin(
        baseline: baseline,
        startVin: 0.0,
        stopVin: 20.0,
        steps: 21,
      );

      expect(vinResults.length, equals(21));
      expect(vinResults.first.vin, equals(0.0));
      expect(vinResults.last.vin, equals(20.0));

      // Initial point (Vin=0) must be below breakdown
      expect(vinResults.first.zenerState, equals(ZenerState.belowBreakdown));

      // Final point (Vin=20) must be in breakdown/regulating
      expect(vinResults.last.vout, closeTo(5.1, 0.0001));

      // RL Sweep
      final rlResults = sweepService.sweepRl(
        baseline: baseline,
        startRl: 100.0,
        stopRl: 2000.0,
        steps: 10,
      );
      expect(rlResults.length, equals(10));
      expect(rlResults.first.rl, equals(100.0));
      expect(rlResults.last.rl, equals(2000.0));

      // Rs Sweep
      final rsResults = sweepService.sweepRs(
        baseline: baseline,
        startRs: 100.0,
        stopRs: 1000.0,
        steps: 10,
      );
      expect(rsResults.length, equals(10));
    });

    // 11. Formula layer inspection test
    test('11. ZenerFormulas repository provides complete formula metadata', () {
      expect(ZenerFormulas.all.isNotEmpty, isTrue);
      expect(ZenerFormulas.seriesCurrent.formula, contains('Is = (Vin - Vout) / Rs'));
      expect(ZenerFormulas.loadCurrent.formula, contains('IL = Vout / RL'));
      expect(ZenerFormulas.zenerCurrent.formula, contains('Iz = Is - IL'));
      expect(ZenerFormulas.zenerPower.formula, contains('Pz = Vz × Iz'));
    });

    // 12. Programmatic validation of all CircuitPresets
    test('12. CircuitPresets produce their intended electrical operating states', () {
      const presets = CircuitPreset.all;
      expect(presets.length, equals(7));

      // Preset 1: Standard 5.1V Regulator -> Regulating
      final p1 = simulator.simulate(presets[0].parameters);
      expect(p1.zenerState, equals(ZenerState.regulating));
      expect(p1.vout, closeTo(5.1, 0.001));

      // Preset 2: Below Breakdown -> Below Breakdown
      final p2 = simulator.simulate(presets[1].parameters);
      expect(p2.zenerState, equals(ZenerState.belowBreakdown));
      expect(p2.zenerCurrent, equals(0.0));

      // Preset 3: Low Voltage 3.3V Logic Supply -> Regulating
      final p3 = simulator.simulate(presets[2].parameters);
      expect(p3.zenerState, equals(ZenerState.regulating));
      expect(p3.vout, closeTo(3.3, 0.001));

      // Preset 4: Heavy Load -> Low Zener Current
      final p4 = simulator.simulate(presets[3].parameters);
      expect(p4.zenerState, equals(ZenerState.lowZenerCurrent));
      expect(p4.zenerCurrent < presets[3].parameters.izMin, isTrue);

      // Preset 5: Light Load -> Regulating with high Iz
      final p5 = simulator.simulate(presets[4].parameters);
      expect(p5.zenerState, equals(ZenerState.regulating));
      expect(p5.zenerCurrent > 0.020, isTrue);

      // Preset 6: High Input -> Regulating with high dissipation
      final p6 = simulator.simulate(presets[5].parameters);
      expect(p6.zenerCurrent > 0.050, isTrue);

      // Preset 7: Over Power Demonstration -> Over Power
      final p7 = simulator.simulate(presets[6].parameters);
      expect(p7.zenerState, equals(ZenerState.overPower));
      expect(p7.zenerPower > presets[6].parameters.pzMax, isTrue);
    });
  });
}

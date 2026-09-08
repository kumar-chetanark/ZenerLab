import '../models/zener_parameters.dart';
import '../models/zener_simulation_result.dart';
import 'zener_simulator.dart';

/// Supported physical parameters for sweep simulations.
enum SweepParameter {
  vin,
  rl,
  rs,
}

/// Generic sweep configuration.
class SweepConfiguration {
  final SweepParameter parameter;
  final double start;
  final double stop;
  final int steps;

  const SweepConfiguration({
    required this.parameter,
    required this.start,
    required this.stop,
    this.steps = 50,
  }) : assert(steps > 0, 'Sweep steps must be greater than 0');

  /// Generate discrete parameter values from start to stop inclusive.
  List<double> generateValues() {
    if (steps == 1 || start == stop) {
      return [start];
    }
    final double stepSize = (stop - start) / (steps - 1);
    return List.generate(steps, (index) => start + (index * stepSize));
  }
}

/// Service to perform multi-point parameter sweeps for Line Regulation, Load Regulation, and I-V curves.
class ParameterSweepService {
  final ZenerSimulator simulator;

  const ParameterSweepService({
    this.simulator = const ZenerSimulator(),
  });

  /// Executes a parameter sweep across the configured range against baseline parameters.
  List<ZenerSimulationResult> sweep({
    required ZenerParameters baseline,
    required SweepConfiguration configuration,
  }) {
    final values = configuration.generateValues();
    final List<ZenerSimulationResult> results = [];

    for (final value in values) {
      ZenerParameters currentParams;
      switch (configuration.parameter) {
        case SweepParameter.vin:
          currentParams = baseline.copyWith(vin: value);
          break;
        case SweepParameter.rl:
          currentParams = baseline.copyWith(rl: value);
          break;
        case SweepParameter.rs:
          currentParams = baseline.copyWith(rs: value);
          break;
      }
      results.add(simulator.simulate(currentParams));
    }

    return results;
  }

  /// Convenience method for sweeping input voltage Vin (e.g. for Line Regulation).
  List<ZenerSimulationResult> sweepVin({
    required ZenerParameters baseline,
    double startVin = 0.0,
    double stopVin = 20.0,
    int steps = 50,
  }) {
    return sweep(
      baseline: baseline,
      configuration: SweepConfiguration(
        parameter: SweepParameter.vin,
        start: startVin,
        stop: stopVin,
        steps: steps,
      ),
    );
  }

  /// Convenience method for sweeping load resistance RL (e.g. for Load Regulation).
  List<ZenerSimulationResult> sweepRl({
    required ZenerParameters baseline,
    double startRl = 100.0,
    double stopRl = 5000.0,
    int steps = 50,
  }) {
    return sweep(
      baseline: baseline,
      configuration: SweepConfiguration(
        parameter: SweepParameter.rl,
        start: startRl,
        stop: stopRl,
        steps: steps,
      ),
    );
  }

  /// Convenience method for sweeping series resistance Rs.
  List<ZenerSimulationResult> sweepRs({
    required ZenerParameters baseline,
    double startRs = 50.0,
    double stopRs = 1000.0,
    int steps = 50,
  }) {
    return sweep(
      baseline: baseline,
      configuration: SweepConfiguration(
        parameter: SweepParameter.rs,
        start: startRs,
        stop: stopRs,
        steps: steps,
      ),
    );
  }
}

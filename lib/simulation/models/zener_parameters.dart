/// Input parameters for a Zener diode voltage regulator circuit.
/// All physical quantities are represented in SI units (Volts, Ohms, Amperes, Watts).
class ZenerParameters {
  /// Unregulated DC input supply voltage (Volts).
  final double vin;

  /// Nominal Zener breakdown voltage (Volts).
  final double vz;

  /// Series current-limiting resistance (Ohms).
  final double rs;

  /// Load resistance across which output is regulated (Ohms).
  final double rl;

  /// Minimum recommended Zener reverse current required for stable regulation (Amperes).
  final double izMin;

  /// Maximum continuous safe Zener current (Amperes).
  final double izMax;

  /// Maximum allowable power dissipation of the Zener diode (Watts).
  final double pzMax;

  const ZenerParameters({
    required this.vin,
    required this.vz,
    required this.rs,
    required this.rl,
    this.izMin = defaultIzMin,
    this.izMax = defaultIzMax,
    this.pzMax = defaultPzMax,
  });

  /// Default reference parameters for typical 5.1V silicon Zener regulator
  static const double defaultVin = 12.0; // 12 V
  static const double defaultVz = 5.1; // 5.1 V
  static const double defaultRs = 330.0; // 330 Ω
  static const double defaultRl = 1000.0; // 1 kΩ
  static const double defaultIzMin = 0.005; // 5 mA
  static const double defaultIzMax = 0.050; // 50 mA (for ~500mW diode)
  static const double defaultPzMax = 0.500; // 500 mW (0.5 W)

  /// Validates physical viability of input parameters.
  /// Returns null if valid, or a descriptive error message if invalid.
  String? validate() {
    if (vin.isNaN || vz.isNaN || rs.isNaN || rl.isNaN || izMin.isNaN || izMax.isNaN || pzMax.isNaN) {
      return 'Parameter contains NaN values.';
    }
    if (vin.isInfinite || vz.isInfinite || rs.isInfinite || rl.isInfinite || izMin.isInfinite || izMax.isInfinite || pzMax.isInfinite) {
      return 'Parameter contains infinite values.';
    }
    if (vin < 0) {
      return 'Input voltage (Vin) cannot be negative.';
    }
    if (vz <= 0) {
      return 'Zener breakdown voltage (Vz) must be strictly positive.';
    }
    if (rs <= 0) {
      return 'Series resistance (Rs) must be strictly greater than 0 to prevent infinite current.';
    }
    if (rl <= 0) {
      return 'Load resistance (RL) must be strictly greater than 0.';
    }
    if (izMin < 0) {
      return 'Minimum Zener current (IzMin) cannot be negative.';
    }
    if (izMax <= izMin) {
      return 'Maximum Zener current (IzMax) must be strictly greater than IzMin.';
    }
    if (pzMax <= 0) {
      return 'Maximum Zener power rating (PzMax) must be strictly greater than 0.';
    }
    return null;
  }

  /// Whether the circuit parameters are physically valid.
  bool get isValid => validate() == null;

  /// Copy with modifications.
  ZenerParameters copyWith({
    double? vin,
    double? vz,
    double? rs,
    double? rl,
    double? izMin,
    double? izMax,
    double? pzMax,
  }) {
    return ZenerParameters(
      vin: vin ?? this.vin,
      vz: vz ?? this.vz,
      rs: rs ?? this.rs,
      rl: rl ?? this.rl,
      izMin: izMin ?? this.izMin,
      izMax: izMax ?? this.izMax,
      pzMax: pzMax ?? this.pzMax,
    );
  }

  @override
  String toString() =>
      'ZenerParameters(Vin: $vin V, Vz: $vz V, Rs: $rs Ω, RL: $rl Ω, IzMin: ${(izMin * 1000).toStringAsFixed(1)}mA, IzMax: ${(izMax * 1000).toStringAsFixed(1)}mA, PzMax: ${(pzMax * 1000).toStringAsFixed(1)}mW)';
}

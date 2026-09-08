/// Electrical operational states of a Zener diode voltage regulation circuit.
enum ZenerState {
  /// Unregulated voltage divider state where Vin * RL / (Rs + RL) < Vz.
  /// Diode is not in reverse breakdown, Iz = 0.
  belowBreakdown,

  /// Zener diode is conducting in reverse breakdown with sufficient current (Iz >= IzMin and Iz <= IzMax).
  /// Output voltage is regulated: Vout ≈ Vz.
  regulating,

  /// Output voltage has reached breakdown, but Zener current is below recommended knee current (0 < Iz < IzMin).
  /// Regulation is weak/unreliable.
  lowZenerCurrent,

  /// Zener current exceeds maximum safe continuous reverse current rating (Iz > IzMax).
  overCurrent,

  /// Zener power dissipation exceeds maximum power rating (Pz > PzMax).
  overPower,

  /// Circuit parameters are physically or mathematically invalid (e.g. non-positive resistance, negative voltages).
  invalidParameters;

  /// User-friendly display label for UI representation.
  String get displayName {
    switch (this) {
      case ZenerState.belowBreakdown:
        return 'Below Breakdown (Unregulated)';
      case ZenerState.regulating:
        return 'Regulating (Stable)';
      case ZenerState.lowZenerCurrent:
        return 'Low Zener Current (Unreliable)';
      case ZenerState.overCurrent:
        return 'Over Current Warning';
      case ZenerState.overPower:
        return 'Over Power Warning';
      case ZenerState.invalidParameters:
        return 'Invalid Circuit Parameters';
    }
  }

  /// Whether the circuit is considered actively regulating within safe limits.
  bool get isRegulating => this == ZenerState.regulating;
}

import 'package:flutter/material.dart';

/// Editorial & Technical Sans-Serif Typography for ZenerLab
/// Features massive high-contrast display sizes for desktop hero storytelling and precise mono readouts.
class AppTypography {
  AppTypography._();

  static const TextStyle heroGiant = TextStyle(
    fontSize: 56,
    fontWeight: FontWeight.w900,
    letterSpacing: -2.0,
    height: 1.05,
    fontFamily: 'sans-serif',
  );

  static const TextStyle heroSub = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w500,
    letterSpacing: -0.4,
    height: 1.4,
  );

  static const TextStyle displayLarge = TextStyle(
    fontSize: 38,
    fontWeight: FontWeight.w800,
    letterSpacing: -1.2,
    height: 1.15,
  );

  static const TextStyle displayMedium = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.6,
    height: 1.2,
  );

  static const TextStyle titleLarge = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.3,
    height: 1.3,
  );

  static const TextStyle titleMedium = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.1,
    height: 1.35,
  );

  static const TextStyle bodyLarge = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: 1.6,
  );

  static const TextStyle bodyMedium = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 1.5,
  );

  static const TextStyle bodySmall = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    height: 1.4,
  );

  static const TextStyle labelLarge = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w700,
    letterSpacing: 0.8,
  );

  static const TextStyle labelSmall = TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.5,
  );

  static const TextStyle monoReadout = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.w800,
    letterSpacing: -0.5,
    fontFamily: 'monospace',
  );

  static const TextStyle monoSub = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.2,
    fontFamily: 'monospace',
  );

  // Backward-compatible getters for legacy core widgets
  static const TextStyle readoutValue = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w800,
    letterSpacing: -0.5,
    fontFamily: 'monospace',
  );

  static const TextStyle readoutUnit = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w600,
    fontFamily: 'monospace',
  );

  static const TextStyle formula = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    fontFamily: 'monospace',
  );
}

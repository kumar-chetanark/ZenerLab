import 'package:flutter/material.dart';

/// ZenerLab Electric Acid-Lime & Void Obsidian Palette
/// Inspired by cinematic 3D engineering studios: deep negative space, high-contrast typography, and electric highlights
class AppColors {
  AppColors._();

  // Primary System (Electric Acid Lime)
  static const Color primaryLight = Color(0xFF8FAF20);
  static const Color primary = Color(0xFFDFFF35); // Electric Lime
  static const Color primaryDark = Color(0xFFB5D422);
  static const Color primaryContainerLight = Color(0xFFF3FDC8);
  static const Color primaryContainerDark = Color(0xFF1E2805);

  // Secondary System (Muted Acid Olive / Steel Gold)
  static const Color secondaryLight = Color(0xFF6B8418);
  static const Color secondary = Color(0xFF8FAF20); // Acid Olive
  static const Color secondaryDark = Color(0xFFA5C926);
  static const Color secondaryContainerLight = Color(0xFFEAF5C5);
  static const Color secondaryContainerDark = Color(0xFF161E05);

  // Tertiary System (Precision Titanium Slate)
  static const Color tertiary = Color(0xFF8B949E);
  static const Color tertiaryDark = Color(0xFFAEB2B5);
  static const Color tertiaryContainerLight = Color(0xFFECEFF3);
  static const Color tertiaryContainerDark = Color(0xFF161B22);

  // Surfaces & Backgrounds - Light Theme (Clean Technical Studio)
  static const Color lightBg = Color(0xFFF4F5F2);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightSurfaceContainer = Color(0xFFE6EAF0);
  static const Color lightSurfaceHigh = Color(0xFFD8DFE8);
  static const Color lightBorder = Color(0xFFCDD6E2);
  static const Color lightTextPrimary = Color(0xFF070809);
  static const Color lightTextSecondary = Color(0xFF4B5563);

  // Surfaces & Backgrounds - Dark Theme (Deep Void Obsidian Studio)
  static const Color darkBg = Color(0xFF070809); // Deep Void Base
  static const Color darkSurface = Color(0xFF0D1117); // Low Inset
  static const Color darkSurfaceContainer = Color(0xFF161B22); // Titanium Plate
  static const Color darkSurfaceHigh = Color(0xFF21262D); // Raised Bezel
  static const Color darkBorder = Color(0xFF30363D); // Specular Edge
  static const Color darkTextPrimary = Color(0xFFF4F5F2); // Editorial Technical White
  static const Color darkTextSecondary = Color(0xFFAEB2B5); // Muted Engineering Notation

  // Semantic States
  static const Color success = Color(0xFF3FB950); // Muted Emerald
  static const Color successContainerLight = Color(0xFFDCFCE7);
  static const Color successContainerDark = Color(0xFF122C1A);

  static const Color warning = Color(0xFFD29922); // Warm Amber
  static const Color warningContainerLight = Color(0xFFFEF3C7);
  static const Color warningContainerDark = Color(0xFF3B2B0A);

  static const Color error = Color(0xFFF85149); // Muted Vermillion
  static const Color errorContainerLight = Color(0xFFFEE2E2);
  static const Color errorContainerDark = Color(0xFF381515);

  static const Color info = Color(0xFF58A6FF);
  static const Color infoContainerLight = Color(0xFFE0F2FE);
  static const Color infoContainerDark = Color(0xFF0F2642);

  // Circuit Channels (Precision Lab Instrumentation)
  static const Color voltageIn = Color(0xFF58A6FF); // Series / Input Channel (Cobalt Blue)
  static const Color zenerVoltage = Color(0xFFDFFF35); // Zener Regulation Channel (Electric Lime)
  static const Color voltageOut = Color(0xFF3FB950); // Load Output Channel (Precision Jade)
  static const Color zenerCurrent = Color(0xFFDFFF35); // Zener Current Excitation
}

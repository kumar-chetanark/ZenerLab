import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../../../theme/app_colors.dart';

/// 3D Isometric Laboratory Instrument Workstation (multimeter / semiconductor analyzer bezel)
/// Replaces the decorative rings with realistic 3D industrial laboratory hardware.
class KineticHero3DWidget extends StatefulWidget {
  final double size;

  const KineticHero3DWidget({
    super.key,
    this.size = 220,
  });

  @override
  State<KineticHero3DWidget> createState() => _KineticHero3DWidgetState();
}

class _KineticHero3DWidgetState extends State<KineticHero3DWidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  double _hoverX = 0.0;
  double _hoverY = 0.0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return MouseRegion(
      onHover: (event) {
        setState(() {
          _hoverX = (event.localPosition.dx / widget.size - 0.5) * 0.4;
          _hoverY = (event.localPosition.dy / widget.size - 0.5) * 0.4;
        });
      },
      onExit: (_) {
        setState(() {
          _hoverX = 0.0;
          _hoverY = 0.0;
        });
      },
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) {
          return SizedBox(
            width: widget.size,
            height: widget.size,
            child: CustomPaint(
              painter: _Instrument3DPainter(
                progress: _controller.value,
                hoverX: _hoverX,
                hoverY: _hoverY,
                isDark: isDark,
              ),
            ),
          );
        },
      ),
    );
  }
}

class _Instrument3DPainter extends CustomPainter {
  final double progress;
  final double hoverX;
  final double hoverY;
  final bool isDark;

  _Instrument3DPainter({
    required this.progress,
    required this.hoverX,
    required this.hoverY,
    required this.isDark,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width * 0.5, size.height * 0.52);

    // 3D Isometric Projector with hover tilt
    Offset project(double x, double y, double z) {
      final double isoX = (x - y) * 0.866 + (hoverX * 35);
      final double isoY = (x + y) * 0.5 - z * 0.85 + (hoverY * 30);
      return Offset(center.dx + isoX, center.dy + isoY);
    }

    const double hw = 75.0; // Half width
    const double hh = 55.0; // Half height
    const double thick = 22.0;

    // 1. Ambient Drop Shadow
    final shadowPath = Path()
      ..moveTo(project(-hw, -hh, -thick).dx, project(-hw, -hh, -thick).dy + 14)
      ..lineTo(project(hw, -hh, -thick).dx, project(hw, -hh, -thick).dy + 14)
      ..lineTo(project(hw, hh, -thick).dx, project(hw, hh, -thick).dy + 14)
      ..lineTo(project(-hw, hh, -thick).dx, project(-hw, hh, -thick).dy + 14)
      ..close();
    canvas.drawPath(
      shadowPath,
      Paint()
        ..color = Colors.black.withValues(alpha: isDark ? 0.5 : 0.15)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 16),
    );

    // 2. Extruded Chassis Front Face
    final frontFace = Path()
      ..moveTo(project(-hw, hh, 0).dx, project(-hw, hh, 0).dy)
      ..lineTo(project(hw, hh, 0).dx, project(hw, hh, 0).dy)
      ..lineTo(project(hw, hh, -thick).dx, project(hw, hh, -thick).dy)
      ..lineTo(project(-hw, hh, -thick).dx, project(-hw, hh, -thick).dy)
      ..close();
    canvas.drawPath(
      frontFace,
      Paint()..color = isDark ? const Color(0xFF161B22) : const Color(0xFFCBD5E1),
    );

    // 3. Extruded Chassis Side Face
    final sideFace = Path()
      ..moveTo(project(-hw, -hh, 0).dx, project(-hw, -hh, 0).dy)
      ..lineTo(project(-hw, hh, 0).dx, project(-hw, hh, 0).dy)
      ..lineTo(project(-hw, hh, -thick).dx, project(-hw, hh, -thick).dy)
      ..lineTo(project(-hw, -hh, -thick).dx, project(-hw, -hh, -thick).dy)
      ..close();
    canvas.drawPath(
      sideFace,
      Paint()..color = isDark ? const Color(0xFF0D1117) : const Color(0xFF94A3B8),
    );

    // 4. Top Face - Matte Industrial Titanium Bezel
    final topFace = Path()
      ..moveTo(project(-hw, -hh, 0).dx, project(-hw, -hh, 0).dy)
      ..lineTo(project(hw, -hh, 0).dx, project(hw, -hh, 0).dy)
      ..lineTo(project(hw, hh, 0).dx, project(hw, hh, 0).dy)
      ..lineTo(project(-hw, hh, 0).dx, project(-hw, hh, 0).dy)
      ..close();

    final topGradient = LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: isDark
          ? [const Color(0xFF2B323D), const Color(0xFF1E242C), const Color(0xFF161B22)]
          : [const Color(0xFFF8FAFC), const Color(0xFFE2E8F0), const Color(0xFFCBD5E1)],
    ).createShader(Rect.fromCenter(center: center, width: hw * 2.5, height: hh * 2.5));

    canvas.drawPath(topFace, Paint()..shader = topGradient);
    canvas.drawPath(
      topFace,
      Paint()
        ..color = isDark ? const Color(0xFF38434F) : const Color(0xFF94A3B8)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5,
    );

    // 5. 3D Digital Scope Screen Screen Inset
    const double sw = 50.0;
    const double sh = 30.0;
    const double sy = -16.0;

    final screenPath = Path()
      ..moveTo(project(-sw, sy - sh, 2).dx, project(-sw, sy - sh, 2).dy)
      ..lineTo(project(sw, sy - sh, 2).dx, project(sw, sy - sh, 2).dy)
      ..lineTo(project(sw, sy + sh, 2).dx, project(sw, sy + sh, 2).dy)
      ..lineTo(project(-sw, sy + sh, 2).dx, project(-sw, sy + sh, 2).dy)
      ..close();

    canvas.drawPath(
      screenPath,
      Paint()..color = isDark ? const Color(0xFF090D11) : const Color(0xFF1E293B),
    );

    canvas.drawPath(
      screenPath,
      Paint()
        ..color = AppColors.voltageOut.withValues(alpha: 0.4)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.0,
    );

    // 6. Oscilloscope Waveform on 3D screen
    final wavePath = Path();
    for (int i = 0; i <= 24; i++) {
      final double t = i / 24.0;
      final double wx = -sw + t * (sw * 2);
      final double waveVal = math.sin(t * 4 * math.pi - progress * 2 * math.pi) * 12.0;
      final p = project(wx, sy + waveVal, 2.5);
      if (i == 0) {
        wavePath.moveTo(p.dx, p.dy);
      } else {
        wavePath.lineTo(p.dx, p.dy);
      }
    }
    canvas.drawPath(
      wavePath,
      Paint()
        ..color = AppColors.voltageOut
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.0
        ..strokeCap = StrokeCap.round,
    );

    // 7. 3D Rotary Knobs (Cobalt & Copper Dials)
    _draw3DRotaryKnob(
      canvas: canvas,
      center: project(-30, 36, 4),
      radius: 14,
      rotation: progress * 2 * math.pi,
      accentColor: AppColors.primary,
      isDark: isDark,
    );

    _draw3DRotaryKnob(
      canvas: canvas,
      center: project(30, 36, 4),
      radius: 14,
      rotation: -progress * 2 * math.pi,
      accentColor: AppColors.secondary,
      isDark: isDark,
    );

    // 8. Probe Jacks / Terminals
    _drawJack(canvas, project(-55, 36, 2), AppColors.voltageIn);
    _drawJack(canvas, project(55, 36, 2), AppColors.voltageOut);
  }

  void _draw3DRotaryKnob({
    required Canvas canvas,
    required Offset center,
    required double radius,
    required double rotation,
    required Color accentColor,
    required bool isDark,
  }) {
    // Drop shadow
    canvas.drawCircle(
      center.translate(0, 3),
      radius,
      Paint()
        ..color = Colors.black.withValues(alpha: isDark ? 0.4 : 0.1)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4),
    );

    // Knob Body
    final knobGradient = RadialGradient(
      center: const Alignment(-0.3, -0.3),
      colors: isDark
          ? [const Color(0xFF38434F), const Color(0xFF1E242C), const Color(0xFF161B22)]
          : [const Color(0xFFFFFFFF), const Color(0xFFE2E8F0), const Color(0xFF94A3B8)],
    ).createShader(Rect.fromCircle(center: center, radius: radius));

    canvas.drawCircle(center, radius, Paint()..shader = knobGradient);
    canvas.drawCircle(
      center,
      radius,
      Paint()
        ..color = accentColor.withValues(alpha: 0.8)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.2,
    );

    // Pointer notch
    final notchX = center.dx + math.cos(rotation) * (radius * 0.7);
    final notchY = center.dy + math.sin(rotation) * (radius * 0.7);
    canvas.drawLine(
      center,
      Offset(notchX, notchY),
      Paint()
        ..color = accentColor
        ..strokeWidth = 2.2
        ..strokeCap = StrokeCap.round,
    );
  }

  void _drawJack(Canvas canvas, Offset center, Color color) {
    canvas.drawCircle(center, 6, Paint()..color = const Color(0xFF0D1117));
    canvas.drawCircle(
      center,
      6,
      Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5,
    );
    canvas.drawCircle(center, 2.5, Paint()..color = color);
  }

  @override
  bool shouldRepaint(covariant _Instrument3DPainter oldDelegate) => true;
}

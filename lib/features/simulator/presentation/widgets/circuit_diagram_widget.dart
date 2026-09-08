import 'package:flutter/material.dart';
import '../../../../simulation/simulation.dart';
import '../../../../theme/app_colors.dart';

/// Interactive 3D Isometric Circuit Workbench with dynamic camera zoom, mouse tilt, physical components, and particle flow
class CircuitDiagramWidget extends StatefulWidget {
  final ZenerSimulationResult result;
  final bool showCurrentFlow;
  final double zoomScale;
  final double focusOffsetX;
  final bool isInteractive;

  const CircuitDiagramWidget({
    super.key,
    required this.result,
    this.showCurrentFlow = true,
    this.zoomScale = 1.0,
    this.focusOffsetX = 0.0,
    this.isInteractive = true,
  });

  @override
  State<CircuitDiagramWidget> createState() => _CircuitDiagramWidgetState();
}

class _CircuitDiagramWidgetState extends State<CircuitDiagramWidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  double _tiltX = 0.0;
  double _tiltY = 0.0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
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

    return LayoutBuilder(
      builder: (context, constraints) {
        // Auto-scale zoom down on mobile screens (e.g. 320px - 500px width)
        final double width = constraints.maxWidth.isFinite ? constraints.maxWidth : 600.0;
        final double autoScale = (width / 540.0).clamp(0.55, 1.15);
        final double effectiveZoom = widget.zoomScale * autoScale;

        Widget canvasWidget = AnimatedBuilder(
          animation: _controller,
          builder: (context, _) {
            return CustomPaint(
              size: Size(double.infinity, (360 * autoScale).clamp(200.0, 420.0)),
              painter: _Circuit3DWorkbenchPainter(
                result: widget.result,
                showCurrentFlow: widget.showCurrentFlow,
                animationProgress: _controller.value,
                tiltX: _tiltX,
                tiltY: _tiltY,
                zoomScale: effectiveZoom,
                focusOffsetX: widget.focusOffsetX,
                isDark: isDark,
              ),
            );
          },
        );

        if (!widget.isInteractive) {
          return canvasWidget;
        }

        return MouseRegion(
          onHover: (event) {
            final size = context.size ?? const Size(500, 360);
            setState(() {
              _tiltX = ((event.localPosition.dx / size.width) - 0.5) * 0.45;
              _tiltY = ((event.localPosition.dy / size.height) - 0.5) * 0.35;
            });
          },
          onExit: (_) {
            setState(() {
              _tiltX = 0.0;
              _tiltY = 0.0;
            });
          },
          child: canvasWidget,
        );
      },
    );
  }
}

class _Circuit3DWorkbenchPainter extends CustomPainter {
  final ZenerSimulationResult result;
  final bool showCurrentFlow;
  final double animationProgress;
  final double tiltX;
  final double tiltY;
  final double zoomScale;
  final double focusOffsetX;
  final bool isDark;

  _Circuit3DWorkbenchPainter({
    required this.result,
    required this.showCurrentFlow,
    required this.animationProgress,
    required this.tiltX,
    required this.tiltY,
    required this.zoomScale,
    required this.focusOffsetX,
    required this.isDark,
  });

  @override
  void paint(Canvas canvas, Size size) {
    canvas.save();
    canvas.clipRect(Offset.zero & size);
    final center = Offset(size.width * 0.5 + (focusOffsetX * zoomScale), size.height * 0.52);

    // 3D Isometric Camera Projection with zoom & mouse tilt
    Offset project(double x, double y, double z) {
      final double isoX = (x - y) * 0.866 * zoomScale + (tiltX * 50);
      final double isoY = ((x + y) * 0.5 - z * 0.9) * zoomScale + (tiltY * 40);
      return Offset(center.dx + isoX, center.dy + isoY);
    }

    // 1. Draw 3D Isometric Breadboard Slab
    _draw3DBreadboard(canvas, size, center, project);

    // 2. Base wire & node paints
    final wireColor = isDark ? const Color(0xFF8B949E) : const Color(0xFF4B5563);
    final wirePaint = Paint()
      ..color = wireColor
      ..strokeWidth = 3.0 * zoomScale
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    final busPaint = Paint()
      ..color = isDark ? const Color(0xFF21262D) : const Color(0xFFCDD6E2)
      ..strokeWidth = 4.0 * zoomScale
      ..style = PaintingStyle.stroke;

    // Coordinates
    const double pLeft = -170.0;
    const double pRight = 170.0;
    const double pRsStart = -100.0;
    const double pRsEnd = -30.0;
    const double pZener = 35.0;
    const double pLoad = 115.0;

    const double yTop = -50.0;
    const double yBottom = 50.0;
    const double zElevated = 28.0;

    // 3. Ground / Bottom Return Bus Wire
    canvas.drawLine(project(pLeft, yBottom, 0), project(pLoad, yBottom, 0), busPaint);

    // 4. Ground Symbols
    _drawGround3D(canvas, project(pLeft, yBottom, 0), wireColor);
    _drawGround3D(canvas, project(pZener, yBottom, 0), wireColor);
    _drawGround3D(canvas, project(pLoad, yBottom, 0), wireColor);

    // 5. 3D DC Source Meter (Vin)
    _draw3DDcSource(canvas, project(pLeft, 0, zElevated), pLeft, yTop, yBottom, zElevated, project);

    // 6. Top Rail Floating Wires
    canvas.drawLine(project(pLeft, yTop, zElevated), project(pRsStart, yTop, zElevated), wirePaint);
    canvas.drawLine(project(pRsEnd, yTop, zElevated), project(pZener, yTop, zElevated), wirePaint);
    canvas.drawLine(project(pZener, yTop, zElevated), project(pLoad, yTop, zElevated), wirePaint);
    canvas.drawLine(project(pLoad, yTop, zElevated), project(pRight, yTop, zElevated), wirePaint);

    // Vertical down leads to ground bus
    canvas.drawLine(project(pLeft, yTop, zElevated), project(pLeft, yTop, 0), wirePaint);
    canvas.drawLine(project(pLeft, yTop, 0), project(pLeft, yBottom, 0), wirePaint);

    // 7. 3D Ceramic Resistor Rs
    _draw3DResistor(
      canvas: canvas,
      start: project(pRsStart, yTop, zElevated),
      end: project(pRsEnd, yTop, zElevated),
      label: 'Rs',
      value: '${result.rs.toStringAsFixed(0)} Ω',
      isDark: isDark,
    );

    // 8. 3D Glass Zener Diode Branch
    _draw3DZenerDiode(
      canvas: canvas,
      top: project(pZener, yTop, zElevated),
      bottom: project(pZener, yBottom, 0),
      isDark: isDark,
    );

    // 9. 3D Load Resistor RL Branch
    _draw3DVerticalResistor(
      canvas: canvas,
      top: project(pLoad, yTop, zElevated),
      bottom: project(pLoad, yBottom, 0),
      label: 'RL',
      value: result.rl >= 1000 ? '${(result.rl / 1000).toStringAsFixed(2)} kΩ' : '${result.rl.toStringAsFixed(0)} Ω',
      isDark: isDark,
    );

    // 10. 3D Output Digital Probe
    _draw3DOutputProbe(canvas, project(pRight, yTop, zElevated), result.vout, isDark);

    // 11. Animated 3D Current Particles (Driven by live physics)
    if (showCurrentFlow && !result.isInvalid) {
      _draw3DCurrentParticles(
        canvas: canvas,
        project: project,
        pLeft: pLeft,
        pRsStart: pRsStart,
        pRsEnd: pRsEnd,
        pZener: pZener,
        pLoad: pLoad,
        yTop: yTop,
        yBottom: yBottom,
        zElevated: zElevated,
      );
    }

    canvas.restore();
  }

  void _draw3DBreadboard(
    Canvas canvas,
    Size size,
    Offset center,
    Offset Function(double, double, double) project,
  ) {
    const double bw = 210.0;
    const double bh = 85.0;
    const double thick = 14.0;

    final p0 = project(-bw, -bh, 0);
    final p1 = project(bw, -bh, 0);
    final p2 = project(bw, bh, 0);
    final p3 = project(-bw, bh, 0);

    final p2b = project(bw, bh, -thick);
    final p3b = project(-bw, bh, -thick);
    final p0b = project(-bw, -bh, -thick);

    // Ambient drop shadow
    final shadowPath = Path()
      ..moveTo(p0b.dx, p0b.dy + 14 * zoomScale)
      ..lineTo(p1.dx, p1.dy + 14 * zoomScale)
      ..lineTo(p2b.dx, p2b.dy + 14 * zoomScale)
      ..lineTo(p3b.dx, p3b.dy + 14 * zoomScale)
      ..close();
    canvas.drawPath(
      shadowPath,
      Paint()
        ..color = Colors.black.withValues(alpha: isDark ? 0.5 : 0.15)
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, 16 * zoomScale),
    );

    // Front Face
    final frontFace = Path()
      ..moveTo(p3.dx, p3.dy)
      ..lineTo(p2.dx, p2.dy)
      ..lineTo(p2b.dx, p2b.dy)
      ..lineTo(p3b.dx, p3b.dy)
      ..close();
    canvas.drawPath(
      frontFace,
      Paint()..color = isDark ? const Color(0xFF0D1117) : const Color(0xFFCBD5E1),
    );

    // Left Face
    final leftFace = Path()
      ..moveTo(p0.dx, p0.dy)
      ..lineTo(p3.dx, p3.dy)
      ..lineTo(p3b.dx, p3b.dy)
      ..lineTo(p0b.dx, p0b.dy)
      ..close();
    canvas.drawPath(
      leftFace,
      Paint()..color = isDark ? const Color(0xFF070809) : const Color(0xFF94A3B8),
    );

    // Top Surface
    final topFace = Path()
      ..moveTo(p0.dx, p0.dy)
      ..lineTo(p1.dx, p1.dy)
      ..lineTo(p2.dx, p2.dy)
      ..lineTo(p3.dx, p3.dy)
      ..close();

    final topGradient = LinearGradient(
      colors: isDark
          ? [const Color(0xFF161B22), const Color(0xFF0D1117)]
          : [const Color(0xFFF4F5F2), const Color(0xFFE2E8F0)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ).createShader(Rect.fromCenter(center: center, width: bw * 2 * zoomScale, height: bh * 2 * zoomScale));

    canvas.drawPath(topFace, Paint()..shader = topGradient);
    canvas.drawPath(
      topFace,
      Paint()
        ..color = isDark ? const Color(0xFF21262D) : const Color(0xFFCBD5E1)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.2,
    );

    // Grid Pinholes
    final holePaint = Paint()
      ..color = isDark ? const Color(0xFF070809) : const Color(0xFF94A3B8);

    for (double gx = -180; gx <= 180; gx += 30) {
      for (double gy = -65; gy <= 65; gy += 25) {
        canvas.drawCircle(project(gx, gy, 0), 1.6 * zoomScale, holePaint);
      }
    }
  }

  void _draw3DDcSource(
    Canvas canvas,
    Offset center,
    double pLeft,
    double yTop,
    double yBottom,
    double zElevated,
    Offset Function(double, double, double) project,
  ) {
    canvas.drawCircle(
      center.translate(0, 8 * zoomScale),
      26 * zoomScale,
      Paint()
        ..color = Colors.black.withValues(alpha: isDark ? 0.45 : 0.15)
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, 8 * zoomScale),
    );

    final bezelGradient = RadialGradient(
      center: const Alignment(-0.3, -0.3),
      colors: isDark
          ? [const Color(0xFF21262D), const Color(0xFF0D1117)]
          : [const Color(0xFFE2E8F0), const Color(0xFF94A3B8)],
    ).createShader(Rect.fromCircle(center: center, radius: 24 * zoomScale));

    canvas.drawCircle(center, 24 * zoomScale, Paint()..shader = bezelGradient);
    canvas.drawCircle(
      center,
      24 * zoomScale,
      Paint()
        ..color = AppColors.voltageIn
        ..strokeWidth = 2.0 * zoomScale
        ..style = PaintingStyle.stroke,
    );

    _drawText(canvas, '+', Offset(center.dx - 5 * zoomScale, center.dy - 18 * zoomScale), 13 * zoomScale, AppColors.voltageIn, isBold: true);
    _drawText(canvas, '−', Offset(center.dx - 4 * zoomScale, center.dy + 4 * zoomScale), 14 * zoomScale, AppColors.voltageIn, isBold: true);

    _drawText(
      canvas,
      'Vin = ${result.vin.toStringAsFixed(1)}V',
      Offset(center.dx - 34 * zoomScale, center.dy - 38 * zoomScale),
      11.5 * zoomScale,
      AppColors.voltageIn,
      isBold: true,
    );
  }

  void _draw3DResistor({
    required Canvas canvas,
    required Offset start,
    required Offset end,
    required String label,
    required String value,
    required bool isDark,
  }) {
    final mid = Offset((start.dx + end.dx) / 2, (start.dy + end.dy) / 2);
    final width = ((end.dx - start.dx).abs() + 20) * zoomScale;

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(center: mid.translate(0, 5 * zoomScale), width: width * 0.75, height: 16 * zoomScale),
        Radius.circular(5 * zoomScale),
      ),
      Paint()
        ..color = Colors.black.withValues(alpha: isDark ? 0.4 : 0.12)
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, 4 * zoomScale),
    );

    final bodyRect = RRect.fromRectAndRadius(
      Rect.fromCenter(center: mid, width: width * 0.75, height: 16 * zoomScale),
      Radius.circular(5 * zoomScale),
    );

    final bodyGradient = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: isDark
          ? [const Color(0xFF30363D), const Color(0xFF161B22), const Color(0xFF0D1117)]
          : [const Color(0xFFF8FAFC), const Color(0xFFE2E8F0), const Color(0xFFCBD5E1)],
    ).createShader(bodyRect.outerRect);

    canvas.drawRRect(bodyRect, Paint()..shader = bodyGradient);
    canvas.drawRRect(
      bodyRect,
      Paint()
        ..color = isDark ? const Color(0xFF30363D) : const Color(0xFF94A3B8)
        ..strokeWidth = 1.0
        ..style = PaintingStyle.stroke,
    );

    // Color Bands
    canvas.drawRect(Rect.fromLTWH(mid.dx - 14 * zoomScale, mid.dy - 8 * zoomScale, 3.5 * zoomScale, 16 * zoomScale), Paint()..color = const Color(0xFFB91C1C));
    canvas.drawRect(Rect.fromLTWH(mid.dx - 5 * zoomScale, mid.dy - 8 * zoomScale, 3.5 * zoomScale, 16 * zoomScale), Paint()..color = const Color(0xFF2563EB));
    canvas.drawRect(Rect.fromLTWH(mid.dx + 6 * zoomScale, mid.dy - 8 * zoomScale, 3.5 * zoomScale, 16 * zoomScale), Paint()..color = const Color(0xFFD97706));

    _drawText(canvas, label, Offset(mid.dx - 8 * zoomScale, mid.dy - 24 * zoomScale), 12 * zoomScale, isDark ? Colors.white : Colors.black87, isBold: true);
    _drawText(canvas, value, Offset(mid.dx - 18 * zoomScale, mid.dy + 12 * zoomScale), 11 * zoomScale, isDark ? const Color(0xFFAEB2B5) : const Color(0xFF64748B), isBold: true);
  }

  void _draw3DZenerDiode({
    required Canvas canvas,
    required Offset top,
    required Offset bottom,
    required bool isDark,
  }) {
    final mid = Offset((top.dx + bottom.dx) / 2, (top.dy + bottom.dy) / 2);
    final color = _getZenerColor();

    final leadPaint = Paint()
      ..color = isDark ? const Color(0xFF8B949E) : const Color(0xFF4B5563)
      ..strokeWidth = 2.5 * zoomScale
      ..style = PaintingStyle.stroke;

    canvas.drawLine(top, mid.translate(0, -18 * zoomScale), leadPaint);
    canvas.drawLine(mid.translate(0, 18 * zoomScale), bottom, leadPaint);

    // Zener Breakdown Glow Pulse when active
    if (result.isRegulating) {
      canvas.drawCircle(
        mid,
        28 * zoomScale,
        Paint()
          ..color = AppColors.primary.withValues(alpha: 0.22)
          ..maskFilter = MaskFilter.blur(BlurStyle.normal, 16 * zoomScale),
      );
    }

    final beadRect = RRect.fromRectAndRadius(
      Rect.fromCenter(center: mid, width: 24 * zoomScale, height: 34 * zoomScale),
      Radius.circular(8 * zoomScale),
    );

    final glassGradient = LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: result.isRegulating
          ? [AppColors.primary.withValues(alpha: 0.35), AppColors.secondary.withValues(alpha: 0.6)]
          : (isDark
              ? [const Color(0xFF21262D).withValues(alpha: 0.5), const Color(0xFF161B22).withValues(alpha: 0.8)]
              : [const Color(0xFFE2E8F0).withValues(alpha: 0.5), const Color(0xFFCBD5E1).withValues(alpha: 0.8)]),
    ).createShader(beadRect.outerRect);

    canvas.drawRRect(beadRect, Paint()..shader = glassGradient);
    canvas.drawRRect(
      beadRect,
      Paint()
        ..color = result.isRegulating ? AppColors.primary.withValues(alpha: 0.7) : (isDark ? const Color(0xFF30363D) : const Color(0xFF94A3B8))
        ..strokeWidth = 1.2 * zoomScale
        ..style = PaintingStyle.stroke,
    );

    // Cathode Band (Black band)
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(mid.dx - 11 * zoomScale, mid.dy - 15 * zoomScale, 22 * zoomScale, 5 * zoomScale),
        Radius.circular(2 * zoomScale),
      ),
      Paint()..color = const Color(0xFF070809),
    );

    // Diode Schematic Symbol
    final symPaint = Paint()
      ..color = color
      ..strokeWidth = 2.0 * zoomScale
      ..style = PaintingStyle.fill;

    final trianglePath = Path()
      ..moveTo(mid.dx, mid.dy - 7 * zoomScale)
      ..lineTo(mid.dx - 8 * zoomScale, mid.dy + 7 * zoomScale)
      ..lineTo(mid.dx + 8 * zoomScale, mid.dy + 7 * zoomScale)
      ..close();

    canvas.drawPath(trianglePath, symPaint);

    final cathodePath = Path()
      ..moveTo(mid.dx - 9 * zoomScale, mid.dy - 11 * zoomScale)
      ..lineTo(mid.dx - 9 * zoomScale, mid.dy - 7 * zoomScale)
      ..lineTo(mid.dx + 9 * zoomScale, mid.dy - 7 * zoomScale)
      ..lineTo(mid.dx + 9 * zoomScale, mid.dy - 3 * zoomScale);

    canvas.drawPath(
      cathodePath,
      Paint()
        ..color = color
        ..strokeWidth = 2.0 * zoomScale
        ..style = PaintingStyle.stroke,
    );

    _drawText(canvas, 'Dz (${result.vz.toStringAsFixed(1)}V)', Offset(mid.dx + 16 * zoomScale, mid.dy - 8 * zoomScale), 11 * zoomScale, color, isBold: true);
    _drawText(canvas, result.isBelowBreakdown ? 'OFF' : 'REGULATING', Offset(mid.dx + 16 * zoomScale, mid.dy + 6 * zoomScale), 10 * zoomScale, color, isBold: true);
  }

  void _draw3DVerticalResistor({
    required Canvas canvas,
    required Offset top,
    required Offset bottom,
    required String label,
    required String value,
    required bool isDark,
  }) {
    final mid = Offset((top.dx + bottom.dx) / 2, (top.dy + bottom.dy) / 2);

    final leadPaint = Paint()
      ..color = isDark ? const Color(0xFF8B949E) : const Color(0xFF4B5563)
      ..strokeWidth = 2.5 * zoomScale
      ..style = PaintingStyle.stroke;

    canvas.drawLine(top, mid.translate(0, -20 * zoomScale), leadPaint);
    canvas.drawLine(mid.translate(0, 20 * zoomScale), bottom, leadPaint);

    final bodyRect = RRect.fromRectAndRadius(
      Rect.fromCenter(center: mid, width: 18 * zoomScale, height: 38 * zoomScale),
      Radius.circular(5 * zoomScale),
    );

    final bodyGradient = LinearGradient(
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
      colors: isDark
          ? [const Color(0xFF30363D), const Color(0xFF161B22), const Color(0xFF0D1117)]
          : [const Color(0xFFF8FAFC), const Color(0xFFE2E8F0), const Color(0xFFCBD5E1)],
    ).createShader(bodyRect.outerRect);

    canvas.drawRRect(bodyRect, Paint()..shader = bodyGradient);
    canvas.drawRRect(
      bodyRect,
      Paint()
        ..color = isDark ? const Color(0xFF30363D) : const Color(0xFF94A3B8)
        ..strokeWidth = 1.0
        ..style = PaintingStyle.stroke,
    );

    canvas.drawRect(Rect.fromLTWH(mid.dx - 9 * zoomScale, mid.dy - 11 * zoomScale, 18 * zoomScale, 3.5 * zoomScale), Paint()..color = const Color(0xFF16A34A));
    canvas.drawRect(Rect.fromLTWH(mid.dx - 9 * zoomScale, mid.dy - 1 * zoomScale, 18 * zoomScale, 3.5 * zoomScale), Paint()..color = const Color(0xFFD97706));
    canvas.drawRect(Rect.fromLTWH(mid.dx - 9 * zoomScale, mid.dy + 9 * zoomScale, 18 * zoomScale, 3.5 * zoomScale), Paint()..color = const Color(0xFFB91C1C));

    _drawText(canvas, label, Offset(mid.dx + 14 * zoomScale, mid.dy - 10 * zoomScale), 12 * zoomScale, isDark ? Colors.white : Colors.black87, isBold: true);
    _drawText(canvas, value, Offset(mid.dx + 14 * zoomScale, mid.dy + 6 * zoomScale), 11 * zoomScale, isDark ? const Color(0xFFAEB2B5) : const Color(0xFF64748B), isBold: true);
  }

  void _draw3DOutputProbe(Canvas canvas, Offset pos, double vout, bool isDark) {
    final bgPaint = Paint()
      ..color = isDark ? AppColors.darkSurfaceHigh : AppColors.lightSurfaceHigh
      ..style = PaintingStyle.fill;

    final borderPaint = Paint()
      ..color = AppColors.voltageOut
      ..strokeWidth = 1.5 * zoomScale
      ..style = PaintingStyle.stroke;

    final rrect = RRect.fromRectAndRadius(
      Rect.fromCenter(center: Offset(pos.dx + 10 * zoomScale, pos.dy), width: 84 * zoomScale, height: 32 * zoomScale),
      Radius.circular(8 * zoomScale),
    );

    canvas.drawRRect(rrect, bgPaint);
    canvas.drawRRect(rrect, borderPaint);

    _drawText(
      canvas,
      'Vout: ${vout.toStringAsFixed(2)}V',
      Offset(pos.dx - 26 * zoomScale, pos.dy - 7 * zoomScale),
      11.5 * zoomScale,
      AppColors.voltageOut,
      isBold: true,
    );
  }

  void _draw3DCurrentParticles({
    required Canvas canvas,
    required Offset Function(double, double, double) project,
    required double pLeft,
    required double pRsStart,
    required double pRsEnd,
    required double pZener,
    required double pLoad,
    required double yTop,
    required double yBottom,
    required double zElevated,
  }) {
    final seriesPaint = Paint()..color = AppColors.voltageIn;
    final zenerPaint = Paint()..color = AppColors.primary;
    final loadPaint = Paint()..color = AppColors.voltageOut;

    // Series Path: pLeft -> pRsStart, pRsEnd -> pZener
    if (result.seriesCurrent > 0) {
      final double seg1 = (pRsStart - pLeft);
      final double seg2 = (pZener - pRsEnd);
      final double total = seg1 + seg2;
      final double p = (animationProgress * total) % total;

      Offset pos;
      if (p < seg1) {
        pos = project(pLeft + p, yTop, zElevated);
      } else {
        pos = project(pRsEnd + (p - seg1), yTop, zElevated);
      }
      canvas.drawCircle(pos, 3.5 * zoomScale, seriesPaint);
    }

    // Load Path: pZener -> pLoad -> Ground
    if (result.loadCurrent > 0) {
      final double seg1 = (pLoad - pZener);
      final double seg2 = (yBottom - yTop);
      final double total = seg1 + seg2;
      final double p = (animationProgress * total) % total;

      Offset pos;
      if (p < seg1) {
        pos = project(pZener + p, yTop, zElevated);
      } else {
        final double yProgress = p - seg1;
        pos = project(pLoad, yTop + yProgress, zElevated * (1 - yProgress / seg2));
      }
      canvas.drawCircle(pos, 3.5 * zoomScale, loadPaint);
    }

    // Zener Path: Top -> Bottom (Excited when breakdown occurs)
    if (result.zenerCurrent > 0) {
      final double seg = (yBottom - yTop);
      final double p = (animationProgress * seg) % seg;
      final pos = project(pZener, yTop + p, zElevated * (1 - p / seg));
      canvas.drawCircle(pos, 4.0 * zoomScale, zenerPaint);
    }
  }

  void _drawGround3D(Canvas canvas, Offset top, Color color) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 2.0 * zoomScale;

    canvas.drawLine(top, Offset(top.dx, top.dy + 8 * zoomScale), paint);
    canvas.drawLine(Offset(top.dx - 10 * zoomScale, top.dy + 8 * zoomScale), Offset(top.dx + 10 * zoomScale, top.dy + 8 * zoomScale), paint);
    canvas.drawLine(Offset(top.dx - 6 * zoomScale, top.dy + 12 * zoomScale), Offset(top.dx + 6 * zoomScale, top.dy + 12 * zoomScale), paint);
    canvas.drawLine(Offset(top.dx - 2 * zoomScale, top.dy + 16 * zoomScale), Offset(top.dx + 2 * zoomScale, top.dy + 16 * zoomScale), paint);
  }

  Color _getZenerColor() {
    switch (result.zenerState) {
      case ZenerState.regulating:
        return AppColors.primary;
      case ZenerState.belowBreakdown:
        return isDark ? const Color(0xFF484F58) : const Color(0xFF94A3B8);
      case ZenerState.lowZenerCurrent:
        return AppColors.warning;
      case ZenerState.overCurrent:
      case ZenerState.overPower:
        return AppColors.error;
      case ZenerState.invalidParameters:
        return Colors.grey;
    }
  }

  void _drawText(Canvas canvas, String text, Offset offset, double fontSize, Color color, {bool isBold = false}) {
    final textPainter = TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(
          color: color,
          fontSize: fontSize,
          fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
          fontFamily: 'monospace',
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    textPainter.paint(canvas, offset);
  }

  @override
  bool shouldRepaint(covariant _Circuit3DWorkbenchPainter oldDelegate) {
    return oldDelegate.animationProgress != animationProgress ||
        oldDelegate.result != result ||
        oldDelegate.showCurrentFlow != showCurrentFlow ||
        oldDelegate.tiltX != tiltX ||
        oldDelegate.tiltY != tiltY ||
        oldDelegate.zoomScale != zoomScale ||
        oldDelegate.focusOffsetX != focusOffsetX ||
        oldDelegate.isDark != isDark;
  }
}

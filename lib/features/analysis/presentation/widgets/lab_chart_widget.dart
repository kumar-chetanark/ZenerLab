import 'package:flutter/material.dart';
import '../../../../theme/app_colors.dart';

/// Single Point in a 2D line graph series
class GraphPoint {
  final double x;
  final double y;
  final String? label;

  const GraphPoint({
    required this.x,
    required this.y,
    this.label,
  });
}

/// Custom painted interactive engineering chart with grid lines, axis labels, units, and highlighted operating point
class LabChartWidget extends StatelessWidget {
  final String title;
  final String xLabel;
  final String yLabel;
  final String xUnit;
  final String yUnit;
  final List<GraphPoint> points;
  final GraphPoint? currentPoint;
  final Color lineColor;
  final String? interpretation;

  const LabChartWidget({
    super.key,
    required this.title,
    required this.xLabel,
    required this.yLabel,
    required this.xUnit,
    required this.yUnit,
    required this.points,
    this.currentPoint,
    this.lineColor = AppColors.primary,
    this.interpretation,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: 8,
          runSpacing: 6,
          alignment: WrapAlignment.spaceBetween,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            Text(
              title,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            if (currentPoint != null)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: lineColor.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: lineColor.withValues(alpha: 0.4)),
                ),
                child: Text(
                  'Current: ${currentPoint!.x.toStringAsFixed(1)}$xUnit, ${currentPoint!.y.toStringAsFixed(2)}$yUnit',
                  style: TextStyle(
                    fontFamily: 'monospace',
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: lineColor,
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 300,
          width: double.infinity,
          child: CustomPaint(
            painter: _LabChartPainter(
              points: points,
              currentPoint: currentPoint,
              xLabel: xLabel,
              yLabel: yLabel,
              xUnit: xUnit,
              yUnit: yUnit,
              lineColor: lineColor,
              isDark: isDark,
            ),
          ),
        ),
        if (interpretation != null) ...[
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: theme.colorScheme.outlineVariant.withValues(alpha: 0.4),
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.auto_awesome_rounded, color: lineColor, size: 18),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    interpretation!,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurface,
                      height: 1.4,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }
}

class _LabChartPainter extends CustomPainter {
  final List<GraphPoint> points;
  final GraphPoint? currentPoint;
  final String xLabel;
  final String yLabel;
  final String xUnit;
  final String yUnit;
  final Color lineColor;
  final bool isDark;

  _LabChartPainter({
    required this.points,
    required this.currentPoint,
    required this.xLabel,
    required this.yLabel,
    required this.xUnit,
    required this.yUnit,
    required this.lineColor,
    required this.isDark,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (points.isEmpty) return;

    const paddingLeft = 52.0;
    const paddingRight = 24.0;
    const paddingTop = 18.0;
    const paddingBottom = 38.0;

    final plotWidth = size.width - paddingLeft - paddingRight;
    final plotHeight = size.height - paddingTop - paddingBottom;

    // Determine domain & range with comfortable headroom
    double minX = points.first.x;
    double maxX = points.first.x;
    double minY = points.first.y;
    double maxY = points.first.y;

    for (final p in points) {
      if (p.x < minX) minX = p.x;
      if (p.x > maxX) maxX = p.x;
      if (p.y < minY) minY = p.y;
      if (p.y > maxY) maxY = p.y;
    }

    // Anchor baseline to 0 if data is non-negative for natural physical scale
    if (minY >= 0) minY = 0.0;
    if (minX >= 0 && minX <= 100) minX = 0.0;

    // Add 15% top headroom to maxY so curves do not hit the top boundary
    if (maxY > minY) {
      maxY = maxY + (maxY - minY) * 0.15;
    } else {
      minY = minY - 1;
      maxY = maxY + 1;
    }

    if (minX == maxX) {
      minX = minX - 1;
      maxX = maxX + 1;
    }

    // Grid & Axis paints
    final gridPaint = Paint()
      ..color = (isDark ? Colors.white : Colors.black).withValues(alpha: 0.08)
      ..strokeWidth = 1.0;

    final axisPaint = Paint()
      ..color = (isDark ? Colors.white : Colors.black).withValues(alpha: 0.3)
      ..strokeWidth = 1.5;

    final textStyle = TextStyle(
      color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
      fontSize: 10,
      fontFamily: 'monospace',
    );

    // Draw 4 Horizontal Grid Lines & Y ticks
    const int yGridCount = 4;
    for (int i = 0; i <= yGridCount; i++) {
      final double normalized = i / yGridCount;
      final double yPos = paddingTop + (plotHeight * (1 - normalized));
      final double val = minY + (normalized * (maxY - minY));

      canvas.drawLine(Offset(paddingLeft, yPos), Offset(paddingLeft + plotWidth, yPos), gridPaint);
      _drawText(canvas, val.toStringAsFixed(1), Offset(6, yPos - 6), textStyle);
    }

    // Draw 5 Vertical Grid Lines & X ticks
    const int xGridCount = 5;
    for (int i = 0; i <= xGridCount; i++) {
      final double normalized = i / xGridCount;
      final double xPos = paddingLeft + (plotWidth * normalized);
      final double val = minX + (normalized * (maxX - minX));

      canvas.drawLine(Offset(xPos, paddingTop), Offset(xPos, paddingTop + plotHeight), gridPaint);
      _drawText(canvas, val.toStringAsFixed(0), Offset(xPos - 8, paddingTop + plotHeight + 6), textStyle);
    }

    // Plot Border
    canvas.drawRect(Rect.fromLTWH(paddingLeft, paddingTop, plotWidth, plotHeight), axisPaint);

    // Coordinate mapping functions
    double toCanvasX(double x) => paddingLeft + ((x - minX) / (maxX - minX)) * plotWidth;
    double toCanvasY(double y) => paddingTop + plotHeight - ((y - minY) / (maxY - minY)) * plotHeight;

    // Draw Line Curve
    final path = Path();
    for (int i = 0; i < points.length; i++) {
      final cx = toCanvasX(points[i].x);
      final cy = toCanvasY(points[i].y);
      if (i == 0) {
        path.moveTo(cx, cy);
      } else {
        path.lineTo(cx, cy);
      }
    }

    final linePaint = Paint()
      ..color = lineColor
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke;

    canvas.drawPath(path, linePaint);

    // Fill under curve
    final fillPath = Path.from(path)
      ..lineTo(toCanvasX(points.last.x), paddingTop + plotHeight)
      ..lineTo(toCanvasX(points.first.x), paddingTop + plotHeight)
      ..close();

    final fillPaint = Paint()
      ..shader = LinearGradient(
        colors: [lineColor.withValues(alpha: 0.25), lineColor.withValues(alpha: 0.0)],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ).createShader(Rect.fromLTWH(paddingLeft, paddingTop, plotWidth, plotHeight))
      ..style = PaintingStyle.fill;

    canvas.drawPath(fillPath, fillPaint);

    // Highlight Current Operating Point
    if (currentPoint != null &&
        currentPoint!.x >= minX &&
        currentPoint!.x <= maxX &&
        currentPoint!.y >= minY &&
        currentPoint!.y <= maxY) {
      final cx = toCanvasX(currentPoint!.x);
      final cy = toCanvasY(currentPoint!.y);

      // Dash guides
      final guidePaint = Paint()
        ..color = lineColor.withValues(alpha: 0.4)
        ..strokeWidth = 1.0;

      canvas.drawLine(Offset(cx, paddingTop + plotHeight), Offset(cx, cy), guidePaint);
      canvas.drawLine(Offset(paddingLeft, cy), Offset(cx, cy), guidePaint);

      // Outer glow and inner dot
      canvas.drawCircle(Offset(cx, cy), 6.5, Paint()..color = lineColor.withValues(alpha: 0.3));
      canvas.drawCircle(Offset(cx, cy), 4.0, Paint()..color = lineColor);
      canvas.drawCircle(Offset(cx, cy), 2.0, Paint()..color = Colors.white);
    }

    // X and Y Axis Titles
    _drawText(
      canvas,
      '$xLabel ($xUnit)',
      Offset(paddingLeft + plotWidth / 2 - 35, paddingTop + plotHeight + 22),
      textStyle.copyWith(fontWeight: FontWeight.bold),
    );

    _drawText(
      canvas,
      '$yLabel ($yUnit)',
      const Offset(48.0, 4.0),
      textStyle.copyWith(fontWeight: FontWeight.bold),
    );
  }

  void _drawText(Canvas canvas, String text, Offset offset, TextStyle style) {
    final textPainter = TextPainter(
      text: TextSpan(text: text, style: style),
      textDirection: TextDirection.ltr,
    )..layout();
    textPainter.paint(canvas, offset);
  }

  @override
  bool shouldRepaint(covariant _LabChartPainter oldDelegate) {
    return oldDelegate.points != points ||
        oldDelegate.currentPoint != currentPoint ||
        oldDelegate.lineColor != lineColor ||
        oldDelegate.isDark != isDark;
  }
}

import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../../../simulation/simulation.dart';
import '../../../../theme/app_colors.dart';

/// 3D Isometric Parametric Surface Visualization
/// Maps (Vin, RL) -> Vout to visually illustrate the 3D Regulation Plateau
class Surface3DChartWidget extends StatefulWidget {
  final ZenerParameters baseline;

  const Surface3DChartWidget({
    super.key,
    required this.baseline,
  });

  @override
  State<Surface3DChartWidget> createState() => _Surface3DChartWidgetState();
}

class _Surface3DChartWidgetState extends State<Surface3DChartWidget> {
  double _yaw = 0.75; // Horizontal rotation angle in radians
  double _pitch = 0.55; // Vertical tilt angle in radians

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '3D Regulation Surface: (Vin × RL → Vout)',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Drag to rotate 3D view and observe the flat regulation plateau',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.voltageOut.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: AppColors.voltageOut.withValues(alpha: 0.4)),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.threed_rotation_rounded, size: 14, color: AppColors.voltageOut),
                  SizedBox(width: 4),
                  Text(
                    'Interactive 3D Mesh',
                    style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.voltageOut),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        GestureDetector(
          onPanUpdate: (details) {
            setState(() {
              _yaw += details.delta.dx * 0.01;
              _pitch = (_pitch - details.delta.dy * 0.01).clamp(0.2, 1.2);
            });
          },
          child: Container(
            height: 320,
            width: double.infinity,
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF161B22) : const Color(0xFFE6EAF0),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: theme.colorScheme.outlineVariant.withValues(alpha: 0.6),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.06),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: CustomPaint(
                painter: _Surface3DPainter(
                  baseline: widget.baseline,
                  yaw: _yaw,
                  pitch: _pitch,
                  isDark: isDark,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF21262D) : const Color(0xFFF1F3F6),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: theme.colorScheme.outlineVariant.withValues(alpha: 0.4),
            ),
          ),
          child: Row(
            children: [
              const Icon(Icons.info_outline_rounded, size: 16, color: AppColors.info),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  '3D Interpretation: The elevated flat green region represents the stable Vz (${widget.baseline.vz.toStringAsFixed(1)}V) regulation ceiling. Notice how the surface slopes downward when RL is small (heavy load) or Vin is below threshold.',
                  style: theme.textTheme.bodySmall?.copyWith(height: 1.4),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _Surface3DPainter extends CustomPainter {
  final ZenerParameters baseline;
  final double yaw;
  final double pitch;
  final bool isDark;

  static const int gridX = 14; // Vin steps
  static const int gridY = 14; // RL steps
  final ZenerSimulator _simulator = const ZenerSimulator();

  _Surface3DPainter({
    required this.baseline,
    required this.yaw,
    required this.pitch,
    required this.isDark,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width * 0.5, size.height * 0.52);
    final double scale = size.width * 0.38;

    // Generate 3D grid points (Vin, RL) -> Vout
    final List<List<_Point3D>> grid = [];

    const double minVin = 0.0;
    const double maxVin = 25.0;
    const double minRl = 100.0;
    const double maxRl = 3000.0;

    for (int i = 0; i <= gridX; i++) {
      final List<_Point3D> row = [];
      final double vin = minVin + (i / gridX) * (maxVin - minVin);

      for (int j = 0; j <= gridY; j++) {
        final double rl = minRl + (j / gridY) * (maxRl - minRl);
        final res = _simulator.simulate(baseline.copyWith(vin: vin, rl: rl));

        // Normalize X, Y, Z to [-1, 1] range for 3D rotation
        final double nx = ((vin - minVin) / (maxVin - minVin)) * 2.0 - 1.0;
        final double ny = ((rl - minRl) / (maxRl - minRl)) * 2.0 - 1.0;
        final double nz = (res.vout / (baseline.vz * 1.3)) * 1.5 - 0.75;

        row.add(_Point3D(nx, ny, nz, res.vout));
      }
      grid.add(row);
    }

    // 3D Isometric Camera Projection
    Offset project(_Point3D p) {
      // Yaw rotation (around Z axis)
      final double cosY = math.cos(yaw);
      final double sinY = math.sin(yaw);
      final double rx = p.x * cosY - p.y * sinY;
      final double ry = p.x * sinY + p.y * cosY;

      // Pitch rotation (around X axis)
      final double cosP = math.cos(pitch);
      final double sinP = math.sin(pitch);
      final double py = ry * cosP - p.z * sinP;
      final double pz = ry * sinP + p.z * cosP;

      // Perspective scale factor
      final double perspective = 1.0 / (1.0 + pz * 0.25);
      return Offset(
        center.dx + rx * scale * perspective,
        center.dy + py * scale * 0.65 * perspective,
      );
    }

    // Draw 3D Polygons back-to-front
    for (int i = 0; i < gridX; i++) {
      for (int j = 0; j < gridY; j++) {
        final p00 = grid[i][j];
        final p10 = grid[i + 1][j];
        final p11 = grid[i + 1][j + 1];
        final p01 = grid[i][j + 1];

        final s00 = project(p00);
        final s10 = project(p10);
        final s11 = project(p11);
        final s01 = project(p01);

        final avgVout = (p00.vout + p10.vout + p11.vout + p01.vout) / 4.0;
        final isReg = avgVout >= baseline.vz * 0.96;

        // Color shading based on regulation condition
        final faceColor = isReg
            ? (isDark ? const Color(0xFF238636) : const Color(0xFF2EA043)).withValues(alpha: 0.7)
            : (isDark ? const Color(0xFF30363D) : const Color(0xFF8C959F)).withValues(alpha: 0.5);

        final path = Path()
          ..moveTo(s00.dx, s00.dy)
          ..lineTo(s10.dx, s10.dy)
          ..lineTo(s11.dx, s11.dy)
          ..lineTo(s01.dx, s01.dy)
          ..close();

        // Polygon Face
        canvas.drawPath(path, Paint()..color = faceColor);

        // 3D Wireframe Grid Lines
        final wirePaint = Paint()
          ..color = isDark ? const Color(0xFF58A6FF).withValues(alpha: 0.35) : const Color(0xFF1F2328).withValues(alpha: 0.2)
          ..strokeWidth = 1.0
          ..style = PaintingStyle.stroke;
        canvas.drawPath(path, wirePaint);
      }
    }

    // 3D Axis Labels
    final textStyle = TextStyle(
      color: isDark ? const Color(0xFFC9D1D9) : const Color(0xFF24292F),
      fontSize: 11,
      fontWeight: FontWeight.bold,
      fontFamily: 'monospace',
    );

    final pVin = project(const _Point3D(1.15, -1.0, -0.75, 0));
    final pRl = project(const _Point3D(-1.0, 1.15, -0.75, 0));
    final pVz = project(_Point3D(-1.0, -1.0, (baseline.vz / (baseline.vz * 1.3)) * 1.5 - 0.75, 0));

    _drawText(canvas, 'Vin (0→25V)', pVin, textStyle);
    _drawText(canvas, 'RL (100Ω→3kΩ)', pRl, textStyle);
    _drawText(canvas, 'Vout (Vz=${baseline.vz}V)', pVz, textStyle.copyWith(color: AppColors.voltageOut));
  }

  void _drawText(Canvas canvas, String text, Offset offset, TextStyle style) {
    final tp = TextPainter(
      text: TextSpan(text: text, style: style),
      textDirection: TextDirection.ltr,
    )..layout();
    tp.paint(canvas, offset);
  }

  @override
  bool shouldRepaint(covariant _Surface3DPainter oldDelegate) {
    return oldDelegate.yaw != yaw || oldDelegate.pitch != pitch || oldDelegate.baseline != baseline;
  }
}

class _Point3D {
  final double x;
  final double y;
  final double z;
  final double vout;

  const _Point3D(this.x, this.y, this.z, this.vout);
}

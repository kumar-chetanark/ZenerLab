import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../../../theme/app_colors.dart';
import '../../../../theme/app_typography.dart';

/// Tactile Laboratory Rotary Knob Instrument Control
class RotaryKnobWidget extends StatefulWidget {
  final double value;
  final double min;
  final double max;
  final String label;
  final String unit;
  final Color accentColor;
  final ValueChanged<double> onChanged;

  const RotaryKnobWidget({
    super.key,
    required this.value,
    required this.min,
    required this.max,
    required this.label,
    required this.unit,
    this.accentColor = AppColors.primary,
    required this.onChanged,
  });

  @override
  State<RotaryKnobWidget> createState() => _RotaryKnobWidgetState();
}

class _RotaryKnobWidgetState extends State<RotaryKnobWidget> {
  double _dragStartY = 0.0;
  double _startValue = 0.0;
  late TextEditingController _textController;
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController(text: _formatValue(widget.value));
    _focusNode.addListener(() {
      if (!_focusNode.hasFocus) {
        _commitTextChange(_textController.text);
      }
    });
  }

  @override
  void didUpdateWidget(RotaryKnobWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value && !_focusNode.hasFocus) {
      _textController.text = _formatValue(widget.value);
    }
  }

  @override
  void dispose() {
    _textController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  String _formatValue(double val) {
    if (val >= 1000 && widget.unit == 'Ω') {
      return (val / 1000).toStringAsFixed(2);
    }
    return val.toStringAsFixed(1);
  }

  void _commitTextChange(String text) {
    final parsed = double.tryParse(text.trim());
    if (parsed != null) {
      double targetVal = parsed;
      if (widget.unit == 'Ω' && widget.value >= 1000 && parsed < 50) {
        // If user typed kΩ value
        targetVal = parsed * 1000;
      }
      final clamped = targetVal.clamp(widget.min, widget.max);
      widget.onChanged(clamped);
      _textController.text = _formatValue(clamped);
    } else {
      _textController.text = _formatValue(widget.value);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // Map value to angle (-135 deg to +135 deg)
    final double normalized = ((widget.value - widget.min) / (widget.max - widget.min)).clamp(0.0, 1.0);
    final double angle = -math.pi * 0.75 + normalized * (math.pi * 1.5);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          widget.label,
          style: theme.textTheme.labelSmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
            letterSpacing: 0.8,
            fontSize: 10,
          ),
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onVerticalDragStart: (details) {
            _dragStartY = details.globalPosition.dy;
            _startValue = widget.value;
          },
          onVerticalDragUpdate: (details) {
            final double deltaY = _dragStartY - details.globalPosition.dy;
            final double range = widget.max - widget.min;
            final double newValue = (_startValue + (deltaY / 120.0) * range).clamp(widget.min, widget.max);
            widget.onChanged(newValue);
          },
          child: MouseRegion(
            cursor: SystemMouseCursors.resizeUpDown,
            child: SizedBox(
              width: 76,
              height: 76,
              child: CustomPaint(
                painter: _KnobPainter(
                  angle: angle,
                  accentColor: widget.accentColor,
                  isDark: isDark,
                  normalized: normalized,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        // Typable interactive readout badge
        Container(
          height: 28,
          constraints: const BoxConstraints(minWidth: 68, maxWidth: 96),
          padding: const EdgeInsets.symmetric(horizontal: 4),
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkBg : const Color(0xFFF1F5F9),
            borderRadius: BorderRadius.circular(4),
            border: Border.all(
              color: _focusNode.hasFocus ? widget.accentColor : (isDark ? AppColors.darkBorder : const Color(0xFFCBD5E1)),
              width: 1,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Flexible(
                child: TextField(
                  controller: _textController,
                  focusNode: _focusNode,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  textAlign: TextAlign.right,
                  style: AppTypography.monoSub.copyWith(
                    color: widget.accentColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                  decoration: const InputDecoration(
                    isDense: true,
                    contentPadding: EdgeInsets.symmetric(vertical: 4, horizontal: 2),
                    border: InputBorder.none,
                  ),
                  onSubmitted: _commitTextChange,
                ),
              ),
              const SizedBox(width: 3),
              Text(
                widget.unit,
                style: AppTypography.monoSub.copyWith(
                  color: isDark ? AppColors.darkTextSecondary : const Color(0xFF64748B),
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _KnobPainter extends CustomPainter {
  final double angle;
  final Color accentColor;
  final bool isDark;
  final double normalized;

  _KnobPainter({
    required this.angle,
    required this.accentColor,
    required this.isDark,
    required this.normalized,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width * 0.5, size.height * 0.5);
    final radius = size.width * 0.42;

    // Track arc
    final trackPaint = Paint()
      ..color = isDark ? const Color(0xFF21262D) : const Color(0xFFE2E8F0)
      ..strokeWidth = 3.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius + 4),
      -math.pi * 1.25,
      math.pi * 1.5,
      false,
      trackPaint,
    );

    // Active arc
    final activePaint = Paint()
      ..color = accentColor
      ..strokeWidth = 3.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius + 4),
      -math.pi * 1.25,
      normalized * (math.pi * 1.5),
      false,
      activePaint,
    );

    // Ambient drop shadow
    canvas.drawCircle(
      center.translate(0, 4),
      radius,
      Paint()
        ..color = Colors.black.withValues(alpha: isDark ? 0.5 : 0.15)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6),
    );

    // Metallic Knob Body
    final knobGradient = RadialGradient(
      center: const Alignment(-0.35, -0.35),
      colors: isDark
          ? [const Color(0xFF30363D), const Color(0xFF161B22), const Color(0xFF070809)]
          : [const Color(0xFFFFFFFF), const Color(0xFFE2E8F0), const Color(0xFFCBD5E1)],
    ).createShader(Rect.fromCircle(center: center, radius: radius));

    canvas.drawCircle(center, radius, Paint()..shader = knobGradient);
    canvas.drawCircle(
      center,
      radius,
      Paint()
        ..color = isDark ? const Color(0xFF30363D) : const Color(0xFF94A3B8)
        ..strokeWidth = 1.2
        ..style = PaintingStyle.stroke,
    );

    // Pointer notch
    final notchX = center.dx + math.cos(angle) * (radius * 0.7);
    final notchY = center.dy + math.sin(angle) * (radius * 0.7);

    canvas.drawLine(
      center,
      Offset(notchX, notchY),
      Paint()
        ..color = accentColor
        ..strokeWidth = 2.5
        ..strokeCap = StrokeCap.round,
    );
  }

  @override
  bool shouldRepaint(covariant _KnobPainter oldDelegate) {
    return oldDelegate.angle != angle ||
        oldDelegate.accentColor != accentColor ||
        oldDelegate.isDark != isDark ||
        oldDelegate.normalized != normalized;
  }
}

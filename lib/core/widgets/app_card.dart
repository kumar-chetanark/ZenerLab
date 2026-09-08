import 'package:flutter/material.dart';
import '../constants/app_constants.dart';

/// Reusable engineering surface card with subtle border and elevation
class AppCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final Color? color;
  final Color? borderColor;
  final double? width;
  final double? height;
  final VoidCallback? onTap;
  final double borderRadius;

  const AppCard({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.color,
    this.borderColor,
    this.width,
    this.height,
    this.onTap,
    this.borderRadius = AppConstants.radiusMd,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final effectiveColor = color ?? theme.colorScheme.surface;
    final effectiveBorderColor =
        borderColor ?? theme.colorScheme.outlineVariant.withValues(alpha: 0.6);

    final isDark = theme.brightness == Brightness.dark;

    return Container(
      width: width,
      height: height,
      margin: margin,
      decoration: BoxDecoration(
        color: effectiveColor,
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(color: effectiveBorderColor, width: 1),
        boxShadow: [
          // Ambient depth drop shadow
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.45 : 0.08),
            blurRadius: 14,
            offset: const Offset(0, 5),
          ),
          // 3D Rim bevel light reflection
          BoxShadow(
            color: isDark ? Colors.white.withValues(alpha: 0.04) : Colors.white,
            blurRadius: 1,
            offset: const Offset(0, -1),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(borderRadius),
        child: InkWell(
          borderRadius: BorderRadius.circular(borderRadius),
          onTap: onTap,
          child: Padding(
            padding: padding ?? const EdgeInsets.all(AppConstants.spaceMd),
            child: child,
          ),
        ),
      ),
    );
  }
}

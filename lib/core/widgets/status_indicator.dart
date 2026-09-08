import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../constants/app_constants.dart';

enum StatusType { active, inactive, warning, error, info }

/// Status indicator chip with pulsing dot and semantic color support
class StatusIndicator extends StatelessWidget {
  final String label;
  final StatusType type;
  final bool showDot;

  const StatusIndicator({
    super.key,
    required this.label,
    this.type = StatusType.info,
    this.showDot = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    Color color;
    Color bgColor;

    switch (type) {
      case StatusType.active:
        color = AppColors.success;
        bgColor = isDark ? AppColors.successContainerDark : AppColors.successContainerLight;
        break;
      case StatusType.warning:
        color = AppColors.warning;
        bgColor = isDark ? AppColors.warningContainerDark : AppColors.warningContainerLight;
        break;
      case StatusType.error:
        color = AppColors.error;
        bgColor = isDark ? AppColors.errorContainerDark : AppColors.errorContainerLight;
        break;
      case StatusType.info:
        color = AppColors.info;
        bgColor = isDark ? AppColors.infoContainerDark : AppColors.infoContainerLight;
        break;
      case StatusType.inactive:
        color = theme.colorScheme.onSurfaceVariant;
        bgColor = theme.colorScheme.surfaceContainerHigh;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppConstants.spaceSm + 2,
        vertical: AppConstants.spaceXs,
      ),
      decoration: BoxDecoration(
        color: bgColor.withValues(alpha: 0.8),
        borderRadius: BorderRadius.circular(AppConstants.radiusFull),
        border: Border.all(color: color.withValues(alpha: 0.3), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (showDot) ...[
            Container(
              width: 7,
              height: 7,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: AppConstants.spaceXs + 2),
          ],
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 11.5,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.2,
            ),
          ),
        ],
      ),
    );
  }
}

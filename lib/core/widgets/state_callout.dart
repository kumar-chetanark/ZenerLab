import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../constants/app_constants.dart';
import 'app_card.dart';

enum CalloutType { info, success, warning, error }

/// Callout banner for displaying instructional tips, warnings, or lab notes
class StateCallout extends StatelessWidget {
  final String title;
  final String message;
  final CalloutType type;
  final Widget? action;

  const StateCallout({
    super.key,
    required this.title,
    required this.message,
    this.type = CalloutType.info,
    this.action,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    Color color;
    Color bgColor;
    IconData icon;

    switch (type) {
      case CalloutType.success:
        color = AppColors.success;
        bgColor = isDark ? AppColors.successContainerDark : AppColors.successContainerLight;
        icon = Icons.check_circle_outline_rounded;
        break;
      case CalloutType.warning:
        color = AppColors.warning;
        bgColor = isDark ? AppColors.warningContainerDark : AppColors.warningContainerLight;
        icon = Icons.warning_amber_rounded;
        break;
      case CalloutType.error:
        color = AppColors.error;
        bgColor = isDark ? AppColors.errorContainerDark : AppColors.errorContainerLight;
        icon = Icons.error_outline_rounded;
        break;
      case CalloutType.info:
        color = AppColors.info;
        bgColor = isDark ? AppColors.infoContainerDark : AppColors.infoContainerLight;
        icon = Icons.info_outline_rounded;
        break;
    }

    return AppCard(
      color: bgColor.withValues(alpha: 0.5),
      borderColor: color.withValues(alpha: 0.4),
      padding: const EdgeInsets.all(AppConstants.spaceMd),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 22),
          const SizedBox(width: AppConstants.spaceMd),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: color,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: AppConstants.space2xs),
                Text(
                  message,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurface,
                  ),
                ),
                if (action != null) ...[
                  const SizedBox(height: AppConstants.spaceSm),
                  action!,
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

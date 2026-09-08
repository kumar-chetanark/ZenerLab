import 'package:flutter/material.dart';
import '../constants/app_constants.dart';

/// Standard primary and secondary action buttons with polished feedback
class AppButton extends StatelessWidget {
  final String label;
  final IconData? icon;
  final VoidCallback? onPressed;
  final bool isPrimary;
  final bool isFullWidth;
  final bool isLoading;

  const AppButton.primary({
    super.key,
    required this.label,
    this.icon,
    required this.onPressed,
    this.isFullWidth = false,
    this.isLoading = false,
  }) : isPrimary = true;

  const AppButton.secondary({
    super.key,
    required this.label,
    this.icon,
    required this.onPressed,
    this.isFullWidth = false,
    this.isLoading = false,
  }) : isPrimary = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final Widget buttonContent = Row(
      mainAxisSize: isFullWidth ? MainAxisSize.max : MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (isLoading) ...[
          SizedBox(
            width: 16,
            height: 16,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(
                isPrimary ? theme.colorScheme.onPrimary : theme.colorScheme.primary,
              ),
            ),
          ),
          const SizedBox(width: AppConstants.spaceSm),
        ] else if (icon != null) ...[
          Icon(icon, size: 18),
          const SizedBox(width: AppConstants.spaceSm),
        ],
        Text(
          label,
          style: theme.textTheme.labelLarge?.copyWith(
            fontWeight: FontWeight.w600,
            color: isPrimary ? theme.colorScheme.onPrimary : theme.colorScheme.primary,
          ),
        ),
      ],
    );

    if (isPrimary) {
      return FilledButton(
        onPressed: isLoading ? null : onPressed,
        style: FilledButton.styleFrom(
          backgroundColor: theme.colorScheme.primary,
          foregroundColor: theme.colorScheme.onPrimary,
          elevation: AppConstants.elevationLow,
          padding: const EdgeInsets.symmetric(
            horizontal: AppConstants.spaceLg,
            vertical: AppConstants.spaceMd,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppConstants.radiusSm),
          ),
        ),
        child: buttonContent,
      );
    } else {
      return OutlinedButton(
        onPressed: isLoading ? null : onPressed,
        style: OutlinedButton.styleFrom(
          foregroundColor: theme.colorScheme.primary,
          side: BorderSide(
            color: theme.colorScheme.outlineVariant.withValues(alpha: 0.8),
            width: 1,
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: AppConstants.spaceLg,
            vertical: AppConstants.spaceMd,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppConstants.radiusSm),
          ),
        ),
        child: buttonContent,
      );
    }
  }
}

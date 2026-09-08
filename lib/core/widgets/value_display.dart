import 'package:flutter/material.dart';
import '../../theme/app_typography.dart';
import '../constants/app_constants.dart';
import 'app_card.dart';

/// Digital value display tile imitating lab oscilloscopes and multimeters
class ValueDisplay extends StatelessWidget {
  final String label;
  final String value;
  final String unit;
  final Color? accentColor;
  final String? formula;
  final IconData? icon;

  const ValueDisplay({
    super.key,
    required this.label,
    required this.value,
    required this.unit,
    this.accentColor,
    this.formula,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = accentColor ?? theme.colorScheme.primary;

    return AppCard(
      padding: const EdgeInsets.symmetric(
        horizontal: AppConstants.spaceMd,
        vertical: AppConstants.spaceSm + 2,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Row(
              children: [
                if (icon != null) ...[
                  Icon(icon, color: color, size: 20),
                  const SizedBox(width: AppConstants.spaceSm),
                ],
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        label,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (formula != null) ...[
                        const SizedBox(height: AppConstants.space2xs),
                        Text(
                          formula!,
                          style: AppTypography.formula.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                            fontSize: 11,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: AppConstants.spaceSm),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppConstants.spaceSm + 2,
              vertical: AppConstants.spaceXs,
            ),
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerHigh,
              borderRadius: BorderRadius.circular(AppConstants.radiusSm),
              border: Border.all(
                color: theme.colorScheme.outlineVariant.withValues(alpha: 0.5),
                width: 1,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  value,
                  style: const TextStyle(
                    fontFamily: 'monospace',
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(width: AppConstants.spaceXs),
                Text(
                  unit,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: color,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

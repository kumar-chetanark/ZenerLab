import 'package:flutter/material.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/widgets/app_buttons.dart';
import '../../../../theme/app_colors.dart';
import '../../../../theme/app_typography.dart';

/// Section 11 — Final Call to Action & Laboratory Footer
class FinalCtaSection extends StatelessWidget {
  final VoidCallback onSimulateAgain;
  final VoidCallback onTakeQuiz;
  final VoidCallback onExploreTheory;

  const FinalCtaSection({
    super.key,
    required this.onSimulateAgain,
    required this.onTakeQuiz,
    required this.onExploreTheory,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isDesktop = constraints.maxWidth >= 960;

        return Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(
            horizontal: isDesktop ? AppConstants.spaceXl * 1.5 : AppConstants.spaceMd,
            vertical: 80,
          ),
          decoration: BoxDecoration(
            color: AppColors.darkSurface.withValues(alpha: 0.6),
            border: const Border(top: BorderSide(color: AppColors.darkBorder)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'UNDERSTAND THE CIRCUIT.',
                textAlign: TextAlign.center,
                style: (isDesktop ? AppTypography.heroGiant : AppTypography.displayLarge).copyWith(
                  color: AppColors.darkTextPrimary,
                ),
              ),
              Text(
                'NOT JUST THE FORMULA.',
                textAlign: TextAlign.center,
                style: (isDesktop ? AppTypography.heroGiant : AppTypography.displayLarge).copyWith(
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: AppConstants.spaceMd),
              Text(
                'ZENERLAB — Interactive Virtual Electronics Laboratory',
                textAlign: TextAlign.center,
                style: AppTypography.heroSub.copyWith(
                  color: AppColors.darkTextSecondary,
                ),
              ),
              const SizedBox(height: AppConstants.spaceXl),
              Wrap(
                spacing: AppConstants.spaceMd,
                runSpacing: AppConstants.spaceMd,
                alignment: WrapAlignment.center,
                children: [
                  AppButton.primary(
                    label: 'Simulate Again',
                    icon: Icons.replay_rounded,
                    onPressed: onSimulateAgain,
                  ),
                  AppButton.secondary(
                    label: 'Take the Quiz',
                    icon: Icons.quiz_outlined,
                    onPressed: onTakeQuiz,
                  ),
                  AppButton.secondary(
                    label: 'Explore Theory',
                    icon: Icons.menu_book_outlined,
                    onPressed: onExploreTheory,
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

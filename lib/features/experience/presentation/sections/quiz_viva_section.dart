import 'package:flutter/material.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/widgets/app_buttons.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../theme/app_colors.dart';
import '../../../../theme/app_typography.dart';
import '../../../quiz/models/quiz_data.dart';

/// Section 10 — Interactive Viva Assessment & Quiz Deck
class QuizVivaSection extends StatefulWidget {
  const QuizVivaSection({super.key});

  @override
  State<QuizVivaSection> createState() => _QuizVivaSectionState();
}

class _QuizVivaSectionState extends State<QuizVivaSection> {
  final List<QuizQuestion> _questions = QuizQuestionBank.questions;
  int _currentIndex = 0;
  int? _selectedOption;
  bool _hasChecked = false;
  int _score = 0;

  @override
  Widget build(BuildContext context) {
    final currentQ = _questions[_currentIndex];

    return LayoutBuilder(
      builder: (context, constraints) {
        final isDesktop = constraints.maxWidth >= 960;

        return Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(
            horizontal: isDesktop ? AppConstants.spaceXl * 1.5 : AppConstants.spaceMd,
            vertical: 48,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '10 — ASSESSMENT & VIVA PREPARATION',
                style: AppTypography.labelSmall.copyWith(
                  color: AppColors.primary,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: AppConstants.spaceSm),
              Text(
                'INTERACTIVE QUIZ & VIVA VOCE',
                style: (isDesktop ? AppTypography.displayLarge : AppTypography.displayMedium).copyWith(
                  color: AppColors.darkTextPrimary,
                ),
              ),
              const SizedBox(height: AppConstants.spaceLg),

              // Interactive Single Question Focus Deck
              AppCard(
                padding: const EdgeInsets.all(AppConstants.spaceXl),
                color: AppColors.darkSurfaceContainer,
                borderColor: AppColors.darkBorder,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'QUESTION ${_currentIndex + 1} OF ${_questions.length}',
                          style: AppTypography.labelSmall.copyWith(color: AppColors.primary),
                        ),
                        Text(
                          'Score: $_score',
                          style: AppTypography.monoSub.copyWith(color: AppColors.darkTextSecondary),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppConstants.spaceMd),
                    Text(
                      currentQ.question,
                      style: AppTypography.titleLarge.copyWith(color: AppColors.darkTextPrimary),
                    ),
                    const SizedBox(height: AppConstants.spaceLg),

                    // Options List
                    Column(
                      children: List.generate(currentQ.options.length, (optIdx) {
                        final isSelected = _selectedOption == optIdx;
                        final isCorrect = optIdx == currentQ.correctIndex;

                        Color optBorder = AppColors.darkBorder;
                        Color optBg = AppColors.darkSurfaceHigh;

                        if (_hasChecked) {
                          if (isCorrect) {
                            optBorder = AppColors.primary;
                            optBg = AppColors.primary.withValues(alpha: 0.15);
                          } else if (isSelected) {
                            optBorder = AppColors.error;
                            optBg = AppColors.error.withValues(alpha: 0.15);
                          }
                        } else if (isSelected) {
                          optBorder = AppColors.primary;
                          optBg = AppColors.darkSurfaceContainer;
                        }

                        return Padding(
                          padding: const EdgeInsets.only(bottom: AppConstants.spaceSm),
                          child: InkWell(
                            onTap: _hasChecked ? null : () => setState(() => _selectedOption = optIdx),
                            borderRadius: BorderRadius.circular(AppConstants.radiusSm),
                            child: Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(AppConstants.spaceMd),
                              decoration: BoxDecoration(
                                color: optBg,
                                borderRadius: BorderRadius.circular(AppConstants.radiusSm),
                                border: Border.all(color: optBorder),
                              ),
                              child: Text(
                                currentQ.options[optIdx],
                                style: AppTypography.bodyMedium.copyWith(
                                  color: AppColors.darkTextPrimary,
                                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                ),
                              ),
                            ),
                          ),
                        );
                      }),
                    ),
                    const SizedBox(height: AppConstants.spaceLg),

                    // Feedback & Navigation Action
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        if (_hasChecked)
                          Text(
                            _selectedOption == currentQ.correctIndex ? '✓ Correct Answer!' : '✕ Incorrect',
                            style: AppTypography.monoSub.copyWith(
                              color: _selectedOption == currentQ.correctIndex ? AppColors.primary : AppColors.error,
                              fontWeight: FontWeight.bold,
                            ),
                          )
                        else
                          const SizedBox.shrink(),
                        Wrap(
                          spacing: AppConstants.spaceSm,
                          children: [
                            if (!_hasChecked)
                              AppButton.primary(
                                label: 'Check Answer',
                                onPressed: _selectedOption == null
                                    ? null
                                    : () {
                                        setState(() {
                                          _hasChecked = true;
                                          if (_selectedOption == currentQ.correctIndex) {
                                            _score++;
                                          }
                                        });
                                      },
                              )
                            else if (_currentIndex < _questions.length - 1)
                              AppButton.primary(
                                label: 'Next Question',
                                onPressed: () {
                                  setState(() {
                                    _currentIndex++;
                                    _selectedOption = null;
                                    _hasChecked = false;
                                  });
                                },
                              )
                            else
                              AppButton.primary(
                                label: 'Restart Quiz',
                                onPressed: () {
                                  setState(() {
                                    _currentIndex = 0;
                                    _selectedOption = null;
                                    _hasChecked = false;
                                    _score = 0;
                                  });
                                },
                              ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

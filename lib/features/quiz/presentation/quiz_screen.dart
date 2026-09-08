import 'package:flutter/material.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/widgets/widgets.dart';
import '../../../../theme/app_colors.dart';
import '../models/quiz_data.dart';

/// Formative Assessment Quiz & Viva Preparation Workspace
class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  final List<QuizQuestion> _questions = QuizQuestionBank.questions;

  int _currentIndex = 0;
  int? _selectedAnswerIndex;
  bool _hasSubmittedCurrent = false;
  int _score = 0;
  bool _isQuizFinished = false;

  final Map<int, int> _userAnswers = {};

  void _onOptionSelected(int index) {
    if (_hasSubmittedCurrent || _isQuizFinished) return;
    setState(() {
      _selectedAnswerIndex = index;
    });
  }

  void _submitAnswer() {
    if (_selectedAnswerIndex == null || _hasSubmittedCurrent) return;

    final currentQuestion = _questions[_currentIndex];
    final isCorrect = _selectedAnswerIndex == currentQuestion.correctIndex;

    setState(() {
      _hasSubmittedCurrent = true;
      _userAnswers[_currentIndex] = _selectedAnswerIndex!;
      if (isCorrect) {
        _score++;
      }
    });
  }

  void _nextQuestion() {
    if (_currentIndex < _questions.length - 1) {
      setState(() {
        _currentIndex++;
        _selectedAnswerIndex = null;
        _hasSubmittedCurrent = false;
      });
    } else {
      setState(() {
        _isQuizFinished = true;
      });
    }
  }

  void _resetQuiz() {
    setState(() {
      _currentIndex = 0;
      _selectedAnswerIndex = null;
      _hasSubmittedCurrent = false;
      _score = 0;
      _isQuizFinished = false;
      _userAnswers.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppConstants.spaceLg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Header
          SectionHeader(
            title: 'Knowledge Assessment & Viva Prep',
            subtitle: 'Curriculum multiple-choice assessment and viva voce questions',
            icon: Icons.quiz_outlined,
            trailing: StatusIndicator(
              label: _isQuizFinished ? 'Score: $_score / ${_questions.length}' : 'Question ${_currentIndex + 1} of ${_questions.length}',
              type: _isQuizFinished ? StatusType.active : StatusType.info,
            ),
          ),

          // Main Quiz Widget
          if (_isQuizFinished) ...[
            _buildQuizScorecard(theme),
          ] else ...[
            _buildActiveQuestionCard(theme),
          ],
          const SizedBox(height: AppConstants.space2xl),

          // Viva Voce Section
          const SectionHeader(
            title: 'Laboratory Viva Voce Q&A Reference',
            subtitle: 'Model questions and succinct answers for electronics laboratory examinations',
            icon: Icons.record_voice_over_outlined,
          ),
          ...VivaQuestionItem.all.map((item) {
            return Padding(
              padding: const EdgeInsets.only(bottom: AppConstants.spaceSm),
              child: AppCard(
                padding: const EdgeInsets.all(AppConstants.spaceMd),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.question,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: AppConstants.spaceXs),
                    Text(
                      item.answer,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildActiveQuestionCard(ThemeData theme) {
    final currentQ = _questions[_currentIndex];
    final progress = (_currentIndex + 1) / _questions.length;

    return AppCard(
      padding: const EdgeInsets.all(AppConstants.spaceLg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Progress Bar
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Chip(
                label: Text(currentQ.category),
                backgroundColor: theme.colorScheme.primary.withValues(alpha: 0.1),
              ),
              Text(
                'Question ${_currentIndex + 1} / ${_questions.length}',
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
              ),
            ],
          ),
          const SizedBox(height: AppConstants.spaceSm),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 6,
              backgroundColor: theme.colorScheme.surfaceContainerHigh,
            ),
          ),
          const SizedBox(height: AppConstants.spaceLg),

          // Question Prompt
          Text(
            currentQ.question,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              fontSize: 17,
            ),
          ),
          const SizedBox(height: AppConstants.spaceLg),

          // Options List
          ...currentQ.options.asMap().entries.map((entry) {
            final optIndex = entry.key;
            final optText = entry.value;

            Color? optionBg;
            Color? borderColor;

            if (_hasSubmittedCurrent) {
              if (optIndex == currentQ.correctIndex) {
                optionBg = AppColors.success.withValues(alpha: 0.15);
                borderColor = AppColors.success;
              } else if (optIndex == _selectedAnswerIndex) {
                optionBg = AppColors.error.withValues(alpha: 0.15);
                borderColor = AppColors.error;
              }
            } else if (optIndex == _selectedAnswerIndex) {
              optionBg = theme.colorScheme.primary.withValues(alpha: 0.12);
              borderColor = theme.colorScheme.primary;
            }

            return Padding(
              padding: const EdgeInsets.only(bottom: AppConstants.spaceSm),
              child: AppCard(
                color: optionBg,
                borderColor: borderColor,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                onTap: _hasSubmittedCurrent ? null : () => _onOptionSelected(optIndex),
                child: Row(
                  children: [
                    Container(
                      width: 28,
                      height: 28,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _hasSubmittedCurrent && optIndex == currentQ.correctIndex
                            ? AppColors.success
                            : (_hasSubmittedCurrent && optIndex == _selectedAnswerIndex
                                ? AppColors.error
                                : (optIndex == _selectedAnswerIndex ? theme.colorScheme.primary : theme.colorScheme.surfaceContainerHigh)),
                      ),
                      child: Center(
                        child: Text(
                          String.fromCharCode(65 + optIndex), // A, B, C, D
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: (_hasSubmittedCurrent && (optIndex == currentQ.correctIndex || optIndex == _selectedAnswerIndex)) ||
                                    optIndex == _selectedAnswerIndex
                                ? Colors.white
                                : theme.colorScheme.onSurface,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: AppConstants.spaceMd),
                    Expanded(
                      child: Text(
                        optText,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: optIndex == _selectedAnswerIndex ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
          const SizedBox(height: AppConstants.spaceMd),

          // Feedback explanation if submitted
          if (_hasSubmittedCurrent) ...[
            StateCallout(
              title: _selectedAnswerIndex == currentQ.correctIndex ? '✓ Correct Answer!' : '✗ Incorrect',
              message: currentQ.explanation,
              type: _selectedAnswerIndex == currentQ.correctIndex ? CalloutType.success : CalloutType.error,
            ),
            const SizedBox(height: AppConstants.spaceMd),
          ],

          // Action Button
          Align(
            alignment: Alignment.centerRight,
            child: _hasSubmittedCurrent
                ? AppButton.primary(
                    label: _currentIndex < _questions.length - 1 ? 'Next Question' : 'Finish Quiz',
                    icon: Icons.arrow_forward_rounded,
                    onPressed: _nextQuestion,
                  )
                : AppButton.primary(
                    label: 'Check Answer',
                    icon: Icons.done_rounded,
                    onPressed: _selectedAnswerIndex != null ? _submitAnswer : null,
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuizScorecard(ThemeData theme) {
    final percentage = ((_score / _questions.length) * 100).toStringAsFixed(0);

    return AppCard(
      padding: const EdgeInsets.all(AppConstants.spaceXl),
      child: Center(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(AppConstants.spaceLg),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: theme.colorScheme.primary.withValues(alpha: 0.12),
              ),
              child: Icon(Icons.emoji_events_rounded, color: theme.colorScheme.primary, size: 54),
            ),
            const SizedBox(height: AppConstants.spaceMd),
            Text(
              'Quiz Completed!',
              style: theme.textTheme.displayMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: AppConstants.spaceXs),
            Text(
              'Your Final Score: $_score / ${_questions.length} ($percentage%)',
              style: TextStyle(
                fontFamily: 'monospace',
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.primary,
              ),
            ),
            const SizedBox(height: AppConstants.spaceMd),
            Text(
              _score >= 12
                  ? 'Outstanding performance! You have mastered Zener breakdown physics and voltage regulation principles.'
                  : 'Good attempt! Review the Theory and Simulator tabs to reinforce breakdown calculations.',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant),
            ),
            const SizedBox(height: AppConstants.spaceLg),
            AppButton.primary(
              label: 'Retry Quiz',
              icon: Icons.replay_rounded,
              onPressed: _resetQuiz,
            ),
          ],
        ),
      ),
    );
  }
}

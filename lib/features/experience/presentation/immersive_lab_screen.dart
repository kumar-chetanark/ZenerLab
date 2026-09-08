import 'package:flutter/material.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/widgets/status_indicator.dart';
import '../../../../theme/app_colors.dart';
import '../../../../theme/app_typography.dart';
import 'sections/analysis_curves_section.dart';
import 'sections/breakdown_moment_section.dart';
import 'sections/calculation_deck_section.dart';
import 'sections/circuit_architecture_section.dart';
import 'sections/experiment_lab_section.dart';
import 'sections/final_cta_section.dart';
import 'sections/hero_section.dart';
import 'sections/how_regulation_works_section.dart';
import 'sections/live_simulator_section.dart';
import 'sections/quiz_viva_section.dart';
import 'sections/theory_textbook_section.dart';

/// Single-page continuous scroll coordinator hosting all 11 modular narrative chapters
class ImmersiveLabScreen extends StatefulWidget {
  const ImmersiveLabScreen({super.key});

  @override
  State<ImmersiveLabScreen> createState() => _ImmersiveLabScreenState();
}

class _ImmersiveLabScreenState extends State<ImmersiveLabScreen> {
  final ScrollController _scrollController = ScrollController();

  final GlobalKey _heroKey = GlobalKey();
  final GlobalKey _architectureKey = GlobalKey();
  final GlobalKey _howWorksKey = GlobalKey();
  final GlobalKey _breakdownKey = GlobalKey();
  final GlobalKey _simulatorKey = GlobalKey();
  final GlobalKey _calculationKey = GlobalKey();
  final GlobalKey _analysisKey = GlobalKey();
  final GlobalKey _experimentKey = GlobalKey();
  final GlobalKey _theoryKey = GlobalKey();
  final GlobalKey _quizKey = GlobalKey();

  void _scrollToKey(GlobalKey key) {
    final context = key.currentContext;
    if (context != null) {
      Scrollable.ensureVisible(
        context,
        duration: const Duration(milliseconds: 700),
        curve: Curves.easeInOutCubic,
      );
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBg,
      body: Stack(
        children: [
          // Main Scrollable Experience
          SingleChildScrollView(
            controller: _scrollController,
            child: Column(
              children: [
                const SizedBox(height: 70), // Header clearance
                Container(key: _heroKey, child: HeroSection(
                  onExplore: () => _scrollToKey(_architectureKey),
                  onStartSimulating: () => _scrollToKey(_simulatorKey),
                )),
                Container(key: _architectureKey, child: const CircuitArchitectureSection()),
                Container(key: _howWorksKey, child: const HowRegulationWorksSection()),
                Container(key: _breakdownKey, child: const BreakdownMomentSection()),
                Container(key: _simulatorKey, child: const LiveSimulatorSection()),
                Container(key: _calculationKey, child: const CalculationDeckSection()),
                Container(key: _analysisKey, child: const AnalysisCurvesSection()),
                Container(key: _experimentKey, child: const ExperimentLabSection()),
                Container(key: _theoryKey, child: const TheoryTextbookSection()),
                Container(key: _quizKey, child: const QuizVivaSection()),
                FinalCtaSection(
                  onSimulateAgain: () => _scrollToKey(_simulatorKey),
                  onTakeQuiz: () => _scrollToKey(_quizKey),
                  onExploreTheory: () => _scrollToKey(_theoryKey),
                ),
              ],
            ),
          ),

          // Floating Minimal Studio Navigation Bar
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 64,
              padding: const EdgeInsets.symmetric(horizontal: AppConstants.spaceLg),
              decoration: BoxDecoration(
                color: AppColors.darkBg.withValues(alpha: 0.85),
                border: const Border(bottom: BorderSide(color: AppColors.darkBorder)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Logo
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Icon(Icons.bolt_rounded, color: AppColors.darkBg, size: 18),
                      ),
                      const SizedBox(width: AppConstants.spaceSm),
                      Text(
                        'ZENERLAB',
                        style: AppTypography.titleMedium.copyWith(
                          color: AppColors.darkTextPrimary,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 1.0,
                        ),
                      ),
                    ],
                  ),

                  // Navigation Links (Desktop)
                  LayoutBuilder(
                    builder: (context, constraints) {
                      return Row(
                        children: [
                          _buildNavLink('SIMULATE', () => _scrollToKey(_simulatorKey)),
                          _buildNavLink('ANALYSIS', () => _scrollToKey(_analysisKey)),
                          _buildNavLink('EXPERIMENT', () => _scrollToKey(_experimentKey)),
                          _buildNavLink('THEORY', () => _scrollToKey(_theoryKey)),
                          _buildNavLink('QUIZ', () => _scrollToKey(_quizKey)),
                          const SizedBox(width: AppConstants.spaceMd),
                          const StatusIndicator(label: 'ENGINE ACTIVE', type: StatusType.active),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavLink(String label, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(4),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Text(
          label,
          style: AppTypography.labelSmall.copyWith(
            color: AppColors.darkTextSecondary,
            letterSpacing: 0.8,
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/services/pwa_service.dart';
import '../../../../core/widgets/status_indicator.dart';
import '../../../../theme/app_colors.dart';
import '../../../../theme/app_typography.dart';
import 'sections/analysis_curves_section.dart';
import 'sections/apparatus_required_section.dart';
import 'sections/calculation_deck_section.dart';
import 'sections/comprehensive_theory_section.dart';
import 'sections/experiment_lab_section.dart';
import 'sections/final_cta_section.dart';
import 'sections/hero_section.dart';
import 'sections/live_simulator_section.dart';
import 'sections/procedure_section.dart';
import 'sections/quiz_viva_section.dart';
import 'sections/result_conclusion_section.dart';

/// Single-page continuous scroll coordinator structured cleanly into standard Lab Report layout:
/// 1. AIM
/// 2. APPARATUS REQUIRED
/// 3. THEORY (Semiconductor Physics, Formula Wall, 4 Stages, How Regulation Works)
/// 4. PROCEDURE (Part A: Line Reg, Part B: Load Reg, Breakdown Threshold Testing)
/// 5. OBSERVATIONS (Live Workbench, Interactive Characteristic Curves, Sweep Observation Tables)
/// 6. CALCULATIONS (Mathematical Derivation Deck)
/// 7. RESULT & CONCLUSION (Quantitative Metrics, Observations, Viva Quiz, Evaluation)
class ImmersiveLabScreen extends StatefulWidget {
  const ImmersiveLabScreen({super.key});

  @override
  State<ImmersiveLabScreen> createState() => _ImmersiveLabScreenState();
}

class _ImmersiveLabScreenState extends State<ImmersiveLabScreen> {
  final ScrollController _scrollController = ScrollController();

  final GlobalKey _aimKey = GlobalKey();
  final GlobalKey _apparatusKey = GlobalKey();
  final GlobalKey _theoryKey = GlobalKey();
  final GlobalKey _procedureKey = GlobalKey();
  final GlobalKey _observationKey = GlobalKey();
  final GlobalKey _calculationKey = GlobalKey();
  final GlobalKey _resultKey = GlobalKey();
  final GlobalKey _quizKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    PwaService.instance.initialize(() {
      if (mounted) setState(() {});
    });
  }

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
          // Main Scrollable Lab Report Experience
          SingleChildScrollView(
            controller: _scrollController,
            child: Column(
              children: [
                const SizedBox(height: 70), // Header clearance

                // 1. AIM
                Container(
                  key: _aimKey,
                  child: HeroSection(
                    onExplore: () => _scrollToKey(_theoryKey),
                    onStartSimulating: () => _scrollToKey(_observationKey),
                  ),
                ),

                // 2. APPARATUS REQUIRED
                Container(
                  key: _apparatusKey,
                  child: const ApparatusRequiredSection(),
                ),

                // 3. THEORY & WORKING PRINCIPLE (Physics, Formula Wall, 4 Stages, Regulation Principle)
                Container(
                  key: _theoryKey,
                  child: const ComprehensiveTheorySection(),
                ),

                // 4. PROCEDURE (Line Reg, Load Reg, Breakdown Transition Test)
                Container(
                  key: _procedureKey,
                  child: const ProcedureSection(),
                ),

                // 5. OBSERVATIONS (Workbench, Characteristic Curves, Sweep Tables)
                Container(
                  key: _observationKey,
                  child: const Column(
                    children: [
                      LiveSimulatorSection(),
                      AnalysisCurvesSection(),
                      ExperimentLabSection(),
                    ],
                  ),
                ),

                // 6. CALCULATIONS (Live Derivation Deck)
                Container(
                  key: _calculationKey,
                  child: const CalculationDeckSection(),
                ),

                // 7. RESULT & CONCLUSION (Metrics, Results, Conclusions)
                Container(
                  key: _resultKey,
                  child: ResultConclusionSection(
                    onSimulateAgain: () => _scrollToKey(_observationKey),
                    onTakeQuiz: () => _scrollToKey(_quizKey),
                    onExploreTheory: () => _scrollToKey(_theoryKey),
                  ),
                ),

                // 8. ASSESSMENT & VIVA QUIZ (Full Quiz preserved)
                Container(
                  key: _quizKey,
                  child: const QuizVivaSection(),
                ),

                // Lab Wrap-up Footer
                FinalCtaSection(
                  onSimulateAgain: () => _scrollToKey(_observationKey),
                  onTakeQuiz: () => _scrollToKey(_quizKey),
                  onExploreTheory: () => _scrollToKey(_theoryKey),
                ),
              ],
            ),
          ),

          // Floating Studio Navigation Bar with Lab Layout Sections
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
                  InkWell(
                    onTap: () => _scrollToKey(_aimKey),
                    child: Row(
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
                  ),

                  // Navigation Links (Responsive) & Install App Button
                  LayoutBuilder(
                    builder: (context, constraints) {
                      final screenWidth = MediaQuery.of(context).size.width;
                      final bool canInstall = PwaService.instance.canInstall;

                      if (screenWidth < 1100) {
                        return Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (canInstall) ...[
                              _buildInstallButton(compact: true),
                              const SizedBox(width: AppConstants.spaceSm),
                            ],
                            const StatusIndicator(label: 'LAB ONLINE', type: StatusType.active),
                          ],
                        );
                      }
                      return Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _buildNavLink('AIM', () => _scrollToKey(_aimKey)),
                          _buildNavLink('APPARATUS', () => _scrollToKey(_apparatusKey)),
                          _buildNavLink('THEORY', () => _scrollToKey(_theoryKey)),
                          _buildNavLink('PROCEDURE', () => _scrollToKey(_procedureKey)),
                          _buildNavLink('OBSERVATION', () => _scrollToKey(_observationKey)),
                          _buildNavLink('CALCULATIONS', () => _scrollToKey(_calculationKey)),
                          _buildNavLink('RESULT', () => _scrollToKey(_resultKey)),
                          _buildNavLink('VIVA QUIZ', () => _scrollToKey(_quizKey)),
                          if (canInstall) ...[
                            const SizedBox(width: 4),
                            _buildInstallButton(compact: false),
                          ],
                          const SizedBox(width: AppConstants.spaceSm),
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

  Widget _buildInstallButton({required bool compact}) {
    return InkWell(
      onTap: () async {
        final installed = await PwaService.instance.promptInstall();
        if (installed && mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('ZenerLab installed successfully!'),
              backgroundColor: AppColors.primary,
            ),
          );
        }
      },
      borderRadius: BorderRadius.circular(6),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: compact ? 8 : 12, vertical: 6),
        decoration: BoxDecoration(
          color: AppColors.primary.withValues(alpha: 0.15),
          border: Border.all(color: AppColors.primary),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.download_rounded, color: AppColors.primary, size: 14),
            if (!compact) ...[
              const SizedBox(width: 6),
              Text(
                'INSTALL APP',
                style: AppTypography.monoSub.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.8,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildNavLink(String label, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(4),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
        child: Text(
          label,
          style: AppTypography.labelSmall.copyWith(
            color: AppColors.darkTextSecondary,
            letterSpacing: 0.5,
            fontSize: 10,
          ),
        ),
      ),
    );
  }
}

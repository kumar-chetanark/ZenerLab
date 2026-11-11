import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zener_lab/app/app.dart';
import 'package:zener_lab/features/experience/presentation/sections/experiment_lab_section.dart';
import 'package:zener_lab/features/experience/presentation/sections/quiz_viva_section.dart';
import 'package:zener_lab/simulation/simulation.dart';

void main() {
  setUp(() {
    SimulatorController.instance.resetToDefaults();
  });

  group('ZenerLab Laboratory Report Layout Tests', () {
    testWidgets('1. Verify Standard Lab Report Sections & Studio Nav', (WidgetTester tester) async {
      tester.view.physicalSize = const Size(1280, 1200);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      await tester.pumpWidget(const ZenerLabApp());
      await tester.pump(const Duration(milliseconds: 300));

      // Aim Section
      expect(find.text('ZENER LAB'), findsAtLeastNWidgets(1));
      expect(find.text('VOLTAGE REGULATION'), findsAtLeastNWidgets(1));
      expect(find.text('01 — AIM OF THE EXPERIMENT'), findsOneWidget);
      expect(find.text('Enter Live Simulator'), findsOneWidget);
      expect(find.text('Explore Physics Story'), findsOneWidget);

      // Apparatus Required Section
      expect(find.text('02 — APPARATUS REQUIRED'), findsOneWidget);
      expect(find.text('COMPONENTS & LABORATORY INSTRUMENTS'), findsOneWidget);

      // Theory Section (Incorporating Stages, Formula Wall, and Mechanism)
      expect(find.text('03 — THEORY & WORKING PRINCIPLE'), findsOneWidget);
      expect(find.text('SEMICONDUCTOR PHYSICS & REGULATION PRINCIPLE'), findsOneWidget);
      expect(find.text('FOUR PHYSICAL STAGES'), findsOneWidget);
      expect(find.text('HOW REGULATION WORKS'), findsOneWidget);

      // Procedure Section (Incorporating Breakdown Moment)
      expect(find.text('04 — PROCEDURE'), findsOneWidget);
      expect(find.text('STEP-BY-STEP LABORATORY INSTRUCTIONS'), findsOneWidget);
      expect(find.text('THE MOMENT OF REGULATION'), findsOneWidget);

      // Observation Section (Workbench, Curves, Observation Tables)
      expect(find.text('05 — OBSERVATION & SIMULATION WORKBENCH'), findsOneWidget);
      expect(find.text('LIVE INTERACTIVE OBSERVATION WORKBENCH'), findsOneWidget);
      expect(find.text('SYNCHRONIZED ANALYSIS CURVES'), findsOneWidget);
      expect(find.text('EXPERIMENTAL OBSERVATION TABLES'), findsOneWidget);

      // Calculation Section
      expect(find.text('06 — CALCULATIONS & MATHEMATICAL DERIVATION'), findsOneWidget);
      expect(find.text('STEP-BY-STEP CALCULATION'), findsOneWidget);

      // Result & Conclusion Section
      expect(find.text('07 — RESULT & CONCLUSION'), findsOneWidget);
      expect(find.text('EXPERIMENTAL RESULTS & ENGINEERING CONCLUSION'), findsOneWidget);
      expect(find.text('EXPERIMENTAL RESULT'), findsOneWidget);
      expect(find.text('CONCLUSION'), findsOneWidget);

      // Viva Quiz & Final CTA
      expect(find.text('INTERACTIVE QUIZ & VIVA VOCE'), findsOneWidget);
      expect(find.text('UNDERSTAND THE CIRCUIT.'), findsOneWidget);
      expect(find.text('NOT JUST THE FORMULA.'), findsOneWidget);
    });

    testWidgets('2. Interactive Experiment Data Sweep and Table Logging', (WidgetTester tester) async {
      tester.view.physicalSize = const Size(1280, 1200);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      await tester.pumpWidget(const MaterialApp(
        home: Scaffold(
          body: SingleChildScrollView(
            child: ExperimentLabSection(),
          ),
        ),
      ));
      await tester.pump(const Duration(milliseconds: 300));

      await tester.tap(find.text('Generate Full Run Data'));
      await tester.pump(const Duration(milliseconds: 300));

      expect(find.text('Trial #'), findsOneWidget);
      expect(find.text('Line Regulation Calculation & Report'), findsOneWidget);
      expect(find.text('Experiment Curve: Line Regulation (Vin vs Vout)'), findsOneWidget);

      // Switch to Load Regulation
      await tester.tap(find.text('Experiment 2: Load Regulation (VNL - VFL) / VFL'));
      await tester.pump(const Duration(milliseconds: 300));

      await tester.tap(find.text('Generate Full Run Data'));
      await tester.pump(const Duration(milliseconds: 300));

      expect(find.text('Load Regulation Calculation & Report'), findsOneWidget);
      expect(find.text('Experiment Curve: Load Regulation (RL vs Vout)'), findsOneWidget);
    });

    testWidgets('3. Quiz Interactive Answering & Feedback', (WidgetTester tester) async {
      tester.view.physicalSize = const Size(1280, 1200);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      await tester.pumpWidget(const MaterialApp(
        home: Scaffold(
          body: SingleChildScrollView(
            child: QuizVivaSection(),
          ),
        ),
      ));
      await tester.pump(const Duration(milliseconds: 300));

      // Answer Question 1
      await tester.tap(find.text('Reverse Bias'));
      await tester.pump(const Duration(milliseconds: 300));

      await tester.tap(find.text('Check Answer'));
      await tester.pump(const Duration(milliseconds: 300));

      expect(find.text('✓ Correct Answer!'), findsOneWidget);
      expect(find.text('Next Question'), findsOneWidget);
    });
  });
}

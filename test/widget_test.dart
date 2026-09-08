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

  group('ZenerLab Cinematic 3D Immersive Website Tests', () {
    testWidgets('1. Verify 11 Cinematic Chapters & Floating Studio Nav', (WidgetTester tester) async {
      tester.view.physicalSize = const Size(1280, 1200);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      await tester.pumpWidget(const ZenerLabApp());
      await tester.pump(const Duration(milliseconds: 300));

      // Hero Section
      expect(find.text('ZENER LAB'), findsAtLeastNWidgets(1));
      expect(find.text('VOLTAGE REGULATION'), findsAtLeastNWidgets(1));
      expect(find.text('01 — CINEMATIC LABORATORY'), findsOneWidget);
      expect(find.text('Enter Live Simulator'), findsOneWidget);
      expect(find.text('Explore Physics Story'), findsOneWidget);

      // Section 02 & 03
      expect(find.text('02 — PHYSICAL ARCHITECTURE'), findsOneWidget);
      expect(find.text('FOUR PHYSICAL STAGES'), findsOneWidget);
      expect(find.text('03 — PHYSICAL MECHANISM'), findsOneWidget);
      expect(find.text('HOW REGULATION WORKS'), findsOneWidget);

      // Section 04 Breakdown
      expect(find.text('04 — BREAKDOWN TRANSITION'), findsOneWidget);

      // Section 05 Live Simulator
      expect(find.text('05 — LABORATORY WORKBENCH'), findsOneWidget);
      expect(find.text('LIVE INTERACTIVE SIMULATOR'), findsOneWidget);

      // Section 06 & 07 Derivation and Curves
      expect(find.text('06 — LIVE MATHEMATICAL DERIVATION'), findsOneWidget);
      expect(find.text('07 — MATHEMATICAL CHARACTERIZATION'), findsOneWidget);
      expect(find.text('SYNCHRONIZED ANALYSIS CURVES'), findsOneWidget);

      // Section 08 Experiment
      expect(find.text('08 — PRACTICAL EXPERIMENTATION'), findsOneWidget);
      expect(find.text('VIRTUAL ELECTRONICS LABORATORY BENCH'), findsOneWidget);

      // Section 09 & 10 Theory and Quiz
      expect(find.text('09 — THEORETICAL FOUNDATION'), findsOneWidget);
      expect(find.text('SEMICONDUCTOR PHYSICS & FORMULA WALL'), findsOneWidget);
      expect(find.text('10 — ASSESSMENT & VIVA PREPARATION'), findsOneWidget);

      // Section 11 Final CTA
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

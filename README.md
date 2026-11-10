# ZenerLab — Zener Diode Voltage Regulation Simulator

An interactive digital electronics laboratory and simulation tool built with Flutter to study, experiment with, and visualize Zener diode voltage regulation circuits in real time.

Live Web Demo: https://kumar-chetanark.github.io/ZenerLab/

---

## Overview

When studying analog electronics, understanding how a Zener diode maintains a constant output voltage across varying input voltages and load conditions can be tricky from static textbook diagrams alone.

I created **ZenerLab** as a hands-on learning workstation where you can:
- Interact directly with the circuit schematic in real time.
- Vary input voltage ($V_{in}$), series resistance ($R_s$), and load resistance ($R_L$).
- Observe instantaneous transitions between operating modes:
  - **Below Breakdown / Unregulated State** ($V_{in} < V_z$)
  - **Normal Regulation Mode** ($I_z > I_{z_{min}}$)
  - **Heavy Load Drop** ($I_z \le 0$)
  - **Over-Current & Over-Power Warnings** ($I_z > I_{z_{max}}$, $P_z > P_{z_{max}}$)
- Analyze synchronized characteristic curves ($V_{out}$ vs $V_{in}$, $I_z$ vs $V_{in}$, and Regulation vs Load).
- Log experimental data points and export them to CSV.
- Test conceptual understanding with a built-in assessment/viva quiz module.

---

## Features

### 1. Interactive 3D Circuit Workbench
- Isometric circuit projection drawn on canvas showing the DC power source, series resistor ($R_s$), Zener diode ($V_z$), load resistor ($R_L$), and digital voltage probe.
- Animated current particles showing physical electron flow dynamically scaled by actual simulated milliampere values.
- Direct-entry typable tuners and rotary dials for fast parameter adjustments.

### 2. Physics & Calculation Engine
- Live nodal calculations strictly implementing standard electrical formulas:
  - $I_s = \frac{V_{in} - V_{out}}{R_s}$
  - $I_L = \frac{V_{out}}{R_L}$
  - $I_z = I_s - I_L$
  - $P_z = V_z \times I_z$
- Step-by-step mathematical breakdown showing every intermediate value and substitution in real time.

### 3. Synchronized Characteristic Curves
- Live plots rendered with custom painters:
  - **Line Regulation:** Output Voltage ($V_{out}$) vs Input Voltage ($V_{in}$).
  - **Diode Current:** Zener Current ($I_z$) vs Input Voltage ($V_{in}$).
  - **Load Regulation:** Output Voltage ($V_{out}$) vs Load Resistance ($R_L$).
- Active operating point indicator tracked on the curves in real time.

### 4. Virtual Experiment Deck
- Run automated parameter sweeps across varying $V_{in}$ and $R_L$.
- Log measured values ($V_{in}$, $V_{out}$, $I_s$, $I_z$, $I_L$, and diode state) into an observation table.
- One-click CSV export for lab reports.

### 5. Viva & Assessment Module
- Multiple-choice questions covering semiconductor physics, breakdown mechanisms (Zener vs Avalanche breakdown), and regulation conditions with explanations.

### 6. Multi-Platform Support
- **Web / PWA:** Runs in any browser with offline caching and standalone installation.
- **Android APK:** Pre-built release APK available under GitHub Releases.

---

## Project Structure

```text
lib/
├── app/                  # Application root & shell navigation
├── core/
│   ├── constants/        # Layout spacing, breakpoints, sizing
│   ├── services/         # PWA service and interop
│   ├── utils/            # Responsive helpers
│   └── widgets/          # Shared cards, badges, and button components
├── features/
│   ├── experience/       # Immersive guided laboratory walkthrough
│   ├── simulator/        # Circuit canvas, interactive tuners, and meters
│   ├── analysis/         # Synchronized characteristic curve plots
│   ├── experiment/       # Automated sweep tables and CSV export
│   ├── theory/           # Formula references and semiconductor theory
│   └── quiz/             # Viva questions and score evaluation
├── simulation/
│   ├── models/           # Zener circuit parameters & simulation results
│   ├── formulas/         # Formula definitions and calculation steps
│   └── services/         # Pure Dart simulation engine & sweep logic
└── theme/                # Custom dark palette and typography
```

---

## Getting Started

### Prerequisites
- [Flutter SDK](https://docs.flutter.dev/get-started/install) (v3.0.0 or higher)
- Google Chrome (for web) or Android Studio / Android Device (for mobile)

### Installation & Run

1. **Clone the repository:**
   ```bash
   git clone https://github.com/kumar-chetanark/ZenerLab.git
   cd ZenerLab
   ```

2. **Get dependencies:**
   ```bash
   flutter pub get
   ```

3. **Run on Chrome (Web):**
   ```bash
   flutter run -d chrome
   ```

4. **Run on Android Device:**
   ```bash
   flutter run -d android
   ```

5. **Run test suite:**
   ```bash
   flutter test
   ```

---

## Building

- **Web (Release):**
  ```bash
  flutter build web --release
  ```

- **Android APK (Release):**
  ```bash
  flutter build apk --release
  ```
  The compiled APK will be located at `build/app/outputs/flutter-apk/app-release.apk`.

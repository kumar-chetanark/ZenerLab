# ZenerLab — Zener Diode Voltage Regulation Simulator

An interactive digital electronics laboratory and simulation tool built with Flutter to study, experiment with, and visualize Zener diode voltage regulation circuits in real time.

Live Web Demo: https://kumar-chetanark.github.io/ZenerLab/

---

## Laboratory Experiment Layout

The application is structured into the standard formal laboratory report format:

1. **AIM OF THE EXPERIMENT**: Study the operation of a Zener diode as a shunt voltage regulator and analyze its Line Regulation and Load Regulation characteristics.
2. **APPARATUS REQUIRED**: Complete catalog of circuit components, rated series resistors, variable decade loads, DC supplies, and measuring meters.
3. **THEORY & WORKING PRINCIPLE**:
   - Semiconductor physics of reverse breakdown (Zener tunneling vs Avalanche multiplication).
   - Core governing formula wall ($V_{out}$, $I_s$, $I_L$, $I_z$, $P_z$).
   - Four physical circuit stages (DC Source, Series Resistor, Zener Diode Clamp, Load Terminal).
   - Step-by-step physical regulation mechanism.
4. **PROCEDURE**:
   - **Part A:** Line Regulation step-by-step instructions.
   - **Part B:** Load Regulation step-by-step instructions.
   - Interactive breakdown threshold transition test.
5. **OBSERVATIONS**:
   - Live interactive 3D circuit workbench with real-time particle electron flow.
   - Synchronized characteristic curves (Line Regulation, Diode Current, Load Regulation).
   - Automated parameter sweep observation tables with CSV data export.
6. **CALCULATIONS**:
   - Live mathematical derivation deck computing intermediate equations and nodal values step by step.
7. **RESULT & CONCLUSION**:
   - Quantitative evaluation of Line Regulation factor (%) and Load Regulation factor (%).
   - Formal technical conclusions and operating criteria.
8. **VIVA VOCE & EVALUATION**:
   - Interactive quiz with instantaneous evaluation, score tracking, and explanations.

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

### 6. Progressive Web App (PWA)
- Runs in any browser with offline caching and standalone installation.

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
│   ├── experience/       # Standard Lab Report layout (Aim, Apparatus, Theory, Procedure, Observation, Calculations, Result)
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
- Google Chrome or any modern web browser

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

4. **Run test suite:**
   ```bash
   flutter test
   ```

---

## Building

- **Web (Release):**
  ```bash
  flutter build web --release
  ```

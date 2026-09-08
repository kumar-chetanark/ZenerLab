/// Question structure for the interactive electronics knowledge quiz.
class QuizQuestion {
  final int id;
  final String question;
  final List<String> options;
  final int correctIndex;
  final String explanation;
  final String category;

  const QuizQuestion({
    required this.id,
    required this.question,
    required this.options,
    required this.correctIndex,
    required this.explanation,
    required this.category,
  });
}

/// Curated question bank containing 15 high-quality conceptual and calculation quiz items.
class QuizQuestionBank {
  QuizQuestionBank._();

  static const List<QuizQuestion> questions = [
    QuizQuestion(
      id: 1,
      category: 'Breakdown Mechanism',
      question: 'In a Zener diode voltage regulator circuit, in which bias condition is the diode connected?',
      options: [
        'Forward Bias',
        'Reverse Bias',
        'Unbiased',
        'Alternating Bias',
      ],
      correctIndex: 1,
      explanation: 'A Zener diode is connected in reverse bias across the load so that it operates in its reverse breakdown region, maintaining constant voltage Vz.',
    ),
    QuizQuestion(
      id: 2,
      category: 'Operating Principle',
      question: 'What happens to the output voltage (Vout) when the input DC voltage (Vin) increases within the normal regulation range?',
      options: [
        'Vout increases proportionally with Vin',
        'Vout drops to zero',
        'Vout remains approximately constant equal to Vz',
        'Vout oscillates continuously',
      ],
      correctIndex: 2,
      explanation: 'When operating in reverse breakdown, the Zener diode clamps Vout at Vz. The excess voltage is dropped across the series resistor Rs as series current increases.',
    ),
    QuizQuestion(
      id: 3,
      category: 'Circuit Analysis',
      question: 'According to Kirchhoff’s Current Law (KCL) at the output node, what is the formula for Zener current (Iz)?',
      options: [
        'Iz = Is + IL',
        'Iz = Is - IL',
        'Iz = IL - Is',
        'Iz = Is × IL',
      ],
      correctIndex: 1,
      explanation: 'Total current from the series resistor Is divides into Zener current Iz and load current IL (Is = Iz + IL). Therefore, Iz = Is - IL.',
    ),
    QuizQuestion(
      id: 4,
      category: 'Breakdown Physics',
      question: 'Which breakdown mechanism dominates in Zener diodes with breakdown voltages below 5V?',
      options: [
        'Avalanche Breakdown via impact ionization',
        'Thermal Breakdown via Joule heating',
        'Zener Breakdown via direct quantum tunneling of electrons',
        'Dielectric Breakdown',
      ],
      correctIndex: 2,
      explanation: 'Heavily doped diodes have very narrow depletion regions (< 10 nm) where high electric fields pull electrons directly from valence to conduction band (quantum tunneling).',
    ),
    QuizQuestion(
      id: 5,
      category: 'Calculation',
      question: 'If Vin = 12V, Vz = 5.1V, and Rs = 330Ω, what is the total series current (Is) entering the regulator in breakdown?',
      options: [
        '36.36 mA',
        '20.91 mA',
        '15.45 mA',
        '51.00 mA',
      ],
      correctIndex: 1,
      explanation: 'Is = (Vin - Vout) / Rs = (12 - 5.1) / 330 = 6.9 / 330 = 0.02091 A = 20.91 mA.',
    ),
    QuizQuestion(
      id: 6,
      category: 'Load Regulation',
      question: 'What happens to the Zener current (Iz) if the load resistance (RL) is significantly decreased (heavy load)?',
      options: [
        'Iz increases',
        'Iz decreases because the load draws more current (IL)',
        'Iz remains constant',
        'Iz reverses polarity',
      ],
      correctIndex: 1,
      explanation: 'As RL decreases, IL = Vz/RL increases. Since Is is fixed by (Vin - Vz)/Rs, Iz = Is - IL must decrease. If Iz drops below IzMin, regulation fails.',
    ),
    QuizQuestion(
      id: 7,
      category: 'Component Selection',
      question: 'Why is a series resistor (Rs) mandatory in a Zener diode voltage regulator circuit?',
      options: [
        'To boost the output voltage',
        'To limit the maximum current flowing into the diode and absorb excess voltage',
        'To convert DC into AC',
        'To reduce the Zener breakdown potential',
      ],
      correctIndex: 1,
      explanation: 'Without Rs, an input voltage above Vz would force near-infinite current through the low-impedance breakdown diode, instantly burning it out.',
    ),
    QuizQuestion(
      id: 8,
      category: 'Power Dissipation',
      question: 'How is the power dissipation (Pz) of the Zener diode calculated in the breakdown region?',
      options: [
        'Pz = Vin × Is',
        'Pz = Vz × Iz',
        'Pz = Vout² / Rs',
        'Pz = Is² × RL',
      ],
      correctIndex: 1,
      explanation: 'Pz is the product of the breakdown voltage across the diode and the reverse current flowing through it: Pz = Vz × Iz.',
    ),
    QuizQuestion(
      id: 9,
      category: 'Unregulated Condition',
      question: 'If the input voltage Vin is so low that Vin × RL / (Rs + RL) < Vz, what is the Zener current (Iz)?',
      options: [
        'Iz = 0 A (Diode is non-conducting)',
        'Iz = IzMin',
        'Iz = Vin / Rs',
        'Iz = -5 mA',
      ],
      correctIndex: 0,
      explanation: 'Because the reverse bias voltage is below the Zener threshold, the diode is OFF and acts as an open circuit (Iz = 0A).',
    ),
    QuizQuestion(
      id: 10,
      category: 'Temperature Coefficient',
      question: 'What is the temperature coefficient of Zener diodes with breakdown voltages greater than 6V (Avalanche dominant)?',
      options: [
        'Zero',
        'Negative temperature coefficient',
        'Positive temperature coefficient',
        'Infinite',
      ],
      correctIndex: 2,
      explanation: 'In avalanche breakdown, increased lattice vibrations with temperature increase carrier collisions, requiring a higher voltage to achieve breakdown (+ve temp coefficient).',
    ),
    QuizQuestion(
      id: 11,
      category: 'Formula Definition',
      question: 'What is the ideal Line Regulation percentage for a perfect voltage regulator?',
      options: [
        '100%',
        '50%',
        '0%',
        '10%',
      ],
      correctIndex: 2,
      explanation: 'Ideal line regulation means ΔVout = 0V when Vin changes, which corresponds to 0% line regulation.',
    ),
    QuizQuestion(
      id: 12,
      category: 'Circuit Safety',
      question: 'When is a Zener diode in danger of maximum power destruction (Over-Power)?',
      options: [
        'At maximum Vin and minimum load current (RL = open circuit)',
        'At minimum Vin and maximum load current',
        'When Vin is disconnected',
        'When RL is zero (short circuit)',
      ],
      correctIndex: 0,
      explanation: 'Under no-load (RL = ∞) and maximum Vin, load current IL = 0, so the entire series current Is passes through the Zener, maximizing Pz.',
    ),
    QuizQuestion(
      id: 13,
      category: 'Viva Question',
      question: 'What is the dynamic resistance (Rz) of an ideal Zener diode in its breakdown region?',
      options: [
        'Infinite (∞ Ω)',
        'Zero (0 Ω)',
        '100 Ω',
        '1 kΩ',
      ],
      correctIndex: 1,
      explanation: 'An ideal Zener diode has a vertical I-V breakdown curve with zero dynamic resistance (Rz = ΔVz / ΔIz = 0Ω).',
    ),
    QuizQuestion(
      id: 14,
      category: 'Calculation',
      question: 'For Vz = 5V, Vin = 10V, Rs = 100Ω, and RL = 500Ω, what is the load current IL?',
      options: [
        '50 mA',
        '10 mA',
        '25 mA',
        '5 mA',
      ],
      correctIndex: 1,
      explanation: 'IL = Vout / RL = 5V / 500Ω = 0.01 A = 10 mA.',
    ),
    QuizQuestion(
      id: 15,
      category: 'Viva Question',
      question: 'What is the primary commercial application of Zener diodes?',
      options: [
        'Half-wave power rectification',
        'Voltage regulation and reference voltage generation',
        'Light emission in displays',
        'Audio amplification',
      ],
      correctIndex: 1,
      explanation: 'Zener diodes are primarily used as shunt voltage regulators and stable reference voltage sources in power supplies and analog instrumentation.',
    ),
  ];
}

/// Common Viva Questions and succinct model answers for lab examinations
class VivaQuestionItem {
  final String question;
  final String answer;

  const VivaQuestionItem({
    required this.question,
    required this.answer,
  });

  static const List<VivaQuestionItem> all = [
    VivaQuestionItem(
      question: '1. What is a Zener diode and how does it differ from a conventional diode?',
      answer: 'A Zener diode is a heavily doped silicon PN junction diode engineered to operate continuously in the reverse breakdown region without damage. Conventional rectifier diodes are moderately doped and burn out if pushed into reverse breakdown.',
    ),
    VivaQuestionItem(
      question: '2. What is the role of the series resistor Rs in the regulator circuit?',
      answer: 'Rs serves two vital functions: (1) It drops the excess voltage (Vin - Vz), and (2) it limits the series current to prevent the Zener diode from exceeding its maximum power dissipation rating (PzMax).',
    ),
    VivaQuestionItem(
      question: '3. What are the two types of breakdown in semiconductor diodes?',
      answer: 'Zener breakdown (occurs below 5V due to high-field direct valence electron quantum tunneling) and Avalanche breakdown (occurs above 6V due to impact ionization from accelerated minority carriers).',
    ),
    VivaQuestionItem(
      question: '4. What happens when the input voltage (Vin) increases in a regulating circuit?',
      answer: 'The output voltage (Vout) remains clamped at Vz. The excess input voltage increases current through the series resistor Rs, which is shunted safely to ground through the Zener diode (Iz increases).',
    ),
    VivaQuestionItem(
      question: '5. What happens when the load resistance (RL) is decreased?',
      answer: 'Load current IL increases (IL = Vz/RL). Since series current Is is fixed for constant Vin, the additional load current is taken from the Zener diode (Iz decreases). If RL becomes too small, Iz drops below IzMin and regulation fails.',
    ),
    VivaQuestionItem(
      question: '6. What is the condition for the Zener diode to enter regulation?',
      answer: 'The open-circuit voltage produced by the resistive voltage divider must be greater than or equal to the Zener breakdown voltage: Vin × RL / (Rs + RL) ≥ Vz.',
    ),
    VivaQuestionItem(
      question: '7. Define Line Regulation and Load Regulation.',
      answer: 'Line Regulation is the change in output voltage per unit change in input voltage (ΔVout / ΔVin). Load Regulation is the percentage change in output voltage from no-load to full-load: [(V_NL - V_FL) / V_FL] × 100%.',
    ),
    VivaQuestionItem(
      question: '8. What is the worst-case condition for Zener power dissipation?',
      answer: 'No-load condition (RL = ∞) at maximum input voltage (Vin_max). Here, IL = 0, so all series current flows through the Zener diode, maximizing Pz = Vz × Is.',
    ),
  ];
}

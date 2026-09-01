class Achievement {
  final String id;
  final String title;
  final String description;
  final int target;
  final String metric;

  const Achievement({
    required this.id,
    required this.title,
    required this.description,
    required this.target,
    required this.metric,
  });
}

const achievements = <Achievement>[
  Achievement(
    id: 'first_match',
    title: 'First Spark',
    description: 'Score your first match.',
    target: 1,
    metric: 'best_score',
  ),
  Achievement(
    id: 'score_25',
    title: 'Locked In',
    description: 'Reach a score of 25.',
    target: 25,
    metric: 'best_score',
  ),
  Achievement(
    id: 'score_75',
    title: 'Neon Nerves',
    description: 'Reach a score of 75.',
    target: 75,
    metric: 'best_score',
  ),
  Achievement(
    id: 'combo_10',
    title: 'Combo Circuit',
    description: 'Reach a 10x combo.',
    target: 10,
    metric: 'best_combo',
  ),
  Achievement(
    id: 'combo_25',
    title: 'Untouchable',
    description: 'Reach a 25x combo.',
    target: 25,
    metric: 'best_combo',
  ),
  Achievement(
    id: 'games_10',
    title: 'Regular',
    description: 'Finish 10 runs.',
    target: 10,
    metric: 'games',
  ),
  Achievement(
    id: 'perfect_100',
    title: 'Precision Core',
    description: 'Land 100 perfect matches total.',
    target: 100,
    metric: 'perfects',
  ),
];

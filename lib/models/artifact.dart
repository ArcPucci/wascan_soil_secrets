enum LuckyStatus { lucky, unlucky, neutral }

class Artifact {
  final int id;
  final int score;
  final LuckyStatus luckyStatus;

  Artifact({
    required this.id,
    required this.score,
    required this.luckyStatus,
  });
}

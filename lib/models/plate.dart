/*
* plate types
* 0: stone
* 1: +25
* 2: +15
* 3: 10
* 4: jackpot
* 5: lucky
* 6: fail
* */
enum PlateType { empty, positive, fail, jackpot, lucky }

class Plate {
  final int id;
  final PlateType plateType;
  final int score;
  final String asset;

  Plate({
    required this.id,
    required this.plateType,
    required this.score,
    required this.asset,
  });
}

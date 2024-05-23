import 'package:wascan_soil_secrets/models/models.dart';

final List<Plate> plateTypes = [
  Plate(
    id: 0,
    plateType: PlateType.empty,
    score: 0,
    asset: "assets/png/plate/stone.png",
  ),
  Plate(
    id: 1,
    plateType: PlateType.positive,
    score: 25,
    asset: "assets/png/plate/twenty_five_score.png",
  ),
  Plate(
    id: 2,
    plateType: PlateType.positive,
    score: 15,
    asset: "assets/png/plate/fifteen_score.png",
  ),
  Plate(
    id: 3,
    plateType: PlateType.positive,
    score: 10,
    asset: "assets/png/plate/ten_score.png",
  ),
  Plate(
    id: 4,
    plateType: PlateType.jackpot,
    score: 0,
    asset: "assets/png/plate/jackpot.png",
  ),
  Plate(
    id: 5,
    plateType: PlateType.lucky,
    score: 0,
    asset: "assets/png/plate/plate_lucky.png",
  ),
  Plate(
    id: 6,
    plateType: PlateType.fail,
    score: -20,
    asset: "assets/png/plate/fail.png",
  ),
];
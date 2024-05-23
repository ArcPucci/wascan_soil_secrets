import 'package:flutter/material.dart';
import 'package:wascan_soil_secrets/models/plate.dart';

class PlateWidget extends StatelessWidget {
  const PlateWidget({
    Key? key,
    required this.plate,
    required this.isVisible,
    required this.isUser,
    required this.playerSkin,
    required this.plateAsset,
  }) : super(key: key);

  final Plate plate;
  final bool isVisible;
  final bool isUser;
  final String playerSkin;
  final String plateAsset;

  @override
  Widget build(BuildContext context) {
    if (isUser) {
      return Image.asset(
        playerSkin,
        fit: BoxFit.cover,
      );
    } else if (isVisible) {
      return Image.asset(
        plate.asset,
        fit: BoxFit.cover,
      );
    } else {
      return Image.asset(
        plateAsset,
        fit: BoxFit.cover,
      );
    }
  }
}

part of 'config_bloc.dart';

@immutable
class ConfigState {
  final int points;
  final String playerSkin;
  final String backgroundSkin;
  final bool isPremium;
  final List<String> playerSkins;
  final List<String> backgroundSkins;
  final String plateAsset;

  const ConfigState({
    required this.plateAsset,
    required this.points,
    required this.playerSkin,
    required this.backgroundSkin,
    required this.isPremium,
    required this.playerSkins,
    required this.backgroundSkins,
  });


  ConfigState copyWith({
    int? points,
    String? playerSkin,
    String? backgroundSkin,
    List<String>? playerSkins,
    List<String>? backgroundSkins,
    bool? isPremium,
    String? plateAsset,
  }) {
    return ConfigState(
      plateAsset: plateAsset ?? this.plateAsset,
      points: points ?? this.points,
      playerSkin: playerSkin ?? this.playerSkin,
      backgroundSkin: backgroundSkin ?? this.backgroundSkin,
      isPremium: isPremium ?? this.isPremium,
      backgroundSkins: backgroundSkins ?? this.backgroundSkins,
      playerSkins: playerSkins ?? this.playerSkins,
    );
  }

  factory ConfigState.empty() => const ConfigState(
        plateAsset: "assets/png/plate/plate_1.png",
        points: 1000,
        playerSkin: "assets/png/player_skins/bast.png",
        backgroundSkin: "assets/png/background_skins/background_1.png",
        isPremium: false,
        backgroundSkins: ["assets/png/background_skins/background_1.png"],
        playerSkins: ["assets/png/player_skins/bast.png"],
      );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ConfigState &&
          runtimeType == other.runtimeType &&
          points == other.points &&
          playerSkin == other.playerSkin &&
          backgroundSkin == other.backgroundSkin &&
          isPremium == other.isPremium &&
          playerSkins == other.playerSkins &&
          backgroundSkins == other.backgroundSkins &&
          plateAsset == other.plateAsset;

  @override
  int get hashCode =>
      points.hashCode ^
      playerSkin.hashCode ^
      backgroundSkin.hashCode ^
      isPremium.hashCode ^
      playerSkins.hashCode ^
      backgroundSkins.hashCode ^
      plateAsset.hashCode;
}

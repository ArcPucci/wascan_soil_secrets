part of 'game_bloc.dart';

enum GamingProcess { jackpot, lucky, endGame, playing }

@immutable
class GameState {
  final int userPosition;
  final Set<int> visiblePlates;
  final List<Plate> plates;
  final int collectedPoints;
  final GamingProcess gamingProcess;
  final Artifact artifact;
  final Set<int> collectedPlates;
  final bool abilityUsed;
  final int counter;
  final bool abilityInActive;
  final PlayerSkin playerSkin;
  final List<int> randomPlates;

  const GameState({
    required this.randomPlates,
    required this.playerSkin,
    required this.abilityUsed,
    required this.counter,
    required this.abilityInActive,
    required this.collectedPlates,
    required this.artifact,
    required this.userPosition,
    required this.visiblePlates,
    required this.plates,
    required this.collectedPoints,
    required this.gamingProcess,
  });

  GameState copyWith({
    Set<int>? visiblePlates,
    int? userPosition,
    List<Plate>? plates,
    int? collectedPoints,
    GamingProcess? gamingProcess,
    Artifact? artifact,
    Set<int>? collectedPlates,
    PlayerSkin? playerSkin,
    bool? abilityUsed,
    bool? abilityInActive,
    int? counter,
    List<int>? randomPlates,
  }) {
    return GameState(
      randomPlates: randomPlates ?? this.randomPlates,
      playerSkin: playerSkin ?? this.playerSkin,
      abilityUsed: abilityUsed ?? this.abilityUsed,
      counter: counter ?? this.counter,
      abilityInActive: abilityInActive ?? this.abilityInActive,
      collectedPlates: collectedPlates ?? this.collectedPlates,
      artifact: artifact ?? this.artifact,
      gamingProcess: gamingProcess ?? this.gamingProcess,
      userPosition: userPosition ?? this.userPosition,
      visiblePlates: visiblePlates ?? this.visiblePlates,
      plates: plates ?? this.plates,
      collectedPoints: collectedPoints ?? this.collectedPoints,
    );
  }

  factory GameState.empty() => GameState(
        randomPlates: const [],
        playerSkin: playerSkins[0],
        abilityUsed: false,
        counter: 15,
        abilityInActive: false,
        collectedPlates: const {0},
        artifact: artifacts[0],
        gamingProcess: GamingProcess.playing,
        userPosition: 0,
        visiblePlates: const {0},
        plates: const [],
        collectedPoints: 0,
      );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GameState &&
          runtimeType == other.runtimeType &&
          userPosition == other.userPosition &&
          visiblePlates == other.visiblePlates &&
          plates == other.plates &&
          collectedPoints == other.collectedPoints &&
          gamingProcess == other.gamingProcess &&
          artifact == other.artifact &&
          collectedPlates == other.collectedPlates &&
          abilityUsed == other.abilityUsed &&
          counter == other.counter &&
          abilityInActive == other.abilityInActive &&
          playerSkin == other.playerSkin &&
          randomPlates == other.randomPlates;

  @override
  int get hashCode =>
      userPosition.hashCode ^
      visiblePlates.hashCode ^
      plates.hashCode ^
      collectedPoints.hashCode ^
      gamingProcess.hashCode ^
      artifact.hashCode ^
      collectedPlates.hashCode ^
      abilityUsed.hashCode ^
      counter.hashCode ^
      abilityInActive.hashCode ^
      playerSkin.hashCode ^
      randomPlates.hashCode;
}

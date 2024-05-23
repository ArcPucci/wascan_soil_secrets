import 'dart:async';
import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:wascan_soil_secrets/blocs/config_bloc/config_bloc.dart';
import 'package:wascan_soil_secrets/models/artifact.dart';
import 'package:wascan_soil_secrets/models/plate.dart';
import 'package:wascan_soil_secrets/models/player_skin.dart';
import 'package:wascan_soil_secrets/utils/lucky_artifacts.dart';
import 'package:wascan_soil_secrets/utils/plates.dart';
import 'package:wascan_soil_secrets/utils/player_skins.dart';

part 'game_event.dart';

part 'game_state.dart';

class GameBloc extends Bloc<GameEvent, GameState> {
  late StreamSubscription _streamSubscription;

  final ConfigBloc configBloc;

  GameBloc(this.configBloc) : super(GameState.empty()) {
    on<InitGameEvent>(_onInitGameEvent);
    on<UserMoving>(_onUserMoves);
    on<ContinueGameEvent>(_onContinueGame);
    on<FinishGameEvent>(_onFinishGame);
    on<UseAbilityGameEvent>(_onUseAbilityGameEvent);
    on<_UpdateTimerGameEvent>(_onUpdateTimerGameEvent);
    on<ChangePersonEvent>(_onChangePerson);
    on<RestartGameEvent>(_onRestartGameEvent);
  }

  FutureOr<void> _onInitGameEvent(
      InitGameEvent event, Emitter<GameState> emit) async {
    final List<Plate> plates = List.generate(
      80,
      (index) => plateTypes[0],
    );
    final randomArtifactIndex = Random().nextInt(3);
    final Artifact artifact = artifacts[randomArtifactIndex];
    final List<int> randomPlates = [];

    int randomPlate = 0;
    int randomPlateType = 0;

    for (int i = 0; i <= 25; i++) {
      randomPlate = Random().nextInt(79) + 1;
      randomPlates.add(randomPlate);
      randomPlateType = Random().nextInt(6) + 1;
      plates[randomPlate] = plateTypes[randomPlateType];
    }

    emit(
      state.copyWith(
        randomPlates: randomPlates,
        userPosition: 0,
        collectedPoints: 0,
        artifact: artifact,
        plates: plates,
        collectedPlates: {0},
        abilityInActive: false,
        abilityUsed: false,
        visiblePlates: {0},
        counter: state.playerSkin.abilityDuration,
        gamingProcess: GamingProcess.playing,
      ),
    );
  }

  FutureOr<void> _onUserMoves(UserMoving event, Emitter<GameState> emit) async {
    final collectedPlates = {...state.collectedPlates};
    final visiblePlates = {
      ...collectedPlates,
      ...state.visiblePlates,
      state.userPosition
    };
    final userPosition = event.newUserPosition;
    final lastPosition = state.userPosition;
    final Plate plate = state.plates[lastPosition];
    final PlateType plateType = plate.plateType;

    int points = configBloc.state.points;
    int collectedPoints = state.collectedPoints;

    if (collectedPlates.isNotEmpty && userPosition == 0) {
      return add(FinishGameEvent());
    }

    if (!collectedPlates.contains(lastPosition)) {
      if (state.abilityInActive &&
          plate.plateType == PlateType.positive &&
          state.playerSkin.id == 0) {
        collectedPoints += plate.score * 2;
      } else if (plate.plateType == PlateType.positive) {
        collectedPoints += plate.score;
      }
      if (plateType == PlateType.lucky) {
        emit(
          state.copyWith(gamingProcess: GamingProcess.lucky),
        );
      } else if (plateType == PlateType.jackpot) {
        emit(
          state.copyWith(gamingProcess: GamingProcess.jackpot),
        );
      } else if (plateType == PlateType.fail) {
        if (!((state.playerSkin.id == 2 || state.playerSkin.id == 4) &&
            state.abilityInActive)) {
          if (collectedPoints + plate.score >= 0) {
            collectedPoints += plate.score;
          } else {
            collectedPoints = 0;
          }
          if (points - points * 0.05 >= 0) {
            points -= (points * 0.05).round();
          } else {
            points = 0;
          }
        }
      }
      collectedPlates.add(lastPosition);
    }

    configBloc.add(SavePointsConfigEvent(points));

    emit(
      state.copyWith(
        gamingProcess: GamingProcess.playing,
        userPosition: userPosition,
        visiblePlates: visiblePlates,
        collectedPoints: collectedPoints,
        collectedPlates: collectedPlates,
      ),
    );
  }

  FutureOr<void> _onContinueGame(
      ContinueGameEvent event, Emitter<GameState> emit) async {
    final randomArtifactIndex = Random().nextInt(3);
    final Artifact newArtifact = artifacts[randomArtifactIndex];
    Artifact artifact = state.artifact;
    int collectedPoints = state.collectedPoints;
    double jackpotCoefficient = 1;

    if (event.jackpotCoefficient != null) {
      jackpotCoefficient = event.jackpotCoefficient!;
    }

    if (!(state.playerSkin.id == 2 &&
        state.abilityInActive &&
        state.artifact.luckyStatus == LuckyStatus.unlucky)) {
      if (collectedPoints + artifact.score > 0) {
        collectedPoints += artifact.score;
      }
    }

    collectedPoints = (collectedPoints * jackpotCoefficient).round();

    emit(state.copyWith(
      artifact: newArtifact,
      gamingProcess: GamingProcess.playing,
      collectedPoints: collectedPoints,
    ));
  }

  FutureOr<void> _onFinishGame(
      FinishGameEvent event, Emitter<GameState> emit) async {
    final int collectedCoins = state.collectedPoints;

    emit(
      state.copyWith(
        gamingProcess: GamingProcess.endGame,
        collectedPoints: collectedCoins,
      ),
    );
  }

  FutureOr<void> _onUseAbilityGameEvent(
      UseAbilityGameEvent event, Emitter<GameState> emit) async {
    final visiblePlates = state.visiblePlates;
    final userPosition = state.userPosition;
    emit(state.copyWith(
      abilityInActive: true,
      abilityUsed: true,
    ));
    if (state.playerSkin.id == 1 && state.abilityInActive) {
      if (userPosition % 10 < 9) {
        visiblePlates.add(userPosition + 1);
      }
      if (userPosition % 10 > 0) {
        visiblePlates.add(userPosition - 1);
      }
      if (userPosition + 10 < 80) {
        visiblePlates.add(userPosition + 10);
      }
      if (userPosition - 10 >= 0) {
        visiblePlates.add(userPosition - 10);
      }
      if (userPosition % 10 > 0 && userPosition - 10 >= 0) {
        visiblePlates.add(userPosition - 11);
      }
      if (userPosition % 10 < 9 && userPosition - 10 >= 0) {
        visiblePlates.add(userPosition - 9);
      }
      if (userPosition % 10 > 0 && userPosition + 10 < 80) {
        visiblePlates.add(userPosition + 9);
      }
      if (userPosition % 10 < 9 && userPosition + 10 < 80) {
        visiblePlates.add(userPosition + 11);
      }

      return emit(state.copyWith(
        visiblePlates: visiblePlates,
        abilityInActive: false,
      ));
    }
    _streamSubscription =
        Stream.periodic(const Duration(seconds: 1)).listen(_listener);
  }

  void _listener(event) {
    add(_UpdateTimerGameEvent());
  }

  FutureOr<void> _onUpdateTimerGameEvent(event, Emitter<GameState> emit) async {
    final counter = state.counter - 1;
    if (counter <= 0) {
      if (state.playerSkin.id == 3) {
        emit(state.copyWith(randomPlates: []));
      }
      _streamSubscription.cancel();
      return emit(state.copyWith(
        abilityUsed: true,
        abilityInActive: false,
      ));
    }
    emit(state.copyWith(counter: counter));
  }

  FutureOr<void> _onChangePerson(
      ChangePersonEvent event, Emitter<GameState> emit) async {
    final PlayerSkin playerSkin = event.playerSkin;

    emit(state.copyWith(
      playerSkin: playerSkin,
      counter: playerSkin.abilityDuration,
    ));
  }

  FutureOr<void> _onRestartGameEvent(
      RestartGameEvent event, Emitter<GameState> emit) async {
    final collectedCoins = state.collectedPoints + configBloc.state.points;
    configBloc.add(SavePointsConfigEvent(collectedCoins));
    add(InitGameEvent());
  }
}

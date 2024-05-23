import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:wascan_soil_secrets/models/background_skin.dart';
import 'package:wascan_soil_secrets/models/player_skin.dart';
import 'package:wascan_soil_secrets/services/services.dart';
import 'package:wascan_soil_secrets/utils/player_skins.dart';

part 'config_event.dart';

part 'config_state.dart';

class ConfigBloc extends Bloc<ConfigEvent, ConfigState> {
  final PreferenceService preferenceService;

  ConfigBloc(this.preferenceService) : super(ConfigState.empty()) {
    on<InitConfigEvent>(_onInit);
    on<BuyPremiumConfigEvent>(_onBuyPremiumConfigEvent);
    on<SelectPlayerSkin>(_onSelectPlayerSkin);
    on<SelectBackgroundSkin>(_onSelectBackgroundSkin);
    on<SavePointsConfigEvent>(_onSaveConfigEvent);
  }

  FutureOr<void> _onInit(InitConfigEvent event, Emitter<ConfigState> emit) {
    final int points = preferenceService.getPoints();
    final String playerSkin = preferenceService.getPlayerSkin();
    final String backgroundSkin = preferenceService.getBackgroundSkin();
    final bool isPremium = preferenceService.isPremium();
    final List<String> boughtBackgroundSkins =
        preferenceService.getBackgroundSkins();
    final List<String> boughtPlayerSkins = preferenceService.getPlayerSkins();

    emit(
      state.copyWith(
        points: points,
        playerSkin: playerSkin,
        backgroundSkin: backgroundSkin,
        isPremium: isPremium,
        backgroundSkins: boughtBackgroundSkins,
        playerSkins: boughtPlayerSkins,
      ),
    );
  }

  FutureOr<void> _onBuyPremiumConfigEvent(
      BuyPremiumConfigEvent event, Emitter<ConfigState> emit) async {
    await preferenceService.setPremium();

    final boughtPlayerSkins = [
      ...state.playerSkins,
      playerSkins[3].asset,
      playerSkins[4].asset,
    ];

    await preferenceService.setPlayerSkins(boughtPlayerSkins);

    emit(state.copyWith(
      isPremium: true,
      playerSkins: boughtPlayerSkins,
    ));
  }

  FutureOr<void> _onSelectPlayerSkin(
      SelectPlayerSkin event, Emitter<ConfigState> emit) async {
    final playerSkins = state.playerSkins;
    final playerSkin = event.playerSkin;
    final hasPlayerSkin = playerSkins.contains(playerSkin.asset);

    if (hasPlayerSkin) {
      return emit(
        state.copyWith(playerSkin: playerSkin.asset),
      );
    }

    final points = state.points - playerSkin.cost;

    playerSkins.add(playerSkin.asset);

    preferenceService.setPlayerSkins(playerSkins);

    emit(
      state.copyWith(
        points: points,
        playerSkin: playerSkin.asset,
        playerSkins: playerSkins,
      ),
    );
  }

  FutureOr<void> _onSelectBackgroundSkin(
      SelectBackgroundSkin event, Emitter<ConfigState> emit) async {
    final backgroundSkins = state.backgroundSkins;
    final backgroundSkin = event.backgroundSkin;
    final hasBackgroundSkin = backgroundSkins.contains(backgroundSkin.asset);

    if (hasBackgroundSkin) {
      return emit(
        state.copyWith(
          backgroundSkin: backgroundSkin.asset,
          plateAsset: backgroundSkin.plateAsset,
        ),
      );
    }

    final points = state.points - backgroundSkin.cost;
    backgroundSkins.add(backgroundSkin.asset);

    preferenceService.setBackgroundSkins(backgroundSkins);

    emit(
      state.copyWith(
        points: points,
        plateAsset: backgroundSkin.plateAsset,
        backgroundSkin: backgroundSkin.asset,
        backgroundSkins: backgroundSkins,
      ),
    );
  }

  FutureOr<void> _onSaveConfigEvent(
      SavePointsConfigEvent event, Emitter<ConfigState> emit) async {
    final points = event.points;

    await preferenceService.setPoints(points);

    emit(
      state.copyWith(
        points: points,
      ),
    );
  }
}

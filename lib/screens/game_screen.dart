import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wascan_soil_secrets/blocs/config_bloc/config_bloc.dart';
import 'package:wascan_soil_secrets/blocs/game_bloc/game_bloc.dart';
import 'package:wascan_soil_secrets/models/models.dart';
import 'package:wascan_soil_secrets/screens/end_game_screen.dart';
import 'package:wascan_soil_secrets/screens/jackpot_screen.dart';
import 'package:wascan_soil_secrets/screens/lucky_game_screen.dart';
import 'package:wascan_soil_secrets/utils/utils.dart';
import 'package:wascan_soil_secrets/widgets/widgets.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({Key? key}) : super(key: key);

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  late final GameBloc _gameBloc;

  @override
  void initState() {
    _gameBloc = BlocProvider.of(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ConfigBloc, ConfigState>(
      builder: (configBloc, configState) {
        return BlocConsumer<GameBloc, GameState>(
          listener: _listener,
          builder: (context, state) {
            return BackgroundWidget(
              child: Column(
                children: [
                  CustomAppBar(
                    coins: configState.points,
                    hasInfo: true,
                  ),
                  _buildGameGround(
                    gameState: state,
                    configState: configState,
                  ),
                  SizedBox(height: 18.h),
                  Expanded(
                    child: _buildScoreView(state),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildGameGround({
    required GameState gameState,
    required ConfigState configState,
  }) {
    return Container(
      width: 344.w,
      height: 276.w,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(configState.backgroundSkin),
          fit: BoxFit.fill,
        ),
      ),
      child: Center(
        child: Container(
          width: 350.w,
          height: 282.w,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage(
                "assets/png/background_shadow.png",
              ),
              fit: BoxFit.fill,
            ),
          ),
          padding: EdgeInsets.symmetric(horizontal: 11.w, vertical: 11.w),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8.sp),
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 10,
                mainAxisSpacing: 0,
              ),
              itemCount: 80,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                final Plate plate = gameState.plates[index];
                final visiblePlates = gameState.visiblePlates;
                final userPosition = gameState.userPosition;
                final String playerSkin = configState.playerSkin;

                return PlateWidget(
                  plateAsset: configState.plateAsset,
                  playerSkin: playerSkin,
                  plate: plate,
                  isVisible: (visiblePlates.contains(index) ||
                      gameState.playerSkin.id == 3 &&
                          gameState.abilityInActive &&
                          gameState.randomPlates.contains(index)),
                  isUser: index == userPosition,
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildScoreView(GameState gameState) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "You collected:",
                    style: TextStyleHelper.helper3.copyWith(
                      color: Colors.white.withOpacity(0.5),
                    ),
                  ),
                  Text(
                    "${gameState.collectedPoints} COINS",
                    style: TextStyleHelper.helper3,
                  ),
                ],
              ),
              if (gameState.counter >= 1 && gameState.abilityInActive)
                Text(
                  "00:${gameState.counter}",
                  style: TextStyleHelper.helper11,
                ),
              GameButton(
                asset: "assets/svg/fire.svg",
                enabled: !gameState.abilityUsed,
                onTap: () {
                  if (!gameState.abilityInActive) {
                    _gameBloc.add(UseAbilityGameEvent());
                  }
                },
              ),
            ],
          ),
          Spacer(),
          _buildMoverButtons(
            userIndex: gameState.userPosition,
            onMoveRight: () {
              if (gameState.userPosition % 10 < 9) {
                _gameBloc.add(
                  UserMoving(gameState.userPosition + 1),
                );
              }
            },
            onMoveLeft: () {
              if (gameState.userPosition % 10 > 0) {
                _gameBloc.add(
                  UserMoving(gameState.userPosition - 1),
                );
              }
            },
            onMoveDown: () {
              if (gameState.userPosition + 10 < 80) {
                _gameBloc.add(
                  UserMoving(gameState.userPosition + 10),
                );
              }
            },
            onMoveUp: () {
              if (gameState.userPosition - 10 >= 0) {
                _gameBloc.add(
                  UserMoving(gameState.userPosition - 10),
                );
              }
            },
          ),
          SizedBox(height: 32.h),
        ],
      ),
    );
  }

  Widget _buildMoverButtons({
    final VoidCallback? onMoveRight,
    final VoidCallback? onMoveLeft,
    final VoidCallback? onMoveUp,
    final VoidCallback? onMoveDown,
    final int userIndex = 0,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        GameButton(
          enabled: userIndex % 10 > 0,
          width: 107.w,
          height: 60,
          onTap: onMoveLeft,
          color: ThemeHelper.red,
          shadowColor: ThemeHelper.redAccent,
          asset: "assets/svg/arrow_left.svg",
        ),
        Column(
          children: [
            GameButton(
              enabled: userIndex - 10 >= 0,
              width: 107.w,
              height: 60,
              onTap: onMoveUp,
              color: ThemeHelper.red,
              shadowColor: ThemeHelper.redAccent,
              asset: "assets/svg/arrow_up.svg",
            ),
            SizedBox(height: 16.h),
            GameButton(
              enabled: userIndex + 10 < 80,
              width: 107.w,
              height: 60,
              onTap: onMoveDown,
              color: ThemeHelper.red,
              shadowColor: ThemeHelper.redAccent,
              asset: "assets/svg/arrow_down.svg",
            ),
          ],
        ),
        GameButton(
          width: 107.w,
          height: 60,
          enabled: userIndex % 10 < 9,
          onTap: onMoveRight,
          color: ThemeHelper.red,
          shadowColor: ThemeHelper.redAccent,
          asset: "assets/svg/arrow_right.svg",
        ),
      ],
    );
  }

  void _showLuckyScreen() {
    showDialog(
      barrierColor: Colors.black.withOpacity(0.6),
      context: context,
      builder: (context) {
        return const LuckyGameScreen();
      },
    );
  }

  void _showJackpotScreen() {
    showDialog(
      barrierColor: Colors.black.withOpacity(0.6),
      context: context,
      builder: (context) {
        return const JackpotScreen();
      },
    );
  }

  void _showEndGameScreen() {
    showDialog(
      barrierColor: Colors.black.withOpacity(0.6),
      context: context,
      builder: (context) {
        return const EndGameScreen();
      },
    );
  }

  void _listener(BuildContext context, GameState state) {
    if (state.gamingProcess == GamingProcess.lucky) {
      _showLuckyScreen();
    } else if (state.gamingProcess == GamingProcess.jackpot) {
      _showJackpotScreen();
    } else if (state.gamingProcess == GamingProcess.endGame) {
      _showEndGameScreen();
    }
  }
}

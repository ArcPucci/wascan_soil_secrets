import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:wascan_soil_secrets/blocs/config_bloc/config_bloc.dart';
import 'package:wascan_soil_secrets/blocs/game_bloc/game_bloc.dart';
import 'package:wascan_soil_secrets/screens/premium_screen.dart';
import 'package:wascan_soil_secrets/utils/player_skins.dart';
import 'package:wascan_soil_secrets/utils/text_style_helper.dart';
import 'package:wascan_soil_secrets/widgets/background_widget.dart';
import 'package:wascan_soil_secrets/widgets/custom_app_bar.dart';
import 'package:wascan_soil_secrets/widgets/custom_button.dart';
import 'package:wascan_soil_secrets/widgets/prev_next_widget.dart';

class PlayerSkinsScreen extends StatefulWidget {
  const PlayerSkinsScreen({super.key});

  @override
  State<PlayerSkinsScreen> createState() => _PlayerSkinsScreenState();
}

class _PlayerSkinsScreenState extends State<PlayerSkinsScreen> {
  int _selected = 0;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GameBloc, GameState>(
      builder: (gameBloc, gameState) {
        return BlocBuilder<ConfigBloc, ConfigState>(
          builder: (context, state) {
            final points = state.points;
            final playerSkin = playerSkins[_selected];
            final canChoose = state.playerSkins.contains(playerSkin.asset);
            final canBuy = playerSkin.cost <= points && !canChoose;
            final choosen = state.playerSkin == playerSkin.asset;
            final enabled = choosen ? false : canBuy || canChoose;
            return BackgroundWidget(
              child: Column(
                children: [
                  CustomAppBar(
                    coins: state.points,
                    onTapBack: () => context.pop(),
                  ),
                  SizedBox(height: 24.h),
                  SizedBox(
                    width: 200.w,
                    height: 200.h,
                    child: Image.asset(
                      playerSkins[_selected].asset,
                      fit: BoxFit.contain,
                    ),
                  ),
                  SizedBox(height: 24.h),
                  Text(
                    playerSkins[_selected].name,
                    style: TextStyleHelper.helper6,
                  ),
                  SizedBox(height: 12.h),
                  SizedBox(
                    width: 343.w,
                    child: Opacity(
                      opacity: 0.7,
                      child: Text(
                        playerSkins[_selected].description,
                        style: TextStyleHelper.helper5.copyWith(
                          fontWeight: FontWeight.w400,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  const Spacer(),
                  PrevNextWidget(
                    itemCount: playerSkins.length,
                    onTapPrev: (index) => setState(() {
                      _selected = index;
                    }),
                    onTapNext: (index) => setState(() {
                      _selected = index;
                    }),
                  ),
                  SizedBox(height: 20.h),
                  CustomButton(
                    onTap: () {
                      if (enabled && !state.isPremium && playerSkin.isPremium) {
                        final route =
                            MaterialPageRoute(builder: (BuildContext context) {
                          return const PremiumScreen();
                        });
                        Navigator.of(context, rootNavigator: true).push(route);
                      } else if (enabled) {
                        context.read<ConfigBloc>().add(
                              SelectPlayerSkin(playerSkin),
                            );
                        gameBloc.read<GameBloc>().add(
                              ChangePersonEvent(playerSkin),
                            );
                      }
                    },
                    text: canChoose
                        ? choosen
                            ? "CHOSEN"
                            : "CHOOSE"
                        : playerSkin.isPremium
                            ? "GET PREMIUM"
                            : "${playerSkin.cost} COINS",
                    enabled: enabled,
                  ),
                  SizedBox(height: 24.h),
                ],
              ),
            );
          },
        );
      },
    );
  }
}

import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wascan_soil_secrets/blocs/game_bloc/game_bloc.dart';
import 'package:wascan_soil_secrets/utils/text_style_helper.dart';
import 'package:wascan_soil_secrets/widgets/custom_button.dart';

class EndGameScreen extends StatelessWidget {
  const EndGameScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: BlocBuilder<GameBloc, GameState>(
        builder: (context, state) {
          return BackdropFilter(
            filter: ImageFilter.blur(
              sigmaY: 5,
              sigmaX: 5,
            ),
            child: SafeArea(
              child: Stack(
                children: [
                  Positioned(
                    left: 78.w,
                    top: 115.h,
                    child: SizedBox(
                      width: 219.w,
                      height: 370.h,
                      child: Image.asset(
                        "assets/png/end_game.png",
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  Positioned(
                    left: 78.w,
                    top: 115.h,
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaY: 15, sigmaX: 15),
                      child: SizedBox(
                        width: 219.w,
                        height: 370.h,
                        child: Image.asset(
                          "assets/png/end_game.png",
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 402.h,
                    left: 53.w,
                    child: Container(
                      width: 270.w,
                      height: 109.h,
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black,
                            spreadRadius: -16.sp,
                            blurRadius: 15.sp,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    top: 418.h,
                    left: 54.w,
                    child: Column(
                      children: [
                        Text(
                          "YOU GOT",
                          style: TextStyleHelper.helper8,
                        ),
                        Text(
                          "+${state.collectedPoints} COINS",
                          style: TextStyleHelper.helper9,
                        ),
                        Text(
                          "TO YOUR BALANCE",
                          style: TextStyleHelper.helper7,
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    top: 418.h,
                    left: 54.w,
                    child: ImageFiltered(
                      imageFilter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                      child: Column(
                        children: [
                          Text(
                            "YOU GOT",
                            style: TextStyleHelper.helper8,
                          ),
                          Text(
                            "+${state.collectedPoints} COINS",
                            style: TextStyleHelper.helper9,
                          ),
                          Text(
                            "TO YOUR BALANCE",
                            style: TextStyleHelper.helper7,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    top: 645.h,
                    left: 16.w,
                    child: CustomButton(
                      onTap: () {
                        Navigator.pop(context);
                        context.read<GameBloc>().add(
                              RestartGameEvent(),
                            );
                      },
                      text: 'PLAY AGAIN',
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

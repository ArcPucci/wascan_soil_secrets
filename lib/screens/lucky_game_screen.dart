import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wascan_soil_secrets/blocs/game_bloc/game_bloc.dart';
import 'package:wascan_soil_secrets/models/artifact.dart';
import 'package:wascan_soil_secrets/utils/text_style_helper.dart';
import 'package:wascan_soil_secrets/utils/theme_helper.dart';
import 'package:wascan_soil_secrets/widgets/custom_button.dart';

class LuckyGameScreen extends StatefulWidget {
  const LuckyGameScreen({Key? key}) : super(key: key);

  @override
  State<LuckyGameScreen> createState() => _LuckyGameScreenState();
}

class _LuckyGameScreenState extends State<LuckyGameScreen> {
  late GameBloc gameBloc;

  @override
  void initState() {
    gameBloc = BlocProvider.of(context);
    super.initState();
  }

  bool isChosen = false;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: BlocBuilder<GameBloc, GameState>(
        builder: (gameBloc, state) {
          return BackdropFilter(
            filter: ImageFilter.blur(sigmaY: 5, sigmaX: 5),
            child: SafeArea(
              child: isChosen
                  ? _buildResultBody(
                      gameState: state,
                      context: context,
                    )
                  : _buildChooseBody(
                      onTap: () {
                        setState(() {
                          isChosen = true;
                        });
                      },
                    ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildChooseBody({final VoidCallback? onTap}) {
    return Column(
      children: [
        SizedBox(height: 185.h),
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: "CHOOSE",
                style: TextStyleHelper.helper8,
              ),
              TextSpan(
                text: " ONE",
                style: TextStyleHelper.helper8.copyWith(
                  color: ThemeHelper.red,
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 20.h),
        Expanded(
          child: GridView.builder(
            physics: const BouncingScrollPhysics(),
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 1.3,
            ),
            itemCount: 4,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: onTap,
                child: Image.asset(
                  "assets/png/artifact.png",
                  fit: BoxFit.cover,
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildResultBody({
    required GameState gameState,
    required BuildContext context,
  }) {
    return Column(
      children: [
        SizedBox(height: 160.h),
        if (gameState.artifact.luckyStatus == LuckyStatus.lucky)
          _buildLuckyBody(
            artifact: gameState.artifact,
          ),
        if (gameState.artifact.luckyStatus == LuckyStatus.unlucky)
          _buildUnluckyBody(
            artifact: gameState.artifact,
          ),
        if (gameState.artifact.luckyStatus == LuckyStatus.neutral)
          _buildNeutralBody(),
        const Spacer(),
        CustomButton(
          onTap: () {
            context.read<GameBloc>().add(ContinueGameEvent());
            Navigator.pop(context);
          },
          text: "CONTINUE",
        ),
        SizedBox(height: 24.h),
      ],
    );
  }

  Widget _buildNeutralBody() {
    return Column(
      children: [
        SizedBox(
          width: 220.w,
          height: 220.w,
          child: Image.asset(
            "assets/png/neutral.png",
            fit: BoxFit.cover,
          ),
        ),
        SizedBox(height: 16.h),
        Text(
          "YOU GOT",
          style: TextStyleHelper.helper8,
        ),
        RichText(
          text: TextSpan(
            text: "0 ",
            style: TextStyleHelper.helper10.copyWith(
              color: ThemeHelper.white,
            ),
            children: [
              TextSpan(
                text: "COINS",
                style: TextStyleHelper.helper9.copyWith(
                  color: ThemeHelper.white,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildUnluckyBody({required final Artifact artifact}) {
    return Column(
      children: [
        Stack(
          children: [
            Image.asset(
              "assets/png/unlucky.png",
              width: 220.w,
              height: 220.w,
              fit: BoxFit.cover,
            ),
            Opacity(
              opacity: 0.8,
              child: Image.asset(
                "assets/png/artifact_mask.png",
                width: 220.w,
                height: 220.w,
                fit: BoxFit.cover,
              ),
            ),
          ],
        ),
        SizedBox(height: 16.h),
        Text(
          "YOU LOST",
          style: TextStyleHelper.helper8,
        ),
        RichText(
          text: TextSpan(
            text: "${artifact.score} ",
            style: TextStyleHelper.helper10.copyWith(
              color: ThemeHelper.red,
            ),
            children: [
              TextSpan(
                text: "COINS",
                style: TextStyleHelper.helper9.copyWith(
                  color: ThemeHelper.red,
                ),
              ),
            ],
          ),
        ),
        Text(
          "TO YOUR BALANCE",
          style: TextStyleHelper.helper7.copyWith(
            color: ThemeHelper.red,
          ),
        ),
      ],
    );
  }

  Widget _buildLuckyBody({required final Artifact artifact}) {
    return Column(
      children: [
        SizedBox(
          width: 220.w,
          height: 220.w,
          child: Image.asset(
            "assets/png/lucky.png",
            fit: BoxFit.cover,
          ),
        ),
        SizedBox(height: 16.h),
        Stack(
          children: [
            Column(
              children: [
                Text(
                  "YOU GOT",
                  style: TextStyleHelper.helper8,
                ),
                RichText(
                  text: TextSpan(
                    text: "+${artifact.score} ",
                    style: TextStyleHelper.helper10,
                    children: [
                      TextSpan(
                        text: "COINS",
                        style: TextStyleHelper.helper9,
                      ),
                    ],
                  ),
                ),
                Text(
                  "TO YOUR BALANCE",
                  style: TextStyleHelper.helper7,
                ),
              ],
            ),
            ImageFiltered(
              imageFilter: ImageFilter.blur(sigmaY: 15, sigmaX: 15),
              child: Column(
                children: [
                  Text(
                    "YOU GOT",
                    style: TextStyleHelper.helper8,
                  ),
                  RichText(
                    text: TextSpan(
                      text: "+${artifact.score} ",
                      style: TextStyleHelper.helper10,
                      children: [
                        TextSpan(
                          text: "COINS",
                          style: TextStyleHelper.helper9,
                        ),
                      ],
                    ),
                  ),
                  Text(
                    "TO YOUR BALANCE",
                    style: TextStyleHelper.helper7,
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}

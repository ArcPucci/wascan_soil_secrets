import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:wascan_soil_secrets/blocs/config_bloc/config_bloc.dart';
import 'package:wascan_soil_secrets/utils/background_skins.dart';
import 'package:wascan_soil_secrets/widgets/widgets.dart';

class BackgroundSkinsScreen extends StatefulWidget {
  const BackgroundSkinsScreen({Key? key}) : super(key: key);

  @override
  State<BackgroundSkinsScreen> createState() => _BackgroundSkinsScreenState();
}

class _BackgroundSkinsScreenState extends State<BackgroundSkinsScreen> {
  int _selected = 0;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ConfigBloc, ConfigState>(
      builder: (context, state) {
        final points = state.points;
        final backgroundSkin = backgroundSkins[_selected];
        final canChoose = state.backgroundSkins.contains(backgroundSkin.asset);
        final canBuy = backgroundSkin.cost <= points && !canChoose;
        final choosen = state.backgroundSkin == backgroundSkin.asset;
        final enabled = choosen ? false : canBuy || canChoose;
        return BackgroundWidget(
          child: Column(
            children: [
              CustomAppBar(
                coins: state.points,
                onTapBack: () => context.pop(),
              ),
              SizedBox(height: 18.h),
              SizedBox(
                width: 344.sp,
                height: 276.sp,
                child: Image.asset(
                  backgroundSkin.asset,
                  fit: BoxFit.fill,
                ),
              ),
              Spacer(),
              PrevNextWidget(
                itemCount: backgroundSkins.length,
                onTapPrev: (index) => setState(() {
                  _selected = index;
                }),
                onTapNext: (index) => setState(() {
                  _selected = index;
                }),
              ),
              SizedBox(height: 20.h),
              CustomButton(
                onTap: enabled
                    ? () => context
                        .read<ConfigBloc>()
                        .add(SelectBackgroundSkin(backgroundSkin))
                    : null,
                text: canChoose
                    ? choosen
                        ? "CHOSEN"
                        : "CHOOSE"
                    : "${backgroundSkin.cost} COINS",
                enabled: enabled,
              ),
              SizedBox(height: 45.h),
            ],
          ),
        );
      },
    );
  }
}

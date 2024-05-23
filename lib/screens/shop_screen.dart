import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:wascan_soil_secrets/blocs/config_bloc/config_bloc.dart';
import 'package:wascan_soil_secrets/utils/utils.dart';
import 'package:wascan_soil_secrets/widgets/background_widget.dart';
import 'package:wascan_soil_secrets/widgets/custom_app_bar.dart';
import 'package:wascan_soil_secrets/widgets/general_button.dart';

class ShopScreen extends StatelessWidget {
  const ShopScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ConfigBloc, ConfigState>(
      builder: (context, state) {
        return BackgroundWidget(
          child: Column(
            children: [
              CustomAppBar(
                coins: state.points,
              ),
              SizedBox(height: 48.h),
              GeneralButton(
                onTap: () => context.go('/shop_screen/player_skins_screen'),
                asset: "assets/svg/character.svg",
                content: "CHARACTERS",
              ),
              SizedBox(height: 20.h),
              GeneralButton(
                onTap: () => context.go("/shop_screen/backgroundSkins"),
                color: ThemeHelper.blue,
                shadowColor: ThemeHelper.blueAccent,
                asset: "assets/svg/backgrounds.svg",
                content: "BACKGROUNDS",
              ),
            ],
          ),
        );
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wascan_soil_secrets/blocs/config_bloc/config_bloc.dart';
import 'package:wascan_soil_secrets/screens/premium_screen.dart';
import 'package:wascan_soil_secrets/utils/links.dart';
import 'package:wascan_soil_secrets/utils/theme_helper.dart';
import 'package:wascan_soil_secrets/utils/utils.dart';
import 'package:wascan_soil_secrets/widgets/background_widget.dart';
import 'package:wascan_soil_secrets/widgets/custom_app_bar.dart';
import 'package:wascan_soil_secrets/widgets/general_button.dart';

class SettingsScreen extends StatelessWidget {
  SettingsScreen({Key? key}) : super(key: key);

  final List<String> assets = [
    "assets/svg/shield.svg",
    "assets/svg/tasks.svg",
    "assets/svg/support.svg",
  ];

  final List<String> contents = [
    "PRIVACY POLICY",
    "TERMS OF USE",
    "SUPPORT",
  ];

  final List<Uri> links = [
    Links.privacyLink,
    Links.termsOfUseLink,
    Links.supportLink,
  ];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ConfigBloc, ConfigState>(
      builder: (context, state) {
        return BackgroundWidget(
          child: Column(
            children: [
              CustomAppBar(coins: state.points),
              SizedBox(height: 24.h),
              if (!state.isPremium)
                GeneralButton(
                  width: 343.w,
                  height: 80.h,
                  onTap: () => _onBuyPremium(context),
                  color: ThemeHelper.blue,
                  shadowColor: ThemeHelper.blueAccent,
                  asset: "assets/svg/coin.svg",
                  content: "GET PREMIUM",
                ),
              SizedBox(height: 20.h),
              Column(
                children: List.generate(
                  3,
                  (index) => Column(
                    children: [
                      GeneralButton(
                        width: 343.w,
                        height: 65.h,
                        onTap: () => _launchUrl(links[index]),
                        color: ThemeHelper.red,
                        shadowColor: ThemeHelper.redAccent,
                        asset: assets[index],
                        content: contents[index],
                        textStyle: TextStyleHelper.helper5,
                      ),
                      SizedBox(height: 20.h),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _launchUrl(Uri url) async {
    if (!await launchUrl(url)) {
      throw "Could not launch $url";
    }
  }

  _onBuyPremium(BuildContext context) {
    final route = MaterialPageRoute(builder: (BuildContext context) {
      return const PremiumScreen();
    });
    Navigator.of(context, rootNavigator: true).push(route);
  }
}

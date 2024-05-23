import 'dart:ui';

import 'package:bordered_text/bordered_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wascan_soil_secrets/blocs/config_bloc/config_bloc.dart';
import 'package:wascan_soil_secrets/utils/links.dart';
import 'package:wascan_soil_secrets/utils/text_style_helper.dart';
import 'package:wascan_soil_secrets/utils/theme_helper.dart';
import 'package:wascan_soil_secrets/widgets/background_widget.dart';
import 'package:wascan_soil_secrets/widgets/custom_button.dart';

class PremiumScreen extends StatelessWidget {
  const PremiumScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ConfigBloc, ConfigState>(
      builder: (context, state) {
        return BackgroundWidget(
          child: Stack(
            children: [
              Positioned(
                left: 16.w,
                child: GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: SizedBox(
                    height: 56.h,
                    child: SizedBox(
                      width: 24.w,
                      height: 24.h,
                      child: Image.asset(
                        'assets/png/icons/close.png',
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 48,
                top: 56,
                child: SizedBox(
                  width: 280.w,
                  height: 192.h,
                  child: Image.asset(
                    'assets/png/wascan.png',
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              Positioned(
                top: 215,
                left: 43,
                child: SizedBox(
                  width: 288.w,
                  height: 390.h,
                  child: Image.asset(
                    'assets/png/crow.png',
                    fit: BoxFit.contain,
                    colorBlendMode: BlendMode.overlay,
                  ),
                ),
              ),
              Positioned(
                top: 393.h,
                left: 56.w,
                child: Container(
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.7),
                        blurRadius: 75.sp,
                        spreadRadius: 8.sp,
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      _buildText(
                        borderedText: 'ALL',
                        text: 'SKINS',
                      ),
                      SizedBox(height: 16.h),
                      Container(
                        width: 75.w,
                        height: 2.h,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100.r),
                          color: ThemeHelper.blue.withOpacity(0.3),
                        ),
                      ),
                      SizedBox(height: 16.h),
                      _buildText(
                        borderedText: 'ADS',
                        text: 'REMOVING',
                      ),
                      SizedBox(height: 16.h),
                      Container(
                        width: 125.w,
                        height: 2.h,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100.r),
                          color: ThemeHelper.blue.withOpacity(0.3),
                        ),
                      ),
                      SizedBox(height: 16.h),
                      _buildText(
                        borderedText: 'ALL',
                        text: 'BACKGROUNDS',
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                top: 605.h,
                left: 16.w,
                child: CustomButton(
                  text: 'GET PREMIUM FOR 0.99\$',
                  onTap: () => _onBuyPremium(context),
                ),
              ),
              Positioned(
                top: 686.h,
                left: 16.w,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildTextButton(
                      text: 'TERMS OF USE',
                      onTap: () => _launchUrl(Links.termsOfUseLink),
                    ),
                    _buildTextButton(
                      text: 'RESTORE',
                      onTap: () => _onBuyPremium(context),
                    ),
                    _buildTextButton(
                      text: 'PRIVACY POLICY',
                      onTap: () => _launchUrl(Links.privacyLink),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildText({
    required String borderedText,
    required String text,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        BorderedText(
          strokeWidth: 1.r,
          strokeColor: ThemeHelper.blue,
          child: Text(
            '$borderedText ',
            style: TextStyleHelper.helper4,
          ),
        ),
        Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: ThemeHelper.blue.withOpacity(0.5),
                blurRadius: 16.sp,
                spreadRadius: -12.sp,
              ),
            ],
          ),
          child: BorderedText(
            strokeWidth: 1.r,
            strokeColor: ThemeHelper.blue,
            child: Text(
              text,
              style: TextStyleHelper.helper4.copyWith(color: ThemeHelper.blue),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTextButton({
    required String text,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        height: 40.h,
        width: 114.w,
        child: Center(
          child: Text(
            text,
            style: TextStyleHelper.helper2.copyWith(
              color: ThemeHelper.white.withOpacity(0.7),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _launchUrl(Uri url) async {
    if (!await launchUrl(url)) {
      throw "Could not launch $url";
    }
  }

  _onBuyPremium(BuildContext context) {
    context.read<ConfigBloc>().add(
          BuyPremiumConfigEvent(),
        );
    Navigator.pop(context);
  }
}

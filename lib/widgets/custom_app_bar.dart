import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wascan_soil_secrets/screens/info_screen.dart';
import 'package:wascan_soil_secrets/utils/utils.dart';

class CustomAppBar extends StatelessWidget {
  const CustomAppBar({
    Key? key,
    required this.coins,
    this.onTapBack,
    this.hasInfo = false,
  }) : super(key: key);

  final int coins;
  final VoidCallback? onTapBack;
  final bool hasInfo;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        GestureDetector(
          onTap: onTapBack,
          child: Container(
            width: 56.w,
            height: 56.h,
            color: Colors.transparent,
            child: onTapBack != null
                ? Center(
                    child: SizedBox(
                      width: 24.w,
                      height: 24.w,
                      child: Image.asset(
                        "assets/png/icons/back.png",
                      ),
                    ),
                  )
                : null,
          ),
        ),
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: "$coins",
                style: TextStyleHelper.helper3,
              ),
              TextSpan(
                text: " COINS",
                style: TextStyleHelper.helper3.copyWith(
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
        GestureDetector(
          onTap: () {
            if (hasInfo) {
              showDialog(
                context: context,
                barrierColor: Colors.black.withOpacity(0.6),
                builder: (context) {
                  return const InfoScreen();
                },
              );
            }
          },
          child: Container(
            width: 56.w,
            height: 56.h,
            color: Colors.transparent,
            child: hasInfo
                ? Center(
                    child: SizedBox(
                      width: 24.w,
                      height: 24.w,
                      child: Image.asset(
                        "assets/png/icons/info.png",
                      ),
                    ),
                  )
                : null,
          ),
        ),
      ],
    );
  }
}

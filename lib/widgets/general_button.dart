import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:wascan_soil_secrets/utils/utils.dart';

class GeneralButton extends StatelessWidget {
  const GeneralButton({
    Key? key,
    required this.asset,
    this.onTap,
    this.width,
    this.height,
    required this.content,
    this.color,
    this.shadowColor,
    this.textStyle,
  }) : super(key: key);

  final String asset;
  final VoidCallback? onTap;
  final double? width;
  final double? height;
  final String content;
  final Color? color;
  final Color? shadowColor;
  final TextStyle? textStyle;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width ?? 343.w,
        height: height ?? 100.h,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16.sp),
          color: color ?? ThemeHelper.red,
          boxShadow: [
            BoxShadow(
              offset: const Offset(0, 4),
              color: shadowColor ?? ThemeHelper.redAccent,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(asset),
            SizedBox(height: 4.h),
            Text(
              content,
              style: textStyle ?? TextStyleHelper.helper1,
            ),
          ],
        ),
      ),
    );
  }
}

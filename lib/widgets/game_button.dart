import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:wascan_soil_secrets/utils/utils.dart';

class GameButton extends StatelessWidget {
  const GameButton({
    Key? key,
    required this.asset,
    this.onTap,
    this.color,
    this.width,
    this.height,
    this.shadowColor, this.enabled = true,
  }) : super(key: key);

  final double? width;
  final double? height;
  final String asset;
  final VoidCallback? onTap;
  final Color? color;
  final Color? shadowColor;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: enabled ? onTap : null,
      child: Opacity(
        opacity: enabled ? 1 : 0.3,
        child: Container(
          width: width ?? 100.w,
          height: height ?? 50.h,
          decoration: BoxDecoration(
            color: color ?? ThemeHelper.blue,
            borderRadius: BorderRadius.circular(8.sp),
            boxShadow: [
              BoxShadow(
                color: shadowColor ?? ThemeHelper.blueAccent,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Center(
            child: SvgPicture.asset(
              asset,
            ),
          ),
        ),
      ),
    );
  }
}

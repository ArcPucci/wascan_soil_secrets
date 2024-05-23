import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wascan_soil_secrets/utils/utils.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    Key? key,
    this.onTap,
    required this.text,
    this.width,
    this.height,
    this.color,
    this.shadowColor,
    this.enabled = true,
  }) : super(key: key);

  final VoidCallback? onTap;
  final String text;
  final double? width;
  final double? height;
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
          alignment: Alignment.center,
          width: width ?? 343.w,
          height: height ?? 65.h,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.r),
            color: color ?? ThemeHelper.red,
            boxShadow: [
              BoxShadow(
                color: shadowColor ?? ThemeHelper.redAccent,
                blurRadius: 0,
                offset: const Offset(0, 4),
              )
            ],
          ),
          child: Text(
            text,
            style: TextStyleHelper.helper1,
          ),
        ),
      ),
    );
  }
}

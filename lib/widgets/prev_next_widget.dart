import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:wascan_soil_secrets/utils/utils.dart';

class PrevNextWidget extends StatefulWidget {
  const PrevNextWidget({
    Key? key,
    this.onTapPrev,
    this.onTapNext,
    required this.itemCount,
  }) : super(key: key);

  final void Function(int)? onTapPrev;
  final void Function(int)? onTapNext;
  final int itemCount;

  @override
  State<PrevNextWidget> createState() => _PrevNextWidgetState();
}

class _PrevNextWidgetState extends State<PrevNextWidget> {
  int index = 0;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 343.w,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          PrevNextButton(
            onTap: () {
              if (index > 0) {
                index--;
              }
              widget.onTapPrev?.call(index);
              setState(() {});
            },
            enabled: index > 0,
            content: "PREV",
          ),
          PrevNextButton(
            onTap: () {
              if (index < widget.itemCount - 1) {
                index++;
              }
              widget.onTapNext?.call(index);
              setState(() {});
            },
            enabled: index < widget.itemCount - 1,
            isPrev: false,
            content: "NEXT",
          ),
        ],
      ),
    );
  }
}

class PrevNextButton extends StatelessWidget {
  const PrevNextButton({
    Key? key,
    this.isPrev = true,
    this.onTap,
    required this.content,
    this.enabled = true,
  }) : super(key: key);

  final bool isPrev;
  final VoidCallback? onTap;
  final String content;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Opacity(
        opacity: enabled ? 1 : 0.3,
        child: Container(
          width: 162.w,
          height: 60.h,
          decoration: BoxDecoration(
            color: ThemeHelper.red,
            boxShadow: const [
              BoxShadow(
                color: ThemeHelper.redAccent,
                offset: Offset(0, 4),
              ),
            ],
            borderRadius: BorderRadius.circular(8.sp),
          ),
          padding: EdgeInsets.only(
            left: isPrev ? 6.w : 20.w,
            top: 14.h,
            bottom: 14.h,
            right: isPrev ? 20.w : 6.w,
          ),
          child: Row(
            children: [
              if (isPrev) ...[
                SvgPicture.asset("assets/svg/arrow_left.svg"),
                SizedBox(width: 4.w),
              ],
              Expanded(
                child: Text(
                  content,
                  style: TextStyleHelper.helper5,
                  textAlign: TextAlign.center,
                ),
              ),
              if (!isPrev) ...[
                SizedBox(width: 4.w),
                SvgPicture.asset("assets/svg/arrow_right.svg"),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

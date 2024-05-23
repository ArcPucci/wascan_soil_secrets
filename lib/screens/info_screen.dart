import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wascan_soil_secrets/widgets/custom_button.dart';
import 'package:wascan_soil_secrets/widgets/prev_next_widget.dart';

class InfoScreen extends StatefulWidget {
  const InfoScreen({Key? key}) : super(key: key);

  @override
  State<InfoScreen> createState() => _InfoScreenState();
}

class _InfoScreenState extends State<InfoScreen> {
  final List<String> infoList = [
    "assets/png/cell_info.png",
    "assets/png/actions_info.png",
  ];

  int selected = 0;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaY: 5,
          sigmaX: 5,
        ),
        child: Material(
          color: Colors.transparent,
          child: Column(
            children: [
              SizedBox(height: 120.h),
              SizedBox(
                width: 342.w,
                child: Image.asset(
                  infoList[selected],
                  fit: BoxFit.fitWidth,
                ),
              ),
              const Spacer(),
              PrevNextWidget(
                itemCount: infoList.length,
                onTapNext: (index) => setState(() {
                  selected = index;
                }),
                onTapPrev: (index) => setState(() {
                  selected = index;
                }),
              ),
              SizedBox(height: 20.h),
              CustomButton(
                onTap: () => Navigator.pop(context),
                width: 343.w,
                height: 65.h,
                text: "CLOSE",
              ),
              SizedBox(height: 24.h),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:wascan_soil_secrets/models/image_item.dart';
import 'package:wascan_soil_secrets/utils/image_items.dart';
import 'package:wascan_soil_secrets/utils/text_style_helper.dart';
import 'package:wascan_soil_secrets/utils/theme_helper.dart';
import 'package:wascan_soil_secrets/widgets/background_widget.dart';

class NavigationScreen extends StatefulWidget {
  const NavigationScreen({
    Key? key,
    required this.child,
  }) : super(key: key);
  final Widget child;

  @override
  State<NavigationScreen> createState() => _NavigationScreenState();
}

class _NavigationScreenState extends State<NavigationScreen> {
  int _selected = 0;

  @override
  Widget build(BuildContext context) {
    return BackgroundWidget(
      child: Column(
        children: [
          Expanded(child: widget.child),
          SizedBox(
            height: 56.h,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                imageItems.length,
                (index) {
                  final item = imageItems[index];
                  return _buildNavigationBarItem(
                    imageItem: item,
                    selected: index == _selected,
                    onTap: () {
                      _selected = index;
                      context.go(item.path);
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavigationBarItem({
    required ImageItem imageItem,
    bool selected = false,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 125.w,
        height: 56.h,
        decoration: BoxDecoration(
          color: const Color(0xFF041228).withOpacity(0.9),
          border: Border(
            top: BorderSide(
              color: ThemeHelper.darkBlue,
              width: 1.w,
            ),
          ),
        ),
        child: Center(
          child: selected
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 24.r,
                      height: 24.r,
                      child: Image.asset(imageItem.asset),
                    ),
                    SizedBox(height: 6.h),
                    Text(
                      imageItem.name,
                      style: TextStyleHelper.helper2.copyWith(
                        color: ThemeHelper.red,
                      ),
                    ),
                  ],
                )
              : Opacity(
                  opacity: 0.5,
                  child: SizedBox(
                    width: 24.r,
                    height: 24.r,
                    child: Image.asset(imageItem.asset),
                  ),
                ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class CustomTile extends StatelessWidget {
  const CustomTile({
    super.key,
    required this.title,
    required this.subTitle,
    required this.trailing,
    required this.leading,
    this.onTap,
    this.selected,
  });
  final Widget leading;
  final Widget title;
  final Widget subTitle;
  final Widget trailing;
  final VoidCallback? onTap;
  final bool? selected;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
        decoration: (selected != null && selected!)
            ? BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(20)).r,
                border: Border.all(
                    color: Get.theme.colorScheme.secondary, width: 0.6),
              )
            : const BoxDecoration(),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            leading,
            const SizedBox(
              width: 10,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  title,
                  2.verticalSpace,
                  subTitle,
                ],
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            trailing,
          ],
        ),
      ),
    );
  }
}

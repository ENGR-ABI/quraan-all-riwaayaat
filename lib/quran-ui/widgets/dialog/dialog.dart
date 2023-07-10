import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../layout/layout_controller.dart';
import 'custom_dialog.dart';

class IqraaDialog extends StatelessWidget {
  const IqraaDialog({
    super.key,
    this.titleIcon,
    this.title,
    this.alignment = Alignment.center,
    this.onConfirmText = 'Confirm',
    this.onCancelText = 'Cancel',
    this.constraints = const BoxConstraints(
      minWidth: 300.0,
      maxWidth: 300.0,
      maxHeight: 500.0,
    ),
    required this.contents,
    this.contentPadding = const EdgeInsets.all(20.0),
    this.onConfirm,
    this.onCancel,
  });
  final Widget? titleIcon;
  final String? title;
  final Alignment alignment;
  final String onCancelText;
  final String onConfirmText;
  final BoxConstraints constraints;
  final List<Widget> contents;
  final EdgeInsetsGeometry contentPadding;
  final VoidCallback? onConfirm;
  final VoidCallback? onCancel;

  @override
  Widget build(BuildContext context) {
    return CustomDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      elevation: 10,
      contentPadding: EdgeInsets.zero,
      alignment: alignment,
      constraints: constraints,
      insetPadding: getInsetPadding(context),
      titlePadding: EdgeInsets.zero,
      titleTextStyle: Theme.of(context).textTheme.titleMedium!.copyWith(
            color: Get.theme.colorScheme.onPrimary,
            fontSize: 18,
          ),
      title: Column(
        children: [
          if (title != null)
            Container(
              padding: const EdgeInsets.all(12).r,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10)),
                color: Get.theme.colorScheme.primary,
              ),
              child: Row(
                children: [
                  if (titleIcon != null) ...[
                    titleIcon!,
                    4.horizontalSpace,
                  ],
                  Text(
                    title!,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
        ],
      ),
      children: [
        Padding(
          padding: contentPadding,
          child: Column(
            children: [
              ...contents,
            ],
          ),
        ),
        if (onConfirm != null) ...[
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(10),
                  bottomRight: Radius.circular(10)),
              color: Get.theme.colorScheme.surface,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: onCancel ?? Get.back,
                  child: Text(onCancelText),
                ),
                4.horizontalSpace,
                ElevatedButton(
                  onPressed: onConfirm,
                  child: Text(onConfirmText),
                ),
              ],
            ),
          )
        ],
      ],
    );
  }

  EdgeInsets getInsetPadding(BuildContext context) {
    if (alignment == Alignment.topLeft ||
        alignment == Alignment.bottomLeft ||
        alignment == Alignment.centerLeft) {
      return LayoutController.inst.isPhone(context)
          ? const EdgeInsets.all(24.0)
          : const EdgeInsets.only(left: 20);
    } else if (alignment == Alignment.topRight ||
        alignment == Alignment.bottomRight ||
        alignment == Alignment.centerRight) {
      return LayoutController.inst.isPhone(context)
          ? const EdgeInsets.all(24.0)
          : const EdgeInsets.only(right: 40).r;
    } else {
      return const EdgeInsets.all(24.0);
    }
  }
}

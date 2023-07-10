import 'package:flutter/widgets.dart';

class LayoutItemModel {
  LayoutItemModel({
    this.height = 400,
    required this.flex,
    required this.child,
  });
  final int flex;
  final Widget child;
  final double height;
}

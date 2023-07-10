import 'package:flutter/material.dart';

class LayoutItem extends StatelessWidget {
  const LayoutItem(
      {super.key,
      required this.flex,
      required this.item,
      this.isRightMost = false,
      this.requireFlex = true});

  final int flex;
  final bool isRightMost;
  final Widget item;
  final bool requireFlex;

  @override
  Widget build(BuildContext context) {
    return requireFlex
        ? Flexible(
            flex: flex,
            child: Container(
              child: item,
            ),
          )
        : item;
  }
}

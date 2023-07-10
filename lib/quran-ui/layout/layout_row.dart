import 'package:flutter/material.dart';
import 'layout_controller.dart';
import 'layout_item.dart';
import 'layout_item_model.dart';

class LayoutRow extends StatefulWidget {
  const LayoutRow({
    super.key,
    required this.items,
    this.phoneCols = 1,
    this.tabletCols = 2,
    this.bigTabletCols = 3,
    this.computerCols = 3,
    this.width = double.infinity,
  });

  final List<LayoutItemModel> items;
  final int computerCols;
  final int bigTabletCols;
  final int tabletCols;
  final int phoneCols;
  final double width;

  @override
  State<LayoutRow> createState() => _LayoutRowState();
}

class _LayoutRowState extends State<LayoutRow> {
  List<Widget> _generateRows(List<LayoutItemModel> items, int maxColumns) {
    int rowsCount = 0;
    int tobeTaken = maxColumns;
    final List<Widget> phoneItems = [];
    if (maxColumns == 1) {
      phoneItems.addAll(_buildPhoneLayoutList(items));
      return phoneItems;
    }
    final List<Row> list = [];
    while (rowsCount < items.length) {
      if (maxColumns >= items.length) {
        list.add(_buildLayoutItems(items));
        break;
      }
      final rowItems = items.getRange(rowsCount, tobeTaken).toList();
      final Row row = _buildLayoutItems(rowItems);
      list.add(row);

      if ((items.length - tobeTaken) > 0 &&
          items.length - tobeTaken < maxColumns) {
        tobeTaken = items.length;
        rowsCount += maxColumns;
      } else {
        rowsCount += maxColumns;
        tobeTaken += maxColumns;
      }
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: _generateRows(
            widget.items,
            LayoutController.inst.isPhone(context)
                ? widget.phoneCols
                : LayoutController.inst.isTablet(context)
                    ? widget.tabletCols
                    : LayoutController.inst.isLargeTablet(context)
                        ? widget.bigTabletCols
                        : widget.computerCols),
      ),
    );
  }

  List<Widget> _buildPhoneLayoutList(List<LayoutItemModel> layoutItems) {
    final List<Widget> widgets = [];
    for (var item in layoutItems) {
      widgets.add(
        LayoutItem(
          isRightMost: true,
          requireFlex: false,
          flex: item.flex,
          item: item.child,
        ),
      );
    }
    return widgets;
  }

  _buildLayoutItems(List<LayoutItemModel> rowItems) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      children: List.generate(
        rowItems.length,
        (index) => LayoutItem(
          flex: rowItems[index].flex,
          item: rowItems[index].child,
        ),
      ),
    );
  }
}

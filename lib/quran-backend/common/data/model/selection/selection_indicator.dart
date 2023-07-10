import 'selection_rectangle.dart';

abstract class SelectionIndicator {}

class NoneIndicator extends SelectionIndicator {}

class ScrollOnly extends SelectionIndicator {}

class SelectedPointPosition extends SelectionIndicator {
  final double x;
  final double y;
  final double xScroll;
  final double yScroll;

  SelectedPointPosition(this.x, this.y, {this.xScroll = 0, this.yScroll = 0});
}

class SelectedItemPosition extends SelectionIndicator {
  final SelectionRectangle firstItem;
  final SelectionRectangle lastItem;
  final double xScroll;
  final double yScroll;

  SelectedItemPosition(this.firstItem, this.lastItem,
      {this.xScroll = 0, this.yScroll = 0});
}

SelectionIndicator withXScroll(SelectionIndicator selectionIndicator, double xScroll) {
  if (selectionIndicator is NoneIndicator || selectionIndicator is ScrollOnly) {
    return selectionIndicator;
  } else if (selectionIndicator is SelectedPointPosition) {
    return SelectedPointPosition(
      selectionIndicator.x,
      selectionIndicator.y,
      xScroll: xScroll,
      yScroll: selectionIndicator.yScroll,
    );
  } else if (selectionIndicator is SelectedItemPosition) {
    return SelectedItemPosition(
      selectionIndicator.firstItem,
      selectionIndicator.lastItem,
      xScroll: xScroll,
      yScroll: selectionIndicator.yScroll,
    );
  }
  throw ArgumentError("Invalid selectionIndicator");
}

SelectionIndicator withYScroll(SelectionIndicator selectionIndicator, double yScroll) {
  if (selectionIndicator is NoneIndicator || selectionIndicator is ScrollOnly) {
    return selectionIndicator;
  } else if (selectionIndicator is SelectedPointPosition) {
    return SelectedPointPosition(
      selectionIndicator.x,
      selectionIndicator.y,
      xScroll: selectionIndicator.xScroll,
      yScroll: yScroll,
    );
  } else if (selectionIndicator is SelectedItemPosition) {
    return SelectedItemPosition(
      selectionIndicator.firstItem,
      selectionIndicator.lastItem,
      xScroll: selectionIndicator.xScroll,
      yScroll: yScroll,
    );
  }
  throw ArgumentError("Invalid selectionIndicator");
}

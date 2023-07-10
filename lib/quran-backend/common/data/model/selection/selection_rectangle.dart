class SelectionRectangle {
  final double left;
  final double top;
  final double right;
  final double bottom;

  SelectionRectangle(this.left, this.top, this.right, this.bottom);

  double centerX() => left + ((right - left) / 2);
  double centerY() => top + ((bottom - top) / 2);
  SelectionRectangle offset(double x, double y) =>
      SelectionRectangle(left + x, top + y, right + x, bottom + y);
}

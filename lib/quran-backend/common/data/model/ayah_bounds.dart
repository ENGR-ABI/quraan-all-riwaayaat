import 'package:flutter/painting.dart';

class AyahBounds {
  final int ayah;
  final int line;
  final int position;
  late Rect bounds;

  AyahBounds(this.ayah, this.line, this.position, double minX, double minY, double maxX,
      double maxY, )
      : bounds = Rect.fromLTRB(minX, minY, maxX, maxY);

  AyahBounds.withRect(this.ayah, this.line, this.position, this.bounds,);

  void engulf(AyahBounds other) {
    bounds = bounds.expandToInclude(other.bounds);
  }

  Rect getBounds() {
    return Rect.fromLTWH(bounds.left, bounds.top, bounds.width, bounds.height);
  }

  AyahBounds withBounds(Rect bounds) {
    return AyahBounds.withRect(ayah,line, position, bounds);
  }
}

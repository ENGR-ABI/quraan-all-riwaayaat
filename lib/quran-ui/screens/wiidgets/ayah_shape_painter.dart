import 'package:flutter/material.dart';
import 'package:quranallriwayat/quran-backend/common/data/model/ayah_bounds.dart';

class AyahShapePainter extends CustomPainter {
  AyahShapePainter({this.ayahBounds, required this.color});
  final List<AyahBounds>? ayahBounds;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    if (ayahBounds != null) {
      final paint = Paint()
        ..color = color
        ..style = PaintingStyle.fill
        ..strokeWidth = 1.0;

      final path = Path();
      for (final verse in ayahBounds!) {
        final rect = verse.bounds;
        path.addRect(rect);
      }
      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true; // We do need to repaint since the shape is dynamic
  }
}

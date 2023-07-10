import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quranallriwayat/quran-backend/common/data/model/page_model.dart';
import 'package:quranallriwayat/quran-ui/index.dart';
import 'package:quranallriwayat/quran-ui/screens/wiidgets/ayah_shape_painter.dart';

class QuranPage extends GetView<QuranUIController> {
  const QuranPage({
    super.key,
    required this.fullScreen,
    required this.firstVerse,
    required this.page,
  });

  final bool fullScreen;
  final int firstVerse;
  final PageModel page;

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => CustomPaint(
        painter: AyahShapePainter(
          ayahBounds: controller.leftSelectedPageAyahBounds.value,
          color: controller.selectedColor.value,
        ),
        child: Container(
          padding: const EdgeInsets.fromLTRB(40, 30, 20, 30),
          constraints: const BoxConstraints.expand(),
          decoration: BoxDecoration(
            image: DecorationImage(
              image: FileImage(File(page.pageImage)),
              fit: BoxFit.fill,
            ),
          ),
        ),
      ),
    );
  }
}

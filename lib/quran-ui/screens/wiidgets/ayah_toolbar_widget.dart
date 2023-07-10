import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'triangle_clipper.dart';

class AyahToolbarWidget extends StatelessWidget {
  const AyahToolbarWidget({
    super.key,
    required this.ayahOffset,
    required this.leftPage,
    required this.ayahSelectioMode,
  });

  final Offset ayahOffset;
  final double leftPage;
  final bool ayahSelectioMode;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: ayahOffset.dy,
      left: ayahOffset.dx,
      child: Visibility(
        visible: ayahSelectioMode,
        child: Column(
          children: [
            Material(
              borderRadius: const BorderRadius.all(
                Radius.circular(20),
              ),
              color: Get.theme.colorScheme.shadow.withOpacity(.5),
              child: SizedBox(
                child: Wrap(
                  children: [
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.language_outlined),
                      color: Get.theme.colorScheme.secondary.withOpacity(.8),
                      splashRadius: 20,
                      tooltip: 'Tafseer',
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.bookmark_add),
                      color: Get.theme.colorScheme.secondary.withOpacity(.8),
                      splashRadius: 20,
                      tooltip: 'Bookmark',
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.play_circle_outline),
                      color: Get.theme.colorScheme.secondary.withOpacity(.8),
                      splashRadius: 20,
                      tooltip: 'Play',
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.highlight),
                      color: Get.theme.colorScheme.secondary.withOpacity(.8),
                      splashRadius: 20,
                      tooltip: 'Highlight',
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.share),
                      color: Get.theme.colorScheme.secondary.withOpacity(.8),
                      splashRadius: 20,
                      tooltip: 'Share',
                    ),
                  ],
                ),
              ),
            ),
            ClipPath(
              clipper: TriangleClipper(),
              child: Container(
                width: 20,
                height: 20 / 2,
                color: Get.theme.colorScheme.shadow.withOpacity(.5),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

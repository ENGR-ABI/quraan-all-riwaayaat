import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller.dart';

class QuranTypes extends GetView<QuranUIController> {
  const QuranTypes({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Obx(
        () => Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: 300,
              child: Obx(() => Column(
                    children: [
                      Text(
                        controller.quranTypes.value.isNotEmpty
                            ? controller
                                .quranTypes
                                .value[controller.quranTCurrentIndex.value]
                                .title
                            : '',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      Text(
                        controller.quranTypes.value.isNotEmpty
                            ? controller
                                .quranTypes
                                .value[controller.quranTCurrentIndex.value]
                                .description
                            : '',
                        style: const TextStyle(),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  )),
            ),
            const SizedBox(
              height: 20,
            ),
            ClipRRect(
              borderRadius: BorderRadius.circular(100),
              child: Container(
                constraints: const BoxConstraints(
                  maxWidth: 500,
                ),
                height: 280,
                width: controller.layout.isComputer(context) ? 500 : 600,
                child: Stack(
                  children: [
                    PageView.builder(
                      controller: controller.quranTypePController,
                      itemCount: controller.quranTypes.value.length,
                      reverse: false,
                      itemBuilder: (ctx, index) {
                        double scaleFactor =
                            index == controller.quranTCurrentIndex.value
                                ? 1.0
                                : 0.8; // Scale factor for each item
                        double translateFactor = index >
                                controller.quranTCurrentIndex.value
                            ? (index - controller.quranTCurrentIndex.value) *
                                32.0
                            : (controller.quranTCurrentIndex.value - index) *
                                32.0;
                        var quranType = controller.quranTypes.value[index];
                        return AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                          transform: Matrix4.identity()
                            ..scale(scaleFactor)
                            ..translate(
                              index == controller.quranTCurrentIndex.value
                                  ? 0.0
                                  : index ==
                                          controller.quranTCurrentIndex.value -
                                              1
                                      ? 0.0
                                      : 50.0,
                              translateFactor,
                            ),
                          height: 280,
                          child: Obx(
                            () => GestureDetector(
                              onTap: () {
                                if (controller.quranTCurrentIndex.value ==
                                    quranType.id - 1) {
                                  controller.quranTypeHovered.value =
                                      !controller.quranTypeHovered.value;
                                }
                              },
                              child: Stack(
                                children: [
                                  Positioned.fill(
                                    child: Image(
                                      image: FileImage(File(
                                          '${controller.appDocumentDirectory}/quranType/${quranType.images.first}')),
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                  Positioned.fill(
                                    child: AnimatedOpacity(
                                      duration:
                                          const Duration(milliseconds: 300),
                                      opacity:
                                          controller.quranTypeHovered.isTrue &&
                                                  controller.quranTCurrentIndex
                                                          .value ==
                                                      quranType.id - 1
                                              ? 1.0
                                              : 0.0,
                                      child: Image(
                                        image: FileImage(File(
                                            '${controller.appDocumentDirectory}/quranType/${quranType.images.last}')),
                                        fit: BoxFit.fill,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                      onPageChanged: (value) {
                        controller.quranTCurrentIndex.value = value;
                      },
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
                        constraints: const BoxConstraints(
                          maxWidth: 500 / 4,
                        ),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(colors: [
                            Colors.black.withOpacity(.1),
                            Colors.black.withOpacity(.19),
                            Colors.black.withOpacity(.16),
                            Colors.black.withOpacity(.13),
                            Colors.black.withOpacity(.09),
                            Colors.black.withOpacity(.06),
                            Colors.black.withOpacity(.03),
                          ]),
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Container(
                        constraints: const BoxConstraints(
                          maxWidth: 500 / 4,
                        ),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(colors: [
                            Colors.black.withOpacity(.03),
                            Colors.black.withOpacity(.06),
                            Colors.black.withOpacity(.09),
                            Colors.black.withOpacity(.13),
                            Colors.black.withOpacity(.16),
                            Colors.black.withOpacity(.19),
                            Colors.black.withOpacity(.1),
                          ]),
                        ),
                      ),
                    ),
                    if (controller.quranTCurrentIndex.value > 0)
                      Align(
                        alignment: Alignment.centerLeft,
                        child: InkWell(
                          onTap: () => controller.quranTypePController
                              .previousPage(
                                  duration: const Duration(milliseconds: 300),
                                  curve: Curves.easeIn),
                          child: Container(
                            width: 30,
                            height: 100,
                            decoration: BoxDecoration(
                              borderRadius: const BorderRadius.only(
                                topRight: Radius.circular(20),
                                bottomRight: Radius.circular(20),
                              ),
                              gradient: LinearGradient(
                                colors: [
                                  Get.theme.colorScheme.shadow.withOpacity(.3),
                                  Get.theme.colorScheme.background
                                      .withOpacity(.3),
                                ],
                                begin: Alignment.centerRight,
                                end: Alignment.centerLeft,
                              ),
                            ),
                            child: Icon(
                              Icons.chevron_left,
                              color: controller
                                  .activeTheme.value.colorScheme.primary,
                            ),
                          ),
                        ),
                      ),
                    if (controller.quranTCurrentIndex.value < 5 &&
                        controller.quranTypes.value.isNotEmpty)
                      Align(
                        alignment: Alignment.centerRight,
                        child: InkWell(
                          onTap: () => controller.quranTypePController.nextPage(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeIn),
                          child: Container(
                            width: 30,
                            height: 100,
                            decoration: BoxDecoration(
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(20),
                                bottomLeft: Radius.circular(20),
                              ),
                              gradient: LinearGradient(
                                colors: [
                                  Get.theme.colorScheme.background
                                      .withOpacity(.3),
                                  Get.theme.colorScheme.shadow.withOpacity(.3),
                                ],
                                begin: Alignment.centerRight,
                                end: Alignment.centerLeft,
                              ),
                            ),
                            child: Icon(
                              Icons.chevron_right,
                              color: controller
                                  .activeTheme.value.colorScheme.primary,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
            if (controller.quranTypes.value.isNotEmpty) ...[
              const SizedBox(
                height: 30,
              ),
              ElevatedButton.icon(
                onPressed: () {
                  int currentIndex = controller.quranTCurrentIndex.value;
                  var quranType = controller.quranTypes.value[currentIndex];
                  print(quranType.title);
                },
                icon: const Icon(Icons.download),
                label: const Text('Download'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Get.theme.primaryColor,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

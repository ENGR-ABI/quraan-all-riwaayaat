import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quranallriwayat/quran-ui/utils/extensions.dart';
import '../controller.dart';
import 'wiidgets/ayah_shape_painter.dart';
import 'wiidgets/ayah_toolbar_widget.dart';
import 'wiidgets/quran_page.dart';

class QuraanPageViewer extends StatefulWidget {
  const QuraanPageViewer({
    super.key,
  });

  @override
  State<QuraanPageViewer> createState() => _QuraanPageViewerState();
}

class _QuraanPageViewerState extends State<QuraanPageViewer> {
  final QuranUIController controller = Get.find();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double quranWidth =
        !controller.fullScreen.isTrue ? Get.width : Get.width - 300;
    return Scaffold(
      body: Column(
        children: [
          ///SECTION - QURAN PAGES SECTION
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              margin: const EdgeInsets.only(left: 10, right: 10, top: 10),
              color: Get.theme.primaryColor,
              child: Column(
                children: [
                  // Positioned(
                  //   top: 30,
                  //   left: 20,
                  //   width: quranInnerWidth,
                  //   child: Stack(
                  //     children: [
                  //       Align(
                  //         alignment: Alignment.centerRight,
                  //         child: InkWell(
                  //           onTapDown: (details) {
                  //             highligthAyah(
                  //               ayahCoordinates.ayahCoordinates,
                  //               details.localPosition,
                  //             );
                  //           },
                  //           onLongPress: () {
                  //             ayahSelectioMode = !ayahSelectioMode;
                  //             selectedColor = ayahSelectioMode
                  //                 ? selectionColor
                  //                 : hoverColor;
                  //             setState(() {});
                  //           },
                  //           onTap: () {
                  //             highligthAyah(
                  //                 ayahCoordinates.ayahCoordinates,
                  //                 ayahOffset);
                  //           },
                  //           child: QuranPage(
                  //             fullScreen: _fullScreen,
                  //             width: rightPage,
                  //             firstVerse: firstVerse,
                  //             currentAyahBounds: currentAyahBounds,
                  //             selectedColor: selectedColor,
                  //           ),
                  //         ),
                  //       ),

                  //       Align(
                  //         alignment: Alignment.centerLeft,
                  //         child: InkWell(
                  //           onTapDown: (details) {
                  //             highligthAyah(
                  //               ayahCoordinates.ayahCoordinates,
                  //               details.localPosition,
                  //             );
                  //           },
                  //           onLongPress: () {
                  //             ayahSelectioMode = !ayahSelectioMode;
                  //             selectedColor = ayahSelectioMode
                  //                 ? selectionColor
                  //                 : hoverColor;
                  //             setState(() {});
                  //           },
                  //           onTap: () {
                  //             highligthAyah(
                  //                 ayahCoordinates.ayahCoordinates,
                  //                 ayahOffset);
                  //           },
                  //           child: QuranPage(
                  //             fullScreen: _fullScreen,
                  //             width: leftPage,
                  //             firstVerse: firstVerse,
                  //             currentAyahBounds: currentAyahBounds,
                  //             selectedColor: selectedColor,
                  //           ),
                  //         ),
                  //       ),

                  const Row(
                    children: [
                      CommonToolbar(),
                      Spacer(),
                      PlayerToolbarWidget(),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Expanded(
                    child: Row(
                      children: [
                        if (!isSinglePage())
                          Container(
                            width: 20,
                            height: Get.height - 100,
                            decoration: BoxDecoration(
                              color: Get.theme.colorScheme.background,
                              image: DecorationImage(
                                repeat: ImageRepeat.repeatX,
                                image:
                                    AssetImage('book-edge-right.png'.imagePath),
                                fit: BoxFit.fitHeight,
                              ),
                            ),
                          ),
                        Expanded(
                          child: Obx(
                            () => AnimatedSwitcher(
                              duration: const Duration(microseconds: 300),
                              child: controller.loading.isTrue
                                  ? Container(
                                      constraints:
                                          const BoxConstraints.expand(),
                                      color: Get.theme.canvasColor,
                                      child: const Center(
                                        child: CircularProgressIndicator(),
                                      ),
                                    )
                                  : PageView.builder(
                                      controller: controller.pageController,
                                      physics: const ClampingScrollPhysics(),
                                      reverse: true,
                                      allowImplicitScrolling: true,
                                      onPageChanged: (page) {
                                        int destinationPageIndex =
                                            isSinglePage() ? page : (page * 2);
                                        var nextPage = controller.pagesToDisplay
                                            .value[destinationPageIndex];
                                        int prevIndex = destinationPageIndex <
                                                controller.pagesToDisplay.value
                                                        .length -
                                                    1
                                            ? destinationPageIndex + 1
                                            : destinationPageIndex;
                                        var prevPage = controller
                                            .pagesToDisplay.value[prevIndex];
                                        if (controller.currentPage.value >
                                            page) {
                                          controller.highligthAyah(
                                            prevPage.pageNumber,
                                            prevPage.ayahCoordinates,
                                            prevPage
                                                .ayahCoordinates[prevPage
                                                    .lastSuraAyah
                                                    .toTags()]!
                                                .first
                                                .bounds
                                                .topCenter,
                                          );
                                          controller.loadMorePages(page, false);
                                        } else {
                                          controller.highligthAyah(
                                            nextPage.pageNumber,
                                            nextPage.ayahCoordinates,
                                            nextPage
                                                .ayahCoordinates[
                                                    nextPage.suraAyah.toTags()]!
                                                .first
                                                .bounds
                                                .topCenter,
                                          );
                                          controller.loadMorePages(page, true);
                                        }
                                        controller.currentPage.value = page;
                                      },
                                      itemCount: isSinglePage()
                                          ? controller
                                              .pagesToDisplay.value.length
                                          : (controller.pagesToDisplay.value
                                                      .length /
                                                  2)
                                              .round(),
                                      itemBuilder: (context, index) {
                                        return buildBookPage(index, context);
                                      },
                                    ),
                            ),
                          ),
                        ),
                        if (!isSinglePage())
                          Container(
                            width: 10,
                            height: Get.height - 100,
                            decoration: BoxDecoration(
                              color: Get.theme.colorScheme.background,
                              image: DecorationImage(
                                image:
                                    AssetImage('book-edge-right.png'.imagePath),
                                fit: BoxFit.fitHeight,
                                repeat: ImageRepeat.repeatX,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          ///SECTION - BOTTOM NAVIGATIONS (JUZZ'U) SECTION
          if (!isSinglePage())
            Container(
              margin: const EdgeInsets.fromLTRB(10, 0, 10, 10),
              padding: const EdgeInsets.symmetric(horizontal: 40),
              width:
                  !controller.fullScreen.value ? quranWidth - 120 : quranWidth,
              height: 30,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(16),
                    bottomRight: Radius.circular(16)),
                gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Get.theme.colorScheme.primary,
                      Get.theme.colorScheme.secondary,
                      Get.theme.colorScheme.primary,
                    ]),
              ),
              child: Row(
                textDirection: TextDirection.rtl,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(
                  30,
                  (index) => InkWell(
                    onTap: () {
                      print('Jumping to juz ${index + 1}');
                    },
                    child: Text(
                      '${index + 1}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        backgroundColor:
                            index + 1 == 1 ? Get.theme.canvasColor : null,
                        color: Get.theme.colorScheme.primary,
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  isSinglePage() {
    return !controller.layout.isComputer(context);
  }

  List<int> _getEvenOrOddNumbers(int lenght, {bool checkForEven = true}) {
    List<int> evenNumbers = [];
    List<int> oddNumbers = [];
    for (int i = 0; i <= lenght; i++) {
      i.isEven ? evenNumbers.add(i) : oddNumbers.add(i);
    }
    return checkForEven ? evenNumbers : oddNumbers;
  }

  Widget buildBookPage(int index, BuildContext context) {
    double quranWidth =
        !controller.fullScreen.isTrue ? Get.width : Get.width - 300;
    double quranInnerWidth = quranWidth - 90;
    double leftPage = quranInnerWidth / 2;
    double rightPage = quranInnerWidth / 2;
    if (isSinglePage()) {
      return Container(
        color: Get.theme.canvasColor,
        height: double.infinity,
        width: quranInnerWidth,
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Column(
          children: [
            const SizedBox(
              height: 20,
            ),
            Expanded(
              child: QuranPage(
                fullScreen: controller.fullScreen.isTrue,
                firstVerse: controller.firstVerse,
                page: controller.pagesToDisplay.value[index],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            SizedBox(
              height: 30,
              child: Text(
                controller.pagesToDisplay.value[index].pageNumber.toString(),
              ),
            ),
          ],
        ),
      );
    } else {
      final rightScreenIndex =
          _getEvenOrOddNumbers(controller.pagesToDisplay.value.length - 1);
      final leftScreenIndex = _getEvenOrOddNumbers(
          controller.pagesToDisplay.value.length - 1,
          checkForEven: false);
      final currentPage = index + 1;
      final nextPage = currentPage + 1 <= controller.pagesToDisplay.value.length
          ? currentPage + 1
          : null;
      return Obx(
        () => Container(
          color: Get.theme.colorScheme.surface,
          child: Stack(
            children: [
              Align(
                alignment: Alignment.centerRight,
                child: GestureDetector(
                  onTapUp: (TapUpDetails details) {
                    final tapPosition = details.localPosition.dx;

                    if (tapPosition >= rightPage * 0.8) {
                      _goToPreviousPage();
                    }
                  },
                  child: Container(
                    height: Get.height,
                    width: rightPage,
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Expanded(
                          child: InkWell(
                            onTapDown: (details) {
                              controller.highligthAyah(
                                controller.pagesToDisplay
                                    .value[rightScreenIndex[index]].pageNumber,
                                controller
                                    .pagesToDisplay
                                    .value[rightScreenIndex[index]]
                                    .ayahCoordinates,
                                details.localPosition,
                              );
                            },
                            onLongPress: () {
                              controller.ayahSelectioMode.value =
                                  !controller.ayahSelectioMode.value;
                              controller.selectedColor.value =
                                  controller.ayahSelectioMode.value
                                      ? controller.selectionColor
                                      : controller.hoverColor;
                            },
                            child: CustomPaint(
                              painter: AyahShapePainter(
                                ayahBounds: controller
                                    .rightSelectedPageAyahBounds.value,
                                color: controller.selectedColor.value,
                              ),
                              child: Container(
                                padding:
                                    const EdgeInsets.fromLTRB(40, 30, 20, 30),
                                constraints: const BoxConstraints.expand(),
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: FileImage(File(controller
                                        .pagesToDisplay
                                        .value[rightScreenIndex[index]]
                                        .pageImage)),
                                    fit: BoxFit.fill,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 30,
                          child: Text(
                            controller.pagesToDisplay
                                .value[rightScreenIndex[index]].pageNumber
                                .toString(),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              if (nextPage != null)
                Align(
                  alignment: Alignment.centerLeft,
                  child: GestureDetector(
                    onTapUp: (TapUpDetails details) {
                      final tapPosition = details.localPosition.dx;

                      if (tapPosition <= leftPage * 0.2) {
                        _goToNextPage();
                      }
                    },
                    child: Container(
                      width: leftPage,
                      height: Get.height,
                      padding: const EdgeInsets.all(20),
                      child: index < leftScreenIndex.length
                          ? Column(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Expanded(
                                  child: InkWell(
                                    onTapDown: (details) {
                                      controller.highligthAyah(
                                        controller
                                            .pagesToDisplay
                                            .value[leftScreenIndex[index]]
                                            .pageNumber,
                                        controller
                                            .pagesToDisplay
                                            .value[leftScreenIndex[index]]
                                            .ayahCoordinates,
                                        details.localPosition,
                                      );
                                    },
                                    onLongPress: () {
                                      controller.ayahSelectioMode.value =
                                          !controller.ayahSelectioMode.value;
                                      controller.selectedColor.value =
                                          controller.ayahSelectioMode.value
                                              ? controller.selectionColor
                                              : controller.hoverColor;
                                    },
                                    child: CustomPaint(
                                      painter: AyahShapePainter(
                                        ayahBounds: controller
                                            .leftSelectedPageAyahBounds.value,
                                        color: controller.selectedColor.value,
                                      ),
                                      child: Container(
                                        padding: const EdgeInsets.fromLTRB(
                                            40, 30, 20, 30),
                                        constraints:
                                            const BoxConstraints.expand(),
                                        decoration: BoxDecoration(
                                          image: DecorationImage(
                                            image: FileImage(File(controller
                                                .pagesToDisplay
                                                .value[leftScreenIndex[index]]
                                                .pageImage)),
                                            fit: BoxFit.fill,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 30,
                                  child: Text(
                                    controller
                                        .pagesToDisplay
                                        .value[leftScreenIndex[index]]
                                        .pageNumber
                                        .toString(),
                                  ),
                                ),
                              ],
                            )
                          : const SizedBox.shrink(),
                    ),
                  ),
                ),

              /// Shadows
              Align(
                child: Container(
                  height: Get.height - 100,
                  width: 160,
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                          begin: Alignment.centerRight,
                          end: Alignment.centerLeft,
                          colors: [
                        Get.theme.shadowColor.withOpacity(0.02),
                        Get.theme.shadowColor.withOpacity(0.05),
                        Get.theme.shadowColor.withOpacity(0.06),
                        Get.theme.shadowColor.withOpacity(0.08),
                        Get.theme.shadowColor.withOpacity(0.09),
                        Get.theme.shadowColor.withOpacity(.3),
                        Get.theme.shadowColor.withOpacity(0.09),
                        Get.theme.shadowColor.withOpacity(0.08),
                        Get.theme.shadowColor.withOpacity(0.06),
                        Get.theme.shadowColor.withOpacity(0.05),
                        Get.theme.shadowColor.withOpacity(0.02),
                      ])),
                ),
              ),

              AyahToolbarWidget(
                ayahOffset: controller.ayahOffset.value,
                ayahSelectioMode: controller.ayahSelectioMode.value,
                leftPage: leftPage,
              ),
            ],
          ),
        ),
      );
    }
  }

  void _goToPreviousPage() {
    print('Going to previous');
  }

  void _goToNextPage() {
    print('Going to next');
  }
}

class CommonToolbar extends StatelessWidget {
  const CommonToolbar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        InkWell(
          onTap: () {
            // _fullScreen = !_fullScreen;
            // setState(() {});
          },
          child: Icon(
            Icons.menu,
            color: Get.theme.colorScheme.secondary,
          ),
        ),
        const SizedBox(
          width: 10,
        ),
        InkWell(
          onTap: () {},
          child: Icon(
            Icons.bookmark,
            color: Get.theme.colorScheme.secondary,
          ),
        ),
        const SizedBox(
          width: 10,
        ),
        InkWell(
          onTap: () {},
          child: Icon(
            Icons.search,
            color: Get.theme.colorScheme.secondary,
          ),
        ),
        const SizedBox(
          width: 10,
        ),
        InkWell(
          onTap: () {},
          child: Icon(
            Icons.info_outline,
            color: Get.theme.colorScheme.secondary,
          ),
        ),
      ],
    );
  }
}

class PlayerToolbarWidget extends StatelessWidget {
  const PlayerToolbarWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Text(
          'Sheikh Mahmud Khalil',
          style: TextStyle(color: Get.theme.colorScheme.onPrimary),
        ),
        const SizedBox(
          width: 10,
        ),
        InkWell(
          onTap: () {},
          child: Icon(
            Icons.play_circle,
            color: Get.theme.colorScheme.secondary,
          ),
        ),
        const SizedBox(
          width: 10,
        ),
        InkWell(
          onTap: () {},
          child: Icon(
            Icons.stop_circle,
            color: Get.theme.colorScheme.secondary,
          ),
        ),
        const SizedBox(
          width: 10,
        ),
        InkWell(
          onTap: () {},
          child: Icon(
            Icons.repeat,
            color: Get.theme.colorScheme.secondary,
          ),
        ),
      ],
    );
  }
}

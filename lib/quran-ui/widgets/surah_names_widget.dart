import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:quranallriwayat/quran-ui/theme/theme_controller.dart';
import 'package:quranallriwayat/quran-ui/utils/extensions.dart';
import '../controller.dart';
import 'custom_tile.dart';

class SurahNamesWidget extends StatefulWidget {
  const SurahNamesWidget({
    super.key,
  });

  @override
  State<SurahNamesWidget> createState() => _SurahNamesWidgetState();
}

class _SurahNamesWidgetState extends State<SurahNamesWidget>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final QuranUIController controller = Get.find<QuranUIController>();
  final themeCTRL = ThemeController.inst;
  @override
  void initState() {
    super.initState();
    // Create a TabController to manage the tabs
    _tabController = TabController(initialIndex: 1, length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      decoration: BoxDecoration(
        color: themeCTRL.darkTheme.primaryColor,
        image: DecorationImage(
          image: AssetImage(
            'quran.png'.imagePath,
          ),
          fit: BoxFit.fill,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Container(
            padding: const EdgeInsets.only(top: 10),
            height: .25.sh,
            child: Stack(
              children: [
                Align(
                  alignment: Alignment.topCenter,
                  child: Obx(
                    () => Row(
                      children: [
                        if (controller.state.index.value != 0)
                          IconButton(
                            onPressed: controller.stopReading,
                            icon: const Icon(Icons.arrow_back_ios_new),
                            color: Get.theme.canvasColor,
                          ),
                        const Spacer(),
                      ],
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    'بِسْمِ اللهِ الرَّحْمٰنِ الرَّحِيْمِ',
                    style: TextStyle(
                      fontSize: 14,
                      color: themeCTRL.darkTheme.primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    margin: const EdgeInsets.only(left: 4, right: 8),
                    child: TabBar(
                      controller: _tabController,
                      labelColor: themeCTRL.darkTheme.primaryColor,
                      indicatorColor: themeCTRL.darkTheme.primaryColor,
                      tabs: const [
                        Tab(text: 'JUZ'),
                        Tab(text: 'SURAHS'),
                        Tab(text: 'BOOKMARK'),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Material(
              color: Colors.transparent,
              child: TabBarView(
                controller: _tabController,
                children: [
                  Container(),
                  ListView.builder(
                      itemCount: controller.quranSurahMeta.length,
                      itemBuilder: (ctx, index) {
                        return CustomTile(
                          leading: SizedBox(
                            width: 30,
                            child: Center(
                              child: Text(
                                '${index + 1}',
                                style: TextStyle(
                                  color: themeCTRL.darkTheme.primaryColor,
                                ),
                              ),
                            ),
                          ),
                          title: Text(
                            'Surah ${controller.quranSurahMeta[index].name} (${controller.quranSurahMeta[index].translatedName})',
                            style: TextStyle(
                              color: themeCTRL.darkTheme.primaryColor,
                            ),
                          ),
                          subTitle: Text(
                            '${controller.quranSurahMeta[index].revelationPlace} - ${controller.quranSurahMeta[index].numberOfVerses} verses',
                            style: TextStyle(
                              color: themeCTRL.darkTheme.primaryColor
                                  .withOpacity(.7),
                            ),
                          ),
                          onTap: () => controller
                              .startQuran(controller.quranSurahMeta[index]),
                          trailing: const SizedBox.shrink(),
                        );
                      }),
                  Container(),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

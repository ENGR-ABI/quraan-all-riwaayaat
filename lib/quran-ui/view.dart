import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:libadwaita/libadwaita.dart';
import 'package:libadwaita_window_manager/libadwaita_window_manager.dart';
import 'package:quranallriwayat/quran-ui/index.dart';
import 'package:quranallriwayat/quran-ui/theme/theme_controller.dart';
import 'package:quranallriwayat/quran-ui/widgets/surah_names_widget.dart';
import 'package:url_launcher/url_launcher.dart';

class HomePage extends GetView<QuranUIController> {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final developers = {
      'Aadam B Eydrees': 'engr-abi',
    };

    return Obx(
      () => Scaffold(
        appBar: AppBar(
          toolbarHeight: 0,
          automaticallyImplyLeading: false,
          systemOverlayStyle: SystemUiOverlayStyle(
            statusBarBrightness: controller.activeTheme.value.brightness,
            systemNavigationBarIconBrightness:
                controller.activeTheme.value.brightness,
          ),
        ),
        body: AdwScaffold(
          flapController: controller.flapController,
          flapStyle: const FlapStyle(breakpoint: 1800, flapWidth: 300),
          actions: AdwActions().windowManager,
          start: const [],
          title: const Text('Quran All Riwaayaat'),
          end: [
            AdwHeaderButton(
              icon: const Icon(Icons.view_sidebar_outlined, size: 19),
              isActive: controller.flapController.isOpen,
              onPressed: controller.flapController.toggle,
            ),
            AdwHeaderButton(
              icon: controller.activeTheme.value.brightness == Brightness.dark
                  ? const Icon(Icons.light_mode, size: 15)
                  : const Icon(Icons.nightlight_round, size: 15),
              onPressed: changeTheme,
            ),
            GtkPopupMenu(
              body: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  AdwButton.flat(
                    onPressed: () {
                      //counter.value = 0;
                      Navigator.of(context).pop();
                    },
                    padding: AdwButton.defaultButtonPadding.copyWith(
                      top: 10,
                      bottom: 10,
                    ),
                    child: const Text(
                      'Reset Counter',
                      style: TextStyle(fontSize: 15),
                    ),
                  ),
                  const Divider(),
                  AdwButton.flat(
                    padding: AdwButton.defaultButtonPadding.copyWith(
                      top: 10,
                      bottom: 10,
                    ),
                    child: const Text(
                      'Preferences',
                      style: TextStyle(fontSize: 15),
                    ),
                  ),
                  AdwButton.flat(
                    padding: AdwButton.defaultButtonPadding.copyWith(
                      top: 10,
                      bottom: 10,
                    ),
                    onPressed: () => showDialog<Widget>(
                      context: context,
                      builder: (ctx) => AdwAboutWindow(
                        issueTrackerLink:
                            'https://github.com/ENGR-ABI/quran-all-riwayat/issues',
                        appIcon: Image.asset('assets/logo.png'),
                        appName: 'Quran All Riwayat',
                        credits: [
                          AdwPreferencesGroup.creditsBuilder(
                            title: 'Developers',
                            itemCount: developers.length,
                            itemBuilder: (_, index) => AdwActionRow(
                              title: developers.keys.elementAt(index),
                              onActivated: () => launchUrl(
                                Uri.parse(
                                  'https://github.com/${developers.values.elementAt(index)}',
                                ),
                              ),
                            ),
                          ),
                        ],
                        copyright: 'Copyright 2021-2022 Gtk-Flutter Developers',
                        license: const Text(
                          'GNU LGPL-3.0, This program comes with no warranty.',
                        ),
                      ),
                    ),
                    child: const Text(
                      'About this App',
                      style: TextStyle(fontSize: 15),
                    ),
                  ),
                ],
              ),
            ),
          ],
          flap: (isDrawer) => const SurahNamesWidget(),
          body: controller.screens[controller.state.index.value],
        ),
      ),
    );
  }

  void changeTheme() {
    ThemeController.inst.themeNotifier.value =
        Get.isDarkMode ? ThemeMode.light : ThemeMode.dark;
  }
}

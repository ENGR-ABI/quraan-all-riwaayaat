import 'package:flutter/material.dart';
import 'package:libadwaita/libadwaita.dart';
import 'package:libadwaita_window_manager/libadwaita_window_manager.dart';
import 'package:quranallriwayat/pages/avatar_page.dart';
import 'package:quranallriwayat/pages/counter_page.dart';
import 'package:quranallriwayat/pages/flap_page.dart';
import 'package:quranallriwayat/pages/lists_page.dart';
import 'package:quranallriwayat/pages/settings_page.dart';
import 'package:quranallriwayat/pages/style_classes_page.dart';
import 'package:quranallriwayat/pages/view_switcher_page.dart';
import 'package:quranallriwayat/pages/welcome.dart';
import 'package:quranallriwayat/quran-ui/widgets/surah_names_widget.dart';
import 'package:url_launcher/url_launcher.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.themeNotifier});

  final ValueNotifier<ThemeMode> themeNotifier;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  ValueNotifier<int> counter = ValueNotifier(0);
  final int _currentIndex = 0;

  late ScrollController listController;
  late ScrollController settingsController;
  late FlapController _flapController;
  double drawerWidth = 300.0;

  @override
  void initState() {
    super.initState();
    listController = ScrollController();
    settingsController = ScrollController();
    _flapController = FlapController();

    _flapController.addListener(() {
      if (_flapController.isModal) {
        print('yesss moadl noaw');
        //drawerWidth = 500;
      }
      setState(() {});
    });
  }

  @override
  void dispose() {
    listController.dispose();
    settingsController.dispose();
    super.dispose();
  }

  void changeTheme() =>
      widget.themeNotifier.value = widget.themeNotifier.value == ThemeMode.light
          ? ThemeMode.dark
          : ThemeMode.light;

  @override
  Widget build(BuildContext context) {
    final developers = {
      'Prateek Sunal': 'prateekmedia',
      'Malcolm Mielle': 'MalcolmMielle',
      'sim': 'simrat39',
      'Jesús Rodríguez': 'jesusrp98',
      'Polo': 'pablojimpas',
    };

    return Scaffold(
      body: AdwScaffold(
        flapController: _flapController,
        flapStyle: FlapStyle(breakpoint: 1800, flapWidth: drawerWidth),
        actions: AdwActions().windowManager,
        start: [
          AdwHeaderButton(
            icon: const Icon(Icons.view_sidebar_outlined, size: 19),
            isActive: _flapController.isOpen,
            onPressed: () => _flapController.toggle(),
          ),
          AdwHeaderButton(
            icon: const Icon(Icons.nightlight_round, size: 15),
            onPressed: changeTheme,
          ),
        ],
        title: const Text('Quran All Riwaayaat'),
        end: [
          GtkPopupMenu(
            body: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                AdwButton.flat(
                  onPressed: () {
                    counter.value = 0;
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
                          'https://github.com/gtk-flutter/libadwaita/issues',
                      appIcon: Image.asset('assets/logo.png'),
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
                    'About this Demo',
                    style: TextStyle(fontSize: 15),
                  ),
                ),
              ],
            ),
          ),
        ],
        flap: (isDrawer) =>
            SizedBox(width: drawerWidth, child: const SurahNamesWidget()),
        body: AdwViewStack(
          animationDuration: const Duration(milliseconds: 100),
          index: _currentIndex,
          children: [
            const WelcomePage(),
            CounterPage(counter: counter),
            const ListsPage(),
            const AvatarPage(),
            const FlapPage(),
            const ViewSwitcherPage(),
            const SettingsPage(),
            const StyleClassesPage(),
          ],
        ),
      ),
    );
  }
}

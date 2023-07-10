import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:quranallriwayat/flap/flap_demo.dart';
import 'package:quranallriwayat/quran-ui/binding.dart';
import 'package:quranallriwayat/quran-ui/bindings/intial_binding.dart';
import 'package:quranallriwayat/quran-ui/locale/app_locale.dart';
import 'package:quranallriwayat/quran-ui/theme/theme_controller.dart';
import 'package:quranallriwayat/quran-ui/view.dart';
import 'package:quranallriwayat/view_switcher/view_switcher_demo.dart';
import 'package:syncfusion_localizations/syncfusion_localizations.dart';
import 'package:window_manager/window_manager.dart';

Future<void> main(List<String> args) async {
  await InitialBinding.init();

  if (!Platform.isIOS && !Platform.isAndroid) {
    if (args.firstOrNull == 'multi_window') {
      // final windowId = int.parse(args[1]);
      print(args);
      final argument = args[2].isEmpty
          ? <String, dynamic>{}
          : jsonDecode(args[2]) as Map<String, dynamic>;
      switch (argument['name']) {
        case 'flap':
          runApp(FlapDemo());
          break;
        case 'views':
          runApp(ViewSwitcherDemo());
          break;
      }
    } else {
      await windowManager.ensureInitialized();

      const windowOptions = WindowOptions(
        size: Size(1000, 600),
        minimumSize: Size(400, 450),
        skipTaskbar: false,
        backgroundColor: Colors.transparent,
        titleBarStyle: TitleBarStyle.hidden,
        title: 'Quraan All Riwaayaat',
      );

      //unawaited(
      await windowManager.waitUntilReadyToShow(windowOptions, () async {
        if (Platform.isLinux || Platform.isMacOS) {
          await windowManager.setAsFrameless();
        }
        await windowManager.show();
        await windowManager.focus();
      });
      //);
    }
  }

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final GlobalKey<NavigatorState> navigatorKey = Get.key;

  final FlutterLocalization _localization = FlutterLocalization.instance;

  @override
  void initState() {
    _localization
      ..init(
        mapLocales: [
          const MapLocale(
            'ar',
            AppLocale.AR,
            fontFamily: 'NatoSansArabi_regular',
          ),
          const MapLocale(
            'en',
            AppLocale.EN,
            fontFamily: 'Lato_regular',
          ),
          const MapLocale(
            'ja',
            AppLocale.JA,
          ),
        ],
        initLanguageCode: 'en',
      )
      ..onTranslatedLanguage = _onTranslatedLanguage;
    super.initState();
  }

  void _onTranslatedLanguage(Locale? locale) {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: ThemeController.inst.themeNotifier,
      builder: (_, ThemeMode currentMode, __) {
        return ScreenUtilInit(
            minTextAdapt: true,
            //splitScreenMode: true,
            builder: (BuildContext context, Widget? child) {
              return GetMaterialApp(
                builder: (context, child) {
                  final virtualWindowFrame = VirtualWindowFrameInit();

                  return virtualWindowFrame(context, child);
                },
                theme: ThemeController.inst.lightTheme,
                darkTheme: ThemeController.inst.darkTheme,
                debugShowCheckedModeBanner: false,
                themeMode: currentMode,
                supportedLocales: _localization.supportedLocales,
                localizationsDelegates: [
                  ..._localization.localizationsDelegates,
                  SfGlobalLocalizations.delegate,
                ],
                locale: _localization.currentLocale,
                textDirection:
                    _localization.currentLocale?.toLanguageTag() == 'ar'
                        ? TextDirection.rtl
                        : TextDirection.ltr,
                initialBinding: HomeBinding(),
                home: const HomePage(),
              );
            });
      },
    );
  }
}

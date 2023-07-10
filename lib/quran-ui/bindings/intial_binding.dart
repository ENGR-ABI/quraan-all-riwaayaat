import 'package:fast_cached_network_image/fast_cached_network_image.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/instance_manager.dart';
import 'package:hive_local_storage/hive_local_storage.dart';
import 'package:path_provider/path_provider.dart';
import '../../firebase_options.dart';
import '../controllers/app_storage.dart';
import '../layout/layout_controller.dart';
import '../theme/theme_controller.dart';

class InitialBinding {
  static Future init() async {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    await Hive.initFlutter();
    //Get.put(AuthController());
    //Get.put(AppController());
    Get.put(LayoutController());
    await Get.putAsync<ThemeController>(
        () => ThemeController().loadThemeData());
    await Get.putAsync<AppStorage>(() => AppStorage().initialize());
    // Get.put(CacheStore());
    //Get.lazyPut(() => ApiService());
    String storageLocation = (await getApplicationDocumentsDirectory()).path;
    await FastCachedImageConfig.init(
        subDir: storageLocation, clearCacheAfter: const Duration(days: 15));
  }
}

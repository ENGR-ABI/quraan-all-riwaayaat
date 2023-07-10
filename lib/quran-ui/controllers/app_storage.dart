import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppStorage extends GetxService {
  static AppStorage get inst => Get.find();
  late final SharedPreferences _prefs;

  Future<AppStorage> initialize() async {
    _prefs = await SharedPreferences.getInstance();
    return this;
  }

  Future<bool> store(Map<String, dynamic> values) async {
    bool task = false;
    values.forEach((key, value) async {
      if (value.runtimeType == int) {
        task = await _prefs.setInt(key, value);
      } else if (value.runtimeType == bool) {
        task = await _prefs.setBool(key, value);
      } else if (value.runtimeType == double) {
        task = await _prefs.setDouble(key, value);
      } else if (value.runtimeType == String) {
        task = await _prefs.setString(key, value);
      } else if (value.runtimeType == List) {
        task = await _prefs.setStringList(key, value);
      }
    });
    return task;
  }

  Object? fetch(String key) => _prefs.get(key);

  Future<bool> setStringList(String key, List<String> value) async {
    return await _prefs.setStringList(key, value);
  }

  Future<bool> remove(String key) async => await _prefs.remove(key);
}

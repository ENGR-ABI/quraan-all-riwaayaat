// ignore_for_file: inference_failure_on_function_invocation
import 'dart:convert';
import 'package:hive_local_storage/hive_local_storage.dart';

class CacheManager<T> {

  CacheManager(this.cacheBoxName);
  final String cacheBoxName;

  Future<void> cacheData(String key, T data) async {
    final box = await Hive.openBox(cacheBoxName);
    final json = jsonEncode(data);
    await box.put(key, json);
    await box.close();
  }

  Future<dynamic> fetchData(String key) async {
    final box = await Hive.openBox(cacheBoxName);
    final json = box.get(key);
    await box.close();
    if (json != null) {
      final decoded = jsonDecode(json.toString()) as List;
      return decoded;
    }
    return null;
  }
}

import 'package:get/get.dart';

class QuranUIState {
  var index = 0.obs;

  set(int navValue) {
    index.value = navValue;
  }
}

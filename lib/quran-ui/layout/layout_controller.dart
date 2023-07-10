import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class LayoutController extends GetxService {
  static LayoutController get inst => Get.find();

  /// Responsive Layout Values
  final int tinyHeightLimit = 100;
  final int tinyLimit = 280;
  final int phoneLimit = 550;
  final int tabletLimit = 800;
  final int largeTabletLimit = 1100;

  bool isTinyHeightLimit(BuildContext context) =>
      MediaQuery.of(context).size.height < tinyHeightLimit;

  bool isTinyLimit(BuildContext context) =>
      MediaQuery.of(context).size.width < tinyLimit;

  bool isPhone(BuildContext context) =>
      MediaQuery.of(context).size.width < phoneLimit &&
      MediaQuery.of(context).size.width >= tinyLimit;

  bool isTablet(BuildContext context) =>
      MediaQuery.of(context).size.width < tabletLimit &&
      MediaQuery.of(context).size.width >= phoneLimit;

  bool isLargeTablet(BuildContext context) =>
      MediaQuery.of(context).size.width < largeTabletLimit &&
      MediaQuery.of(context).size.width >= tabletLimit;

  bool isComputer(BuildContext context) =>
      MediaQuery.of(context).size.width >= largeTabletLimit;

  /// End Of Responsive Layput
}

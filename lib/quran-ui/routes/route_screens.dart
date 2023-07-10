import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/routes/get_route.dart';
import '../index.dart';
import 'route_names.dart';

class AppScreens {
  ///
  static final RouteObserver<Route> observer = RouteObserver();

  ///
  static final List<String> history = [];

  ///
  static final List<GetPage> routes = [
    GetPage(
      name: AppRoutes.homePage,
      page: () => const HomePage(),
      binding: HomeBinding(),
      middlewares: const [
        //AuthMiddleware(),
      ],
    ),
    GetPage(
        name: '/name',
        page: () => Scaffold(
              appBar: AppBar(),
            )),
  ];
}

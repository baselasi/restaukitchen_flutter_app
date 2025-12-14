import 'package:flutter/material.dart';
import 'package:restaukitchen_app/page/homePage/home_page.dart';

enum Pages {
  home,
  // menus,
  // tables,
  // settings,
}

Widget buildPage(Pages page) {
  switch (page) {
    case Pages.home:
      return const HomePage();
  }
}

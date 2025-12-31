import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restaukitchen_app/page/homePage/bloc/orders_count_cubit.dart';
import 'package:restaukitchen_app/page/homePage/bloc/table_count_cubit.dart';
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
      return MultiBlocProvider(
        providers: [
          BlocProvider<TableCountCubit>(create: (context) => TableCountCubit()),
          BlocProvider<OrdersCountCubit>(
            create: (context) => OrdersCountCubit(),
          ),
        ],
        child: HomePage(),
      );
  }
}

Widget getPageTitle(Pages page) {
  switch (page) {
    case Pages.home:
      return const Text('Home Page');
  }
}

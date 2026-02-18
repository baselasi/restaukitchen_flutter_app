import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restaukitchen_app/core/services/api_service.dart';
import 'package:restaukitchen_app/core/services/sevices_loactor.dart';
import 'package:restaukitchen_app/page/homePage/bloc/orders_count_cubit.dart';
import 'package:restaukitchen_app/page/homePage/bloc/table_count_cubit.dart';
import 'package:restaukitchen_app/page/homePage/home_page.dart';
import 'package:restaukitchen_app/page/menusPage/menus_page.dart';
import 'package:restaukitchen_app/page/menusPage/bloc/menus_page_bloc.dart';
import 'package:restaukitchen_app/page/order_list/bloc/orders_list_bloc/orders_list_bloc.dart';
import 'package:restaukitchen_app/page/order_list/orders_list.dart';
import 'package:restaukitchen_app/page/order_list/repository/orders_list_repo.dart';

enum Pages {
  home,
  menus,
  orders,
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
    case Pages.menus:
      return BlocProvider<MenusPageBloc>(
        create: (context) => MenusPageBloc(),
        child: MenusPage(),
      );
    case Pages.orders:
      return BlocProvider<OrdersListBloc>(
        create: (context) => OrdersListBloc(
          repo: OrdersListRepo(apiService: getIt<ApiService>()),
        ),
        child: OrdersList(),
      );
  }
}

Widget getPageTitle(Pages page) {
  switch (page) {
    case Pages.home:
      return const Text('Home Page');
    case Pages.menus:
      return const Text('Menus Page');
    case Pages.orders:
      return const Text('Orders Page');
  }
}

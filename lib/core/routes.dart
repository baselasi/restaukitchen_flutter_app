import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restaukitchen_app/page/combination_list/bloc/combination_get_cubit/combination_get_list_cubit.dart';
import 'package:restaukitchen_app/page/combination_list/combination_list.dart';
import 'package:restaukitchen_app/page/combination_list/repository/combination_list_repo.dart';
import 'package:restaukitchen_app/page/homePage/bloc/orders_count_cubit.dart';
import 'package:restaukitchen_app/page/homePage/bloc/table_count_cubit.dart';
import 'package:restaukitchen_app/page/homePage/home_page.dart';
import 'package:restaukitchen_app/page/menusPage/menus_page.dart';
import 'package:restaukitchen_app/page/menusPage/bloc/menus_page_bloc.dart';
import 'package:restaukitchen_app/core/repository/category_repo.dart';
import 'package:restaukitchen_app/page/order_list/bloc/orders_drawer_cubit.dart';
import 'package:restaukitchen_app/page/order_list/bloc/orders_page_cubit.dart';
import 'package:restaukitchen_app/page/order_list/orders_list.dart';
import 'package:restaukitchen_app/page/settings_page/bloc/restaurant_info_cubit/restaurant_info_cubit.dart';
import 'package:restaukitchen_app/page/settings_page/respository/restaurant_repo.dart';
import 'package:restaukitchen_app/page/settings_page/settings_page.dart';
import 'package:restaukitchen_app/page/tabels_list/bloc/tabels_list_cubit.dart';
import 'package:restaukitchen_app/page/tabels_list/repository/tables_repo.dart';
import 'package:restaukitchen_app/page/tabels_list/tabels_list.dart';

enum Pages { home, menus, orders, tables, combinations, settings }

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
      return MultiBlocProvider(
        providers: [
          BlocProvider<OrdersPageCubit>(create: (context) => OrdersPageCubit()),
          BlocProvider<OrdersCategoryCubit>(
            create: (context) =>
                OrdersCategoryCubit(categoryRepo: CategoryRepo()),
          ),
        ],
        child: const OrdersList(),
      );
    case Pages.tables:
      return BlocProvider<TabelsListCubit>(
        create: (context) => TabelsListCubit(tablesRepo: TablesRepo()),
        child: const TabelsList(),
      );
    case Pages.combinations:
      return BlocProvider<CombinationGetListCubit>(
        create: (context) =>
            CombinationGetListCubit(combinationListRepo: CombinationListRepo()),
        child: const CombinationList(),
      );
    case Pages.settings:
      return BlocProvider<RestaurantInfoCubit>(
        create: (context) =>
            RestaurantInfoCubit(restaurantRepo: RestaurantRepo()),
        child: const SettingsPage(),
      );
  }
}

Widget getPageTitle(Pages page) {
  switch (page) {
    case Pages.home:
      return const Text('Home');
    case Pages.menus:
      return const Text('Menus');
    case Pages.orders:
      return const Text('Orders');
    case Pages.tables:
      return const Text('Tables');
    case Pages.combinations:
      return const Text('Combinations');
    case Pages.settings:
      return const Text('Settings');
  }
}

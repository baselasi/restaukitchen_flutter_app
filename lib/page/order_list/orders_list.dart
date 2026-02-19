import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restaukitchen_app/page/order_list/bloc/orders_page_cubit.dart';
import 'package:restaukitchen_app/page/order_list/components/kitchen_list.dart';
import 'package:restaukitchen_app/page/order_list/components/orders_drawer.dart';
import 'package:restaukitchen_app/theme/light_theme.dart';

class OrdersList extends StatelessWidget {
  const OrdersList({super.key});

  Widget _buildBody(OrderSubPage page) {
    switch (page) {
      case OrderSubPage.kitchen:
        return const KitchenList();
      case OrderSubPage.archive:
        return const Center(child: Text('Archive list'));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OrdersPageCubit, OrdersPageState>(
      builder: (context, state) {
        return Scaffold(
          endDrawer: const OrdersDrawer(),
          body: _buildBody(state.page),
          floatingActionButton: Builder(
            builder: (context) {
              return FloatingActionButton(
                backgroundColor: LightTheme.primaryColor,
                onPressed: () => Scaffold.of(context).openEndDrawer(),
                child: const Icon(Icons.menu, color: Colors.white),
              );
            },
          ),
        );
      },
    );
  }
}

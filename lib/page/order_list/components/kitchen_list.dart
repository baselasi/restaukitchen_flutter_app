import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restaukitchen_app/core/services/api_service.dart';
import 'package:restaukitchen_app/core/services/sevices_loactor.dart';
import 'package:restaukitchen_app/page/order_list/bloc/orders_actions_cubit/order_actions_cubit.dart';
import 'package:restaukitchen_app/page/order_list/bloc/orders_list_bloc/orders_list_bloc.dart';
import 'package:restaukitchen_app/page/order_list/bloc/orders_list_bloc/orders_list_events.dart';
import 'package:restaukitchen_app/page/order_list/bloc/orders_list_bloc/orders_list_state.dart';
import 'package:restaukitchen_app/page/order_list/bloc/status_cubit/status_cubit.dart';
import 'package:restaukitchen_app/page/order_list/components/order_card.dart';
import 'package:restaukitchen_app/page/order_list/models/order.dart';
import 'package:restaukitchen_app/page/order_list/repository/orders_list_repo.dart';

class KitchenList extends StatefulWidget {
  const KitchenList({super.key});

  @override
  State<KitchenList> createState() => _KitchenListState();
}

class _KitchenListState extends State<KitchenList> {
  @override
  void initState() {
    super.initState();
    context.read<OrdersListBloc>().add(OrdersListSubscribe());
    context.read<OrdersListBloc>().add(OrdersListGetOrders());
  }

  Future<void> _onRefresh() async {
    context.read<OrdersListBloc>().add(OrdersListGetOrders());
    await context.read<OrdersListBloc>().stream.firstWhere(
      (state) => state is! OrdersListLoading,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OrdersListBloc, OrdersListState>(
      builder: (context, state) {
        if (state is OrdersListLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is OrdersListError) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(state.errorMessage, textAlign: TextAlign.center),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () =>
                      context.read<OrdersListBloc>().add(OrdersListGetOrders()),
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }

        final orders = state is OrdersListLoaded ? state.orders : <Order>[];

        return RefreshIndicator(
          onRefresh: _onRefresh,
          child: orders.isEmpty
              ? ListView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  children: const [
                    SizedBox(height: 200),
                    Center(child: Text('No orders yet')),
                  ],
                )
              : ListView.builder(
                  physics: const AlwaysScrollableScrollPhysics(),
                  itemCount: orders.length,
                  itemBuilder: (context, index) {
                    final order = orders[index];
                    return MultiBlocProvider(
                      providers: [
                        BlocProvider(
                          create: (context) => StatusCubit(
                            ordersListRepo: OrdersListRepo(
                              apiService: getIt<ApiService>(),
                            ),
                          ),
                        ),
                        BlocProvider(
                          create: (context) => OrderActionsCubit(
                            ordersListRepo: OrdersListRepo(
                              apiService: getIt<ApiService>(),
                            ),
                          ),
                        ),
                      ],
                      child: OrderCard(
                        key: ValueKey(order.id),
                        order: order,
                        onArchive: () {},
                        onPrint: () {},
                        onActionSucess: () {
                          context.read<OrdersListBloc>().add(
                            OrdersListRemoveOrder(orderId: order.id ?? ""),
                          );
                        },
                      ),
                    );
                  },
                ),
        );
      },
    );
  }
}

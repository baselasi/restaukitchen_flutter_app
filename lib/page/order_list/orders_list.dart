import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restaukitchen_app/page/order_list/bloc/orders_list_bloc/orders_list_bloc.dart';
import 'package:restaukitchen_app/page/order_list/bloc/orders_list_bloc/orders_list_events.dart';

class OrdersList extends StatefulWidget {
  const OrdersList({super.key});

  @override
  State<OrdersList> createState() => _OrdersListState();
}

class _OrdersListState extends State<OrdersList> {
  @override
  void initState() {
    super.initState();
    context.read<OrdersListBloc>().add(OrdersListSubscribe());
    context.read<OrdersListBloc>().add(OrdersListGetOrders());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Column(children: [Text('Orders List')]));
  }
}

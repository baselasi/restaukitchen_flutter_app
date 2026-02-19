import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restaukitchen_app/page/order_list/bloc/orders_page_cubit.dart';
import 'package:restaukitchen_app/theme/light_theme.dart';

class OrdersDrawer extends StatelessWidget {
  const OrdersDrawer({super.key});

  IconData _getPageIcon(OrderSubPage page) {
    switch (page) {
      case OrderSubPage.kitchen:
        return Icons.restaurant;
      case OrderSubPage.archive:
        return Icons.archive;
    }
  }

  String _getPageLabel(OrderSubPage page) {
    switch (page) {
      case OrderSubPage.kitchen:
        return 'Kitchen';
      case OrderSubPage.archive:
        return 'Archive';
    }
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<OrdersPageCubit>();

    return BlocBuilder<OrdersPageCubit, OrdersPageState>(
      builder: (context, state) {
        final currentPage = state.page;

        return Drawer(
          child: Container(
            color: LightTheme.primaryColor,
            child: SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Text(
                      'Orders',
                      style: TextStyle(
                        color: LightTheme.secondaryColor,
                        fontSize: 28,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const Divider(
                    color: Colors.white24,
                    height: 1,
                  ),
                  const SizedBox(height: 8),
                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: OrderSubPage.values.length,
                      itemBuilder: (context, index) {
                        final page = OrderSubPage.values[index];
                        final isSelected = page == currentPage;

                        return Container(
                          margin: const EdgeInsets.only(bottom: 4),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: isSelected
                                ? LightTheme.secondaryColor
                                : Colors.transparent,
                          ),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(15),
                            onTap: () {
                              cubit.setPage(page);
                              Navigator.pop(context);
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 12,
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    _getPageIcon(page),
                                    color: isSelected
                                        ? LightTheme.primaryColor
                                        : LightTheme.secondaryColor,
                                    size: 28,
                                  ),
                                  const SizedBox(width: 16),
                                  Text(
                                    _getPageLabel(page),
                                    style: TextStyle(
                                      color: isSelected
                                          ? LightTheme.primaryColor
                                          : LightTheme.secondaryColor,
                                      fontSize: 22,
                                      fontWeight: isSelected
                                          ? FontWeight.w600
                                          : FontWeight.normal,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

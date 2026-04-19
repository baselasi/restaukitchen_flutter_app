import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restaukitchen_app/core/services/api_service.dart';
import 'package:restaukitchen_app/core/services/sevices_loactor.dart';
import 'package:restaukitchen_app/l10n/l10n.dart';
import 'package:restaukitchen_app/page/order_list/bloc/archive_list_bloc/archive_list_cubit.dart';
import 'package:restaukitchen_app/page/order_list/bloc/orders_drawer_cubit.dart';
import 'package:restaukitchen_app/page/order_list/bloc/orders_list_bloc/orders_list_bloc.dart';
import 'package:restaukitchen_app/page/order_list/bloc/orders_page_cubit.dart';
import 'package:restaukitchen_app/page/order_list/components/archive_list.dart';
import 'package:restaukitchen_app/page/order_list/components/deleted_list.dart';
import 'package:restaukitchen_app/page/order_list/components/kitchen_list.dart';
import 'package:restaukitchen_app/page/order_list/repository/orders_list_repo.dart';
import 'package:restaukitchen_app/theme/light_theme.dart';

class OrdersList extends StatefulWidget {
  const OrdersList({super.key});

  @override
  State<OrdersList> createState() => _OrdersListState();
}

class _OrdersListState extends State<OrdersList> {
  @override
  void initState() {
    super.initState();
    context.read<OrdersCategoryCubit>().getCategories();
  }

  Widget _buildBody(OrderSubPage page) {
    return switch (page) {
      KitchenPage() => BlocProvider<OrdersListBloc>(
        create: (context) => OrdersListBloc(
          repo: OrdersListRepo(apiService: getIt<ApiService>()),
        ),
        child: const KitchenList(),
      ),
      ArchivePage() => BlocProvider<ArchiveListCubit>(
        create: (context) => ArchiveListCubit(
          repo: OrdersListRepo(apiService: getIt<ApiService>()),
        ),
        child: const ArchiveList(),
      ),
      DeletedPage() => BlocProvider<ArchiveListCubit>(
        create: (context) => ArchiveListCubit(
          repo: OrdersListRepo(apiService: getIt<ApiService>()),
          isDeletedList: true,
        ),
        child: const DeletedList(),
      ),
      CategoryPage(:final category) => BlocProvider<OrdersListBloc>(
        key: ValueKey(category.id),
        create: (context) => OrdersListBloc(
          repo: OrdersListRepo(apiService: getIt<ApiService>()),
          categoryName: category.name,
        ),
        child: KitchenList(category: category),
      ),
    };
  }

  @override
  Widget build(BuildContext context) {
    final pageCubit = context.read<OrdersPageCubit>();

    return BlocBuilder<OrdersPageCubit, OrdersPageState>(
      builder: (context, pageState) {
        return Scaffold(
          body: Column(
            children: [
              _CategoryBar(
                currentPage: pageState.page,
                onPageSelected: pageCubit.setPage,
              ),
              Expanded(child: _buildBody(pageState.page)),
            ],
          ),
        );
      },
    );
  }
}

class _CategoryBar extends StatelessWidget {
  final OrderSubPage currentPage;
  final ValueChanged<OrderSubPage> onPageSelected;

  const _CategoryBar({required this.currentPage, required this.onPageSelected});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OrdersCategoryCubit, OrdersCategoryState>(
      builder: (context, state) {
        final l10n = context.l10n;
        final chips = <_ChipData>[
          _ChipData(label: l10n.ordersKitchen, page: const KitchenPage()),
        ];

        if (state.status == OrdersCategoryStatus.loaded) {
          for (final category in state.categories) {
            chips.add(
              _ChipData(
                label: category.name,
                page: CategoryPage(category: category),
              ),
            );
          }
        }

        chips.add(_ChipData(label: l10n.ordersArchive, page: const ArchivePage()));
        chips.add(_ChipData(label: l10n.ordersDeleted, page: const DeletedPage()));
        return Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              children: chips.map((chip) {
                final isSelected = chip.page == currentPage;
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: ChoiceChip(
                    label: Text(chip.label),
                    selected: isSelected,
                    onSelected: (_) => onPageSelected(chip.page),
                    selectedColor: LightTheme.secondaryColor,
                    backgroundColor: LightTheme.primaryColor,
                    side: const BorderSide(color: Colors.white24),
                    labelStyle: TextStyle(
                      color: isSelected
                          ? LightTheme.primaryColor
                          : Colors.white,
                      fontWeight: isSelected
                          ? FontWeight.w600
                          : FontWeight.normal,
                      fontSize: 14,
                    ),
                    showCheckmark: false,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        );
      },
    );
  }
}

class _ChipData {
  final String label;
  final OrderSubPage page;
  const _ChipData({required this.label, required this.page});
}

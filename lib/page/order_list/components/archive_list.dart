import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restaukitchen_app/core/dialogs/snack_bar.dart';
import 'package:restaukitchen_app/core/services/api_service.dart';
import 'package:restaukitchen_app/core/services/sevices_loactor.dart';
import 'package:restaukitchen_app/l10n/l10n.dart';
import 'package:restaukitchen_app/page/order_list/bloc/archive_list_bloc/archive_list_cubit.dart';
import 'package:restaukitchen_app/page/order_list/bloc/orders_actions_cubit/order_actions_cubit.dart';
import 'package:restaukitchen_app/page/order_list/bloc/status_cubit/status_cubit.dart';
import 'package:restaukitchen_app/page/order_list/components/order_card.dart';
import 'package:restaukitchen_app/page/order_list/repository/orders_list_repo.dart';
import 'package:restaukitchen_app/theme/light_theme.dart';

class ArchiveList extends StatefulWidget {
  final bool? isDeletedList;
  const ArchiveList({super.key, this.isDeletedList = false});

  @override
  State<ArchiveList> createState() => _ArchiveListState();
}

class _ArchiveListState extends State<ArchiveList> {
  DateTime _selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    context.read<ArchiveListCubit>().getArchiveList(_selectedDate);
  }

  Future<void> _onRefresh() async {
    context.read<ArchiveListCubit>().getArchiveList(_selectedDate);
    await context.read<ArchiveListCubit>().stream.firstWhere(
      (state) => state.status != ArchiveListStatus.loading,
    );
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() => _selectedDate = picked);
      if (context.mounted && mounted) {
        context.read<ArchiveListCubit>().getArchiveList(_selectedDate);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Column(
      children: [
        _buildDatePicker(),
        Expanded(
          child: BlocConsumer<ArchiveListCubit, ArchiveListState>(
            builder: (context, state) {
              if (state.status == ArchiveListStatus.loading) {
                return const Center(child: CircularProgressIndicator());
              }

              if (state.status == ArchiveListStatus.error) {
                return Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        state.errorMessage ?? l10n.commonErrorOccurred,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () => context
                            .read<ArchiveListCubit>()
                            .getArchiveList(_selectedDate),
                        child: Text(l10n.commonRetry),
                      ),
                    ],
                  ),
                );
              }

              final orders = state.orders;

              return RefreshIndicator(
                onRefresh: _onRefresh,
                child: orders.isEmpty
                    ? ListView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        children: [
                          const SizedBox(height: 200),
                          Center(
                            child: Text(
                              widget.isDeletedList == true
                                  ? l10n.ordersNoDeletedOrders
                                  : l10n.ordersNoArchivedOrders,
                            ),
                          ),
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
                              isArchived: true,
                              onArchive: () {},
                              onPrint: () {},
                              onActionSucess: () {
                                context.read<ArchiveListCubit>().getArchiveList(
                                  _selectedDate,
                                );
                              },
                            ),
                          );
                        },
                      ),
              );
            },
            listener: (context, state) {
              if (state.status == ArchiveListStatus.error) {
                AppSnackBar.showError(
                  context,
                  state.errorMessage ?? l10n.commonErrorOccurred,
                );
              }
            },
          ),
        ),
      ],
    );
  }

  Widget _buildDatePicker() {
    final d = _selectedDate;
    final l10n = context.l10n;
    final months = [
      l10n.commonMonthJan,
      l10n.commonMonthFeb,
      l10n.commonMonthMar,
      l10n.commonMonthApr,
      l10n.commonMonthMay,
      l10n.commonMonthJun,
      l10n.commonMonthJul,
      l10n.commonMonthAug,
      l10n.commonMonthSep,
      l10n.commonMonthOct,
      l10n.commonMonthNov,
      l10n.commonMonthDec,
    ];
    final formatted =
        '${d.day.toString().padLeft(2, '0')} ${months[d.month - 1]} ${d.year}';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: _pickDate,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            border: Border.all(
              color: LightTheme.primaryColor.withValues(alpha: 0.3),
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Icon(
                Icons.calendar_today,
                size: 20,
                color: LightTheme.primaryColor,
              ),
              const SizedBox(width: 12),
              Text(
                formatted,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: LightTheme.primaryColor,
                ),
              ),
              const Spacer(),
              Icon(Icons.arrow_drop_down, color: LightTheme.primaryColor),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:page_transition/page_transition.dart';
import 'package:restaukitchen_app/core/services/api_service.dart';
import 'package:restaukitchen_app/l10n/l10n.dart';
import 'package:restaukitchen_app/page/menusPage/bloc/menus_page_bloc.dart';
import 'package:restaukitchen_app/page/new_order/bloc/menu_scroll_bar_cubit/menu_scroll_bar_cubit.dart';
import 'package:restaukitchen_app/page/new_order/bloc/new_order_cubit/new_order_cubit.dart';
import 'package:restaukitchen_app/page/new_order/bloc/new_order_form_bloc/new_order_form_bloc.dart';
import 'package:restaukitchen_app/page/new_order/repository/new_order_repository.dart';
import 'package:restaukitchen_app/page/order_list/repository/orders_list_repo.dart';
import 'package:restaukitchen_app/page/preview_order/preview_order_page.dart';
import 'package:restaukitchen_app/page/tabels_list/bloc/tabels_list_delete_cubit/tabels_list_delete_cubit.dart';
import 'package:restaukitchen_app/page/tabels_list/components/qr_code_dialog.dart';
import 'package:restaukitchen_app/page/tabels_list/components/total_covers_dialog.dart';
import 'package:restaukitchen_app/page/tabels_list/models/tabel.dart';
import 'package:restaukitchen_app/page/table_form/bloc/table_form_cubit.dart';
import 'package:restaukitchen_app/page/table_form/table_form_repo/table_form_repo.dart';
import 'package:restaukitchen_app/page/table_form/table_from.dart';

class TabelCard extends StatefulWidget {
  final Tabel tabel;
  final VoidCallback? onEdit;
  final VoidCallback? onOrder;
  final VoidCallback? onGenerateQr;
  final VoidCallback? onDelete;
  final ValueChanged<bool>? onStatusChanged;

  const TabelCard({
    super.key,
    required this.tabel,
    this.onEdit,
    this.onOrder,
    this.onGenerateQr,
    this.onDelete,
    this.onStatusChanged,
  });

  @override
  State<TabelCard> createState() => _TabelCardState();
}

class _TabelCardState extends State<TabelCard> {
  Color _statusColor() {
    switch (widget.tabel.status) {
      case TabelStatus.available:
        return const Color(0xFF4CAF50);
      case TabelStatus.reserved:
        return const Color(0xFFFFA726);
      case TabelStatus.occupied:
        return const Color(0xFFEF5350);
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final l10n = context.l10n;

    return BlocConsumer<TabelsListDeleteCubit, TabelsListDeleteState>(
      listener: (context, state) {
        if (state.status == TabelsListDeleteStatus.success) {
          widget.onDelete?.call();
        }
      },
      builder: (context, state) {
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          clipBehavior: Clip.hardEdge,
          elevation: 1,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      width: 16,
                      height: 16,
                      decoration: BoxDecoration(
                        color: _statusColor(),
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            l10n.commonTableLabel(widget.tabel.number.toString()),
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            l10n.tablesSeatsCount(widget.tabel.numberOfSeats),
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: colorScheme.onSurface.withValues(
                                alpha: 0.6,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _CardAction(
                      icon: Icons.edit_outlined,
                      color: colorScheme.primary,
                      onTap: () async {
                        final bool? result = await Navigator.of(context).push(
                          PageTransition(
                            type: PageTransitionType.rightToLeft,
                            child: BlocProvider<TableFormCubit>(
                              create: (context) => TableFormCubit(
                                tableFormRepo: TableFormRepo(),
                              ),
                              child: TableForm(table: widget.tabel),
                            ),
                          ),
                        );
                        if (result == true) {
                          widget.onEdit?.call();
                        }
                      },
                    ),
                    _CardAction(
                      icon: Icons.receipt_long_outlined,
                      color: const Color(0xFF26A69A),
                      onTap: () async {
                        final totalCovers = await TotalCoversDialog.show(
                          context,
                        );
                        if (!context.mounted || totalCovers == null) {
                          return;
                        }
                        Navigator.of(context).push(
                          PageTransition(
                            type: PageTransitionType.rightToLeft,
                            child: MultiBlocProvider(
                              providers: [
                                BlocProvider(
                                  create: (context) => MenusPageBloc(),
                                ),
                                BlocProvider(
                                  create: (context) => MenuScrollBarCubit(),
                                ),
                                BlocProvider(
                                  create: (context) => NewOrderFormBloc(
                                    tableNumber: widget.tabel.number,
                                    totalCovers: totalCovers,
                                  ),
                                ),
                                BlocProvider(
                                  create: (context) => NewOrderCubit(
                                    newOrderRepo: NewOrderRepository(
                                      apiService: ApiService(),
                                    ),
                                    ordersListRepo: OrdersListRepo(
                                      apiService: ApiService(),
                                    ),
                                  ),
                                ),
                              ],
                              child: PreviewOrderPage(
                                dinnerTableNumber: widget.tabel.number
                                    .toString(),
                                orderId: widget.tabel.orderIDs.isNotEmpty ? widget.tabel.orderIDs.first : null,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                    _CardAction(
                      icon: Icons.qr_code_2,
                      color: const Color(0xFF5C6BC0),
                      onTap: () {
                        QrCodeDialog.show(
                          context,
                          widget.tabel.id ?? '',
                          widget.tabel.number,
                        );
                      },
                    ),
                    if (state.status == TabelsListDeleteStatus.loading)
                      const Center(child: CircularProgressIndicator()),
                    if (state.status != TabelsListDeleteStatus.loading)
                      _CardAction(
                        icon: Icons.delete_outline,
                        color: const Color(0xFFEF5350),
                        onTap: () {
                          context.read<TabelsListDeleteCubit>().deleteTabel(
                            widget.tabel.id ?? '',
                          );
                        },
                      ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _CardAction extends StatelessWidget {
  final IconData icon;
  final Color color;
  final VoidCallback? onTap;

  const _CardAction({required this.icon, required this.color, this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: color, size: 22),
            ),
            const SizedBox(height: 4),
          ],
        ),
      ),
    );
  }
}

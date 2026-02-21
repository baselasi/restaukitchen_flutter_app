import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restaukitchen_app/page/tabels_list/bloc/tabels_list_delete_cubit/tabels_list_delete_cubit.dart';
import 'package:restaukitchen_app/page/tabels_list/models/tabel.dart';

class TabelCard extends StatelessWidget {
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

  Color _statusColor() {
    switch (tabel.status) {
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

    return BlocConsumer<TabelsListDeleteCubit, TabelsListDeleteState>(
      listener: (context, state) {
        if (state.status == TabelsListDeleteStatus.success) {
          onDelete?.call();
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
                            'Table ${tabel.number}',
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '${tabel.numberOfSeats} seats',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: colorScheme.onSurface.withValues(
                                alpha: 0.6,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    // GestureDetector(
                    //   onTap: () => onStatusChanged?.call(!isReserved),
                    //   child: Container(
                    //     padding: const EdgeInsets.symmetric(
                    //       horizontal: 10,
                    //       vertical: 6,
                    //     ),
                    //     decoration: BoxDecoration(
                    //       color: isReserved
                    //           ? const Color(0xFFFFF3E0)
                    //           : const Color(0xFFE8F5E9),
                    //       borderRadius: BorderRadius.circular(20),
                    //       border: Border.all(
                    //         color: isReserved
                    //             ? const Color(0xFFFFA726)
                    //             : const Color(0xFF4CAF50),
                    //         width: 1.2,
                    //       ),
                    //     ),
                    //     child: Row(
                    //       mainAxisSize: MainAxisSize.min,
                    //       children: [
                    //         Container(
                    //           width: 8,
                    //           height: 8,
                    //           decoration: BoxDecoration(
                    //             color: isReserved
                    //                 ? const Color(0xFFFFA726)
                    //                 : const Color(0xFF4CAF50),
                    //             shape: BoxShape.circle,
                    //           ),
                    //         ),
                    //         const SizedBox(width: 6),
                    //         Text(
                    //           isReserved ? 'Reserved' : 'Free',
                    //           style: theme.textTheme.labelSmall?.copyWith(
                    //             color: isReserved
                    //                 ? const Color(0xFFE65100)
                    //                 : const Color(0xFF2E7D32),
                    //             fontWeight: FontWeight.w600,
                    //           ),
                    //         ),
                    //       ],
                    //     ),
                    //   ),
                    // ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _CardAction(
                      icon: Icons.edit_outlined,
                      color: colorScheme.primary,
                      onTap: onEdit,
                    ),
                    _CardAction(
                      icon: Icons.receipt_long_outlined,
                      color: const Color(0xFF26A69A),
                      onTap: onOrder,
                    ),
                    _CardAction(
                      icon: Icons.qr_code_2,
                      color: const Color(0xFF5C6BC0),
                      onTap: onGenerateQr,
                    ),
                    if (state.status == TabelsListDeleteStatus.loading)
                      const Center(child: CircularProgressIndicator()),
                    if (state.status != TabelsListDeleteStatus.loading)
                      _CardAction(
                        icon: Icons.delete_outline,
                        color: const Color(0xFFEF5350),
                        onTap: () {
                          context.read<TabelsListDeleteCubit>().deleteTabel(
                            tabel.id ?? '',
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

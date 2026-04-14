import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restaukitchen_app/core/dialogs/snack_bar.dart';
import 'package:restaukitchen_app/page/combination_list/bloc/delete_combination_cubit/delete_combination_cubit.dart';
import 'package:restaukitchen_app/page/combination_list/models/combination_list_item.dart';
import 'package:restaukitchen_app/core/widgets/square_action_button.dart';
import 'package:restaukitchen_app/theme/light_theme.dart';

/// Horizontal card: image + "Change image", title, price range, action icon buttons.
class CombinationListItemCard extends StatelessWidget {
  final CombinationListItem item;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const CombinationListItemCard({
    super.key,
    required this.item,
    this.onEdit,
    this.onDelete,
  });

  String _priceRangeLabel() {
    final prices = item.dimensionAssignments
        .where((a) => !a.isDeleted)
        .map((a) => a.price)
        .toList();
    if (prices.isEmpty) return '—';
    prices.sort();
    final min = prices.first;
    final max = prices.last;
    final a = min.toStringAsFixed(2);
    final b = max.toStringAsFixed(2);
    if (min == max) return '€$a';
    return '€$a – €$b';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 10,
      shadowColor: Colors.black.withValues(alpha: 0.5),
      surfaceTintColor: Colors.transparent,
      color: theme.colorScheme.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: IntrinsicHeight(
          child: BlocConsumer<DeleteCombinationCubit, DeleteCombinationState>(
            builder: (context, state) {
              if (state.status == DeleteCombinationStatus.loading) {
                return const Center(child: CircularProgressIndicator());
              }
              return Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Container(
                          width: 96,
                          height: 96,
                          color: Colors.grey[200],
                          child: Icon(
                            Icons.restaurant_menu,
                            size: 36,
                            color: Colors.grey[400],
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.photo_camera_outlined,
                            size: 16,
                            color: LightTheme.primaryColor,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'Change image',
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: LightTheme.primaryColor,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.name,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                            color: Colors.black87,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 6),
                        Text(
                          _priceRangeLabel(),
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: Colors.black54,
                            fontSize: 13,
                          ),
                        ),
                        const Spacer(),
                        Align(
                          alignment: Alignment.centerRight,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SquareActionButton(
                                child: Icon(
                                  Icons.delete_outline_rounded,
                                  size: 22,
                                  color: Colors.red,
                                ),
                                onTap: () {
                                  context
                                      .read<DeleteCombinationCubit>()
                                      .deleteCombination(item.id);
                                },
                              ),
                              const SizedBox(width: 8),
                              SquareActionButton(
                                onTap: onEdit,
                                child: Icon(
                                  Icons.edit_outlined,
                                  size: 20,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
            listener: (context, state) {
              if (state.status == DeleteCombinationStatus.success) {
                AppSnackBar.showSuccess(
                  context,
                  'Combination deleted successfully',
                );
                onDelete?.call();
              }
              if (state.status == DeleteCombinationStatus.error) {
                AppSnackBar.showError(
                  context,
                  state.errorMessage ?? 'Error deleting combination',
                );
              }
            },
          ),
        ),
      ),
    );
  }
}

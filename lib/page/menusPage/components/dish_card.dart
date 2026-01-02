
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restaukitchen_app/core/dialogs/conferm_dialogs.dart';
import 'package:restaukitchen_app/core/dialogs/loading_overlay.dart';
import 'package:restaukitchen_app/core/models/dish.dart';
import 'package:restaukitchen_app/page/menusPage/bloc/delete_dish_cubit.dart';
import 'package:restaukitchen_app/theme/light_theme.dart';

class DishCard extends StatefulWidget {
  final Dish dish;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final VoidCallback? onEditPhoto;

  const DishCard({
    super.key,
    required this.dish,
    this.onEdit,
    this.onDelete,
    this.onEditPhoto,
  });

  @override
  State<DishCard> createState() => _DishCardState();
}

class _DishCardState extends State<DishCard> {
  OverlayEntry? overlayEntry;

  @override
  Widget build(BuildContext context) {
    return BlocListener<DeleteDishCubit, DeleteDishState>(
      listener: (context, state) {
        if (state.status == DeleteDishStatus.isLoading) {
          overlayEntry = LoadingOverlay.show(context);
        }
        if (state.status == DeleteDishStatus.isSucess) {
          LoadingOverlay.hide(overlayEntry);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Dish deleted successfully'),
              backgroundColor: Colors.green[700],
            ),
          );
          if (widget.onDelete != null) widget.onDelete!();
        }
        if (state.status == DeleteDishStatus.isError) {
          LoadingOverlay.hide(overlayEntry);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Failed to delete dish'),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      child: Card(
        elevation: 2,
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Photo section with edit photo button
            Stack(
              children: [
                Container(
                  width: double.infinity,
                  height: 200,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(12),
                      topRight: Radius.circular(12),
                    ),
                    color: Colors.grey[200],
                  ),
                  child:
                      widget.dish.dishImagesId != null &&
                          widget.dish.dishImagesId!.isNotEmpty
                      ? ClipRRect(
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(12),
                            topRight: Radius.circular(12),
                          ),
                          child: Image.network(
                            widget.dish.dishImagesId!.first,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return _buildPlaceholderImage();
                            },
                          ),
                        )
                      : _buildPlaceholderImage(),
                ),
                // Edit photo button
                Positioned(
                  top: 8,
                  right: 8,
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: widget.onEditPhoto,
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.5),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.camera_alt,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            // Content section
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Dish name
                  Text(
                    widget.dish.name,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Price and availability
                  Row(
                    children: [
                      if (widget.dish.price != null)
                        Text(
                          '€${widget.dish.price!.toStringAsFixed(2)}',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: LightTheme.primaryColor,
                          ),
                        ),
                      const SizedBox(width: 12),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: widget.dish.isAvailable == true
                              ? Colors.green[100]
                              : Colors.red[100],
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          widget.dish.isAvailable == true
                              ? 'Available'
                              : 'Unavailable',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: widget.dish.isAvailable == true
                                ? Colors.green[700]
                                : Colors.red[700],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  // Action buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      // Edit button
                      TextButton.icon(
                        onPressed: widget.onEdit,
                        icon: const Icon(Icons.edit, size: 18),
                        label: const Text('Edit'),
                        style: TextButton.styleFrom(
                          foregroundColor: LightTheme.primaryColor,
                        ),
                      ),
                      const SizedBox(width: 8),
                      // Delete button
                      TextButton.icon(
                        onPressed: () async {
                          final confirmed = await ConfirmDialog.show(
                            context: context,
                            title: 'Delete Dish',
                            message:
                                'Are you sure you want to delete "${widget.dish.name}"? This action cannot be undone.',
                            confirmText: 'Delete',
                            cancelText: 'Cancel',
                          );

                          if (confirmed == true) {
                            context.read<DeleteDishCubit>().deleteDish(
                              widget.dish.id ?? "",
                            );
                          }
                        },
                        icon: const Icon(Icons.delete, size: 18),
                        label: const Text('Delete'),
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.red,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlaceholderImage() {
    return Container(
      width: double.infinity,
      height: 200,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),
        ),
        color: Colors.grey[200],
      ),
      child: Icon(Icons.restaurant_menu, size: 64, color: Colors.grey[400]),
    );
  }
}

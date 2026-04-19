import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:page_transition/page_transition.dart';
import 'package:restaukitchen_app/core/components/form/categorySelector/category_selector_cubit.dart';
import 'package:restaukitchen_app/core/components/form/descriptionInput/description_cubit.dart';
import 'package:restaukitchen_app/core/components/form/dimensionInput/dimension_cubit.dart';
import 'package:restaukitchen_app/core/dialogs/conferm_dialogs.dart';
import 'package:restaukitchen_app/core/dialogs/loading_overlay.dart';
import 'package:restaukitchen_app/core/dialogs/snack_bar.dart';
import 'package:restaukitchen_app/l10n/l10n.dart';
import 'package:restaukitchen_app/core/models/dish.dart';
import 'package:restaukitchen_app/core/widgets/public_image.dart';
import 'package:restaukitchen_app/core/widgets/square_action_button.dart';
import 'package:restaukitchen_app/page/dishForm/bloc/dish_form_cubit.dart';
import 'package:restaukitchen_app/page/dishForm/dish_form.dart';
import 'package:restaukitchen_app/page/menusPage/bloc/delete_dish_cubit.dart';
import 'package:restaukitchen_app/page/menusPage/bloc/dish_image_cubit.dart';
import 'package:restaukitchen_app/theme/light_theme.dart';

class DishCard extends StatefulWidget {
  final Dish dish;
  final String menuId;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final VoidCallback? onEditPhoto;

  const DishCard({
    super.key,
    required this.dish,
    required this.menuId,
    this.onEdit,
    this.onDelete,
    this.onEditPhoto,
  });

  @override
  State<DishCard> createState() => _DishCardState();
}

class _DishCardState extends State<DishCard> {
  OverlayEntry? overlayEntry;

  final ImagePicker _picker = ImagePicker();

  /// Base dish price plus per-dimension prices (non-deleted assignments).
  List<double> _collectDishPrices() {
    final prices = <double>[];
    final base = widget.dish.price;
    if (base != null) prices.add(base);
    final assignments = widget.dish.dimensionAssignments;
    if (assignments != null) {
      for (final a in assignments) {
        if (a.deleted == true) continue;
        final parsed = num.tryParse(a.price ?? '');
        if (parsed != null) prices.add(parsed.toDouble());
      }
    }
    return prices;
  }

  String _dishPriceRangeLabel() {
    final l10n = context.l10n;
    final prices = _collectDishPrices();
    if (prices.isEmpty) return l10n.commonEmDash;
    prices.sort();
    final min = prices.first;
    final max = prices.last;
    final a = min.toStringAsFixed(2);
    final b = max.toStringAsFixed(2);
    if (min == max) return '${l10n.commonCurrencyEuro}$a';
    return '${l10n.commonCurrencyEuro}$a ${l10n.commonEmDash} ${l10n.commonCurrencyEuro}$b';
  }

  Future<void> _pickImage(ImageSource source, {bool isUpdate = false}) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: source,
        maxWidth: 1800, // Optional: Resizes image to save memory
        maxHeight: 1800,
        imageQuality: 80, // Optional: Compresses image
      );

      if (pickedFile != null && mounted) {
        context.read<DishImageCubit>().uploadDishImage(
          widget.dish.id ?? "",
          File(pickedFile.path),
          isUpdate: isUpdate,
        );
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error picking image: $e");
      }
    }
  }

  void _openDishForm(BuildContext context) {
    Navigator.of(context).push(
      PageTransition(
        type: PageTransitionType.rightToLeft,
        child: MultiBlocProvider(
          providers: [
            BlocProvider<DimensionCubit>(create: (context) => DimensionCubit()),
            BlocProvider(create: (context) => CategorySelectorCubit()),
            BlocProvider(create: (context) => DescriptionCubit()),
            BlocProvider(create: (context) => DishFormCubit()),
          ],
          child: DishForm(menuId: widget.menuId, dish: widget.dish),
        ),
      ),
    );
  }

  Future<void> _confirmDelete(BuildContext context) async {
    final l10n = context.l10n;
    final confirmed = await ConfirmDialog.show(
      context: context,
      title: l10n.dishesDeleteTitle,
      message: l10n.dishesDeleteConfirmation(widget.dish.name),
      confirmText: l10n.commonDelete,
      cancelText: l10n.commonCancel,
    );

    if (confirmed == true && context.mounted) {
      context.read<DeleteDishCubit>().deleteDish(widget.dish.id ?? "");
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final priceRangeLabel = _dishPriceRangeLabel();
    final l10n = context.l10n;
    return BlocListener<DeleteDishCubit, DeleteDishState>(
      listener: (context, state) {
        if (state.status == DeleteDishStatus.isLoading) {
          overlayEntry = LoadingOverlay.show(context);
        }
        if (state.status == DeleteDishStatus.isSucess) {
          LoadingOverlay.hide(overlayEntry);
          AppSnackBar.showSuccess(context, l10n.dishesDeletedSuccessfully);
          if (widget.onDelete != null) widget.onDelete!();
        }
        if (state.status == DeleteDishStatus.isError) {
          LoadingOverlay.hide(overlayEntry);
          AppSnackBar.showError(context, l10n.dishesFailedDelete);
        }
      },
      child: Card(
        margin: const EdgeInsets.fromLTRB(16, 8, 16, 12),
        elevation: 10,
        shadowColor: Colors.black.withValues(alpha: 0.5),
        surfaceTintColor: Colors.transparent,
        color: theme.colorScheme.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        clipBehavior: Clip.antiAlias,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: SizedBox(
                        width: 96,
                        height: 96,
                        child: DishImageWidget(
                          dish: widget.dish,
                          key: Key(widget.dish.id ?? ''),
                          placeholder: _buildThumbnailPlaceholder(),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () {
                          _pickImage(
                            ImageSource.gallery,
                            isUpdate:
                                widget.dish.dishImagesId?.isNotEmpty == true,
                          );
                        },
                        borderRadius: BorderRadius.circular(8),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 2),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.photo_camera_outlined,
                                size: 16,
                                color: LightTheme.primaryColor,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                l10n.commonChangeImage,
                                style: theme.textTheme.labelSmall?.copyWith(
                                  color: LightTheme.primaryColor,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.dish.name,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: Colors.black87,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 6),
                      Text(
                        priceRangeLabel,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: Colors.black54,
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(height: 6),
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
                              ? l10n.commonAvailable
                              : l10n.commonUnavailable,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: widget.dish.isAvailable == true
                                ? Colors.green[700]
                                : Colors.red[700],
                          ),
                        ),
                      ),
                      const Spacer(),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SquareActionButton(
                              onTap: () => _confirmDelete(context),
                              child: Icon(
                                Icons.delete_outline_rounded,
                                size: 22,
                                color: Colors.red,
                              ),
                            ),
                            const SizedBox(width: 8),
                            SquareActionButton(
                              onTap: () {
                                widget.onEdit?.call();
                                _openDishForm(context);
                              },
                              child: Icon(
                                Icons.edit_outlined,
                                size: 20,
                                color: theme.colorScheme.primary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildThumbnailPlaceholder() {
    return ColoredBox(
      color: Colors.grey[200]!,
      child: Icon(Icons.restaurant_menu, size: 36, color: Colors.grey[400]),
    );
  }
}

/// Widget to display dish image or placeholder
class DishImageWidget extends StatefulWidget {
  final Dish dish;
  final Widget placeholder;

  const DishImageWidget({
    super.key,
    required this.dish,
    required this.placeholder,
  });

  @override
  State<DishImageWidget> createState() => _DishImageWidgetState();
}

class _DishImageWidgetState extends State<DishImageWidget> {
  String? imageId;

  @override
  void initState() {
    super.initState();
    imageId = widget.dish.dishImagesId?.isNotEmpty == true
        ? widget.dish.dishImagesId!.last
        : null;
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<DishImageCubit, DishImageUploadState>(
      builder: (context, state) {
        if (state.status == DishImageUploadStatus.loading) {
          return Center(child: CircularProgressIndicator());
        }

        if (imageId != null) {
          return PublicImage(
            imageUrl: "/api/public/dish-image/$imageId",
            fit: BoxFit.cover,
            placeholder: widget.placeholder,
            errorWidget: widget.placeholder,
          );
        }
        return widget.placeholder;
      },
      listener: (context, state) {
        if (state.status == DishImageUploadStatus.success) {
          setState(() {
            imageId = state.imageResponse?.id;
          });
        }
      },
    );
  }
}

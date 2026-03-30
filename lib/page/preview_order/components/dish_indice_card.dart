import 'package:flutter/material.dart';
import 'package:restaukitchen_app/page/new_order/components/add_dish_dialog.dart';
import 'package:restaukitchen_app/page/order_list/models/course.dart';

/// Line item card for a single dish: name as title, optional dimension, dishes + ingredients.
class DishIndiceCard extends StatefulWidget {
  final DishIndice dishIndice;
  final VoidCallback? onDelete;
  final Function(CourseIndice)? onEdit;
  final ValueChanged<int>? onQuantityChanged;

  /// Shown as a badge when non-null/non-empty (e.g. prep time).
  final String? urgencyLabel;

  const DishIndiceCard({
    super.key,
    required this.dishIndice,
    this.onDelete,
    this.onEdit,
    this.onQuantityChanged,
    this.urgencyLabel,
  });

  @override
  State<DishIndiceCard> createState() => _DishIndiceCardState();
}

class _DishIndiceCardState extends State<DishIndiceCard> {
  static const Color _cardBg = Color(0xFFF3F4F6);
  static const Color _titleColor = Color(0xFF111827);
  static const Color _subtitleColor = Color(0xFF6B7280);
  static const Color _ingredientsColor = Color(0xFF6B7280);
  static const Color _divider = Color(0xFFE5E7EB);
  static const Color _iconColor = Color(0xFF4B5563);

  late int _quantity;

  @override
  void initState() {
    super.initState();
    _quantity = widget.dishIndice.dishQuantity;
  }

  @override
  void didUpdateWidget(covariant DishIndiceCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.dishIndice.dishQuantity != widget.dishIndice.dishQuantity) {
      _quantity = widget.dishIndice.dishQuantity;
    }
  }

  String get _primaryTitle {
    final d = widget.dishIndice;
    return d.dishName?.trim().isNotEmpty == true
        ? d.dishName!.trim()
        : (d.dishDimensionName?.trim().isNotEmpty == true
              ? d.dishDimensionName!.trim()
              : 'Dish');
  }

  bool get _showDimensionSubtitle {
    final d = widget.dishIndice;
    final name = d.dishName?.trim();
    final dim = d.dishDimensionName?.trim();
    if (name == null || name.isEmpty || dim == null || dim.isEmpty) {
      return false;
    }
    return name != dim;
  }

  List<Widget> _buildDishBlocks() {
    final dishes = widget.dishIndice.dishesWithIngredients ?? const [];
    if (dishes.isEmpty) return const [];

    final children = <Widget>[];

    children.add(
      Wrap(
        spacing: 10,
        runSpacing: 6,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          for (int i = 0; i < dishes.length; i++) ...[
            if (i > 0) Icon(Icons.circle, color: Colors.black, size: 8),
            Text(
              dishes[i].ingredientsName.join(', '),
              style: const TextStyle(
                color: _ingredientsColor,
                fontSize: 13,
                height: 1.35,
              ),
              softWrap: true,
            ),
          ],
        ],
      ),
    );
    return children;
  }

  Future<void> _onEdit() async {
    final result = await showAddDishDialog(
      context: context,
      dishId: widget.dishIndice.dishId,
      selectedDimensionId: widget.dishIndice.dishDimensionId,
      selectedIngredientsIds: widget.dishIndice.dishIngredientsId,
      note: widget.dishIndice.note,
      quantity: widget.dishIndice.dishQuantity,
    );
    if (result != null) {
      final dishIndice = DishIndice(
        dishId: widget.dishIndice.dishId,
        dishName: widget.dishIndice.dishName,
        dishPrice: widget.dishIndice.dishPrice,
        dishDimensionName: result.selectedDimension?.dimension.name,
        dishDimensionId: result.selectedDimension?.dimension.id ?? '',
        dishIngredientsId: result.ingredients
            .map((ingredient) => ingredient.id)
            .whereType<String>()
            .toList(),
        dishQuantity: result.quantity,
        note: result.note,
        dishesWithIngredients: result.ingredients
            .map(
              (ingredient) => DishesWithIngredients(
                dishId: widget.dishIndice.dishId,
                dishName: widget.dishIndice.dishName ?? '',
                ingredientsId: [ingredient.id ?? ''],
                ingredientsName: [ingredient.name],
              ),
            )
            .toList(),
        course: widget.dishIndice.course,
      );

      widget.onEdit?.call(dishIndice);
    }
  }

  // void _setQuantity(int next) {
  //   if (next < 1) return;
  //   setState(() => _quantity = next);
  //   widget.onQuantityChanged?.call(next);
  // }

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;
    final secondary = Theme.of(context).colorScheme.secondary;
    final iconMuted = _iconColor;

    final urgency = widget.urgencyLabel?.trim();
    final note = widget.dishIndice.note?.trim();
    final showMeta =
        (urgency != null && urgency.isNotEmpty) ||
        (note != null && note.isNotEmpty);

    final price = widget.dishIndice.dishPrice;
    final priceText = price != null ? '\$${price.toStringAsFixed(2)}' : '—';

    final hasBlocks =
        (widget.dishIndice.dishesWithIngredients ?? []).isNotEmpty;

    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Material(
        color: _cardBg,
        elevation: 0,
        shadowColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(color: Color(0xFFE5E7EB)),
        ),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(width: 4, color: primary),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      _primaryTitle,
                                      style: const TextStyle(
                                        color: _titleColor,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      'x$_quantity',
                                      style: const TextStyle(
                                        color: Colors.black,
                                        fontStyle: FontStyle.italic,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                                if (_showDimensionSubtitle) ...[
                                  const SizedBox(height: 4),
                                  Text(
                                    widget.dishIndice.dishDimensionName!,
                                    style: const TextStyle(
                                      color: _subtitleColor,
                                      fontSize: 13,
                                      height: 1.25,
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            priceText,
                            style: TextStyle(
                              color: primary,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      if (hasBlocks) ...[
                        const SizedBox(height: 10),
                        ..._buildDishBlocks(),
                      ],
                      if (showMeta) ...[
                        const SizedBox(height: 10),
                        Wrap(
                          spacing: 10,
                          runSpacing: 6,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: [
                            if (urgency != null && urgency.isNotEmpty)
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: secondary,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  urgency,
                                  style: const TextStyle(
                                    color: Color(0xFF111827),
                                    fontSize: 11,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ),
                            if (note != null && note.isNotEmpty)
                              Text(
                                'Note: $note',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 13,
                                  fontStyle: FontStyle.italic,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                          ],
                        ),
                      ],
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 14),
                        child: Divider(
                          height: 1,
                          thickness: 1,
                          color: _divider,
                        ),
                      ),
                      Row(
                        children: [
                          IconButton(
                            visualDensity: VisualDensity.compact,
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(
                              minWidth: 40,
                              minHeight: 40,
                            ),
                            onPressed: widget.onDelete,
                            icon: Icon(
                              Icons.delete_outline_rounded,
                              color: iconMuted,
                              size: 22,
                            ),
                          ),
                          IconButton(
                            onPressed: _onEdit,
                            icon: Icon(
                              Icons.edit_outlined,
                              color: iconMuted,
                              size: 22,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

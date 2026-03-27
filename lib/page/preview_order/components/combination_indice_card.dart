import 'package:flutter/material.dart';
import 'package:restaukitchen_app/page/order_list/models/course.dart';

/// Line item card for a combination: combination name as title, dishes with ingredients below.
class CombinationIndiceCard extends StatefulWidget {
  final CombinationIndice combinationIndice;
  final VoidCallback? onDelete;
  final VoidCallback? onEdit;
  final ValueChanged<int>? onQuantityChanged;

  /// Shown as a yellow badge when non-null/non-empty (e.g. prep time).
  final String? urgencyLabel;

  /// Shown as yellow italic note when non-null/non-empty.
  final String? note;

  const CombinationIndiceCard({
    super.key,
    required this.combinationIndice,
    this.onDelete,
    this.onEdit,
    this.onQuantityChanged,
    this.urgencyLabel,
    this.note,
  });

  @override
  State<CombinationIndiceCard> createState() => _CombinationIndiceCardState();
}

class _CombinationIndiceCardState extends State<CombinationIndiceCard> {
  /// Soft cool gray — reads clearly on white scaffold backgrounds.
  static const Color _cardBg = Color(0xFFF3F4F6);
  static const Color _titleColor = Color(0xFF111827);
  static const Color _dishNameColor = Color(0xFF1F2937);
  static const Color _ingredientsColor = Color(0xFF6B7280);
  static const Color _divider = Color(0xFFE5E7EB);
  static const Color _qtyTrayBg = Color(0xFFE5E7EB);
  static const Color _iconColor = Color(0xFF4B5563);

  late int _quantity;

  @override
  void initState() {
    super.initState();
    _quantity = widget.combinationIndice.combinationQuantity;
  }

  @override
  void didUpdateWidget(covariant CombinationIndiceCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.combinationIndice.combinationQuantity !=
        widget.combinationIndice.combinationQuantity) {
      _quantity = widget.combinationIndice.combinationQuantity;
    }
  }

  List<Widget> _buildDishBlocks() {
    final dishes = widget.combinationIndice.dishesWithIngredients;
    if (dishes.isEmpty) return const [];

    final children = <Widget>[];
    for (var i = 0; i < dishes.length; i++) {
      final d = dishes[i];
      if (i > 0) {
        children.add(const SizedBox(height: 12));
      }
      children.add(
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              d.dishName,
              style: const TextStyle(
                color: _dishNameColor,
                fontSize: 14,
                fontWeight: FontWeight.w600,
                height: 1.3,
              ),
            ),
            if (d.ingredientsName.isNotEmpty) ...[
              const SizedBox(height: 4),
              Text(
                d.ingredientsName.join(', '),
                style: const TextStyle(
                  color: _ingredientsColor,
                  fontSize: 13,
                  height: 1.35,
                ),
              ),
            ],
          ],
        ),
      );
    }
    return children;
  }

  void _setQuantity(int next) {
    if (next < 1) return;
    setState(() => _quantity = next);
    widget.onQuantityChanged?.call(next);
  }

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;
    final secondary = Theme.of(context).colorScheme.secondary;
    final iconMuted = _iconColor;

    final urgency = widget.urgencyLabel?.trim();
    final note = widget.note?.trim();
    final showMeta = (urgency != null && urgency.isNotEmpty) ||
        (note != null && note.isNotEmpty);

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
                            child: Text(
                              widget.combinationIndice.combinationDimensionName,
                              style: const TextStyle(
                                color: _titleColor,
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '\$${widget.combinationIndice.combinationPrice.toStringAsFixed(2)}',
                            style: TextStyle(
                              color: primary,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      if (widget.combinationIndice.dishesWithIngredients
                          .isNotEmpty) ...[
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
                                  color: secondary,
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
                        child: Divider(height: 1, thickness: 1, color: _divider),
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
                            visualDensity: VisualDensity.compact,
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(
                              minWidth: 40,
                              minHeight: 40,
                            ),
                            onPressed: widget.onEdit,
                            icon: Icon(
                              Icons.edit_outlined,
                              color: iconMuted,
                              size: 22,
                            ),
                          ),
                          const Spacer(),
                          DecoratedBox(
                            decoration: BoxDecoration(
                              color: _qtyTrayBg,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 4,
                                vertical: 4,
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  InkWell(
                                    onTap: _quantity > 1
                                        ? () => _setQuantity(_quantity - 1)
                                        : null,
                                    borderRadius: BorderRadius.circular(8),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 10,
                                        vertical: 6,
                                      ),
                                      child: Icon(
                                        Icons.remove,
                                        size: 20,
                                        color: _quantity > 1
                                            ? iconMuted
                                            : iconMuted.withValues(alpha: 0.4),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 28,
                                    child: Text(
                                      '$_quantity',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: primary,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () => _setQuantity(_quantity + 1),
                                    borderRadius: BorderRadius.circular(8),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 10,
                                        vertical: 6,
                                      ),
                                      child: Icon(
                                        Icons.add,
                                        size: 20,
                                        color: secondary,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
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

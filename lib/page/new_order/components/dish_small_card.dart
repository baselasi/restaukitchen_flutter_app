import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restaukitchen_app/core/models/dish.dart';
import 'package:restaukitchen_app/core/models/ingredients.dart';
import 'package:restaukitchen_app/page/new_order/bloc/new_order_form_bloc/new_order_form_bloc.dart';
import 'package:restaukitchen_app/page/new_order/bloc/new_order_form_bloc/new_order_from_events.dart';
import 'package:restaukitchen_app/page/new_order/components/add_dish_dialog.dart';
import 'package:restaukitchen_app/page/order_list/models/course.dart';
import 'package:restaukitchen_app/theme/light_theme.dart';

class DishSmallCard extends StatefulWidget {
  final Dish dish;
  final VoidCallback? onTap;
  final List<Ingredient> ingredients;
  const DishSmallCard({
    super.key,
    required this.dish,
    this.onTap,
    required this.ingredients,
  });

  @override
  State<DishSmallCard> createState() => _DishSmallCardState();
}

class _DishSmallCardState extends State<DishSmallCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scaleAnimation;

  List<double> _collectDishPrices() {
    final prices = <double>[];
    final base = widget.dish.price;
    if (base != null) prices.add(base);

    final assignments = widget.dish.dimensionAssignments;
    if (assignments != null) {
      for (final assignment in assignments) {
        if (assignment.deleted == true) continue;
        final parsed = num.tryParse(assignment.price ?? '');
        if (parsed != null) prices.add(parsed.toDouble());
      }
    }

    return prices;
  }

  String _dishPriceRangeLabel() {
    final prices = _collectDishPrices();
    if (prices.isEmpty) return '';

    prices.sort();
    final min = prices.first;
    final max = prices.last;

    if (min == max) return '€${min.toStringAsFixed(2)}';
    return '€${min.toStringAsFixed(2)} - €${max.toStringAsFixed(2)}';
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
      reverseDuration: const Duration(milliseconds: 100),
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) => _controller.forward();

  void _onTapUp(TapUpDetails details) async {
    _controller.reverse();
    widget.onTap?.call();
    final result = await showAddDishDialog(
      context: context,
      dish: widget.dish,
      ingredients: widget.ingredients,
    );
    if (result != null && mounted && context.mounted) {
      final courseIndex = context
          .read<NewOrderFormBloc>()
          .state
          .currentCourseIndex;
      final dishIndice = DishIndice(
        dishId: widget.dish.id ?? '',
        dishName: widget.dish.name,
        dishPrice: widget.dish.price,
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
                dishId: widget.dish.id ?? '',
                dishName: widget.dish.name,
                ingredientsId: [ingredient.id ?? ''],
                ingredientsName: [ingredient.name],
              ),
            )
            .toList(),
        course: courseIndex,
      );
      context.read<NewOrderFormBloc>().add(
        AddDishIndice(courseIndice: dishIndice, courseIndex: courseIndex),
      );
    }
  }

  void _onTapCancel() => _controller.reverse();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final priceRangeLabel = _dishPriceRangeLabel();

    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) =>
          Transform.scale(scale: _scaleAnimation.value, child: child),
      child: Material(
        elevation: 2,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          onTapDown: _onTapDown,
          onTapUp: _onTapUp,
          onTapCancel: _onTapCancel,
          borderRadius: BorderRadius.circular(12),

          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.dish.name,
                      style: textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      priceRangeLabel,
                      style: textTheme.bodyMedium?.copyWith(
                        color: colorScheme.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: LightTheme.primaryColor.withValues(alpha: 0.14),
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: Icon(Icons.add, size: 22, color: colorScheme.primary),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

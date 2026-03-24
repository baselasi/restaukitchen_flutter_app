import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restaukitchen_app/core/models/dish.dart';
import 'package:restaukitchen_app/core/models/ingredients.dart';
import 'package:restaukitchen_app/page/new_order/bloc/new_order_form_bloc/new_order_form_bloc.dart';
import 'package:restaukitchen_app/page/new_order/bloc/new_order_form_bloc/new_order_from_events.dart';
import 'package:restaukitchen_app/page/new_order/components/add_dish_dialog.dart';
import 'package:restaukitchen_app/page/order_list/models/course.dart';

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
        dishDimensionId: result.selectedDimension?.dimension.id ?? '',
        dishIngredientsId: result.ingredients
            .map((ingredient) => ingredient.id)
            .whereType<String>()
            .toList(),
        dishQuantity: result.quantity,
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
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.dish.name,
                      style: textTheme.titleSmall,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      widget.dish.price != null
                          ? '€${widget.dish.price!.toStringAsFixed(2)}'
                          : '',
                      style: textTheme.bodyMedium?.copyWith(
                        color: colorScheme.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                top: -20,
                right: -20,
                child: IconButton(
                  onPressed: () {},
                  icon: Icon(
                    Icons.add_circle,
                    color: colorScheme.primary,
                    size: 36,
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

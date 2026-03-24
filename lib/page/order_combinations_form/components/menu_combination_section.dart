import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restaukitchen_app/core/models/ingredients.dart';
import 'package:restaukitchen_app/page/menusPage/models/menu.dart';
import 'package:restaukitchen_app/page/order_combinations_form/bloc/combination_menu_section_cubit/combination_menu_section_cubit.dart';

class MenuCombinationSection extends StatefulWidget {
  final Menu menu;
  final String? selectedDimensionId;
  final Function(String menuId) onDishSelected;
  final bool isActive;
  const MenuCombinationSection({
    super.key,
    required this.menu,
    required this.selectedDimensionId,
    required this.onDishSelected,
    required this.isActive,
  });

  @override
  State<MenuCombinationSection> createState() => _MenuCombinationSectionState();
}

class _MenuCombinationSectionState extends State<MenuCombinationSection> {
  int? _selectedDishIndex;

  @override
  Widget build(BuildContext context) {
    final dishes = widget.menu.dishes;
    final List<Ingredient> availableIngredients = widget.menu.ingredients
        .where(
          (ingredient) => ingredient.dimensionAssignments.any(
            (assignment) =>
                assignment.dimension.id == widget.selectedDimensionId,
          ),
        )
        .toList();

    if (dishes.isEmpty) {
      return const Text('No dishes available for this menu.');
    }

    return BlocConsumer<
      CombinationMenuSectionCubit,
      CombinationMenuSectionState
    >(
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.menu.name,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                if (state.selectedDish != null)
                  Icon(
                    Icons.check_circle,
                    size: 30,
                    color: Theme.of(context).colorScheme.primary,
                  ),
              ],
            ),
            const SizedBox(height: 8),
            RadioGroup<int?>(
              groupValue: _selectedDishIndex,
              onChanged: (value) {
                if (value == null) return;
                if (!widget.isActive) return;
                setState(() {
                  _selectedDishIndex = value;
                  widget.onDishSelected(widget.menu.id);
                  context.read<CombinationMenuSectionCubit>().selectDish(
                    dishes[value],
                  );
                });
              },
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: List.generate(dishes.length, (index) {
                  final dish = dishes[index];
                  return RadioListTile<int?>(
                    dense: true,
                    enabled: widget.isActive,
                    value: index,
                    contentPadding: EdgeInsets.zero,
                    title: Text(dish.name),
                    subtitle:
                        dish.description != null && dish.description!.isNotEmpty
                        ? Text(dish.description!)
                        : null,
                  );
                }),
              ),
            ),
            if (state.selectedDish != null && availableIngredients.isNotEmpty)
              MenuIngredientsList(
                ingredients: availableIngredients,
                ingredientSelections: state.ingredientSelections,
              ),
          ],
        );
      },
      listener: (context, state) {
        if (state.selectedDish != null) {}
      },
    );
  }
}

class MenuIngredientsList extends StatelessWidget {
  const MenuIngredientsList({
    super.key,
    required this.ingredients,
    required this.ingredientSelections,
  });

  final List<Ingredient> ingredients;
  final Map<String, IngredientSelection> ingredientSelections;

  /// Map key: ingredient id when present, else stable fallback per row.
  static String ingredientIdKey(Ingredient ingredient, int index) {
    if (ingredient.id != null && ingredient.id!.isNotEmpty) {
      return ingredient.id!;
    }
    return 'ingredient_$index';
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<CombinationMenuSectionCubit>();

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (var i = 0; i < ingredients.length; i++) ...[
          if (i > 0)
            Divider(
              height: 1,
              thickness: 1,
              color: Theme.of(
                context,
              ).colorScheme.outlineVariant.withValues(alpha: 0.35),
            ),
          _MenuIngredientTile(
            ingredient: ingredients[i],
            quantity:
                ingredientSelections[ingredientIdKey(ingredients[i], i)]
                    ?.quantity ??
                0,
            priceLabel: _ingredientExtraPriceLabel(ingredients[i]),
            onIncrement: () => cubit.incrementIngredientQuantity(
              ingredientIdKey(ingredients[i], i),
              ingredients[i],
            ),
            onDecrement: () => cubit.decrementIngredientQuantity(
              ingredientIdKey(ingredients[i], i),
            ),
          ),
        ],
      ],
    );
  }
}

String? _ingredientExtraPriceLabel(Ingredient ingredient) {
  for (final a in ingredient.dimensionAssignments) {
    if (a.deleted == true) continue;
    final p = a.price;
    if (p != null && p.isNotEmpty) {
      final trimmed = p.trim();
      if (trimmed.contains('€')) return '+$trimmed';
      return '+$trimmed €';
    }
  }
  return null;
}

class _MenuIngredientTile extends StatelessWidget {
  const _MenuIngredientTile({
    required this.ingredient,
    required this.quantity,
    required this.priceLabel,
    required this.onIncrement,
    required this.onDecrement,
  });

  final Ingredient ingredient;
  final int quantity;
  final String? priceLabel;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final titleStyle = quantity > 0
        ? Theme.of(
            context,
          ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600)
        : Theme.of(context).textTheme.bodyLarge;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: quantity == 0 ? onIncrement : null,
        child: ListTile(
          dense: true,
          contentPadding: const EdgeInsets.symmetric(vertical: 6),
          horizontalTitleGap: 12,
          leading: SizedBox(
            width: quantity == 0 ? 40 : 110,
            child: quantity == 0
                ? _PlusOnlyCircle(scheme: scheme)
                : _QuantityStepper(
                    quantity: quantity,
                    scheme: scheme,
                    onIncrement: onIncrement,
                    onDecrement: onDecrement,
                  ),
          ),
          title: Text(ingredient.name, style: titleStyle),
          trailing: priceLabel != null
              ? Text(
                  priceLabel!,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: scheme.onSurfaceVariant.withValues(alpha: 0.5),
                    fontWeight: FontWeight.w800,
                  ),
                )
              : null,
        ),
      ),
    );
  }
}

class _PlusOnlyCircle extends StatelessWidget {
  const _PlusOnlyCircle({required this.scheme});

  final ColorScheme scheme;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 20,
      height: 20,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: scheme.surfaceContainerHighest,
        border: Border.all(
          color: Theme.of(context).colorScheme.primary,
          style: BorderStyle.solid,
          width: 1,
        ),
      ),
      child: Icon(
        Icons.add,
        size: 18,
        color: Theme.of(context).colorScheme.primary,
      ),
    );
  }
}

class _QuantityStepper extends StatelessWidget {
  const _QuantityStepper({
    required this.quantity,
    required this.scheme,
    required this.onIncrement,
    required this.onDecrement,
  });

  final int quantity;
  final ColorScheme scheme;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _RoundGreyIconButton(
          icon: Icons.remove,
          scheme: scheme,
          onTap: onDecrement,
        ),
        const SizedBox(width: 6),
        Container(
          width: 25,
          height: 25,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Theme.of(context).colorScheme.secondary,
          ),
          child: Text(
            '$quantity',
            style: TextStyle(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.w700,
              fontSize: 14,
            ),
          ),
        ),
        const SizedBox(width: 6),
        _RoundGreyIconButton(
          icon: Icons.add,
          scheme: scheme,
          onTap: onIncrement,
        ),
      ],
    );
  }
}

class _RoundGreyIconButton extends StatelessWidget {
  const _RoundGreyIconButton({
    required this.icon,
    required this.scheme,
    required this.onTap,
  });

  final IconData icon;
  final ColorScheme scheme;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: scheme.surfaceContainerHigh,
      shape: const CircleBorder(),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        splashColor: scheme.primary.withValues(alpha: 0.22),
        highlightColor: scheme.primary.withValues(alpha: 0.12),
        child: SizedBox(
          width: 32,
          height: 32,
          child: Center(child: Icon(icon, size: 18, color: scheme.primary)),
        ),
      ),
    );
  }
}

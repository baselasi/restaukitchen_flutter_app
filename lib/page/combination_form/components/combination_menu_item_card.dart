import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:page_transition/page_transition.dart';
import 'package:restaukitchen_app/core/bloc/add_ingredents_to_menu_cubit.dart';
import 'package:restaukitchen_app/core/bloc/get_ingredients_cubit.dart';
import 'package:restaukitchen_app/core/models/dish.dart';
import 'package:restaukitchen_app/core/repository/ingredients_repo.dart';
import 'package:restaukitchen_app/core/widgets/public_image.dart';
import 'package:restaukitchen_app/page/combination_form/bloc/add_dishes_to_menu_cubit/add_dishes_to_menu_combination_cubit.dart';
import 'package:restaukitchen_app/page/combination_form/bloc/combination_menu_creation_form_cubit/combination_menu_creation_form_cubit.dart';
import 'package:restaukitchen_app/page/combination_form/components/add_dishes_page.dart';
import 'package:restaukitchen_app/page/combination_form/components/add_ingredients_page.dart';
import 'package:restaukitchen_app/page/combination_form/repository/combination_form_repo.dart';
import 'package:restaukitchen_app/page/menusPage/bloc/delete_dish_cubit.dart';
import 'package:restaukitchen_app/page/menusPage/bloc/delete_menu_cubit.dart';
import 'package:restaukitchen_app/page/menusPage/bloc/menus_page_bloc.dart';
import 'package:restaukitchen_app/theme/light_theme.dart';

/// Card for a single combination menu group: dishes, optional ingredients, actions.
class CombinationMenuItemCard extends StatefulWidget {
  final CombinationMenuModel menu;

  const CombinationMenuItemCard({super.key, required this.menu});

  @override
  State<CombinationMenuItemCard> createState() =>
      _CombinationMenuItemCardState();
}

class _CombinationMenuItemCardState extends State<CombinationMenuItemCard> {
  bool _ingredientsExpanded = false;

  static const Color _labelColor = Color(0xFF6B7280);
  static const Color _dishRowBg = Color(0xFFEDEAF7);
  static const Color _badgeBg = Color(0xFFE5E7EB);

  Future<void> _addIngredients() async {
    final ingredients = await Navigator.of(context).push(
      PageTransition(
        type: PageTransitionType.rightToLeft,
        child: BlocProvider.value(
          value: context.read<GetIngredientsCubit>(),
          child: BlocProvider(
            create: (context) =>
                AddIngredientsToMenuCubit(ingredientsRepo: IngredientsRepo()),
            child: AddIngredientsPage(
              initialSelected: widget.menu.ingredients,
              menuId: widget.menu.id,
            ),
          ),
        ),
      ),
    );
    if (ingredients != null && mounted) {
      context.read<CombinationMenuCreationFormCubit>().addIngredientToMenu(
        widget.menu.id,
        ingredients,
      );
    }
  }

  Future<void> _addDishes() async {
    final dishes = await Navigator.of(context).push(
      PageTransition(
        type: PageTransitionType.rightToLeft,
        child: MultiBlocProvider(
          providers: [
            BlocProvider(create: (context) => MenusPageBloc()),
            BlocProvider.value(
              value: context.read<CombinationMenuCreationFormCubit>(),
            ),
            BlocProvider(
              create: (context) => AddDishesToMenuCombinationCubit(
                combinationFormRepo: CombinationFormRepo(),
              ),
            ),
          ],
          child: AddDishesPageToCombinationsPage(
            combinationId: widget.menu.id,
            initialSelectedDishes: widget.menu.dishes,
          ),
        ),
      ),
    );
    if (dishes != null && mounted) {
      final dishesList = dishes.toList();
      context.read<CombinationMenuCreationFormCubit>().addDishToMenu(
        widget.menu.id,
        dishesList,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final menu = widget.menu;
    final dishCount = menu.dishes.length;
    final primary = LightTheme.primaryColor;
    final deleteMenuCubit = context.watch<DeleteMenuCubit>();
    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: deleteMenuCubit.state.status != DeleteMenuStatus.isLoading
            ? Border(left: BorderSide(color: primary, width: 5))
            : null,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: BlocConsumer<DeleteMenuCubit, DeleteMenuState>(
        builder: (context, deleteMenuState) {
          if (deleteMenuState.status == DeleteMenuStatus.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          return Material(
            color: theme.colorScheme.surface,
            elevation: 2,
            shadowColor: Colors.black.withValues(alpha: 0.06),
            borderRadius: BorderRadius.circular(16),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          menu.name,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF111827),
                          ),
                        ),
                      ),
                      IconButton(
                        visualDensity: VisualDensity.compact,
                        onPressed: () {},
                        icon: Icon(
                          Icons.edit_outlined,
                          color: primary,
                          size: 22,
                        ),
                        tooltip: 'Edit',
                      ),
                      IconButton(
                        visualDensity: VisualDensity.compact,
                        onPressed: () {
                          context.read<DeleteMenuCubit>().deleteMenu(menu.id);
                        },
                        icon: const Icon(Icons.delete_outline, size: 22),
                        color: Colors.red,
                        tooltip: 'Delete',
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Text(
                        'SELECTED DISHES',
                        style: theme.textTheme.labelSmall?.copyWith(
                          letterSpacing: 0.6,
                          fontWeight: FontWeight.w600,
                          color: _labelColor,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: _badgeBg,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          '$dishCount ${dishCount == 1 ? 'ITEM' : 'ITEMS'}',
                          style: theme.textTheme.labelSmall?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF4B5563),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  if (menu.dishes.isEmpty)
                    Padding(
                      padding: const EdgeInsets.only(left: 16, bottom: 8),
                      child: Text(
                        'No dishes yet',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: _labelColor,
                        ),
                      ),
                    )
                  else
                    ...List.generate(menu.dishes.length, (index) {
                      return Padding(
                        padding: const EdgeInsets.only(left: 16, bottom: 8),
                        child: BlocProvider(
                          create: (context) => DeleteDishCubit(),
                          child: _DishRow(
                            dish: menu.dishes[index],
                            onRemove: () {
                              context
                                  .read<CombinationMenuCreationFormCubit>()
                                  .removeDishAt(
                                    menu.id,
                                    menu.dishes[index].id ?? "",
                                  );
                            },
                          ),
                        ),
                      );
                    }),
                  const SizedBox(height: 8),
                  if (menu.ingredients.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(left: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          InkWell(
                            onTap: () => setState(
                              () =>
                                  _ingredientsExpanded = !_ingredientsExpanded,
                            ),
                            borderRadius: BorderRadius.circular(8),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 6),
                              child: Row(
                                children: [
                                  Icon(
                                    _ingredientsExpanded
                                        ? Icons.expand_less
                                        : Icons.expand_more,
                                    color: _labelColor,
                                    size: 22,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    'INGREDIENTS',
                                    style: theme.textTheme.labelSmall?.copyWith(
                                      letterSpacing: 0.6,
                                      fontWeight: FontWeight.w600,
                                      color: _labelColor,
                                    ),
                                  ),
                                  const Spacer(),
                                ],
                              ),
                            ),
                          ),
                          if (_ingredientsExpanded) ...[
                            const SizedBox(height: 6),
                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: menu.ingredients
                                  .map(
                                    (i) => Chip(
                                      label: Text(i.name),
                                      visualDensity: VisualDensity.compact,
                                      backgroundColor: _dishRowBg,
                                      side: BorderSide.none,
                                    ),
                                  )
                                  .toList(),
                            ),
                          ],
                        ],
                      ),
                    ),
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.only(left: 16),
                    child: Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () {
                              _addDishes();
                            },
                            icon: Icon(
                              Icons.add_circle_outline,
                              color: primary,
                            ),
                            label: Text(
                              'Add Dishes',
                              style: TextStyle(
                                color: primary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: primary,
                              side: BorderSide(color: primary),
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () async {
                              _addIngredients();
                            },
                            icon: const Icon(Icons.tune, size: 20),
                            label: const Text('Add Ingredients'),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: primary,
                              side: BorderSide(color: primary),
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
        listener: (context, deleteMenuState) {
          if (deleteMenuState.status == DeleteMenuStatus.isSucess) {
            context.read<CombinationMenuCreationFormCubit>().removeMenu(
              menu.id,
            );
          }
        },
      ),
    );
  }
}

class _DishRow extends StatelessWidget {
  final Dish dish;
  final VoidCallback onRemove;

  const _DishRow({required this.dish, required this.onRemove});

  static const Color _subtitleColor = Color(0xFF6B7280);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final imageId = dish.dishImagesId?.isNotEmpty == true
        ? dish.dishImagesId!.last
        : null;

    final placeholder = Container(
      color: const Color(0xFFE5E7EB),
      child: const Icon(Icons.restaurant, color: Color(0xFF9CA3AF), size: 24),
    );

    return BlocConsumer<DeleteDishCubit, DeleteDishState>(
      builder: (context, state) {
        if (state.status == DeleteDishStatus.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        return Material(
          color: const Color(0xFFEDEAF7),
          borderRadius: BorderRadius.circular(10),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: SizedBox(
                    width: 48,
                    height: 48,
                    child: imageId != null
                        ? PublicImage(
                            imageUrl: '/api/public/dish-image/$imageId',
                            fit: BoxFit.cover,
                            placeholder: placeholder,
                            errorWidget: placeholder,
                          )
                        : placeholder,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        dish.name,
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF111827),
                        ),
                      ),
                      // const SizedBox(height: 2),
                      // Text(
                      //   'Qty: 1',
                      //   style: theme.textTheme.bodySmall?.copyWith(
                      //     color: _subtitleColor,
                      //   ),
                      // ),
                    ],
                  ),
                ),
                IconButton(
                  visualDensity: VisualDensity.compact,
                  onPressed: () {
                    context.read<DeleteDishCubit>().deleteDish(dish.id ?? "");
                  },
                  icon: const Icon(Icons.close, size: 20),
                  color: _subtitleColor,
                  tooltip: 'Remove',
                ),
              ],
            ),
          ),
        );
      },
      listener: (context, state) {
        if (state.status == DeleteDishStatus.isSucess) {
          // context.read<CombinationMenuCreationFormCubit>().removeDishFromMenu(dish.id);
          onRemove();
        }
      },
    );
  }
}

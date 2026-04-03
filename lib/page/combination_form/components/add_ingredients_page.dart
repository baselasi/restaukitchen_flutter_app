import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restaukitchen_app/core/bloc/add_ingredents_to_menu_cubit.dart';
import 'package:restaukitchen_app/core/bloc/auth_cubit.dart';
import 'package:restaukitchen_app/core/bloc/get_ingredients_cubit.dart';
import 'package:restaukitchen_app/core/components/appBar/details_app_bar.dart';
import 'package:restaukitchen_app/core/components/form/primary_button.dart';
import 'package:restaukitchen_app/core/models/ingredients.dart';
import 'package:restaukitchen_app/theme/light_theme.dart';

class AddIngredientsPage extends StatefulWidget {
  final String menuId;
  const AddIngredientsPage({
    super.key,
    required this.menuId,
    this.initialSelected = const [],
  });

  /// Pre-selected ingredients (matched by `id` if set, otherwise by `name`).
  final List<Ingredient> initialSelected;

  @override
  State<AddIngredientsPage> createState() => _AddIngredientsPageState();
}

class _AddIngredientsPageState extends State<AddIngredientsPage> {
  Set<Ingredient> _selectedIngredients = {};

  @override
  void initState() {
    super.initState();
    _selectedIngredients = widget.initialSelected.toSet();
    if (context.read<GetIngredientsCubit>().state.status !=
        GetIngredientsStatus.loaded) {
      context.read<GetIngredientsCubit>().getIngredientsByRestaurantId(
        context.read<AuthCubit>().state.user!.restaurant!,
      );
    }
  }

  void _toggle(Ingredient ingredient) {
    setState(() {
      if (_selectedIngredients.contains(ingredient)) {
        _selectedIngredients.remove(ingredient);
      } else {
        _selectedIngredients.add(ingredient);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final primary = LightTheme.primaryColor;

    return Scaffold(
      appBar: DetailsAppBar(pageTitle: 'Add Ingredients'),
      bottomNavigationBar: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
          child: PrimaryButton(
            text: 'save',
            onPressed: () {
              context.read<AddIngredientsToMenuCubit>().addIngredientsToMenu(
                widget.menuId,
                _selectedIngredients.map((e) => e.id!).toList(),
              );
              // Navigator.of(context).pop();
            },
          ),
        ),
      ),
      body: BlocConsumer<GetIngredientsCubit, GetIngredientsState>(
        builder: (context, getState) {
          if (getState.status == GetIngredientsStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (getState.status == GetIngredientsStatus.error) {
            return Center(
              child: Text(
                getState.errorMessage ?? 'Failed to load ingredients',
              ),
            );
          }
          if (getState.status == GetIngredientsStatus.loaded) {
            final ingredients = getState.ingredients ?? [];
            if (ingredients.isEmpty) {
              return Center(
                child: Text(
                  'No ingredients available',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: const Color(0xFF6B7280),
                  ),
                ),
              );
            }
            return BlocConsumer<
              AddIngredientsToMenuCubit,
              AddIngredientsToMenuState
            >(
              builder: (context, postState) {
                if (postState.status == AddIngredientsToMenuStatus.loading) {
                  return const Center(child: CircularProgressIndicator());
                }
                return Center(
                  child: ListView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 42, 16, 24),
                    itemCount: ingredients.length,
                    itemBuilder: (context, index) {
                      final ingredient = ingredients[index];
                      final selected = _selectedIngredients.contains(
                        ingredient,
                      );
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: _IngredientSelectCard(
                          ingredient: ingredient,
                          selected: selected,
                          primary: primary,
                          onTap: () => _toggle(ingredient),
                        ),
                      );
                    },
                  ),
                );
              },
              listener: (context, state) {
                if (state.status == AddIngredientsToMenuStatus.success) {
                  Navigator.of(context).pop(_selectedIngredients.toList());
                }
                if (state.status == AddIngredientsToMenuStatus.error) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        state.errorMessage ?? 'Failed to add ingredients',
                      ),
                    ),
                  );
                }
              },
            );
          }
          return const SizedBox.shrink();
        },
        listener: (context, state) {},
      ),
    );
  }
}

class _IngredientSelectCard extends StatelessWidget {
  const _IngredientSelectCard({
    required this.ingredient,
    required this.selected,
    required this.primary,
    required this.onTap,
  });

  final Ingredient ingredient;
  final bool selected;
  final Color primary;
  final VoidCallback onTap;

  static const Color _titleColor = Color(0xFF111827);
  static const Color _surface = Color(0xFFEDEAF7);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Material(
      color: theme.colorScheme.surface,
      elevation: 3,
      shadowColor: Colors.black.withValues(alpha: 0.1),
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeOut,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: selected ? primary : Colors.black.withValues(alpha: 0.1),
              width: 2,
            ),
            color: selected ? _surface : null,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  ingredient.name,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: _titleColor,
                  ),
                ),
              ),
              Icon(
                selected ? Icons.check_circle : Icons.circle_outlined,
                color: selected ? primary : const Color(0xFF9CA3AF),
                size: 26,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

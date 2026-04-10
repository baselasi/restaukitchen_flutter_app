import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:page_transition/page_transition.dart';
import 'package:restaukitchen_app/core/bloc/auth_cubit.dart';
import 'package:restaukitchen_app/core/bloc/get_ingredients_cubit.dart';
import 'package:restaukitchen_app/core/components/appBar/details_app_bar.dart';
import 'package:restaukitchen_app/core/models/ingredients.dart';
import 'package:restaukitchen_app/core/repository/ingredients_repo.dart';
import 'package:restaukitchen_app/page/dimension_list/bloc/get_dimensions_cubit.dart';
import 'package:restaukitchen_app/page/ingredients_list/bloc/delete_ingredient_cubit.dart';
import 'package:restaukitchen_app/page/ingredients_list/bloc/new_ingredient_form_cubit.dart';
import 'package:restaukitchen_app/page/ingredients_list/bloc/post_ingredient_cubit.dart';
import 'package:restaukitchen_app/page/ingredients_list/create_ingredient_page.dart';
import 'package:restaukitchen_app/theme/light_theme.dart';

class IngredientsList extends StatefulWidget {
  const IngredientsList({super.key});

  @override
  State<IngredientsList> createState() => _IngredientsListState();
}

class _IngredientsListState extends State<IngredientsList> {
  @override
  void initState() {
    super.initState();
    context.read<GetIngredientsCubit>().getIngredientsByRestaurantId(
      context.read<AuthCubit>().state.user?.restaurant ?? '',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DetailsAppBar(pageTitle: 'Ingredients List'),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final ingredient = await Navigator.of(context).push(
            PageTransition(
              type: PageTransitionType.rightToLeft,
              child: MultiBlocProvider(
                providers: [
                  BlocProvider.value(value: context.read<GetDimensionsCubit>()),
                  BlocProvider(create: (context) => NewIngredientFormCubit()),
                  BlocProvider(
                    create: (context) =>
                        PostIngredientCubit(ingredientsRepo: IngredientsRepo()),
                  ),
                  BlocProvider.value(
                    value: context.read<GetIngredientsCubit>(),
                  ),
                ],
                child: CreateIngredientPage(),
              ),
            ),
          );
          if (ingredient != null && context.mounted) {
            context.read<GetIngredientsCubit>().addIngredient(ingredient);
          }
        },
        child: const Icon(Icons.add),
      ),
      body: BlocConsumer<GetIngredientsCubit, GetIngredientsState>(
        builder: (context, state) {
          if (state.status == GetIngredientsStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state.status == GetIngredientsStatus.error) {
            return Center(
              child: Text(state.errorMessage ?? 'Error loading ingredients'),
            );
          }
          if (state.status == GetIngredientsStatus.loaded) {
            final ingredients = state.ingredients ?? [];
            return Center(
              child: ListView.separated(
                shrinkWrap: true,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: ingredients.length,
                separatorBuilder: (_, _) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      if (index == 0) const SizedBox(height: 60),
                      BlocProvider(
                        create: (context) => DeleteIngredientCubit(
                          ingredientsRepo: IngredientsRepo(),
                        ),
                        child: _IngredientCard(
                          ingredient: ingredients[index],
                          onUpdate: (ingredient) {
                            context
                                .read<GetIngredientsCubit>()
                                .updateIngredient(ingredient);
                          },
                          onDelete: (ingredientId) {
                            context
                                .read<GetIngredientsCubit>()
                                .removeIngredient(ingredientId);
                          },
                        ),
                      ),
                      if (index == ingredients.length - 1)
                        const SizedBox(height: 60),
                    ],
                  );
                },
              ),
            );
          }
          return const SizedBox.shrink();
        },
        listener: (context, state) {},
      ),
    );
  }
}

class _IngredientCard extends StatelessWidget {
  const _IngredientCard({
    required this.ingredient,
    required this.onUpdate,
    required this.onDelete,
  });
  // final PostIngredientCubit postIngredientCubit;
  final Function(Ingredient) onUpdate;
  final Function(String) onDelete;
  final Ingredient ingredient;

  String _buildPriceRange() {
    final prices =
        ingredient.dimensionAssignments
            .where((assignment) => assignment.deleted != true)
            .map((assignment) => double.tryParse(assignment.price ?? ''))
            .whereType<double>()
            .toList()
          ..sort();

    if (prices.isEmpty) return 'No price set';
    if (prices.length == 1) return '\$${prices.first.toStringAsFixed(2)}';
    return '\$${prices.first.toStringAsFixed(2)} - \$${prices.last.toStringAsFixed(2)}';
  }

  @override
  Widget build(BuildContext context) {
    final priceRange = _buildPriceRange();

    return BlocConsumer<DeleteIngredientCubit, DeleteIngredientState>(
      builder: (context, state) {
        return Material(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          elevation: 2,
          shadowColor: Colors.black.withValues(alpha: 0.08),
          child: InkWell(
            onTap: () {},
            borderRadius: BorderRadius.circular(20),
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: LightTheme.primaryColor,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    alignment: Alignment.center,
                    child: const Icon(
                      Icons.scatter_plot_rounded,
                      color: Colors.white,
                      size: 22,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          ingredient.name,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF111827),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          priceRange,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Color(0xFF6B7280),
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () async {
                      final updatedIngredient = await Navigator.of(context)
                          .push(
                            PageTransition(
                              type: PageTransitionType.rightToLeft,
                              child: MultiBlocProvider(
                                providers: [
                                  BlocProvider.value(
                                    value: context.read<GetDimensionsCubit>(),
                                  ),
                                  BlocProvider(
                                    create: (context) =>
                                        NewIngredientFormCubit(),
                                  ),
                                  BlocProvider(
                                    create: (context) => PostIngredientCubit(
                                      ingredientsRepo: IngredientsRepo(),
                                    ),
                                  ),
                                  BlocProvider.value(
                                    value: context.read<GetIngredientsCubit>(),
                                  ),
                                ],
                                child: CreateIngredientPage(
                                  ingredient: ingredient,
                                ),
                              ),
                            ),
                          );
                      if (updatedIngredient != null) {
                        onUpdate(updatedIngredient);
                      }
                    },
                    icon: const Icon(Icons.edit_outlined),
                    color: const Color(0xFF1D4ED8),
                    tooltip: 'Edit ingredient',
                  ),
                  if (state.status == DeleteIngredientStatus.loading)
                    const Center(child: CircularProgressIndicator()),
                  if (state.status != DeleteIngredientStatus.loading)
                    IconButton(
                      onPressed: () {
                        context.read<DeleteIngredientCubit>().deleteIngredient(
                          ingredient.id ?? '',
                        );
                      },
                      icon: const Icon(Icons.delete_outline),
                      color: const Color(0xFFDC2626),
                      tooltip: 'Delete ingredient',
                    ),
                ],
              ),
            ),
          ),
        );
      },
      listener: (context, state) {
        if (state.status == DeleteIngredientStatus.success) {
          onDelete(ingredient.id ?? '');
        }
        if (state.status == DeleteIngredientStatus.error) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMessage ?? 'Error deleting ingredient'),
            ),
          );
        }
      },
    );
  }
}

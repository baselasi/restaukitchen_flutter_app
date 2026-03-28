import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restaukitchen_app/core/components/appBar/details_app_bar.dart';
import 'package:restaukitchen_app/core/components/form/dimensionInput/dimension.dart';
import 'package:restaukitchen_app/core/components/form/primary_button.dart';
import 'package:restaukitchen_app/page/combination_page/models/combination.dart';
import 'package:restaukitchen_app/page/order_combinations_form/bloc/add_dishes_cubit.dart';
import 'package:restaukitchen_app/page/order_combinations_form/bloc/combination_menu_section_cubit/combination_menu_section_cubit.dart';
import 'package:restaukitchen_app/page/order_combinations_form/components/menu_combination_section.dart';
import 'package:restaukitchen_app/page/order_list/models/course.dart';

class AddDishesPage extends StatefulWidget {
  final Combination? combination;
  final String? selectedDimensionId;
  final String? combinationId;
  final String? combinationDimensionName;
  final Dimension combinationDimension;
  final double? price;
  final String? combinationDimensionId;
  const AddDishesPage({
    super.key,
    this.combination,
    this.selectedDimensionId,
    this.combinationId,
    this.combinationDimensionName,
    this.price,
    this.combinationDimensionId,
    required this.combinationDimension,
  });

  @override
  State<AddDishesPage> createState() => _AddDishesPageState();
}

class _AddDishesPageState extends State<AddDishesPage> {
  int _quantity = 1;
  final TextEditingController _noteController = TextEditingController();
  late final List<CombinationMenuSectionCubit> _sectionCubits;

  @override
  void initState() {
    super.initState();
    _sectionCubits = (widget.combination?.menuList ?? [])
        .map((menu) => CombinationMenuSectionCubit(menu: menu))
        .toList();
  }

  @override
  void dispose() {
    for (final cubit in _sectionCubits) {
      cubit.close();
    }
    _noteController.dispose();
    super.dispose();
  }

  bool get _canSaveOrder =>
      _sectionCubits.isNotEmpty &&
      _sectionCubits.every((c) => c.state.selectedDish != null);

  void _saveOrder() {
    if (!_canSaveOrder) return;
    final menuSectionStates = _sectionCubits.map((c) => c.state).toList();
    List<CombinationIndice> combinationIndices = [];
    final state = menuSectionStates.first;
    if (state.selectedDish != null) {
      combinationIndices.add(
        CombinationIndice(
          combinationName: widget.combination!.name,
          combinationId: widget.combination!.id,
          combinationQuantity: _quantity,
          combinationDimensionId: widget.selectedDimensionId!,
          combinationDimensionName: widget.combinationDimension.name,
          combinationPrice: widget.price ?? 0,
          dishesWithIngredients: _getDishesWithIngredients(menuSectionStates),
          course: 0,
        ),
      );
    }
    Navigator.pop(context, combinationIndices);
  }

  List<DishesWithIngredients> _getDishesWithIngredients(
    List<CombinationMenuSectionState> states,
  ) {
    return states.map((state) {
      final ingredientsId = <String>[];
      final ingredientsName = <String>[];
      for (final entry in state.ingredientSelections.entries) {
        final id = entry.value.ingredient.id ?? entry.key;
        final name = entry.value.ingredient.name;
        for (var q = 0; q < entry.value.quantity; q++) {
          ingredientsId.add(id);
          ingredientsName.add(name);
        }
      }
      return DishesWithIngredients(
        dishId: state.selectedDish!.id!,
        dishName: state.selectedDish!.name,
        ingredientsId: ingredientsId,
        ingredientsName: ingredientsName,
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AddDishesCubit, AddDishesState>(
      builder: (context, state) {
        return Scaffold(
          appBar: DetailsAppBar(pageTitle: 'Add Dishes'),
          bottomNavigationBar: SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
              child: Row(
                children: [
                  _CircleQuantityButton(
                    icon: Icons.remove,
                    onTap: () {
                      if (_quantity > 1) {
                        setState(() => _quantity -= 1);
                      }
                    },
                  ),
                  const SizedBox(width: 12),
                  Text(
                    '$_quantity',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(width: 12),
                  _CircleQuantityButton(
                    icon: Icons.add,
                    onTap: () => setState(() => _quantity += 1),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: PrimaryButton(
                      text: 'Save Order',
                      isDisabled: !_canSaveOrder,
                      onPressed: _saveOrder,
                    ),
                  ),
                ],
              ),
            ),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ...List.generate(_sectionCubits.length, (i) {
                  final cubit = _sectionCubits[i];
                  final menu = cubit.menu;
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 24),
                    child: BlocProvider.value(
                      value: cubit,
                      child: MenuCombinationSection(
                        selectedDimensionId: widget.selectedDimensionId,
                        isActive:
                            state.activeMenuIds.contains(menu.id) || i == 0,
                        menu: menu,
                        onDishSelected: (menuId) {
                          context.read<AddDishesCubit>().addActiveMenuId(
                            menuId,
                          );
                          setState(() {});
                        },
                      ),
                    ),
                  );
                }),
                const SizedBox(height: 8),
                TextField(
                  controller: _noteController,
                  minLines: 3,
                  maxLines: 5,
                  textInputAction: TextInputAction.done,
                  scrollPadding: const EdgeInsets.only(bottom: 120),
                  onTapOutside: (_) => FocusScope.of(context).unfocus(),
                  decoration: const InputDecoration(
                    labelText: 'Note',
                    hintText: 'Add note for this order',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        );
      },
      listener: (context, state) {},
    );
  }
}

class AddDishesPageResult {
  final List<CombinationMenuSectionState> menuSectionStates;
  final int quantity;
  final String note;

  const AddDishesPageResult({
    required this.menuSectionStates,
    required this.quantity,
    required this.note,
  });
}

class _CircleQuantityButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _CircleQuantityButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).colorScheme.primary,
      shape: const CircleBorder(),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: SizedBox(
          width: 36,
          height: 36,
          child: Icon(icon, color: Colors.white, size: 30),
        ),
      ),
    );
  }
}

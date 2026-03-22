import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restaukitchen_app/core/components/appBar/details_app_bar.dart';
import 'package:restaukitchen_app/page/combination_page/models/combination.dart';
import 'package:restaukitchen_app/page/order_combinations_form/bloc/add_dishes_cubit.dart';
import 'package:restaukitchen_app/page/order_combinations_form/bloc/combination_menu_section_cubit/combination_menu_section_cubit.dart';
import 'package:restaukitchen_app/page/order_combinations_form/components/menu_combination_section.dart';

class AddDishesPage extends StatefulWidget {
  final Combination? combination;
  final String? selectedDimensionId;
  final String? combinationId;
  const AddDishesPage({
    super.key,
    this.combination,
    this.selectedDimensionId,
    this.combinationId,
  });

  @override
  State<AddDishesPage> createState() => _AddDishesPageState();
}

class _AddDishesPageState extends State<AddDishesPage> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AddDishesCubit, AddDishesState>(
      builder: (context, state) {
        return Scaffold(
          appBar: DetailsAppBar(pageTitle: 'Add Dishes'),
          body: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ...?widget.combination?.menuList.asMap().entries.map(
                  (menu) => Padding(
                    padding: const EdgeInsets.only(bottom: 24),
                    child: BlocProvider(
                      create: (context) =>
                          CombinationMenuSectionCubit(menu: menu.value),
                      child: MenuCombinationSection(
                        selectedDimensionId:
                            widget.selectedDimensionId,
                        isActive:
                            state.activeMenuIds.contains(menu.value.id) ||
                            menu.key == 0,
                        menu: menu.value,
                        onDishSelected: (menuId) {
                          context.read<AddDishesCubit>().addActiveMenuId(
                            menuId,
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
      listener: (context, state) {},
    );
  }
}

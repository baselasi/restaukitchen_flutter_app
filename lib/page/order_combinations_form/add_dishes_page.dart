import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restaukitchen_app/core/components/appBar/details_app_bar.dart';
import 'package:restaukitchen_app/page/combination_page/models/combination.dart';
import 'package:restaukitchen_app/page/order_combinations_form/bloc/combination_menu_section_cubit/combination_menu_section_cubit.dart';
import 'package:restaukitchen_app/page/order_combinations_form/components/menu_combination_section.dart';

class AddDishesPage extends StatefulWidget {
  final Combination? combination;
  final String? selectedDimensionAssignmentId;
  final String? combinationId;
  const AddDishesPage({
    super.key,
    this.combination,
    this.selectedDimensionAssignmentId,
    this.combinationId,
  });

  @override
  State<AddDishesPage> createState() => _AddDishesPageState();
}

class _AddDishesPageState extends State<AddDishesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DetailsAppBar(pageTitle: 'Add Dishes'),
      body: Column(
        children: [
          ...widget.combination?.menuList
                  .map(
                    (menu) => BlocProvider(
                      create: (context) =>
                          CombinationMenuSectionCubit(menu: menu),
                      child: MenuCombinationSection(menu: menu),
                    ),
                  )
                  .toList() ??
              [],
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restaukitchen_app/page/menusPage/models/menu.dart';
import 'package:restaukitchen_app/page/order_combinations_form/bloc/combination_menu_section_cubit/combination_menu_section_cubit.dart';

class MenuCombinationSection extends StatefulWidget {
  final Menu menu;
  final Function(String menuId) onDishSelected;
  final bool isActive;
  const MenuCombinationSection({
    super.key,
    required this.menu,
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
          children: [
            Text(
              widget.menu.name,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            RadioGroup<int?>(
              groupValue: _selectedDishIndex,
              onChanged: (value) {
                if (!widget.isActive) return;
                setState(() {
                  _selectedDishIndex = value;
                  widget.onDishSelected(widget.menu.id);
                });
              },
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.sizeOf(context).height * 0.4,
                ),
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: dishes.length,
                  itemBuilder: (context, index) {
                    final dish = dishes[index];
                    return RadioListTile<int?>(
                      dense: true,
                      enabled: widget.isActive,
                      value: index,
                      contentPadding: EdgeInsets.zero,
                      title: Text(dish.name),
                      subtitle:
                          dish.description != null &&
                              dish.description!.isNotEmpty
                          ? Text(dish.description!)
                          : null,
                    );
                  },
                ),
              ),
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

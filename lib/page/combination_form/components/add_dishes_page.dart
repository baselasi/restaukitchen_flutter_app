import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restaukitchen_app/core/components/appBar/details_app_bar.dart';
import 'package:restaukitchen_app/core/components/form/primary_button.dart';
import 'package:restaukitchen_app/core/models/dish.dart';
import 'package:restaukitchen_app/l10n/l10n.dart';
import 'package:restaukitchen_app/page/combination_form/bloc/add_dishes_to_menu_cubit/add_dishes_to_menu_combination_cubit.dart';
import 'package:restaukitchen_app/page/menusPage/bloc/menus_page_bloc.dart';
import 'package:restaukitchen_app/page/menusPage/bloc/menus_page_events.dart';
import 'package:restaukitchen_app/page/menusPage/bloc/menus_page_state.dart';
import 'package:restaukitchen_app/page/menusPage/components/menu_dish_compact_card.dart';
import 'package:restaukitchen_app/page/menusPage/components/menus_scroll_bar.dart';

class AddDishesPageToCombinationsPage extends StatefulWidget {
  final String combinationId;
  final List<Dish> initialSelectedDishes;
  const AddDishesPageToCombinationsPage({
    super.key,
    required this.combinationId,
    this.initialSelectedDishes = const [],
  });

  @override
  State<AddDishesPageToCombinationsPage> createState() =>
      _AddDishesPageToCombinationsPageState();
}

class _AddDishesPageToCombinationsPageState
    extends State<AddDishesPageToCombinationsPage> {
  Set<Dish> _selectedDishes = {};

  // void _addDishToCombination(Dish dish) {
  //   context.read<CombinationMenuCreationFormCubit>().addDishToMenu(
  //     widget.combinationId,
  //     [dish],
  //   );
  //   ScaffoldMessenger.of(
  //     context,
  //   ).showSnackBar(SnackBar(content: Text('Added "${dish.name}"')));
  // }

  @override
  void initState() {
    _selectedDishes = widget.initialSelectedDishes.toSet();
    context.read<MenusPageBloc>().add(
      GetMenus(showSucess: false, menuIndex: 0),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Scaffold(
      bottomNavigationBar: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
          child: PrimaryButton(
            text: l10n.commonSaveOrder,
            onPressed: () {
              context.read<AddDishesToMenuCombinationCubit>().addDishesToMenu(
                widget.combinationId,
                _selectedDishes.toList(),
              );
            },
          ),
        ),
      ),
      appBar: DetailsAppBar(pageTitle: l10n.commonAddDishes),
      body: BlocBuilder<MenusPageBloc, MenusPageState>(
        builder: (context, getMenuState) {
          return RefreshIndicator(
            onRefresh: () async {
              final state = context.read<MenusPageBloc>().state;
              if (state is MenusPageLoaded) {
                context.read<MenusPageBloc>().add(
                  GetMenus(showSucess: false, menuIndex: state.selectedMenu),
                );
              } else {
                context.read<MenusPageBloc>().add(
                  GetMenus(showSucess: false, menuIndex: 0),
                );
              }
            },
            child:
                BlocConsumer<
                  AddDishesToMenuCombinationCubit,
                  AddDishesToMenuCombinationState
                >(
                  builder: (context, postDishesState) {
                    if (postDishesState.status ==
                        AddDishesToMenuCombinationStatus.loading) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    return CustomScrollView(
                      slivers: [
                        if (getMenuState is MenusPageLoaded) ...[
                          SliverAppBar(
                            automaticallyImplyLeading: false,
                            pinned: true,
                            floating: false,
                            elevation: 8,
                            backgroundColor: Colors.white,
                            flexibleSpace: MenusScrollBar(
                              menus: getMenuState.menus
                                  .map((menu) => menu.toMenuScrollBarItem())
                                  .toList(),
                              selectedMenuIndex: getMenuState.selectedMenu,
                              onMenuSelected: (index) {
                                context.read<MenusPageBloc>().add(
                                  ChangeMenu(
                                    menuIndex: index,
                                    menus: getMenuState.menus,
                                  ),
                                );
                              },
                            ),
                          ),
                          ..._buildDishesSlivers(getMenuState, _selectedDishes),
                        ],
                        if (getMenuState is MenusPageLoading)
                          SliverFillRemaining(
                            child: Center(child: CircularProgressIndicator()),
                          ),
                        // SliverAppBar (top bar)
                        if (getMenuState is MenusPageError)
                          SliverFillRemaining(
                            child: Center(child: Text(getMenuState.error)),
                          ),
                      ],
                    );
                  },
                  listener: (context, postDishesState) {
                    if (postDishesState.status ==
                        AddDishesToMenuCombinationStatus.success) {
                      Navigator.of(context).pop(postDishesState.dishes);
                    }
                  },
                ),
          );
        },
      ),
    );
  }

  List<Widget> _buildDishesSlivers(
    MenusPageLoaded state,
    Set<Dish> selectedDishes,
  ) {
    final l10n = context.l10n;
    final dishes = state.menus[state.selectedMenu].dishes;
    if (dishes.isEmpty) {
      return [
        SliverFillRemaining(
          hasScrollBody: false,
          child: Center(
            child: Text(
              l10n.combinationsNoDishesInMenu,
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ),
          ),
        ),
      ];
    }

    return [
      SliverList(
        delegate: SliverChildBuilderDelegate((context, index) {
          final dish = dishes[index];
          return MenuDishCompactCard(
            title: dish.name,
            subtitle: dish.description,
            isSelected: selectedDishes.contains(dish),
            onTap: () {
              setState(() {
                if (_selectedDishes.contains(dish)) {
                  _selectedDishes.remove(dish);
                } else {
                  _selectedDishes.add(dish);
                }
              });
            },
          );
        }, childCount: dishes.length),
      ),
    ];
  }
}

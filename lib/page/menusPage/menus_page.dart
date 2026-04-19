import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:page_transition/page_transition.dart';
import 'package:restaukitchen_app/core/bloc/add_ingredents_to_menu_cubit.dart';
import 'package:restaukitchen_app/core/bloc/get_ingredients_cubit.dart';
import 'package:restaukitchen_app/core/components/form/categorySelector/category_selector_cubit.dart';
import 'package:restaukitchen_app/core/components/form/descriptionInput/description_cubit.dart';
import 'package:restaukitchen_app/core/components/form/dimensionInput/dimension_cubit.dart';
import 'package:restaukitchen_app/core/repository/ingredients_repo.dart';
import 'package:restaukitchen_app/page/combination_form/components/add_ingredients_page.dart';
import 'package:restaukitchen_app/page/dishForm/bloc/dish_form_cubit.dart';
import 'package:restaukitchen_app/page/dishForm/dish_form.dart';
import 'package:restaukitchen_app/page/menusPage/bloc/delete_dish_cubit.dart';
import 'package:restaukitchen_app/page/menusPage/bloc/dish_image_cubit.dart';
import 'package:restaukitchen_app/page/menusPage/bloc/menus_page_bloc.dart';
import 'package:restaukitchen_app/page/menusPage/bloc/menus_page_events.dart';
import 'package:restaukitchen_app/page/menusPage/bloc/menus_page_state.dart';
import 'package:restaukitchen_app/page/menusPage/components/dish_card.dart';
import 'package:restaukitchen_app/page/menusPage/components/menus_scroll_bar.dart';

class MenusPage extends StatefulWidget {
  const MenusPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _MenusPageState();
  }
}

class _MenusPageState extends State<MenusPage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _fabController;
  bool _fabExpanded = false;

  @override
  void initState() {
    super.initState();
    context.read<MenusPageBloc>().add(
      GetMenus(showSucess: false, menuIndex: 0),
    );
    _fabController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );
  }

  Future<void> _onRefresh() async {
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
  }

  Widget _buildDishesList(MenusPageLoaded state) {
    final selectedMenu = state.menus[state.selectedMenu];
    final dishes = selectedMenu.dishes;

    if (dishes.isEmpty) {
      return SliverFillRemaining(
        hasScrollBody: false,
        child: const Center(
          child: Text(
            'No dishes available',
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
        ),
      );
    }

    return SliverList(
      delegate: SliverChildBuilderDelegate((context, index) {
        final dish = dishes[index];
        return MultiBlocProvider(
          providers: [
            BlocProvider<DeleteDishCubit>(
              create: (context) => DeleteDishCubit(),
            ),
            BlocProvider<DishImageCubit>(create: (context) => DishImageCubit()),
          ],
          child: DishCard(
            menuId: selectedMenu.id,
            dish: dish,
            onEdit: () {},
            onDelete: () async {
              context.read<MenusPageBloc>().add(
                GetMenus(showSucess: true, menuIndex: state.selectedMenu),
              );
            },
            onEditPhoto: () {},
          ),
        );
      }, childCount: dishes.length),
    );
  }

  void _toggleFab() {
    setState(() {
      _fabExpanded = !_fabExpanded;
      _fabExpanded ? _fabController.forward() : _fabController.reverse();
    });
  }

  @override
  Widget build(BuildContext context) {
    final menuState = context.read<MenusPageBloc>().state;

    final selectedMenuIndex = menuState is MenusPageLoaded
        ? menuState.selectedMenu
        : 0;
    return Scaffold(
      floatingActionButton: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: [
          ScaleTransition(
            scale: _fabController,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: FloatingActionButton.extended(
                heroTag: 'fab_action_1',
                onPressed: () async {
                  _toggleFab();
                  final menuId = menuState is MenusPageLoaded
                      ? menuState.menus[selectedMenuIndex].id
                      : null;
                  final result = await Navigator.of(context).push(
                    PageTransition(
                      type: PageTransitionType.rightToLeft,
                      child: MultiBlocProvider(
                        providers: [
                          BlocProvider<DimensionCubit>(
                            create: (context) => DimensionCubit(),
                          ),
                          BlocProvider(
                            create: (context) => CategorySelectorCubit(),
                          ),
                          BlocProvider(create: (context) => DescriptionCubit()),
                          BlocProvider(create: (context) => DishFormCubit()),
                        ],
                        child: DishForm(menuId: menuId, dish: null),
                      ),
                    ),
                  );
                  if (result == true && context.mounted) {
                    context.read<MenusPageBloc>().add(
                      GetMenus(showSucess: true, menuIndex: selectedMenuIndex),
                    );
                  }
                },
                label: Text('Add Dish'),
                icon: Icon(Icons.add),
              ),
            ),
          ),
          ScaleTransition(
            scale: _fabController,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: FloatingActionButton.extended(
                heroTag: 'fab_action_2',
                onPressed: () async {
                  _toggleFab();
                  final selectedMenu = menuState is MenusPageLoaded
                      ? menuState.menus[selectedMenuIndex]
                      : null;

                  if (selectedMenu != null) {
                    final result = await Navigator.of(context).push(
                      PageTransition(
                        type: PageTransitionType.rightToLeft,
                        child: MultiBlocProvider(
                          providers: [
                            BlocProvider<GetIngredientsCubit>(
                              create: (context) => GetIngredientsCubit(),
                            ),
                            BlocProvider<AddIngredientsToMenuCubit>(
                              create: (context) => AddIngredientsToMenuCubit(
                                ingredientsRepo: IngredientsRepo(),
                              ),
                            ),
                          ],
                          child: AddIngredientsPage(
                            menuId: selectedMenu.id,
                            initialSelected: selectedMenu.ingredients,
                            combinationDimensionIds: [],
                          ),
                        ),
                      ),
                    );
                    if (result != null && context.mounted) {
                      context.read<MenusPageBloc>().add(
                        GetMenus(
                          showSucess: true,
                          menuIndex: selectedMenuIndex,
                        ),
                      );
                    }
                  }
                },
                label: Text('Add ingredients'),
                icon: Icon(Icons.add),
              ),
            ),
          ),
          FloatingActionButton(
            heroTag: 'fab_main',
            onPressed: () async {
              _toggleFab();
            },
            child: AnimatedIcon(
              icon: AnimatedIcons.menu_close,
              progress: _fabController,
            ),
          ),
        ],
      ),
      body: BlocBuilder<MenusPageBloc, MenusPageState>(
        builder: (context, state) {
          return RefreshIndicator(
            onRefresh: _onRefresh,
            child: CustomScrollView(
              slivers: [
                if (state is MenusPageLoaded) ...[
                  SliverAppBar(
                    pinned: true,
                    floating: false,
                    elevation: 8,
                    backgroundColor: Colors.white,
                    flexibleSpace: MenusScrollBar(
                      menus: state.menus
                          .map((menu) => menu.toMenuScrollBarItem())
                          .toList(),
                      selectedMenuIndex: state.selectedMenu,
                      onMenuSelected: (index) {
                        context.read<MenusPageBloc>().add(
                          ChangeMenu(menuIndex: index, menus: state.menus),
                        );
                      },
                    ),
                  ),
                  // SliverList (dishes content)
                  _buildDishesList(state),
                ],
                if (state is MenusPageLoading)
                  SliverFillRemaining(
                    child: Center(child: CircularProgressIndicator()),
                  ),
                // SliverAppBar (top bar)
                if (state is MenusPageError)
                  SliverFillRemaining(child: Center(child: Text(state.error))),
              ],
            ),
          );
        },
      ),
    );
  }
}

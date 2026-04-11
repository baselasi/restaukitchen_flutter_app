import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restaukitchen_app/core/components/appBar/details_app_bar.dart';
import 'package:restaukitchen_app/page/new_order/bloc/new_order_form_bloc/new_order_form_bloc.dart';
import 'package:restaukitchen_app/page/new_order/bloc/new_order_form_bloc/new_order_form_state.dart';
import 'package:restaukitchen_app/page/menusPage/components/menus_scroll_bar.dart';
import 'package:restaukitchen_app/page/new_order/components/combinations_small_card.dart';
import 'package:restaukitchen_app/page/new_order/components/dish_small_card.dart';
import 'package:restaukitchen_app/page/new_order/bloc/menu_scroll_bar_cubit/menu_scroll_bar_cubit.dart';

class AddDishesPage extends StatefulWidget {
  final String? orderId;
  const AddDishesPage({super.key, this.orderId});

  @override
  State<AddDishesPage> createState() => _AddDishesPageState();
}

class _AddDishesPageState extends State<AddDishesPage> {
  @override
  void initState() {
    final menuState = context.read<MenuScrollBarCubit>().state;
    if (menuState.status != MenuScrollBarStatus.success) {
      context.read<MenuScrollBarCubit>().getMenus();
    }
    super.initState();
  }

  Widget _buildDishesList(MenuScrollBarState state) {
    final selectedMenu = state.selectedMenu!;
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

    return SliverPadding(
      padding: const EdgeInsets.all(16),
      sliver: SliverGrid(
        delegate: SliverChildBuilderDelegate((context, index) {
          final dish = dishes[index];
          return DishSmallCard(
            dish: dish,
            ingredients: selectedMenu.ingredients,
          );
        }, childCount: dishes.length),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 1,
          crossAxisSpacing: 1,
          mainAxisSpacing: 1,
          childAspectRatio: 5,
        ),
      ),
    );
  }

  Widget _buildCombinationsList(MenuScrollBarState state) {
    final combinations = state.combinations!;
    if (combinations.isEmpty) {
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

    return SliverPadding(
      padding: const EdgeInsets.all(16),
      sliver: SliverGrid(
        delegate: SliverChildBuilderDelegate((context, index) {
          final combination = combinations[index];
          return  Column(
            children: [
              CombinationsSmallCard(combination: combination),
              const SizedBox(height: 10),
            ],
          );
        }, childCount: combinations.length),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 1,
          crossAxisSpacing: 1,
          mainAxisSpacing: 1,
          childAspectRatio: 5,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NewOrderFormBloc, NewOrderFormState>(
      builder: (context, formState) {
        final hasItems = formState.hasAnyIndicesInCourses();
        return Scaffold(
          appBar: DetailsAppBar(pageTitle: "New Order"),
          body: BlocConsumer<MenuScrollBarCubit, MenuScrollBarState>(
            builder: (context, state) {
              return CustomScrollView(
                slivers: [
                  if (state.status == MenuScrollBarStatus.success) ...[
                    SliverAppBar(
                      pinned: true,
                      floating: false,
                      automaticallyImplyLeading: false,
                      elevation: 10,
                      backgroundColor: Colors.white,
                      flexibleSpace: MenusScrollBar(
                        menus: state.menuScrollBarItem,
                        selectedMenuIndex: state.selectedMenuIndex,
                        onMenuSelected: (index) {
                          if (!state.menuScrollBarItem[index].isCombination) {
                            context.read<MenuScrollBarCubit>().selectMenu(
                              index,
                            );
                          } else {
                            context
                                .read<MenuScrollBarCubit>()
                                .selectCombination(index);
                          }
                        },
                      ),
                    ),
                    SliverToBoxAdapter(child: SizedBox(height: 10)),
                    if (state.selectedMenu != null) _buildDishesList(state),
                    if (state.selectedMenu == null)
                      _buildCombinationsList(state),
                    if (hasItems)
                      const SliverToBoxAdapter(child: SizedBox(height: 80)),
                  ],
                  if (state.status == MenuScrollBarStatus.loading)
                    SliverFillRemaining(
                      child: Center(child: CircularProgressIndicator()),
                    ),
                  if (state.status == MenuScrollBarStatus.error)
                    SliverFillRemaining(
                      child: Center(child: Text(state.errorMessage!)),
                    ),
                ],
              );
            },
            listener: (context, state) {},
          ),
        );
      },
    );
  }
}

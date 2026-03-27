import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:page_transition/page_transition.dart';
import 'package:restaukitchen_app/core/components/appBar/details_app_bar.dart';
import 'package:restaukitchen_app/page/new_order/bloc/new_order_form_bloc/new_order_form_bloc.dart';
import 'package:restaukitchen_app/page/new_order/bloc/new_order_form_bloc/new_order_form_state.dart';
import 'package:restaukitchen_app/page/menusPage/components/menus_scroll_bar.dart';
import 'package:restaukitchen_app/page/new_order/components/combinations_small_card.dart';
import 'package:restaukitchen_app/page/new_order/components/dish_small_card.dart';
import 'package:restaukitchen_app/page/new_order/bloc/menu_scroll_bar_cubit/menu_scroll_bar_cubit.dart';
import 'package:restaukitchen_app/page/preview_order/preview_order_page.dart';

class NewOrder extends StatefulWidget {
  const NewOrder({super.key});

  @override
  State<NewOrder> createState() => _NewOrderState();
}

class _NewOrderState extends State<NewOrder> {
  @override
  void initState() {
    // context.read<MenusPageBloc>().add(
    //   GetMenus(showSucess: false, menuIndex: 0),
    // );
    context.read<MenuScrollBarCubit>().getMenus();
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
          crossAxisCount: 2,
          crossAxisSpacing: 30,
          mainAxisSpacing: 30,
          childAspectRatio: 2,
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
          return CombinationsSmallCard(combination: combination);
        }, childCount: combinations.length),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 30,
          mainAxisSpacing: 30,
          childAspectRatio: 2,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NewOrderFormBloc, NewOrderFormState>(
      builder: (context, formState) {
        final hasItems = formState.hasAnyIndicesInCourses();
        final dishesCount = formState.getTotalIndicesInCourses();

        return Scaffold(
          appBar: DetailsAppBar(pageTitle: "New Order"),
          floatingActionButton: hasItems
              ? FloatingActionButton.extended(
                  heroTag: 'new_order_preview_fab',
                  onPressed: () {
                    Navigator.of(context).push(
                      PageTransition(
                        type: PageTransitionType.rightToLeft,
                        child: BlocProvider.value(
                          value: context.read<NewOrderFormBloc>(),
                          child: const PreviewOrderPage(),
                        ),
                      ),
                    );
                  },
                  icon: const Icon(Icons.receipt_long_outlined),
                  label: const Text('Preview order'),
                )
              : null,
          floatingActionButtonLocation: hasItems
              ? FloatingActionButtonLocation.centerFloat
              : null,

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

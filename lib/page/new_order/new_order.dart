import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restaukitchen_app/core/components/appBar/details_app_bar.dart';
import 'package:restaukitchen_app/core/components/form/primary_button.dart';
import 'package:restaukitchen_app/page/menusPage/bloc/menus_page_bloc.dart';
import 'package:restaukitchen_app/page/menusPage/bloc/menus_page_events.dart';
import 'package:restaukitchen_app/page/menusPage/bloc/menus_page_state.dart';
import 'package:restaukitchen_app/page/new_order/bloc/new_order_form_bloc/new_order_form_bloc.dart';
import 'package:restaukitchen_app/page/new_order/bloc/new_order_form_bloc/new_order_form_state.dart';
import 'package:restaukitchen_app/page/menusPage/components/menus_scroll_bar.dart';
import 'package:restaukitchen_app/page/new_order/components/dish_small_card.dart';

class NewOrder extends StatefulWidget {
  const NewOrder({super.key});

  @override
  State<NewOrder> createState() => _NewOrderState();
}

class _NewOrderState extends State<NewOrder> {
  @override
  void initState() {
    context.read<MenusPageBloc>().add(
      GetMenus(showSucess: false, menuIndex: 0),
    );
    super.initState();
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

    return SliverPadding(
      padding: const EdgeInsets.all(16),
      sliver: SliverGrid(
        delegate: SliverChildBuilderDelegate((context, index) {
          final dish = dishes[index];
          return DishSmallCard(dish: dish);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DetailsAppBar(pageTitle: "New Order"),
      bottomNavigationBar: SafeArea(
        minimum: const EdgeInsets.fromLTRB(16, 8, 16, 12),
        child: BlocBuilder<NewOrderFormBloc, NewOrderFormState>(
          builder: (context, state) {
            final hasDishes = state.hasAnyIndicesInCourses();
            final dishesCount = state.getTotalIndicesInCourses();

            return PrimaryButton(
              text: hasDishes
                  ? 'Submit Order ($dishesCount)'
                  : 'Submit Order',
              isDisabled: !hasDishes,
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Order submitted')),
                );
                Navigator.of(context).pop(state);
              },
            );
          },
        ),
      ),
      body: BlocConsumer<MenusPageBloc, MenusPageState>(
        builder: (context, state) {
          return CustomScrollView(
            slivers: [
              if (state is MenusPageLoaded) ...[
                SliverAppBar(
                  pinned: true,
                  floating: false,
                  automaticallyImplyLeading: false,
                  elevation: 10,

                  backgroundColor: Colors.white,
                  flexibleSpace: MenusScrollBar(
                    menus: state.menus,
                    selectedMenuIndex: state.selectedMenu,
                    onMenuSelected: (index) {
                      context.read<MenusPageBloc>().add(
                        ChangeMenu(menuIndex: index, menus: state.menus),
                      );
                    },
                  ),
                ),
                SliverToBoxAdapter(
                  child: SizedBox(height: 10),
                ),
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
          );
        },
        listener: (context, state) {},
      ),
    );
  }
}

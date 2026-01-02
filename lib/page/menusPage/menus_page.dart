import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restaukitchen_app/core/dialogs/conferm_dialogs.dart';
import 'package:restaukitchen_app/page/menusPage/bloc/delete_dish_cubit.dart';
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

class _MenusPageState extends State<MenusPage> {
  @override
  void initState() {
    context.read<MenusPageBloc>().add(
      GetMenus(showSucess: false, menuIndex: 0),
    );
    super.initState();
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
        return BlocProvider<DeleteDishCubit>(
          create: (context) => DeleteDishCubit(),
          child: DishCard(
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<MenusPageBloc, MenusPageState>(
        builder: (context, state) {
          if (state is MenusPageLoaded) {
            return RefreshIndicator(
              onRefresh: _onRefresh,
              child: CustomScrollView(
                slivers: [
                  // SliverAppBar (top bar)
                  SliverAppBar(
                    pinned: true,
                    floating: false,
                    elevation: 8,
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
                  // SliverList (dishes content)
                  _buildDishesList(state),
                ],
              ),
            );
          } else if (state is MenusPageLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is MenusPageError) {
            return Center(child: Text('Error: ${state.error}'));
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}

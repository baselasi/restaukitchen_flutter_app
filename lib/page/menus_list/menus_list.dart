import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restaukitchen_app/core/components/appBar/details_app_bar.dart';
import 'package:restaukitchen_app/page/menusPage/bloc/delete_menu_cubit.dart';
import 'package:restaukitchen_app/page/menusPage/repository/menus_page_repo.dart';
import 'package:restaukitchen_app/page/menus_list/components/add_menu_sheet.dart';
import 'package:restaukitchen_app/page/menusPage/bloc/menus_page_bloc.dart';
import 'package:restaukitchen_app/page/menusPage/bloc/menus_page_events.dart';
import 'package:restaukitchen_app/page/menusPage/bloc/menus_page_state.dart';
import 'package:restaukitchen_app/page/menusPage/models/menu.dart';
import 'package:restaukitchen_app/theme/light_theme.dart';

class MenusList extends StatefulWidget {
  const MenusList({super.key});

  @override
  State<MenusList> createState() => _MenusListState();
}

class _MenusListState extends State<MenusList> {
  @override
  void initState() {
    super.initState();
    context.read<MenusPageBloc>().add(
      GetMenus(showSucess: false, menuIndex: 0),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DetailsAppBar(pageTitle: 'Menus List'),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await showAddMenuSheet(context);
          if (result == true && mounted && context.mounted) {
            context.read<MenusPageBloc>().add(
              GetMenus(showSucess: true, menuIndex: 0),
            );
          }
        },
        child: const Icon(Icons.add),
      ),
      body: BlocConsumer<MenusPageBloc, MenusPageState>(
        builder: (context, state) {
          if (state is MenusPageLoaded) {
            return Center(
              child: ListView.separated(
                shrinkWrap: true,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: state.menus.length,
                separatorBuilder: (_, _) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final menu = state.menus[index];
                  return BlocProvider(
                    create: (context) =>
                        DeleteMenuCubit(menusPageRepo: MenusPageRepo()),
                    child: _MenuCard(menu: menu),
                  );
                },
              ),
            );
          }
          if (state is MenusPageLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is MenusPageError) {
            return Center(child: Text(state.error));
          }
          return const SizedBox.shrink();
        },
        listener: (context, state) {},
      ),
    );
  }
}

class _MenuCard extends StatelessWidget {
  const _MenuCard({required this.menu});

  final Menu menu;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
      elevation: 2,

      shadowColor: Colors.black.withValues(alpha: 0.8),
      child: InkWell(
        onTap: () {},
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: LightTheme.primaryColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                alignment: Alignment.center,
                child: const Icon(
                  Icons.restaurant_menu,
                  color: Colors.white,
                  size: 22,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      menu.name,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF111827),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${menu.dishes.length} items${menu.combination ? ' • Combination menu' : ''}',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xFF6B7280),
                      ),
                    ),
                    const SizedBox(height: 2),
                    const Text(
                      'Updated recently',
                      style: TextStyle(fontSize: 14, color: Color(0xFF6B7280)),
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: () async {
                  final result = await showAddMenuSheet(
                    context,
                    id: menu.id,
                    name: menu.name,
                  );
                  if (result == true && context.mounted) {
                    context.read<MenusPageBloc>().add(
                      GetMenus(showSucess: true, menuIndex: 0),
                    );
                  }
                },
                icon: const Icon(Icons.edit_outlined),
                color: const Color(0xFF1D4ED8),
                tooltip: 'Edit menu',
              ),
              BlocConsumer<DeleteMenuCubit, DeleteMenuState>(
                builder: (context, state) {
                  if (state.status == DeleteMenuStatus.isLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  return IconButton(
                    onPressed: () {
                      context.read<DeleteMenuCubit>().deleteMenu(menu.id);
                    },
                    icon: const Icon(Icons.delete_outline),
                    color: const Color(0xFFDC2626),
                    tooltip: 'Delete menu',
                  );
                },
                listener: (context, state) {
                  if (state.status == DeleteMenuStatus.isSucess) {
                    context.read<MenusPageBloc>().add(
                      GetMenus(showSucess: true, menuIndex: 0),
                    );
                  }
                  if (state.status == DeleteMenuStatus.isError) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Failed to delete menu')),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

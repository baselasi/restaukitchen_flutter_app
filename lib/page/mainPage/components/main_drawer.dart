import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restaukitchen_app/core/bloc/auth_cubit.dart';
import 'package:restaukitchen_app/core/routes.dart';
import 'package:restaukitchen_app/page/mainPage/bloc/main_page_cubit.dart';
import 'package:restaukitchen_app/theme/light_theme.dart';

class MainDrawer extends StatelessWidget {
  const MainDrawer({super.key});

  // Get icon for each page
  IconData _getPageIcon(Pages page) {
    switch (page) {
      case Pages.home:
        return Icons.home;
      case Pages.menus:
        return Icons.menu;
      case Pages.orders:
        return Icons.card_giftcard;
      case Pages.tables:
        return Icons.table_restaurant;
    }
  }

  // Get label for each page
  String _getPageLabel(Pages page) {
    switch (page) {
      case Pages.home:
        return 'Home';
      case Pages.menus:
        return 'Menus';
      case Pages.orders:
        return 'Orders';
      case Pages.tables:
        return 'Tables';
    }
  }

  @override
  Widget build(BuildContext context) {
    final mainPageCubit = context.read<MainPageCubit>();
    final authCubit = context.read<AuthCubit>();

    return BlocBuilder<MainPageCubit, MainPageState>(
      builder: (context, state) {
        final currentPage = state.page;

        return Drawer(
          child: Container(
            color: LightTheme.primaryColor,
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(16),
                      bottomRight: Radius.circular(16),
                    ),
                  ),
                  child: Image.asset(
                    'assets/images/logo.png',
                    height: 150,
                    fit: BoxFit.contain,
                  ),
                ),
                const SizedBox(height: 8),
                // Menu Items
                Expanded(
                  child: ListView.builder(
                    padding: EdgeInsets.all(16),
                    itemCount: Pages.values.length,
                    itemBuilder: (context, index) {
                      final page = Pages.values[index];
                      final isSelected = page == currentPage;

                      return Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: isSelected
                              ? LightTheme.secondaryColor
                              : Colors.transparent,
                        ),
                        child: InkWell(
                          onTap: () {
                            mainPageCubit.setPage(page);
                            Navigator.pop(context);
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  _getPageIcon(page),
                                  color: isSelected
                                      ? LightTheme.primaryColor
                                      : LightTheme.secondaryColor,
                                  size: 30,
                                ),
                                const SizedBox(width: 16),
                                Text(
                                  _getPageLabel(page),
                                  style: TextStyle(
                                    color: isSelected
                                        ? LightTheme.primaryColor
                                        : LightTheme.secondaryColor,
                                    fontSize: 24,
                                    fontWeight: isSelected
                                        ? FontWeight.w600
                                        : FontWeight.normal,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                // Logout Button
                Container(
                  padding: const EdgeInsets.all(16),
                  child: InkWell(
                    onTap: () {
                      authCubit.logout();
                      Navigator.pop(context);
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.exit_to_app,
                            color: LightTheme.secondaryColor,
                            size: 24,
                          ),
                          const SizedBox(width: 16),
                          const Text(
                            'Esci',
                            style: TextStyle(
                              color: LightTheme.secondaryColor,
                              fontSize: 24,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

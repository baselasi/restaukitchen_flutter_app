import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restaukitchen_app/core/routes.dart';
import 'package:restaukitchen_app/l10n/l10n.dart';
import 'package:restaukitchen_app/page/mainPage/bloc/main_page_cubit.dart';
import 'package:restaukitchen_app/theme/light_theme.dart';

class MainDrawer extends StatelessWidget {
  const MainDrawer({super.key});

  static const Color _textMuted = Color(0xFF888888);
  static const Color _borderLight = Color(0xFFE0E0E0);
  static const Color _pillBg = Color(0xFFEEEEEE);

  IconData _getPageIcon(Pages page) {
    switch (page) {
      case Pages.home:
        return Icons.home_outlined;
      case Pages.menus:
        return Icons.restaurant_menu;
      case Pages.orders:
        return Icons.receipt_long_outlined;
      case Pages.tables:
        return Icons.table_restaurant_outlined;
      case Pages.combinations:
        return Icons.layers_outlined;
      case Pages.settings:
        return Icons.settings_outlined;
    }
  }

  String _getPageLabel(BuildContext context, Pages page) {
    switch (page) {
      case Pages.home:
        return context.l10n.commonHome;
      case Pages.menus:
        return context.l10n.commonMenus;
      case Pages.orders:
        return context.l10n.commonOrders;
      case Pages.tables:
        return context.l10n.commonTables;
      case Pages.combinations:
        return context.l10n.commonCombinations;
      case Pages.settings:
        return context.l10n.commonSettings;
    }
  }

  @override
  Widget build(BuildContext context) {
    final mainPageCubit = context.read<MainPageCubit>();

    return BlocBuilder<MainPageCubit, MainPageState>(
      builder: (context, state) {
        final currentPage = state.page;

        return Drawer(
          backgroundColor: Colors.white,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(16),
              bottomRight: Radius.circular(16),
            ),
            side: BorderSide(color: _borderLight, width: 1),
          ),
          child: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(30, 1, 30, 1),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(16),
                        bottomRight: Radius.circular(16),
                      ),
                    ),
                    child: Image.asset(
                      'assets/images/logo.png',
                      height: 90,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Expanded(
                  child: ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    itemCount: Pages.values.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 4),
                    itemBuilder: (context, index) {
                      final page = Pages.values[index];
                      final isSelected = page == currentPage;
                      if(page == Pages.settings){
                        return Container();
                      }
                      return Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () {
                            mainPageCubit.setPage(page);
                            Navigator.pop(context);
                          },
                          borderRadius: BorderRadius.circular(24),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 2),
                            child: IntrinsicHeight(
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Container(
                                    width: 4,
                                    decoration: BoxDecoration(
                                      color: isSelected
                                          ? LightTheme.primaryColor
                                          : Colors.transparent,
                                      borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(2),
                                        bottomLeft: Radius.circular(2),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Container(
                                      alignment: Alignment.centerLeft,
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 14,
                                        vertical: 12,
                                      ),
                                      decoration: BoxDecoration(
                                        color: isSelected ? _pillBg : null,
                                        borderRadius: const BorderRadius.only(
                                          topRight: Radius.circular(24),
                                          bottomRight: Radius.circular(24),
                                        ),
                                      ),
                                      child: Row(
                                        children: [
                                          Icon(
                                            _getPageIcon(page),
                                            color: isSelected
                                                ? LightTheme.primaryColor
                                                : _textMuted,
                                            size: 26,
                                          ),
                                          const SizedBox(width: 12),
                                          Text(
                                            _getPageLabel(context, page),
                                            style: TextStyle(
                                              color: isSelected
                                                  ? LightTheme.primaryColor
                                                  : _textMuted,
                                              fontSize: 18,
                                              fontWeight: isSelected
                                                  ? FontWeight.w600
                                                  : FontWeight.w500,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                // Padding(
                //   padding: const EdgeInsets.fromLTRB(20, 4, 20, 16),
                //   child: InkWell(
                //     onTap: () {
                //       authCubit.logout();
                //       Navigator.pop(context);
                //     },
                //     borderRadius: BorderRadius.circular(8),
                //     child: Padding(
                //       padding: const EdgeInsets.symmetric(vertical: 10),
                //       child: Row(
                //         children: [
                //           Icon(Icons.logout, color: _textMuted, size: 22),
                //           const SizedBox(width: 12),
                //           Text(
                //             'Esci',
                //             style: TextStyle(
                //               color: _textMuted,
                //               fontSize: 16,
                //               fontWeight: FontWeight.w500,
                //             ),
                //           ),
                //         ],
                //       ),
                //     ),
                //   ),
                // ),
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () {
                      mainPageCubit.setPage(Pages.settings);
                      Navigator.pop(context);
                    },
                    borderRadius: BorderRadius.circular(24),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 2),
                      child: IntrinsicHeight(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Container(
                              width: 4,
                              decoration: BoxDecoration(
                                color: currentPage == Pages.settings
                                    ? LightTheme.primaryColor
                                    : Colors.transparent,
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(2),
                                  bottomLeft: Radius.circular(2),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                alignment: Alignment.centerLeft,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 14,
                                  vertical: 12,
                                ),
                                decoration: BoxDecoration(
                                  color: currentPage == Pages.settings
                                      ? _pillBg
                                      : null,
                                  borderRadius: const BorderRadius.only(
                                    topRight: Radius.circular(24),
                                    bottomRight: Radius.circular(24),
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      _getPageIcon(Pages.settings),
                                      color: currentPage == Pages.settings
                                          ? LightTheme.primaryColor
                                          : _textMuted,
                                      size: 26,
                                    ),
                                    const SizedBox(width: 12),
                                    Text(
                                      _getPageLabel(context, Pages.settings),
                                      style: TextStyle(
                                        color: currentPage == Pages.settings
                                            ? LightTheme.primaryColor
                                            : _textMuted,
                                        fontSize: 18,
                                        fontWeight:
                                            currentPage == Pages.settings
                                            ? FontWeight.w600
                                            : FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                // Padding(
                //   padding: const EdgeInsets.fromLTRB(20, 4, 20, 16),
                //   child: InkWell(
                //     onTap: () {
                //       mainPageCubit.setPage(Pages.settings);
                //       Navigator.pop(context);
                //     },
                //     borderRadius: BorderRadius.circular(8),
                //     child: Padding(
                //       padding: const EdgeInsets.symmetric(vertical: 10),
                //       child: Row(
                //         children: [
                //           Icon(
                //             Icons.settings_outlined,
                //             color: _textMuted,
                //             size: 22,
                //           ),
                //           const SizedBox(width: 12),
                //           Text(
                //             'Settings',
                //             style: TextStyle(
                //               color: _textMuted,
                //               fontSize: 16,
                //               fontWeight: FontWeight.w500,
                //             ),
                //           ),
                //         ],
                //       ),
                //     ),
                //   ),
                // ),
              ],
            ),
          ),
        );
      },
    );
  }
}

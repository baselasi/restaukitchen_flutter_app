import 'package:flutter/material.dart';
import 'package:restaukitchen_app/page/menusPage/models/menu_scroll_bar_item.dart';
import 'package:restaukitchen_app/theme/light_theme.dart';

class MenusScrollBar extends StatelessWidget {
  final List<MenuScrollBarItem> menus;
  final int selectedMenuIndex;
  final Function(int) onMenuSelected;

  const MenusScrollBar({
    super.key,
    required this.menus,
    required this.selectedMenuIndex,
    required this.onMenuSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: menus.length,
        itemBuilder: (context, index) {
          final menu = menus[index];
          final isSelected = index == selectedMenuIndex;

          return Padding(
            padding: const EdgeInsets.only(right: 16),
            child: InkWell(
              onTap: () {
                onMenuSelected(index);
              },
              borderRadius: BorderRadius.circular(8),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                ),
                decoration: BoxDecoration(
                  color: isSelected ? LightTheme.secondaryColor : Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey[300]!, width: 1),
                ),
                child: Center(
                  child: Text(
                    menu.name,
                    style: TextStyle(
                      color: LightTheme.primaryColor,
                      fontSize: 16,
                      fontWeight: isSelected
                          ? FontWeight.w600
                          : FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

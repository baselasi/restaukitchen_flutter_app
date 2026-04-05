import 'package:flutter/material.dart';

class DetailsAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String pageTitle;
  const DetailsAppBar({super.key, required this.pageTitle});

  @override
  Size get preferredSize => const Size.fromHeight(50);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      centerTitle: false,
      title: Text(pageTitle),
      iconTheme: IconThemeData(color: Colors.white, size: 24),
    );
  }
}

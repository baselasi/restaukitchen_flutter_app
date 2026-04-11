import 'package:flutter/material.dart';
import 'package:restaukitchen_app/theme/light_theme.dart';

class DetailsAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String pageTitle;
  const DetailsAppBar({super.key, required this.pageTitle});

  @override
  Size get preferredSize => const Size.fromHeight(65);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(color: LightTheme.primaryColor, width: 1),
        ),
        boxShadow: [
          BoxShadow(
            color: LightTheme.primaryColor.withValues(alpha: 0.2),
            blurRadius: 4,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        leading: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: 8),
            IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: const Icon(
              Icons.arrow_back,
              size: 30,
              fontWeight: FontWeight.w600,
            ),
          ),
          ],
        ),
        title: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: 8),
            Text(
              pageTitle,
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                color: Colors.black,
                fontSize: 18,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:restaukitchen_app/core/routes.dart';
import 'package:restaukitchen_app/theme/light_theme.dart';

class MainAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Pages page;
  const MainAppBar({super.key, required this.page});

  @override
  Size get preferredSize => const Size.fromHeight(65);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final pageTitle = getPageTitle(page);

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
        foregroundColor: Colors.black,
        elevation: 0,
        centerTitle: true,
        title: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Logo
            Image.asset(
              'assets/images/logo.png',
              height: 30,
              fit: BoxFit.contain,
            ),
            DefaultTextStyle(
              style:
                  theme.textTheme.titleSmall?.copyWith(
                    color: Colors.black,
                    fontSize: 14,
                  ) ??
                  const TextStyle(color: Colors.black, fontSize: 14),
              child: pageTitle,
            ),
          ],
        ),
      ),
    );
  }
}

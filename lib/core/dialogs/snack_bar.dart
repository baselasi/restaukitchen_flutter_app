import 'package:flutter/material.dart';

class AppSnackBar {
  const AppSnackBar._();

  static SnackBar success(BuildContext context,   String message) {
    return _build(
      message: message,
      backgroundColor:Theme.of(context).colorScheme.primary,
      icon: Icons.check_circle_outline,
    );
  }

  static SnackBar error(BuildContext context, String message) {
    return _build(
      message: message,
      backgroundColor:Theme.of(context).colorScheme.error,
      icon: Icons.error_outline,
    );
  }

  static void showSuccess(BuildContext context, String message) {
    _show(context, success(context, message));
  }

  static void showError(BuildContext context, String message) {
    _show(context, error(context, message));
  }

  static void _show(BuildContext context, SnackBar snackBar) {
    final messenger = ScaffoldMessenger.of(context);
    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(snackBar);
  }

  static SnackBar _build({
    required String message,
    required Color backgroundColor,
    required IconData icon,
  }) {
    return SnackBar(
      behavior: SnackBarBehavior.floating,
      backgroundColor: backgroundColor,
      content: Row(
        children: [
          Icon(icon, color: Colors.white),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}




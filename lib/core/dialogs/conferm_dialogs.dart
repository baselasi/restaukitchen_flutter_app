import 'package:flutter/material.dart';
import 'package:restaukitchen_app/l10n/l10n.dart';
import 'package:restaukitchen_app/theme/light_theme.dart';

class ConfirmDialog {
  /// Shows a confirmation dialog with "Are you sure?" message
  /// Returns true if user confirms, false if cancelled
  static Future<bool?> show({
    required BuildContext context,
    String? title,
    String? message,
    String? confirmText,
    String? cancelText,
    Color? confirmButtonColor,
    Color? cancelButtonColor,
  }) async {
    return showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        final l10n = context.l10n;
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          title: title != null
              ? Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                )
              : null,
          content: Text(
            message ?? l10n.commonAreYouSure,
            style: const TextStyle(
              fontSize: 16,
            ),
          ),
          actions: [
            // Cancel Button
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              style: TextButton.styleFrom(
                foregroundColor: cancelButtonColor ?? Colors.grey[700],
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              ),
              child: Text(cancelText ?? l10n.commonCancel),
            ),
            // Confirm Button
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(true),
              style: ElevatedButton.styleFrom(
                backgroundColor: confirmButtonColor ?? LightTheme.primaryColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(confirmText ?? l10n.commonConfirm),
            ),
          ],
        );
      },
    );
  }
}


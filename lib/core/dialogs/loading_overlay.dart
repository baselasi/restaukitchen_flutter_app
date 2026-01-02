import 'package:flutter/material.dart';

class LoadingOverlay {
  /// Shows a transparent loading overlay that covers the entire screen
  /// Returns the BuildContext of the overlay, which can be used to hide it
  static OverlayEntry? show(BuildContext context, {Color? backgroundColor}) {
    final overlay = Overlay.of(context);
    OverlayEntry? overlayEntry;

    overlayEntry = OverlayEntry(
      builder: (context) => Material(
        color: Colors.transparent,
        child: Container(
          color: backgroundColor ?? Colors.black.withValues(alpha: 0.3),
          child: const Center(child: CircularProgressIndicator()),
        ),
      ),
    );

    overlay.insert(overlayEntry);
    return overlayEntry;
  }

  /// Hides the loading overlay
  static void hide(OverlayEntry? overlayEntry) {
    overlayEntry?.remove();
  }

  /// Shows loading overlay and automatically hides it when the future completes
  static Future<T?> showWhile<T>(
    BuildContext context,
    Future<T> future, {
    Color? backgroundColor,
  }) async {
    final overlayEntry = show(context, backgroundColor: backgroundColor);
    try {
      final result = await future;
      return result;
    } finally {
      hide(overlayEntry);
    }
  }
}

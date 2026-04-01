import 'package:flutter/material.dart';

class SecondaryButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isFullWidth;
  final EdgeInsets? padding;
  final double? width;
  final bool isDisabled;

  const SecondaryButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isFullWidth = true,
    this.padding,
    this.width,
    this.isDisabled = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final borderColor = isDisabled
        ? theme.colorScheme.primary.withValues(alpha: 0.5)
        : theme.colorScheme.primary;
    final textColor = isDisabled
        ? theme.colorScheme.primary.withValues(alpha: 0.5)
        : theme.colorScheme.primary;

    Widget button = OutlinedButton(
      onPressed: isDisabled ? null : onPressed,
      style: OutlinedButton.styleFrom(
        side: BorderSide(color: borderColor),
        foregroundColor: textColor,
        padding: padding ?? const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        disabledForegroundColor: theme.colorScheme.primary.withValues(
          alpha: 0.5,
        ),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: textColor,
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
    );

    if (isFullWidth) {
      return SizedBox(width: width ?? double.infinity, child: button);
    }

    return button;
  }
}




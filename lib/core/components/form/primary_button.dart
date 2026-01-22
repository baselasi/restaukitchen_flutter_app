import 'package:flutter/material.dart';

class PrimaryButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isFullWidth;
  final EdgeInsets? padding;
  final double? width;
  final bool isDisabled;

  const PrimaryButton({
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
    
    Widget button = ElevatedButton(
      onPressed: isDisabled ? null : onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: isDisabled 
            ? theme.colorScheme.primary.withOpacity(0.5)
            : theme.colorScheme.primary,
        foregroundColor: Colors.white,
        padding: padding ?? const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        elevation: isDisabled ? 0 : 2,
        disabledBackgroundColor: theme.colorScheme.primary.withOpacity(0.5),
        disabledForegroundColor: Colors.white.withOpacity(0.7),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
    );

    if (isFullWidth) {
      return SizedBox(
        width: width ?? double.infinity,
        child: button,
      );
    }

    return button;
  }
}

import 'package:flutter/material.dart';

class InputField extends StatelessWidget {
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final bool isRequired;
  final bool isNumeric;
  final bool isDisabled;
  final String? label;
  final String? hint;
  final String? helperText;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final Widget? suffixIconWidget;
  final bool obscureText;
    final Widget? suffixIconButton;

  final int? maxLines;
  final int? maxLength;
  final TextInputType? keyboardType;
  final void Function(String)? onChanged;
  final void Function()? onTap;
  final FocusNode? focusNode;
  final TextInputAction? textInputAction;
  final void Function(String)? onSubmitted;
  final String? initialValue;

  const InputField({
    super.key,
    required this.controller,
    this.validator,
    this.isRequired = false,
    this.isNumeric = false,
    this.isDisabled = false,
    this.label,
    this.hint,
    this.helperText,
    this.prefixIcon,
    this.suffixIcon,
    this.suffixIconWidget,
    this.suffixIconButton,
    this.obscureText = false,
    this.maxLines = 1,
    this.maxLength,
    this.keyboardType,
    this.onChanged,
    this.onTap,
    this.focusNode,
    this.textInputAction,
    this.onSubmitted,
    this.initialValue,
  });

  String? _validateInput(String? value) {
    // Required field validation
    if (isRequired && (value == null || value.trim().isEmpty)) {
      return 'This field is required';
    }

    // Numeric field validation
    if (isNumeric && value != null && value.isNotEmpty) {
      if (double.tryParse(value) == null) {
        return 'Please enter a valid number';
      }
    }

    // Custom validator
    if (validator != null) {
      return validator!(value);
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Set initial value if provided and controller is empty
    if (initialValue != null && controller.text.isEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (controller.text.isEmpty) {
          controller.text = initialValue!;
        }
      });
    }

    return TextFormField(
      controller: controller,
      validator: _validateInput,
      enabled: !isDisabled,
      obscureText: obscureText,
      maxLines: maxLines,
      maxLength: maxLength,
      keyboardType: isNumeric
          ? const TextInputType.numberWithOptions(decimal: true)
          : keyboardType,
      onChanged: onChanged,
      onTap: onTap,
      focusNode: focusNode,
      textInputAction: textInputAction,
      onFieldSubmitted: onSubmitted,
      style: theme.textTheme.bodyMedium,
      decoration: InputDecoration(
        labelText: label != null ? (isRequired ? '$label *' : label) : null,
        labelStyle: theme.textTheme.bodyMedium,
        hintText: hint,
        hintStyle: theme.textTheme.bodyMedium,
        helperText: helperText,
        helperStyle: theme.textTheme.bodyMedium,
        suffix:
            suffixIconButton ??
            (suffixIcon != null
                ? Icon(
                    suffixIcon,
                    color: isDisabled
                        ? theme.colorScheme.onSurface.withValues(alpha: 0.38)
                        : theme.colorScheme.primary,
                  )
                : null),
        prefixIcon: prefixIcon != null
            ? Icon(
                prefixIcon,
                color: isDisabled
                    ? theme.colorScheme.onSurface.withValues(alpha: 0.38)
                    : theme.colorScheme.primary,
              )
            : null,
        suffixIcon:
            suffixIconWidget ??
            (suffixIcon != null
                ? Icon(
                    suffixIcon,
                    color: isDisabled
                        ? theme.colorScheme.onSurface.withValues(alpha: 0.38)
                        : theme.colorScheme.primary,
                  )
                : null),
        filled: true,
        fillColor: isDisabled
            ? theme.colorScheme.surfaceContainerHighest
            : null,
        enabled: !isDisabled,
        errorMaxLines: 2,
      ),
    );
  }
}

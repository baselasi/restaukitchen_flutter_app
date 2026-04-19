import 'package:flutter/material.dart';
import 'package:restaukitchen_app/core/components/form/primary_button.dart';
import 'package:restaukitchen_app/core/components/form/secondery_button.dart';
import 'package:restaukitchen_app/l10n/l10n.dart';

class TotalCoversDialog {
  static Future<int?> show(BuildContext context) async {
    return showDialog<int>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => const _TotalCoversDialogContent(),
    );
  }
}

class _TotalCoversDialogContent extends StatefulWidget {
  const _TotalCoversDialogContent();

  @override
  State<_TotalCoversDialogContent> createState() =>
      _TotalCoversDialogContentState();
}

class _TotalCoversDialogContentState extends State<_TotalCoversDialogContent> {
  final TextEditingController _controller = TextEditingController();
  String? _errorText;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onContinue() {
    final parsedValue = int.tryParse(_controller.text.trim());
    if (parsedValue == null || parsedValue <= 0) {
      setState(() {
        _errorText = context.l10n.commonValidNumber;
      });
      return;
    }
    Navigator.of(context).pop(parsedValue);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return AlertDialog(
      alignment: Alignment.center,

      title: Text(l10n.tablesTotalCoversTitle),
      content: TextField(
        controller: _controller,
        autofocus: true,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          labelText: l10n.tablesTotalCoversHint,
          errorText: _errorText,
        ),
      ),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SecondaryButton(
              onPressed: () => Navigator.of(context).pop(),
              text: l10n.commonCancel,
              width: 100,
            ),
            const SizedBox(width: 16),
            PrimaryButton(
              width: 100,
              onPressed: _onContinue,
              text: l10n.commonContinue,
            ),
          ],
        ),
      ],
    );
  }
}

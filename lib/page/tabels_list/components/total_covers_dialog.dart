import 'package:flutter/material.dart';
import 'package:restaukitchen_app/core/components/form/primary_button.dart';
import 'package:restaukitchen_app/core/components/form/secondery_button.dart';

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
        _errorText = 'Please enter a valid number';
      });
      return;
    }
    Navigator.of(context).pop(parsedValue);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      alignment: Alignment.center,

      title: const Text('Total covers'),
      content: TextField(
        controller: _controller,
        autofocus: true,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          labelText: 'Enter total covers',
          errorText: _errorText,
        ),
      ),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            PrimaryButton(width: 100, onPressed: _onContinue, text: 'Continue'),
            const SizedBox(width: 16),
            SecondaryButton(
              onPressed: () => Navigator.of(context).pop(),
              text: 'Cancel',
              width: 100,
            ),
          ],
        ),
      ],
    );
  }
}

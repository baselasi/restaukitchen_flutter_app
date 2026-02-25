import 'package:flutter/material.dart';
import 'package:restaukitchen_app/core/components/form/primary_button.dart';

class AddDishDialogResult {
  final String note;
  final int quantity;

  const AddDishDialogResult({required this.note, required this.quantity});
}

Future<AddDishDialogResult?> showAddDishDialog({
  required BuildContext context,
  double heightFactor = 0.5,
}) {
  return showModalBottomSheet<AddDishDialogResult>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => _AddDishSheet(heightFactor: heightFactor),
  );
}

class _AddDishSheet extends StatefulWidget {
  final double heightFactor;

  const _AddDishSheet({required this.heightFactor});

  @override
  State<_AddDishSheet> createState() => _AddDishSheetState();
}

class _AddDishSheetState extends State<_AddDishSheet> {
  late final DraggableScrollableController _draggableController;
  late final FocusNode _noteFocusNode;
  late final double _collapsedSize;
  late final double _focusedSize;
  int _quantity = 1;
  String _note = '';

  @override
  void initState() {
    super.initState();
    _draggableController = DraggableScrollableController();
    _noteFocusNode = FocusNode()..addListener(_handleNoteFocusChange);
    _collapsedSize = widget.heightFactor.clamp(0.25, 1.0);
    _focusedSize = (_collapsedSize + 0.2).clamp(0.25, 0.95);
  }

  @override
  void dispose() {
    _noteFocusNode.removeListener(_handleNoteFocusChange);
    _noteFocusNode.dispose();
    _draggableController.dispose();
    super.dispose();
  }

  void _handleNoteFocusChange() {
    _animateSheet(_noteFocusNode.hasFocus ? _focusedSize : _collapsedSize);
  }

  void _animateSheet(double size) {
    if (!mounted || !_draggableController.isAttached) return;
    _draggableController.animateTo(
      size,
      duration: const Duration(milliseconds: 220),
      curve: Curves.easeOut,
    );
  }

  void _submit() {
    FocusScope.of(context).unfocus();
    Navigator.of(context).pop(
      AddDishDialogResult(note: _note.trim(), quantity: _quantity),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      controller: _draggableController,
      initialChildSize: _collapsedSize,
      minChildSize: 0.25,
      maxChildSize: 0.95,
      expand: false,
      builder: (context, scrollController) => AnimatedPadding(
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOut,
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              const SizedBox(height: 10),
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade400,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 12),
              Expanded(
                child: SingleChildScrollView(
                  controller: scrollController,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: TextField(
                    focusNode: _noteFocusNode,
                    minLines: 3,
                    maxLines: 5,
                    textInputAction: TextInputAction.done,
                    scrollPadding: const EdgeInsets.only(bottom: 120),
                    onTapOutside: (_) => FocusScope.of(context).unfocus(),
                    onChanged: (value) => _note = value,
                    decoration: const InputDecoration(
                      labelText: 'Note',
                      hintText: 'Add note for this dish',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
              ),
              SafeArea(
                top: false,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                  child: Row(
                    children: [
                      _CircleQuantityButton(
                        icon: Icons.remove,
                        onTap: () {
                          if (_quantity > 1) {
                            setState(() => _quantity -= 1);
                          }
                        },
                      ),
                      const SizedBox(width: 12),
                      Text(
                        '$_quantity',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(width: 12),
                      _CircleQuantityButton(
                        icon: Icons.add,
                        onTap: () => setState(() => _quantity += 1),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: PrimaryButton(onPressed: _submit, text: 'Add'),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CircleQuantityButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _CircleQuantityButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).colorScheme.primary,
      shape: const CircleBorder(),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: SizedBox(
          width: 36,
          height: 36,
          child: Icon(icon, color: Colors.white, size: 30),
        ),
      ),
    );
  }
}

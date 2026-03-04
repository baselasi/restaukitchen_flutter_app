import 'package:flutter/material.dart';
import 'package:restaukitchen_app/core/components/form/dimensionInput/dimension_assignments.dart';
import 'package:restaukitchen_app/core/components/form/primary_button.dart';
import 'package:restaukitchen_app/core/models/dish.dart';
import 'package:restaukitchen_app/core/models/ingredients.dart';

class AddDishDialogResult {
  final String note;
  final int quantity;
  final DimensionAssignments? selectedDimension;
  final List<Ingredient> ingredients;
  const AddDishDialogResult({
    required this.note,
    required this.quantity,
    required this.selectedDimension,
    required this.ingredients,
  });
}

Future<AddDishDialogResult?> showAddDishDialog({
  required BuildContext context,
  double heightFactor = 0.9,
  required Dish dish,
  required List<Ingredient> ingredients,
}) {
  return showModalBottomSheet<AddDishDialogResult>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => _AddDishSheet(
      heightFactor: heightFactor,
      dish: dish,
      ingredients: ingredients,
    ),
  );
}

class _AddDishSheet extends StatefulWidget {
  final double heightFactor;
  final Dish dish;
  final List<Ingredient> ingredients;
  const _AddDishSheet({
    required this.heightFactor,
    required this.dish,
    required this.ingredients,
  });

  @override
  State<_AddDishSheet> createState() => _AddDishSheetState();
}

class _AddDishSheetState extends State<_AddDishSheet> {
  // late final FocusNode _noteFocusNode;
  int _quantity = 1;
  String _note = '';
  late final List<DimensionAssignments> _dimensionAssignments;
  DimensionAssignments? _selectedDimension;
  final Set<String> _selectedIngredientKeys = {};

  @override
  void initState() {
    super.initState();
    // _noteFocusNode = FocusNode()..addListener(_handleNoteFocusChange);
    _dimensionAssignments = (widget.dish.dimensionAssignments ?? [])
        .where((assignment) => assignment.deleted != true)
        .toList();
    if (_dimensionAssignments.isNotEmpty) {
      _selectedDimension = _dimensionAssignments.firstWhere(
        (assignment) => assignment.dimension.standard,
        orElse: () => _dimensionAssignments.first,
      );
    }
  }

  @override
  void dispose() {
    // _noteFocusNode.removeListener(_handleNoteFocusChange);
    // _noteFocusNode.dispose();
    super.dispose();
  }

  // void _handleNoteFocusChange() {
  //   _animateSheet(_noteFocusNode.hasFocus ? _focusedSize : _collapsedSize);
  // }

  // void _animateSheet(double size) {
  //   if (!mounted || !_draggableController.isAttached) return;
  //   _draggableController.animateTo(
  //     size,
  //     duration: const Duration(milliseconds: 220),
  //     curve: Curves.easeOut,
  //   );
  // }

  void _submit() {
    if (_dimensionAssignments.isNotEmpty && _selectedDimension == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please choose a dimension')),
      );
      return;
    }
    FocusScope.of(context).unfocus();
    final selectedIngredients = _ingredientsForSelectedDimension
        .where(
          (ingredient) =>
              _selectedIngredientKeys.contains(_ingredientKey(ingredient)),
        )
        .toList();
    Navigator.of(context).pop(
      AddDishDialogResult(
        note: _note.trim(),
        quantity: _quantity,
        selectedDimension: _selectedDimension,
        ingredients: selectedIngredients,
      ),
    );
  }

  String _dimensionKey(DimensionAssignments assignment) {
    return assignment.id ??
        assignment.dimension.id ??
        assignment.dimension.name;
  }

  String _formatPrice(String? rawPrice) {
    final parsed = num.tryParse(rawPrice ?? '');
    if (parsed == null) return '';
    return '€${parsed.toStringAsFixed(2)}';
  }

  String _ingredientKey(Ingredient ingredient) {
    return ingredient.id ?? ingredient.name;
  }

  List<Ingredient> get _ingredientsForSelectedDimension {
    final selectedDimensionId = _selectedDimension?.dimension.id;
    if (selectedDimensionId == null || selectedDimensionId.isEmpty) return [];

    return widget.ingredients
        .where((ingredient) => ingredient.hasDimensionId(selectedDimensionId))
        .toList();
  }

  void _toggleIngredientSelection(Ingredient ingredient) {
    final key = _ingredientKey(ingredient);
    setState(() {
      if (_selectedIngredientKeys.contains(key)) {
        _selectedIngredientKeys.remove(key);
      } else {
        _selectedIngredientKeys.add(key);
      }
    });
  }

  void _syncSelectedIngredientsWithCurrentDimension() {
    final availableKeys = _ingredientsForSelectedDimension
        .map(_ingredientKey)
        .toSet();
    _selectedIngredientKeys.removeWhere((key) => !availableKeys.contains(key));
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.sizeOf(context).height;
    final maxSheetHeight =
        screenHeight * widget.heightFactor.clamp(0.35, 0.98);

    return AnimatedPadding(
      duration: const Duration(milliseconds: 180),
      curve: Curves.easeOut,
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Align(
        alignment: Alignment.bottomCenter,
        child: ConstrainedBox(
          constraints: BoxConstraints(maxHeight: maxSheetHeight),
          child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(20),
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
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
                Flexible(
                  fit: FlexFit.loose,
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (_dimensionAssignments.isNotEmpty &&
                            _dimensionAssignments.length > 1) ...[
                          const SizedBox(height: 8),
                          RadioGroup<String>(
                            groupValue: _selectedDimension == null
                                ? null
                                : _dimensionKey(_selectedDimension!),
                            onChanged: (value) {
                              final selected = _dimensionAssignments.firstWhere(
                                (assignment) =>
                                    _dimensionKey(assignment) == value,
                              );
                              setState(() => _selectedDimension = selected);
                              _syncSelectedIngredientsWithCurrentDimension();
                            },
                            child: Column(
                              children: _dimensionAssignments.map((assignment) {
                                final isSelected =
                                    _dimensionKey(
                                      _selectedDimension ?? assignment,
                                    ) ==
                                    _dimensionKey(assignment);
                                return Card(
                                  margin: const EdgeInsets.only(bottom: 8),
                                  child: ListTile(
                                    onTap: () => setState(() {
                                      _selectedDimension = assignment;
                                      _syncSelectedIngredientsWithCurrentDimension();
                                    }),
                                    leading: Radio<String>(
                                      value: _dimensionKey(assignment),
                                    ),
                                    title: Text(assignment.dimension.name),
                                    subtitle: Text(
                                      _formatPrice(assignment.price),
                                    ),
                                    selected: isSelected,
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                          const SizedBox(height: 8),
                        ],
                        if (_ingredientsForSelectedDimension.isNotEmpty) ...[
                          Text(
                            'Selected Ingredients',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          const SizedBox(height: 8),
                          ..._ingredientsForSelectedDimension.map((ingredient) {
                            final key = _ingredientKey(ingredient);
                            final isSelected = _selectedIngredientKeys.contains(
                              key,
                            );
                            return Card(
                              margin: const EdgeInsets.only(bottom: 8),
                              child: ListTile(
                                onTap: () =>
                                    _toggleIngredientSelection(ingredient),
                                leading: Icon(
                                  isSelected
                                      ? Icons.radio_button_checked
                                      : Icons.radio_button_unchecked,
                                  color: isSelected
                                      ? Theme.of(context).colorScheme.primary
                                      : null,
                                ),
                                title: Text(ingredient.name),
                                selected: isSelected,
                                trailing: Text(
                                  _formatPrice(
                                    ingredient.dimensionAssignments
                                        .firstWhere(
                                          (assignment) =>
                                              assignment.dimension.id ==
                                              _selectedDimension?.dimension.id,
                                        )
                                        .price,
                                  ),
                                ),
                              ),
                            );
                          }),
                          const SizedBox(height: 8),
                        ],
                        TextField(
                          // focusNode: _noteFocusNode,
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
                        const SizedBox(height: 20),
                      ],
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

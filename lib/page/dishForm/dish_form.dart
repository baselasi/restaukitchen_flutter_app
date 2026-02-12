import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restaukitchen_app/core/components/appBar/details_app_bar.dart';
import 'package:restaukitchen_app/core/components/form/categorySelector/category_selector_cubit.dart';
import 'package:restaukitchen_app/core/components/form/categorySelector/category_selector_field.dart';
import 'package:restaukitchen_app/core/components/form/descriptionInput/description_cubit.dart';
import 'package:restaukitchen_app/core/components/form/descriptionInput/description_input.dart';
import 'package:restaukitchen_app/core/components/form/dimensionInput/dimension_cubit.dart';
import 'package:restaukitchen_app/core/components/form/dimensionInput/dimesion_input.dart';
import 'package:restaukitchen_app/core/components/form/input_field.dart';
import 'package:restaukitchen_app/core/components/form/primary_button.dart';
import 'package:restaukitchen_app/core/models/dish.dart';
import 'package:restaukitchen_app/page/dishForm/bloc/dish_form_cubit.dart';

class DishForm extends StatefulWidget {
  final String? menuId;
  final Dish? dish;
  const DishForm({super.key, this.menuId, this.dish});

  @override
  State<DishForm> createState() => _DishFormState();
}

class _DishFormState extends State<DishForm> {
  final TextEditingController _nameControllere = TextEditingController();
  bool _isAvailable = true;

  @override
  void initState() {
    super.initState();
    if (widget.dish != null) {
      _nameControllere.text = widget.dish!.name;
      _isAvailable = widget.dish!.isAvailable ?? true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<DishFormCubit, DishFormState>(
      listener: (context, state) {
        if (state.status == DishFormStatus.success) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Dish created successfully')),
          );
          Navigator.of(context).pop();
        }
      },
      child: Scaffold(
        appBar: DetailsAppBar(pageTitle: "New Dish"),
        body: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      SizedBox(height: 16),
                      Text('Dish Form'),
                      SizedBox(height: 16),
                      InputField(
                        controller: _nameControllere,
                        label: "Name",
                        isRequired: true,
                      ),
                      SizedBox(height: 16),
                      CategorySelectorField(
                        selectedCategory: widget.dish?.category,
                      ),
                      SizedBox(height: 16),
                      DescriptionInput(dish: widget.dish),
                      SizedBox(height: 16),
                      DimensionInput(),
                      SizedBox(height: 16),
                      Row(
                        children: [
                          Text(
                            'Available',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Spacer(),
                          Switch(
                            value: _isAvailable,
                            onChanged: (value) {
                              setState(() {
                                _isAvailable = value;
                              });
                            },
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 16,
                      ), // Extra padding at bottom for button spacing
                    ],
                  ),
                ),
              ),
            ),
            // Fixed button at the bottom
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Theme.of(context).scaffoldBackgroundColor,
              ),
              child: SaveButton(
                nameController: _nameControllere,
                onSavePressed: () {
                  context.read<DishFormCubit>().createDish(
                    menuId: widget.menuId ?? '',
                    name: _nameControllere.text,
                    categoryId:
                        context
                            .read<CategorySelectorCubit>()
                            .state
                            .selectedCategory
                            ?.id ??
                        '',
                    isAvailable: _isAvailable,
                    descriptions: context
                        .read<DescriptionCubit>()
                        .state
                        .descriptions,
                    dimensionAssignments:
                        context
                            .read<DimensionCubit>()
                            .state
                            .dimensionAssignments ??
                        [],
                    position: 0,
                    dishId: widget.dish?.id,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SaveButton extends StatefulWidget {
  final TextEditingController nameController;
  final VoidCallback onSavePressed;
  const SaveButton({
    super.key,
    required this.nameController,
    required this.onSavePressed,
  });

  @override
  State<SaveButton> createState() => _SaveButtonState();
}

class _SaveButtonState extends State<SaveButton> {
  bool _isNameEmpty = true;

  @override
  void initState() {
    super.initState();
    _isNameEmpty = widget.nameController.text.isEmpty;
    // Listen to name controller changes
    widget.nameController.addListener(_onNameChanged);
  }

  @override
  void dispose() {
    // Remove listener to prevent memory leaks
    widget.nameController.removeListener(_onNameChanged);
    super.dispose();
  }

  void _onNameChanged() {
    final isNameEmpty = widget.nameController.text.isEmpty;
    if (_isNameEmpty != isNameEmpty) {
      setState(() {
        _isNameEmpty = isNameEmpty;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    DimensionState dimensionAssignmentState = context
        .watch<DimensionCubit>()
        .state;
    CategorySelectorState categoryState = context
        .watch<CategorySelectorCubit>()
        .state;
    return BlocBuilder<DishFormCubit, DishFormState>(
      builder: (context, state) {
        if (state.status == DishFormStatus.loading) {
          return const Center(child: CircularProgressIndicator());
        }
        return PrimaryButton(
          text: 'Salva',

          onPressed: widget.onSavePressed,
          isDisabled:
              dimensionAssignmentState.isEmpty ||
              categoryState.selectedCategory == null ||
              _isNameEmpty,
        );
      },
    );
  }
}

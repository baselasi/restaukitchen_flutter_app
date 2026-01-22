import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restaukitchen_app/core/components/appBar/details_app_bar.dart';
import 'package:restaukitchen_app/core/components/form/categorySelector/category_selector_cubit.dart';
import 'package:restaukitchen_app/core/components/form/categorySelector/category_selector_field.dart';
import 'package:restaukitchen_app/core/components/form/descriptionInput/description_input.dart';
import 'package:restaukitchen_app/core/components/form/dimensionInput/dimension_cubit.dart';
import 'package:restaukitchen_app/core/components/form/dimensionInput/dimesion_input.dart';
import 'package:restaukitchen_app/core/components/form/input_field.dart';
import 'package:restaukitchen_app/core/components/form/primary_button.dart';

class DishForm extends StatefulWidget {
  const DishForm({super.key});

  @override
  State<DishForm> createState() => _DishFormState();
}

class _DishFormState extends State<DishForm> {
  final TextEditingController _nameControllere = TextEditingController();
  bool _isAvailable = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                    CategorySelectorField(),
                    SizedBox(height: 16),
                    DescriptionInput(),
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
            child: SaveButton(dishNameIsEmpty: _nameControllere.text.isEmpty),
          ),
        ],
      ),
    );
  }
}

class SaveButton extends StatefulWidget {
  final bool dishNameIsEmpty;

  const SaveButton({super.key, required this.dishNameIsEmpty});

  @override
  State<SaveButton> createState() => _SaveButtonState();
}

class _SaveButtonState extends State<SaveButton> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    DimensionState dimensionAssignmentState = context
        .watch<DimensionCubit>()
        .state;
    CategorySelectorState categoryState = context
        .watch<CategorySelectorCubit>()
        .state;
    return PrimaryButton(
      text: 'Salva',
      onPressed: () {},
      isDisabled:
          dimensionAssignmentState.isEmpty ||
          categoryState.selectedCategory == null ||
          widget.dishNameIsEmpty,
    );
  }
}

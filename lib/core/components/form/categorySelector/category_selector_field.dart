import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restaukitchen_app/core/components/form/categorySelector/category_selector_cubit.dart';
import 'package:restaukitchen_app/core/models/category.dart';

class CategorySelectorField extends StatefulWidget {
  const CategorySelectorField({super.key});

  @override
  State<CategorySelectorField> createState() => _CategorySelectorFieldState();
}

class _CategorySelectorFieldState extends State<CategorySelectorField> {
  @override
  void initState() {
    context.read<CategorySelectorCubit>().getCategories();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // We assume the Cubit is provided either here or higher up
    return BlocBuilder<CategorySelectorCubit, CategorySelectorState>(
      builder: (context, state) {
        return DropdownButtonFormField<String>(
          // hint: const Text('Select Category'),
          initialValue:
              state.selectedCategory?.name, // The current value from Cubit
          decoration: const InputDecoration(
            labelText: 'Select Category',
            border: OutlineInputBorder(), // Gives it that "Input Field" look
            contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          ),
          items: state.status == CategorySelectorStatus.loading
              ? [
                  DropdownMenuItem<String>(
                    value: null,
                    child: const Text('Loading...'),
                  ),
                ]
              : state.categories.map((Category category) {
                  return DropdownMenuItem<String>(
                    value: category.name,
                    child: Text(category.name),
                  );
                }).toList(),
          onChanged: (newValue) {
            if (newValue != null) {
              context.read<CategorySelectorCubit>().selectCategory(
                state.categories.firstWhere(
                  (category) => category.name == newValue,
                ),
              );
            }
          },
        );
      },
    );
  }
}

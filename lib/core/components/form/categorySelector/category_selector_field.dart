import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restaukitchen_app/core/components/form/categorySelector/category_selector_cubit.dart';
import 'package:restaukitchen_app/core/models/category.dart';
import 'package:restaukitchen_app/l10n/l10n.dart';

class CategorySelectorField extends StatefulWidget {
  final Category? selectedCategory;
  const CategorySelectorField({super.key, this.selectedCategory});

  @override
  State<CategorySelectorField> createState() => _CategorySelectorFieldState();
}

class _CategorySelectorFieldState extends State<CategorySelectorField> {
  @override
  void initState() {
    context.read<CategorySelectorCubit>().getCategories(
      widget.selectedCategory,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return BlocBuilder<CategorySelectorCubit, CategorySelectorState>(
      builder: (context, state) {
        return DropdownButtonFormField<String>(
          // hint: const Text('Select Category'),
          initialValue:
              state.selectedCategory?.name, // The current value from Cubit
          decoration: InputDecoration(
            labelText: l10n.commonSelectCategory,
            labelStyle: Theme.of(context).textTheme.bodyMedium,
            border: OutlineInputBorder(), // Gives it that "Input Field" look
            contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          ),
          items: state.status == CategorySelectorStatus.loading
              ? [
                  DropdownMenuItem<String>(
                    value: null,
                    child: Text(l10n.commonLoading),
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

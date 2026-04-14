import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restaukitchen_app/core/dialogs/snack_bar.dart';
import 'package:restaukitchen_app/core/repository/category_repo.dart';
import 'package:restaukitchen_app/page/categories_list/bloc/create_category_cubit/create_category_cubit.dart';

Future<bool?> showAddCategorySheet(
  BuildContext context, {
  String? id,
  String? name,
}) {
  return showModalBottomSheet<bool>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => BlocProvider(
      create: (context) => CreateCategoryCubit(categoryRepo: CategoryRepo()),
      child: _AddCategorySheet(id: id, name: name),
    ),
  );
}

class _AddCategorySheet extends StatefulWidget {
  const _AddCategorySheet({this.id, this.name});
  final String? id;
  final String? name;

  @override
  State<_AddCategorySheet> createState() => _AddCategorySheetState();
}

class _AddCategorySheetState extends State<_AddCategorySheet> {
  final TextEditingController _nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.name != null) {
      _nameController.text = widget.name!;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    final trimmedName = _nameController.text.trim();

    return BlocConsumer<CreateCategoryCubit, CreateCategoryState>(
      builder: (context, state) {
        if (state.status == CreateCategoryStatus.loading) {
          return const Center(child: CircularProgressIndicator());
        }
        return Padding(
          padding: EdgeInsets.only(bottom: bottomInset),
          child: Container(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(24),
              ),
            ),
            child: SafeArea(
              top: false,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 44,
                      height: 4,
                      decoration: BoxDecoration(
                        color: const Color(0xFFD1D5DB),
                        borderRadius: BorderRadius.circular(999),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    widget.id != null ? 'Edit Category' : 'Create Category',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    widget.id != null
                        ? 'Edit the name of your category.'
                        : 'Add a name for your new category.',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: const Color(0xFF6B7280),
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: _nameController,
                    autofocus: true,
                    textInputAction: TextInputAction.done,
                    decoration: const InputDecoration(
                      labelText: 'Category name',
                    ),
                    onChanged: (_) => setState(() {}),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: const Text('Cancel'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: FilledButton(
                          onPressed: trimmedName.isEmpty
                              ? null
                              : () => context
                                    .read<CreateCategoryCubit>()
                                    .createCategory(trimmedName, widget.id),
                          child: widget.id != null
                              ? const Text('Update Category')
                              : const Text('Create Category'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
      listener: (context, state) {
        if (state.status == CreateCategoryStatus.success) {
          Navigator.of(context).pop(true);
        }
        if (state.status == CreateCategoryStatus.error) {
          AppSnackBar.showError(
            context,
            state.error ?? 'Failed to create category',
          );
        }
      },
    );
  }
}

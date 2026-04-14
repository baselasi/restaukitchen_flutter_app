import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restaukitchen_app/core/bloc/get_category_cubit.dart';
import 'package:restaukitchen_app/core/components/appBar/details_app_bar.dart';
import 'package:restaukitchen_app/core/dialogs/snack_bar.dart';
import 'package:restaukitchen_app/core/models/category.dart';
import 'package:restaukitchen_app/core/repository/category_repo.dart';
import 'package:restaukitchen_app/page/categories_list/bloc/delete_category_cubit/delete_category_cubit..dart';
import 'package:restaukitchen_app/page/categories_list/components/add_category_sheet.dart';
import 'package:restaukitchen_app/theme/light_theme.dart';

class CategoriesList extends StatefulWidget {
  const CategoriesList({super.key});

  @override
  State<CategoriesList> createState() => _CategoriesListState();
}

class _CategoriesListState extends State<CategoriesList> {
  @override
  void initState() {
    super.initState();
    context.read<GetCategoryCubit>().getCategories();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DetailsAppBar(pageTitle: 'Categories List'),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await showAddCategorySheet(context);
          if (result == true && context.mounted) {
            context.read<GetCategoryCubit>().getCategories();
          }
        },
        child: const Icon(Icons.add),
      ),
      body: BlocConsumer<GetCategoryCubit, GetCategoryCubitState>(
        listener: (context, state) {},
        builder: (context, state) {
          if (state.status == CategorySelectorStatus.loaded) {
            return Center(
              child: ListView.separated(
                shrinkWrap: true,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: state.categories.length,
                separatorBuilder: (_, _) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final category = state.categories[index];
                  return BlocProvider(
                    create: (context) =>
                        DeleteCategoryCubit(categoryRepo: CategoryRepo()),
                    child: _CategoryCard(category: category),
                  );
                },
              ),
            );
          }
          if (state.status == CategorySelectorStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state.status == CategorySelectorStatus.error) {
            return const Center(child: Text('Failed to load categories'));
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}

class _CategoryCard extends StatelessWidget {
  const _CategoryCard({required this.category});

  final Category category;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<DeleteCategoryCubit, DeleteCategoryState>(
      builder: (context, state) {
        return Material(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          elevation: 2,
          shadowColor: Colors.black.withValues(alpha: 0.08),
          child: InkWell(
            onTap: () {},
            borderRadius: BorderRadius.circular(20),
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Row(
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: LightTheme.primaryColor,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    alignment: Alignment.center,
                    child: const Icon(
                      Icons.category_rounded,
                      color: Colors.white,
                      size: 22,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          category.name,
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF111827),
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () async {
                      final result = await showAddCategorySheet(
                        context,
                        id: category.id,
                        name: category.name,
                      );
                      if (result == true && context.mounted) {
                        context.read<GetCategoryCubit>().getCategories();
                      }
                    },
                    icon: const Icon(Icons.edit_outlined),
                    color: const Color(0xFF1D4ED8),
                    tooltip: 'Edit category',
                  ),
                  if (state.status == DeleteCategoryStatus.loading)
                    Center(child: CircularProgressIndicator()),
                  if (state.status != DeleteCategoryStatus.loading)
                    IconButton(
                      onPressed: () {
                        context.read<DeleteCategoryCubit>().deleteCategory(
                          category.id!,
                        );
                      },
                      icon: const Icon(Icons.delete_outline),
                      color: const Color(0xFFDC2626),
                      tooltip: 'Delete category',
                    ),
                ],
              ),
            ),
          ),
        );
      },
      listener: (context, state) {
        if (state.status == DeleteCategoryStatus.success) {
          context.read<GetCategoryCubit>().getCategories();
        }
        if (state.status == DeleteCategoryStatus.error) {
          AppSnackBar.showError(
            context,
            state.error ?? 'Failed to delete category',
          );
        }
      },
    );
  }
}

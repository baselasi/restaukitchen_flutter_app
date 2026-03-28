import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restaukitchen_app/core/components/form/primary_button.dart';
import 'package:restaukitchen_app/page/new_order/bloc/new_order_cubit/new_order_cubit.dart';
import 'package:restaukitchen_app/page/new_order/bloc/new_order_form_bloc/new_order_form_bloc.dart';
import 'package:restaukitchen_app/page/new_order/bloc/new_order_form_bloc/new_order_form_state.dart';
import 'package:restaukitchen_app/page/new_order/bloc/new_order_form_bloc/new_order_from_events.dart';
import 'package:restaukitchen_app/page/order_list/models/course.dart';
import 'package:restaukitchen_app/page/preview_order/components/combination_indice_card.dart';
import 'package:restaukitchen_app/page/preview_order/components/dish_indice_card.dart';

class PreviewOrderPage extends StatefulWidget {
  const PreviewOrderPage({super.key});

  @override
  State<PreviewOrderPage> createState() => _PreviewOrderPageState();
}

class _PreviewOrderPageState extends State<PreviewOrderPage> {
  Widget _indiceCard(
    BuildContext context,
    CourseIndice item, {
    required int courseIndex,
    required int dishIndiceIndex,
  }) {
    void remove() {
      context.read<NewOrderFormBloc>().add(
        RemoveDishIndice(
          dishIndiceIndex: dishIndiceIndex,
          courseIndex: courseIndex,
        ),
      );
    }

    if (item is CombinationIndice) {
      return CombinationIndiceCard(combinationIndice: item, onDelete: remove);
    }
    if (item is DishIndice) {
      return DishIndiceCard(dishIndice: item, onDelete: remove);
    }
    return const SizedBox.shrink();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Preview Order')),
      bottomNavigationBar: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
          child: PrimaryButton(
            text: 'Create Order',
            onPressed: () {
              context.read<NewOrderCubit>().createOrder(
                newOrderFormState: context.read<NewOrderFormBloc>().state,
              );
            },
          ),
        ),
      ),
      body: BlocConsumer<NewOrderFormBloc, NewOrderFormState>(
        builder: (context, state) {
          final courses = state.courses;
          final hasAnyDish = courses.any((c) => c.disheIndices.isNotEmpty);

          if (!hasAnyDish) {
            return Center(
              child: Text(
                'Nothing in this order yet',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: courses.length,
            separatorBuilder: (_, __) => const SizedBox(height: 24),
            itemBuilder: (context, courseIndex) {
              final course = courses[courseIndex];
              final indices = course.disheIndices;
              final theme = Theme.of(context);

              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Text(
                          'Course ${courseIndex + 1}',
                          style: theme.textTheme.titleMedium,
                        ),
                      ),
                      PrimaryButton(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        isFullWidth: false,
                        text: 'Add dish',
                        onPressed: () {
                          context.read<NewOrderFormBloc>().add(
                            SetCurrentCourseIndex(courseIndex: courseIndex),
                          );
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  if (indices.isEmpty)
                    Text(
                      'No dishes in this course',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.outline,
                      ),
                    )
                  else
                    ...indices.asMap().entries.map((entry) {
                      final dishIndiceIndex = entry.key;
                      final item = entry.value;
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: _indiceCard(
                          context,
                          item,
                          courseIndex: courseIndex,
                          dishIndiceIndex: dishIndiceIndex,
                        ),
                      );
                    }),
                ],
              );
            },
          );
        },
        listener: (context, state) {},
      ),
    );
  }
}

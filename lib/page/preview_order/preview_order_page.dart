import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:page_transition/page_transition.dart';
import 'package:restaukitchen_app/core/components/appBar/details_app_bar.dart';
import 'package:restaukitchen_app/core/components/form/primary_button.dart';
import 'package:restaukitchen_app/page/menusPage/bloc/menus_page_bloc.dart';
import 'package:restaukitchen_app/page/new_order/bloc/menu_scroll_bar_cubit/menu_scroll_bar_cubit.dart';
import 'package:restaukitchen_app/page/new_order/bloc/new_order_cubit/new_order_cubit.dart';
import 'package:restaukitchen_app/page/new_order/bloc/new_order_form_bloc/new_order_form_bloc.dart';
import 'package:restaukitchen_app/page/new_order/bloc/new_order_form_bloc/new_order_form_state.dart';
import 'package:restaukitchen_app/page/new_order/bloc/new_order_form_bloc/new_order_from_events.dart';
import 'package:restaukitchen_app/page/new_order/add_dishes_page.dart';
import 'package:restaukitchen_app/page/order_list/models/course.dart';
import 'package:restaukitchen_app/page/preview_order/components/combination_indice_card.dart';
import 'package:restaukitchen_app/page/preview_order/components/dish_indice_card.dart';

class PreviewOrderPage extends StatefulWidget {
  final String? orderId;
  final String? dinnerTableNumber;
  const PreviewOrderPage({super.key, this.orderId, this.dinnerTableNumber});

  @override
  State<PreviewOrderPage> createState() => _PreviewOrderPageState();
}

class _PreviewOrderPageState extends State<PreviewOrderPage> {
  @override
  void initState() {
    super.initState();
    if (widget.orderId != null) {
      context.read<NewOrderCubit>().getOrder(
        orderId: widget.orderId!,
        dinnerTableNumber: widget.dinnerTableNumber!,
        newOrderFormState: context.read<NewOrderFormBloc>().state,
      );
    }
  }

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

    void onEdit(CourseIndice updatedItem) {
      context.read<NewOrderFormBloc>().add(
        UpdateDishIndice(
          courseIndex: courseIndex,
          dishIndiceIndex: dishIndiceIndex,
          dishIndice: updatedItem,
        ),
      );
    }

    if (item is CombinationIndice) {
      return CombinationIndiceCard(
        combinationIndice: item,
        onDelete: remove,
        onEdit: onEdit,
      );
    }
    if (item is DishIndice) {
      return DishIndiceCard(dishIndice: item, onDelete: remove, onEdit: onEdit);
    }
    return const SizedBox.shrink();
  }

  Widget _courseSection(
    BuildContext context,
    ThemeData theme,
    Course course,
    int courseIndex,
  ) {
    final indices = course.disheIndices;
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
                Navigator.of(context).push(
                  PageTransition(
                    type: PageTransitionType.rightToLeft,
                    child: MultiBlocProvider(
                      providers: [
                        BlocProvider.value(
                          value: context.read<NewOrderFormBloc>(),
                        ),
                        BlocProvider.value(
                          value: context.read<NewOrderCubit>(),
                        ),
                        BlocProvider.value(
                          value: context.read<MenuScrollBarCubit>(),
                        ),
                        BlocProvider.value(
                          value: context.read<MenusPageBloc>(),
                        ),
                      ],
                      child: AddDishesPage(),
                    ),
                  ),
                );
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DetailsAppBar(pageTitle: "New Order"),
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
      body: BlocConsumer<NewOrderCubit, NewOrderState>(
        builder: (context, state) {
          if (state.status == NewOrderStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          }
          return BlocConsumer<NewOrderFormBloc, NewOrderFormState>(
            builder: (context, state) {
              final courses = state.courses;
              final theme = Theme.of(context);
              return ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  for (
                    var courseIndex = 0;
                    courseIndex < courses.length;
                    courseIndex++
                  ) ...[
                    if (courseIndex > 0) const SizedBox(height: 24),
                    _courseSection(
                      context,
                      theme,
                      courses[courseIndex],
                      courseIndex,
                    ),
                  ],
                  const SizedBox(height: 24),
                  _CreateNewCourseCard(
                    accentColor: theme.colorScheme.primary,
                    onTap: () {
                      context.read<NewOrderFormBloc>().add(
                        AddCourse(course: Course(disheIndices: [])),
                      );
                    },
                  ),
                ],
              );
            },
            listener: (context, state) {},
          );
        },
        listener: (context, state) {
          if (state.status == NewOrderStatus.success) {
            Navigator.of(context).pop();
          }
          if (state.status == NewOrderStatus.getSuccess) {
            context.read<NewOrderFormBloc>().add(
              InitializeOrder(order: state.order),
            );
          }
        },
      ),
    );
  }
}

class _CreateNewCourseCard extends StatelessWidget {
  final Color accentColor;
  final VoidCallback onTap;

  const _CreateNewCourseCard({required this.accentColor, required this.onTap});

  static const double _radius = 12;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(_radius),
        child: CustomPaint(
          foregroundPainter: _DashedRoundedRectPainter(
            color: accentColor,
            borderRadius: _radius,
          ),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(_radius),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: accentColor,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.add, color: Colors.white, size: 28),
                ),
                const SizedBox(height: 14),
                Text(
                  'CREATE NEW COURSE',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.labelLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1,
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

class _DashedRoundedRectPainter extends CustomPainter {
  final Color color;
  final double borderRadius;

  _DashedRoundedRectPainter({required this.color, required this.borderRadius});

  @override
  void paint(Canvas canvas, Size size) {
    const strokeWidth = 1.5;
    final rrect = RRect.fromRectAndRadius(
      Rect.fromLTWH(
        strokeWidth / 2,
        strokeWidth / 2,
        size.width - strokeWidth,
        size.height - strokeWidth,
      ),
      Radius.circular(borderRadius - strokeWidth / 2),
    );
    final path = Path()..addRRect(rrect);
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;

    for (final metric in path.computeMetrics()) {
      var distance = 0.0;
      const dashLength = 6.0;
      const gapLength = 4.0;
      while (distance < metric.length) {
        final len = math.min(dashLength, metric.length - distance);
        canvas.drawPath(metric.extractPath(distance, distance + len), paint);
        distance += dashLength + gapLength;
      }
    }
  }

  @override
  bool shouldRepaint(covariant _DashedRoundedRectPainter oldDelegate) {
    return oldDelegate.color != color ||
        oldDelegate.borderRadius != borderRadius;
  }
}

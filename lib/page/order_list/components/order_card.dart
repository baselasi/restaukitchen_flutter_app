import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restaukitchen_app/page/order_list/bloc/orders_actions_cubit/order_actions_cubit.dart';
import 'package:restaukitchen_app/page/order_list/bloc/status_cubit/status_cubit.dart';
import 'package:restaukitchen_app/page/order_list/models/course.dart';
import 'package:restaukitchen_app/page/order_list/models/order.dart';

class OrderCard extends StatefulWidget {
  final Order order;
  final VoidCallback? onArchive;
  final VoidCallback? onPrint;
  final VoidCallback? onActionSucess;

  const OrderCard({
    super.key,
    required this.order,
    this.onArchive,
    this.onPrint,
    this.onActionSucess,
  });

  @override
  State<OrderCard> createState() => _OrderCardState();
}

class _OrderCardState extends State<OrderCard>
    with SingleTickerProviderStateMixin {
  bool _isExpanded = false;
  bool _isSwiped = false;
  late Order _order;

  @override
  void initState() {
    super.initState();
    _order = widget.order;
  }

  /// Groups [courseIndices] by their course number and returns a sorted map.
  Map<int, List<CourseIndice>> _groupByCourse() {
    final indices = _order.dishIndices;
    if (indices == null || indices.isEmpty) return {};

    final Map<int, List<CourseIndice>> grouped = {};
    for (final indice in indices) {
      final course = switch (indice) {
        DishIndice d => d.course,
        CombinationIndice c => c.course,
      };
      grouped.putIfAbsent(course, () => []).add(indice);
    }

    // Return sorted by course number
    return Map.fromEntries(
      grouped.entries.toList()..sort((a, b) => a.key.compareTo(b.key)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      transitionBuilder: (child, animation) {
        // Slide from right when showing status card, slide from left when going back
        final isStatusCard = child.key == const ValueKey('status');
        final offset = isStatusCard
            ? Tween(begin: const Offset(-1, 0), end: Offset.zero)
            : Tween(begin: const Offset(1, 0), end: Offset.zero);
        return SlideTransition(
          position: offset.animate(
            CurvedAnimation(
              parent: animation,
              curve: Curves.easeInOut,
              reverseCurve: Curves.easeInOut,
            ),
          ),
          child: child,
        );
      },
      child: _isSwiped
          ? _buildActionCard(theme, colorScheme)
          : _buildMainCard(theme, colorScheme),
    );
  }

  Widget _buildActionCard(ThemeData theme, ColorScheme colorScheme) {
    return GestureDetector(
      onHorizontalDragEnd: (details) {
        if ((details.primaryVelocity ?? 0) > 200) {
          setState(() => _isSwiped = false);
        }
      },
      child: Card(
        key: const ValueKey('status'),
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        color: colorScheme.primary,
        clipBehavior: Clip.antiAlias,
        child: BlocConsumer<OrderActionsCubit, OrderActionsState>(
          builder: (context, state) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  if (state.status == OrderActionsStatus.loading) ...[
                    Expanded(
                      child: Center(
                        child: CircularProgressIndicator(
                          color: colorScheme.secondary,
                        ),
                      ),
                    ),
                  ],
                  if (state.status == OrderActionsStatus.initial ||
                      state.status == OrderActionsStatus.success ||
                      state.status == OrderActionsStatus.error) ...[
                    _ActionButton(
                      icon: Icons.delete,
                      label: 'Delete',
                      isActive: false,
                      activeColor: colorScheme.secondary,
                      onPressed: () {
                        context.read<OrderActionsCubit>().deleteOrder(
                          _order.id ?? "",
                        );
                      },
                    ),
                    _ActionButton(
                      icon: Icons.print,
                      label: 'Print',
                      isActive: false,
                      activeColor: colorScheme.secondary,
                      onPressed: () {
                        // context.read<OrderActionsCubit>().printOrder(widget.order.id??"");
                      },
                    ),
                    _ActionButton(
                      icon: Icons.archive,
                      label: 'Archive',
                      isActive: false,
                      activeColor: colorScheme.secondary,
                      onPressed: () {
                        context.read<OrderActionsCubit>().archiveOrder(
                          _order.id ?? "",
                        );
                      },
                    ),
                  ],
                ],
              ),
            );
          },
          listener: (context, state) {
            if (state.status == OrderActionsStatus.success) {
              setState(() => _isSwiped = false);
              widget.onActionSucess?.call();
            } else if (state.status == OrderActionsStatus.error) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.errorMessage ?? "An error occurred"),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },
        ),
      ),
    );
  }

  Widget _buildMainCard(ThemeData theme, ColorScheme colorScheme) {
    return GestureDetector(
      key: const ValueKey('main'),
      onHorizontalDragEnd: (details) {
        if ((details.primaryVelocity ?? 0) > 200) {
          setState(() => _isSwiped = true);
        }
      },
      child: BlocConsumer<StatusCubit, StatusState>(
        builder: (context, state) {
          CourseStatus currentStatus = state.newStatus ?? _order.courseStatus;
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            clipBehavior: Clip.antiAlias,
            child: Column(
              children: [
                // ── Header ──────────────────────────────────────────────
                InkWell(
                  onTap: () => setState(() => _isExpanded = !_isExpanded),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 12, 8, 12),
                    child: Row(
                      children: [
                        // Table label + total
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Table ${_order.tableNumber ?? 'N/A'}',
                                style: theme.textTheme.titleMedium,
                              ),
                              const SizedBox(height: 2),
                              Text(
                                'Total: €${_order.total?.toStringAsFixed(2) ?? '-'}',
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: colorScheme.onSurface.withValues(
                                    alpha: 0.7,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (state.status == StatusCubitStatus.loading) ...[
                          Expanded(
                            child: Center(child: CircularProgressIndicator()),
                          ),
                        ],
                        if (state.status == StatusCubitStatus.initial ||
                            state.status == StatusCubitStatus.success ||
                            state.status == StatusCubitStatus.error) ...[
                          _StatusButton(
                            icon: Icons.inbox_outlined,
                            tooltip: 'Received',
                            color: currentStatus == CourseStatus.received
                                ? colorScheme.primary
                                : colorScheme.onSurface.withValues(alpha: 0.5),
                            onPressed: () {
                              context.read<StatusCubit>().updateStatus(
                                CourseStatus.received,
                                _order,
                              );
                            },
                          ),
                          _StatusButton(
                            icon: Icons.local_fire_department,
                            tooltip: 'On Fire',
                            color: currentStatus == CourseStatus.onFire
                                ? colorScheme.primary
                                : colorScheme.onSurface.withValues(alpha: 0.5),
                            onPressed: () {
                              context.read<StatusCubit>().updateStatus(
                                CourseStatus.onFire,
                                _order,
                              );
                            },
                          ),
                          _StatusButton(
                            icon: Icons.check_circle_outline,
                            tooltip: 'Done',
                            color: currentStatus == CourseStatus.finished
                                ? colorScheme.primary
                                : colorScheme.onSurface.withValues(alpha: 0.5),
                            onPressed: () {
                              context.read<StatusCubit>().updateStatus(
                                CourseStatus.finished,
                                _order,
                              );
                            },
                          ),
                        ],
                        // Action buttons

                        // Expand / collapse indicator
                        AnimatedRotation(
                          turns: _isExpanded ? 0.5 : 0,
                          duration: const Duration(milliseconds: 200),
                          child: Icon(
                            Icons.expand_more,
                            color: colorScheme.onSurface.withValues(alpha: 0.5),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // ── Expandable body ─────────────────────────────────────
                AnimatedCrossFade(
                  firstChild: const SizedBox.shrink(),
                  secondChild: _buildExpandedContent(theme, colorScheme),
                  crossFadeState: _isExpanded
                      ? CrossFadeState.showSecond
                      : CrossFadeState.showFirst,
                  duration: const Duration(milliseconds: 250),
                ),
              ],
            ),
          );
        },
        listener: (context, state) {
          if (state.status == StatusCubitStatus.success) {
            setState(() {
              _order = state.updatedOrder!;
            });
          } else if (state.status == StatusCubitStatus.error) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.errorMessage ?? "An error occurred"),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
      ),
    );
  }

  Widget _buildExpandedContent(ThemeData theme, ColorScheme colorScheme) {
    final grouped = _groupByCourse();

    if (grouped.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(16),
        child: Text(
          'No dishes in this order.',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: colorScheme.onSurface.withValues(alpha: 0.5),
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ...grouped.entries.map((entry) {
          final courseNumber = entry.key;
          final items = entry.value;

          return Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Course header
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: colorScheme.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    'Course $courseNumber',
                    style: theme.textTheme.labelLarge?.copyWith(
                      color: colorScheme.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(height: 6),

                // Dish / combination rows
                ...items.map((item) => _buildIndiceRow(item, theme)),
              ],
            ),
          );
        }),
        const SizedBox(height: 8),
      ],
    );
  }

  Widget _buildIndiceRow(CourseIndice item, ThemeData theme) {
    return switch (item) {
      DishIndice d => _DishRow(dish: d, theme: theme),
      CombinationIndice c => _CombinationRow(combination: c, theme: theme),
    };
  }
}

// ── Small private widgets ────────────────────────────────────────────────────

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onPressed;
  final bool isActive;
  final Color activeColor;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.onPressed,
    this.isActive = false,
    this.activeColor = Colors.yellow,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton.filled(
          onPressed: onPressed,
          icon: Icon(icon, size: 24),
          style: IconButton.styleFrom(
            backgroundColor: isActive ? activeColor : Colors.white,
            foregroundColor: isActive
                ? colorScheme.onSecondary
                : colorScheme.primary,
            padding: const EdgeInsets.all(12),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}

class _StatusButton extends StatelessWidget {
  final IconData icon;
  final String tooltip;
  final Color color;
  final VoidCallback? onPressed;

  const _StatusButton({
    required this.icon,
    required this.tooltip,
    required this.color,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(icon, size: 20),
      tooltip: tooltip,
      color: color,
      splashRadius: 20,
      visualDensity: VisualDensity.compact,
      onPressed: onPressed,
    );
  }
}

class _DishRow extends StatelessWidget {
  final DishIndice dish;
  final ThemeData theme;

  const _DishRow({required this.dish, required this.theme});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Quantity badge
          Container(
            width: 28,
            height: 28,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: theme.colorScheme.secondary.withValues(alpha: 0.25),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              '${dish.dishQuantity}x',
              style: theme.textTheme.labelSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.onSecondary,
              ),
            ),
          ),
          const SizedBox(width: 10),

          // Dish name + dimension + ingredients
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        dish.dishName,
                        style: theme.textTheme.bodyMedium,
                      ),
                    ),
                    if (dish.dishDimensionName.isNotEmpty) ...[
                      const SizedBox(width: 6),
                      _DimensionPill(name: dish.dishDimensionName),
                    ],
                  ],
                ),
                // Ingredient pills
                if (dish.dishesWithIngredients.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Wrap(
                      spacing: 6,
                      runSpacing: 4,
                      children: dish.dishesWithIngredients
                          .expand((d) => d.ingredientsName)
                          .map((name) => _IngredientPill(name: name))
                          .toList(),
                    ),
                  ),
              ],
            ),
          ),

          // Price
          Text(
            '€${dish.dishPrice.toStringAsFixed(2)}',
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _CombinationRow extends StatelessWidget {
  final CombinationIndice combination;
  final ThemeData theme;

  const _CombinationRow({required this.combination, required this.theme});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Quantity badge
              Container(
                width: 28,
                height: 28,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: theme.colorScheme.secondary.withValues(alpha: 0.25),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  '${combination.combinationQuantity}x',
                  style: theme.textTheme.labelSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.onSecondary,
                  ),
                ),
              ),
              const SizedBox(width: 10),

              // Combination name + dimension pill
              Expanded(
                child: Row(
                  children: [
                    Flexible(
                      child: Text(
                        combination.combinationDimensionName,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Price
              Text(
                '€${combination.combinationPrice.toStringAsFixed(2)}',
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),

          // Sub-dishes + ingredient pills inside the combination
          if (combination.dishesWithIngredients.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(left: 38, top: 4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: combination.dishesWithIngredients.map((d) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 3),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '• ${d.dishName}',
                          style: theme.textTheme.bodySmall,
                        ),
                        if (d.ingredientsName.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(left: 10, top: 3),
                            child: Wrap(
                              spacing: 6,
                              runSpacing: 4,
                              children: d.ingredientsName
                                  .map((name) => _IngredientPill(name: name))
                                  .toList(),
                            ),
                          ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
        ],
      ),
    );
  }
}

class _DimensionPill extends StatelessWidget {
  final String name;

  const _DimensionPill({required this.name});

  static const _pillBackground = Color(0xFFE3F2FD); // Blue 50
  static const _pillText = Color(0xFF1565C0); // Blue 800

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: _pillBackground,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        name,
        style: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w500,
          color: _pillText,
        ),
      ),
    );
  }
}

class _IngredientPill extends StatelessWidget {
  final String name;

  const _IngredientPill({required this.name});

  static const _pillBackground = Color(0xFFFFCDD2); // Red 100
  static const _pillText = Color(0xFFC62828); // Red 800

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: _pillBackground,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        name,
        style: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w500,
          color: _pillText,
        ),
      ),
    );
  }
}

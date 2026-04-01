import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restaukitchen_app/core/models/dimesnion_assignment.dart';
import 'package:restaukitchen_app/core/models/dish.dart';
import 'package:restaukitchen_app/page/combination_page/bloc/combination_get_cubit/combination_get_cubit.dart';
import 'package:restaukitchen_app/page/combination_page/repository/combination_page_repo.dart';
import 'package:restaukitchen_app/page/menusPage/models/menu.dart';

Future<void> showAddCombinationDialog(
  BuildContext context,
  String combinationId,
) {
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => BlocProvider(
      create: (context) =>
          CombinationGetCubit(combinationPageRepo: CombinationPageRepo())
            ..getCombination(combinationId),
      child: const AddCombinationDialog(),
    ),
  );
}

class AddCombinationDialog extends StatelessWidget {
  const AddCombinationDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return const _AddCombinationDialogBody();
  }
}

class _AddCombinationDialogBody extends StatefulWidget {
  const _AddCombinationDialogBody();

  @override
  State<_AddCombinationDialogBody> createState() =>
      _AddCombinationDialogBodyState();
}

class _AddCombinationDialogBodyState extends State<_AddCombinationDialogBody> {
  final Map<String, TextEditingController> _ratioControllers = {};
  String? _selectedDimensionAssignmentId;
  final Map<String, String> _selectedDishByMenu = {};

  String _assignmentKey(DimensionAssignment assignment) {
    if (assignment.id.isNotEmpty) return assignment.id;
    if (assignment.dimension.id?.isNotEmpty ?? false) return assignment.dimension.id!;
    return assignment.dimension.name;
  }

  String _menuKey(Menu menu) {
    return menu.id;
  }

  String _dishKey(Dish dish) {
    final id = dish.id ?? '';
    if (id.isNotEmpty) return id;
    return dish.name;
  }

  List<Dish> _dishesForMenu(Menu menu, String? selectedDimensionId) {
    if (selectedDimensionId == null || selectedDimensionId.isEmpty) {
      return menu.dishes;
    }
    return menu.dishes.where((dish) {
      final dishAssignments = dish.dimensionAssignments ?? [];
      if (dishAssignments.isEmpty) return true;
      return dishAssignments.any(
        (assignment) => assignment.dimension.id == selectedDimensionId,
      );
    }).toList();
  }

  void _syncSelectedDishesWithMenus(
    List<Menu> menus,
    String? selectedDimensionId,
  ) {
    final availableMenuKeys = menus.map(_menuKey).toSet();
    final removedMenuKeys = _selectedDishByMenu.keys
        .where((menuKey) => !availableMenuKeys.contains(menuKey))
        .toList();
    for (final key in removedMenuKeys) {
      _selectedDishByMenu.remove(key);
    }

    for (final menu in menus) {
      final menuKey = _menuKey(menu);
      final dishes = _dishesForMenu(menu, selectedDimensionId);
      if (dishes.isEmpty) {
        _selectedDishByMenu.remove(menuKey);
        continue;
      }

      final selectedDishKey = _selectedDishByMenu[menuKey];
      final selectedStillAvailable = selectedDishKey != null &&
          dishes.any((dish) => _dishKey(dish) == selectedDishKey);
      if (!selectedStillAvailable) {
        _selectedDishByMenu[menuKey] = _dishKey(dishes.first);
      }
    }
  }

  void _syncStateWithAssignments(List<DimensionAssignment> assignments) {
    final assignmentKeys = assignments
        .map(_assignmentKey)
        .toSet();

    for (final key in assignmentKeys) {
      _ratioControllers.putIfAbsent(key, TextEditingController.new);
    }

    final removedKeys = _ratioControllers.keys
        .where((key) => !assignmentKeys.contains(key))
        .toList();
    for (final key in removedKeys) {
      _ratioControllers.remove(key)?.dispose();
    }

    if (_selectedDimensionAssignmentId == null ||
        !assignmentKeys.contains(_selectedDimensionAssignmentId)) {
      final standardIndex = assignments.indexWhere(
        (assignment) => assignment.dimension.standard,
      );
      final initialAssignment = standardIndex >= 0
          ? assignments[standardIndex]
          : assignments.first;
      _selectedDimensionAssignmentId = _assignmentKey(initialAssignment);
    }
  }

  @override
  void dispose() {
    for (final controller in _ratioControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: BlocBuilder<CombinationGetCubit, CombinationGetState>(
        builder: (context, state) {
          if (state.status == CombinationGetStatus.error) {
            return Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                state.errorMessage ?? 'Failed to load combination',
                textAlign: TextAlign.center,
              ),
            );
          }

          if (state.status != CombinationGetStatus.loaded) {
            return const Padding(
              padding: EdgeInsets.all(16),
              child: Center(
                heightFactor: 1,
                widthFactor: 1,
                child: CircularProgressIndicator(),
              ),
            );
          }

          final combination = state.combination;
          if (combination == null) {
            return const Center(child: Text('No combination data found'));
          }

          final assignments = combination.dimensionAssignments
              .where((assignment) => !assignment.isDeleted)
              .toList();

          if (assignments.isNotEmpty) {
            _syncStateWithAssignments(assignments);
          }
          DimensionAssignment? selectedAssignment;
          if (assignments.isNotEmpty) {
            final selectedIndex = assignments.indexWhere(
              (assignment) =>
                  _assignmentKey(assignment) == _selectedDimensionAssignmentId,
            );
            if (selectedIndex >= 0) {
              selectedAssignment = assignments[selectedIndex];
            }
          }

          _syncSelectedDishesWithMenus(
            combination.menuList,
            selectedAssignment?.dimension.id,
          );

          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  combination.name,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 8),
                if (assignments.isEmpty)
                  const Text('No dimensions available')
                else
                  RadioGroup<String>(
                    groupValue: _selectedDimensionAssignmentId,
                    onChanged: (value) {
                      setState(() {
                        _selectedDimensionAssignmentId = value;
                      });
                    },
                    child: Column(
                      children: assignments.map((assignment) {
                        final assignmentKey = _assignmentKey(assignment);
                        final isSelected =
                            _selectedDimensionAssignmentId == assignmentKey;
                        return Card(
                          margin: const EdgeInsets.only(bottom: 8),
                          child: ListTile(
                            onTap: () => setState(() {
                              _selectedDimensionAssignmentId = assignmentKey;
                            }),
                            leading: Radio<String>(value: assignmentKey,),
                            title: Text(assignment.dimension.name),
                            subtitle: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    'Price: ${assignment.price.toStringAsFixed(2)}',
                                  ),
                                ),
                              ],
                            ),
                            selected: isSelected,
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                if (assignments.isNotEmpty) ...[
                
                  ...combination.menuList.map((menu) {
                    final menuKey = _menuKey(menu);
                    final dishes = _dishesForMenu(
                      menu,
                      selectedAssignment?.dimension.id,
                    );
                    if (dishes.isEmpty) {
                      return Card(
                        margin: const EdgeInsets.only(bottom: 8),
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                menu.name,
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                              const SizedBox(height: 6),
                              const Text(
                                'No plates available for selected dimension',
                              ),
                            ],
                          ),
                        ),
                      );
                    }
                    return Card(
                      margin: const EdgeInsets.only(bottom: 8),
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              menu.name,
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            const SizedBox(height: 8),
                            RadioGroup<String>(
                              groupValue: _selectedDishByMenu[menuKey],
                              onChanged: (value) {
                                if (value == null) return;
                                setState(() {
                                  _selectedDishByMenu[menuKey] = value;
                                });
                              },
                              child: Column(
                                children: dishes.map((dish) {
                                  final dishKey = _dishKey(dish);
                                  return RadioListTile<String>(
                                    dense: true,
                                    contentPadding: EdgeInsets.zero,
                                    value: dishKey,
                                    title: Text(dish.name),
                                  );
                                }).toList(),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
                ],
              ],
            ),
          );
        },
      ),
    );
  }
}

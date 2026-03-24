import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restaukitchen_app/core/components/appBar/details_app_bar.dart';
import 'package:restaukitchen_app/page/combination_page/bloc/combination_get_cubit/combination_get_cubit.dart';
import 'package:restaukitchen_app/page/order_combinations_form/add_dishes_page.dart';
import 'package:restaukitchen_app/page/order_combinations_form/bloc/add_dishes_cubit.dart';

class DimensionsSelectionPage extends StatefulWidget {
  const DimensionsSelectionPage({super.key});

  @override
  State<DimensionsSelectionPage> createState() =>
      _DimensionsSelectionPageState();
}

class _DimensionsSelectionPageState extends State<DimensionsSelectionPage> {
  String? _selectedDimensionId;

  @override
  Widget build(BuildContext context) {
    final combination = context.watch<CombinationGetCubit>().state.combination;
    return Scaffold(
      appBar: DetailsAppBar(pageTitle: combination?.name ?? ''),
      body: BlocBuilder<CombinationGetCubit, CombinationGetState>(
        builder: (context, state) {
          if (state.status == CombinationGetStatus.error) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  state.errorMessage ?? 'Failed to load combination',
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }

          if (state.status != CombinationGetStatus.loaded) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Center(
                  heightFactor: 1,
                  widthFactor: 1,
                  child: CircularProgressIndicator(),
                ),
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

          if (assignments.isEmpty) {
            return const Center(child: Text('No dimensions available'));
          }

          return Center(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 460),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Select the dimension",
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 12),
                    RadioGroup<String>(
                      groupValue: _selectedDimensionId,
                      onChanged: (value) {
                        setState(() {
                          _selectedDimensionId = value;
                        });
                      },
                      child: Column(
                        children: assignments.map((assignment) {
                          final assignmentKey = assignment.dimension.id;
                          final isSelected =
                              _selectedDimensionId == assignmentKey;
                          return Card(
                            margin: const EdgeInsets.only(bottom: 8),
                            child: ListTile(
                              onTap: () => setState(() {
                                _selectedDimensionId = assignmentKey;
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => BlocProvider(
                                      create: (context) => AddDishesCubit(
                                        combination: state.combination,
                                      ),
                                      child: AddDishesPage(
                                        combination: state.combination,
                                        price: assignment.price,
                                        selectedDimensionId: assignmentKey,
                                        combinationDimension:
                                            assignment.dimension,
                                      ),
                                    ),
                                  ),
                                );
                              }),
                              leading: Radio<String>(
                                value: assignmentKey ?? '',
                              ),
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
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:page_transition/page_transition.dart';
import 'package:restaukitchen_app/core/components/appBar/details_app_bar.dart';
import 'package:restaukitchen_app/core/models/dimesnion_assignment.dart';
import 'package:restaukitchen_app/l10n/l10n.dart';
import 'package:restaukitchen_app/page/combination_page/bloc/combination_get_cubit/combination_get_cubit.dart';
import 'package:restaukitchen_app/page/order_combinations_form/select_combinations_dishes_page.dart';
import 'package:restaukitchen_app/page/order_combinations_form/bloc/add_dishes_cubit.dart';

class DimensionsSelectionPage extends StatefulWidget {
  const DimensionsSelectionPage({super.key});

  @override
  State<DimensionsSelectionPage> createState() =>
      _DimensionsSelectionPageState();
}

class _DimensionsSelectionPageState extends State<DimensionsSelectionPage> {
  String? _selectedDimensionId;

  Future<void> _navigateToAddDishesPage(
    String dimensionId,
    CombinationGetState state,
    DimensionAssignment dimensionAssignment,
  ) async {
    final result = await Navigator.of(context).push(
      PageTransition(
        type: PageTransitionType.rightToLeft,
        child: MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (context) =>
                  AddDishesCubit(combination: state.combination),
            ),
            BlocProvider.value(value: context.read<CombinationGetCubit>()),
          ],
          child: SelectCombinationsDishesPage(
            combination: state.combination,
            price: dimensionAssignment.price,
            combinationDimension: dimensionAssignment.dimension,
          ),
        ),
      ),
    );
    if (result != null && mounted) {
      Navigator.pop(context, result);
    }
  }

  @override
  Widget build(BuildContext context) {
    final combination = context.watch<CombinationGetCubit>().state.combination;
    final l10n = context.l10n;
    return Scaffold(
      appBar: DetailsAppBar(pageTitle: combination?.name ?? ''),
      body: BlocBuilder<CombinationGetCubit, CombinationGetState>(
        builder: (context, state) {
          if (state.status == CombinationGetStatus.error) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  state.errorMessage ?? l10n.commonFailedLoadCombination,
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
            return Center(child: Text(l10n.commonNoCombinationDataFound));
          }

          final assignments = combination.dimensionAssignments
              .where((assignment) => !assignment.isDeleted)
              .toList();

          if (assignments.isEmpty) {
            return Center(child: Text(l10n.commonNoDimensionsAvailable));
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
                      l10n.orderFormSelectDimension,
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
                        children: assignments.map((dimensionAssgnment) {
                          final assignmentKey = dimensionAssgnment.dimension.id;
                          final isSelected =
                              _selectedDimensionId == assignmentKey;
                          return Card(
                            margin: const EdgeInsets.only(bottom: 8),
                            child: ListTile(
                              onTap: () => setState(() {
                                _selectedDimensionId = assignmentKey;
                                _navigateToAddDishesPage(
                                  _selectedDimensionId ?? '',
                                  state,
                                  dimensionAssgnment,
                                );
                              }),
                              leading: Radio<String>(
                                value: assignmentKey ?? '',
                              ),
                              title: Text(dimensionAssgnment.dimension.name),
                              subtitle: Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      l10n.commonPriceLabel(
                                        dimensionAssgnment.price.toStringAsFixed(2),
                                      ),
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

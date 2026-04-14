import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restaukitchen_app/core/components/form/dimensionInput/dimension_assignments.dart';
import 'package:restaukitchen_app/core/components/form/dimensionInput/dimension_cubit.dart';
import 'package:restaukitchen_app/core/components/form/dimensionInput/dimensions_dialog.dart';
import 'package:restaukitchen_app/core/dialogs/snack_bar.dart';
import 'package:restaukitchen_app/page/dimension_list/bloc/get_dimensions_cubit.dart';
import 'package:restaukitchen_app/theme/light_theme.dart';

class DimensionInput extends StatefulWidget {
  const DimensionInput({super.key, this.dimensionAssignments});
  final List<DimensionAssignments>? dimensionAssignments;
  @override
  State<DimensionInput> createState() => _DimensionInputState();
}

class _DimensionInputState extends State<DimensionInput> {
  final Map<int, TextEditingController> _priceControllers = {};
  int _previousAssignmentsLength = 0;

  @override
  void initState() {
    super.initState();
    // context.read<DimensionCubit>().getDimensions();
    context.read<GetDimensionsCubit>().getDimensions();
  }

  @override
  void dispose() {
    // Dispose all controllers
    for (var controller in _priceControllers.values) {
      controller.dispose();
    }
    _priceControllers.clear();
    super.dispose();
  }

  void _updateControllers(DimensionState state) {
    if (state.dimensionAssignments == null) {
      // Dispose all controllers if assignments are cleared
      for (var controller in _priceControllers.values) {
        controller.dispose();
      }
      _priceControllers.clear();
      _previousAssignmentsLength = 0;
      return;
    }

    final assignments = state.dimensionAssignments!;
    final currentLength = assignments.length;

    // If the list length changed, rebuild all controllers to handle index shifts
    if (currentLength != _previousAssignmentsLength) {
      // Dispose all existing controllers
      for (var controller in _priceControllers.values) {
        controller.dispose();
      }
      _priceControllers.clear();

      // Create new controllers for all assignments
      for (int i = 0; i < assignments.length; i++) {
        final assignment = assignments[i];
        final priceText = assignment.price?.toString() ?? '';
        _priceControllers[i] = TextEditingController(text: priceText);
      }

      _previousAssignmentsLength = currentLength;
      return;
    }

    // List length hasn't changed, just ensure controllers exist
    // Don't update text here - let the TextField handle it naturally
    // This preserves focus and cursor position when user is typing
    for (int i = 0; i < assignments.length; i++) {
      if (!_priceControllers.containsKey(i)) {
        // Create new controller if it doesn't exist (shouldn't happen normally)
        final assignment = assignments[i];
        final priceText = assignment.price?.toString() ?? '';
        _priceControllers[i] = TextEditingController(text: priceText);
      }
      // Note: We don't update existing controller text here because:
      // 1. If user is typing, the controller already has the latest value
      // 2. Updating would cause cursor to jump and focus to be lost
      // 3. The state is already updated via onChanged callback
    }
  }

  Widget _buildDimensionPreviewRow({
    required BuildContext context,
    required int index,
    required DimensionAssignments assignment,
    required TextEditingController controller,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      padding: EdgeInsets.all(10),
      child: Row(
        children: [
          Expanded(
            child: Text(
              assignment.dimension.name.toUpperCase(),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w700,
                letterSpacing: 0.2,
              ),
            ),
          ),
          Text(
            '\$',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.grey[700],
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(width: 12),
          SizedBox(
            width: 100,
            height: 50,
            child: TextField(
              controller: controller,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              textAlign: TextAlign.end,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 0,
                  vertical: 10,
                ),
                // hintText: '0.00',
                // hintStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
                //   fontWeight: FontWeight.w600,
                //   color: Colors.grey[600],
                // ),
                border: InputBorder.none,
              ),
              onChanged: (value) {
                context.read<DimensionCubit>().updatePrice(index, value);
              },
            ),
          ),
          const SizedBox(width: 16),
          IconButton(
            onPressed: () {
              context.read<DimensionCubit>().removeDimensionAssignment(index);
            },
            icon: Icon(
              Icons.delete_outline_rounded,
              color: Colors.red,
              size: 20,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<GetDimensionsCubit, GetDimensionsState>(
      builder: (context, dimesionGetstate) {
        if (dimesionGetstate.status == GetDimensionsStatus.loading) {
          return Center(child: CircularProgressIndicator());
        }
        if (dimesionGetstate.status == GetDimensionsStatus.error) {
          return Center(
            child: Text(
              dimesionGetstate.errorMessage ?? 'Error loading dimensions',
            ),
          );
        }
        return BlocBuilder<DimensionCubit, DimensionState>(
          builder: (context, dimesnionsFromState) {
            // Update controllers when state changes
            _updateControllers(dimesnionsFromState);
            if (dimesnionsFromState.status == DimensionStateStatus.loading) {
              return Center(child: CircularProgressIndicator());
            }
            if (dimesnionsFromState.status == DimensionStateStatus.loaded) {
              bool emtyDimensions =
                  dimesnionsFromState.availableDimensions!.isEmpty;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  if (dimesnionsFromState.availableDimensions!.isNotEmpty)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () async {
                            if (emtyDimensions) return;
                            final result = await showDialog(
                              context: context,
                              builder: (context) => DimensionsDialog(
                                dimensions:
                                    dimesnionsFromState.availableDimensions!,
                              ),
                            );
                            if (result != null && context.mounted) {
                              context
                                  .read<DimensionCubit>()
                                  .addNewDimensionAssigment(result);
                            }
                          },
                          child: Row(
                            children: [
                              Icon(
                                Icons.add_circle,
                                size: 20,
                                color: emtyDimensions
                                    ? Colors.grey[400]
                                    : LightTheme.primaryColor,
                              ),
                              Text(
                                "ADD DIMENSION",
                                style: Theme.of(context).textTheme.bodyMedium
                                    ?.copyWith(
                                      color: emtyDimensions
                                          ? Colors.grey[400]
                                          : LightTheme.primaryColor,
                                      fontWeight: FontWeight.w600,
                                    ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  const SizedBox(height: 6),
                  if (dimesnionsFromState.status ==
                          DimensionStateStatus.loaded &&
                      dimesnionsFromState.dimensionAssignments != null) ...[
                    ...dimesnionsFromState.dimensionAssignments!
                        .asMap()
                        .entries
                        .map((entry) {
                          final index = entry.key;
                          final assignment = entry.value;
                          final priceController = _priceControllers[index]!;

                          return Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: _buildDimensionPreviewRow(
                              context: context,
                              index: index,
                              assignment: assignment,
                              controller: priceController,
                            ),
                          );
                        }),
                  ],
                ],
              );
            }
            return SizedBox.shrink();
          },
        );
      },
      listener: (context, state) {
        if (state.status == GetDimensionsStatus.loaded) {
          context.read<DimensionCubit>().init(
            widget.dimensionAssignments,
            state.dimensions ?? [],
          );
        }
        if (state.status == GetDimensionsStatus.error) {
          AppSnackBar.showError(
            context,
            state.errorMessage ?? 'Error loading dimensions',
          );
        }
      },
    );
  }
}

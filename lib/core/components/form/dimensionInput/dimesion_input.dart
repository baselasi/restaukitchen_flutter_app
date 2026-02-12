import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restaukitchen_app/core/components/form/dimensionInput/dimension.dart';
import 'package:restaukitchen_app/core/components/form/dimensionInput/dimension_cubit.dart';
import 'package:restaukitchen_app/core/components/form/input_field.dart';

class DimensionInput extends StatefulWidget {
  const DimensionInput({super.key});

  @override
  State<DimensionInput> createState() => _DimensionInputState();
}

class _DimensionInputState extends State<DimensionInput> {
  final Map<int, TextEditingController> _priceControllers = {};
  int _previousAssignmentsLength = 0;

  @override
  void initState() {
    super.initState();
    context.read<DimensionCubit>().getDimensions();
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

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DimensionCubit, DimensionState>(
      builder: (context, state) {
        // Update controllers when state changes
        _updateControllers(state);

        return Column(
          children: [
            if (state.status == DimensionStateStatus.loaded)
              InputDecorator(
                decoration: InputDecoration(
                  hintText: "Select Language",
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.grey[300]!),
                  ),

                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(
                      color: Color(0xFF0047AB),
                      width: 2,
                    ),
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    hint: Text(
                      "Select Language",
                      style: Theme.of(
                        context,
                      ).textTheme.bodyMedium?.copyWith(color: Colors.black),
                    ),
                    isExpanded: true,
                    style: Theme.of(context).textTheme.bodyMedium,
                    icon: Icon(Icons.arrow_drop_down, color: Colors.grey[600]),
                    items: state.availableDimensions!.map((dimension) {
                      return DropdownMenuItem(
                        value: dimension.name,
                        child: Text(dimension.name),
                      );
                    }).toList(),
                    onChanged: (value) {
                      Dimension dimension = state.allDimensions!.firstWhere(
                        (element) => element.name == value,
                      );
                      context.read<DimensionCubit>().addNewDimensionAssigment(
                        dimension,
                      );
                    },
                  ),
                ),
              ),

            if (state.status == DimensionStateStatus.loaded &&
                state.dimensionAssignments != null)
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: state.dimensionAssignments!.length,
                itemBuilder: (context, index) {
                  final assignment = state.dimensionAssignments![index];
                  final priceController = _priceControllers[index]!;

                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Dimension name
                        Text(
                          assignment.dimension.name,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        const SizedBox(height: 8),
                        // Row with price input and delete button
                        Row(
                          children: [
                            // Price input
                            Expanded(
                              child: InputField(
                                controller: priceController,
                                label: "Price",
                                keyboardType: TextInputType.numberWithOptions(),
                                onChanged: (value) {
                                  context.read<DimensionCubit>().updatePrice(
                                    index,
                                    value,
                                  );
                                },
                              ),
                            ),
                            const SizedBox(width: 8),
                            // Delete button
                            IconButton(
                              icon: Icon(Icons.delete, color: Colors.red),
                              onPressed: () {
                                context
                                    .read<DimensionCubit>()
                                    .removeDimensionAssignment(index);
                              },
                              tooltip: 'Remove ${assignment.dimension.name}',
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
          ],
        );
      },
    );
  }
}

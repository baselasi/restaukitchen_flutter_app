import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:restaukitchen_app/core/components/form/dimensionInput/dimension.dart';
import 'package:restaukitchen_app/core/components/form/dimensionInput/dimension_assignments.dart';
import 'package:restaukitchen_app/core/components/form/dimensionInput/dimension_repo.dart';

class DimensionCubit extends Cubit<DimensionState> {
  DimensionCubit()
    : super(DimensionState(status: DimensionStateStatus.initial));

  Future<void> getDimensions() async {
    emit(DimensionState(status: DimensionStateStatus.loading));
    try {
      final dimensions = await DimensionRepo().getDimensions();
      emit(
        DimensionState(
          allDimensions: dimensions.dimensions,
          status: DimensionStateStatus.loaded,
          availableDimensions: dimensions.dimensions,
        ),
      );
    } catch (e) {
      emit(DimensionState(status: DimensionStateStatus.error));
    }
  }

  void addNewDimensionAssigment(Dimension dimension) {
    final newDimensionAssignment = DimensionAssignments(
      dimension: dimension,
      price: null,
    );
    final availableDimensions = state.availableDimensions
        ?.where((element) => element.id != dimension.id)
        .toList();
    emit(
      DimensionState(
        dimensionAssignments: [
          ...state.dimensionAssignments ?? [],
          newDimensionAssignment,
        ],
        status: DimensionStateStatus.loaded,
        allDimensions: state.allDimensions,
        availableDimensions: availableDimensions,
      ),
    );
  }

  void updatePrice(int index, String price) {
    final updatedAssignments = List<DimensionAssignments>.from(
      state.dimensionAssignments ?? [],
    );
    if (index >= 0 && index < updatedAssignments.length) {
      updatedAssignments[index] = DimensionAssignments(
        id: updatedAssignments[index].id,
        dimension: updatedAssignments[index].dimension,
        price: price,
        deleted: updatedAssignments[index].deleted,
      );
      emit(
        DimensionState(
          dimensionAssignments: updatedAssignments,
          status: DimensionStateStatus.loaded,
          allDimensions: state.allDimensions,
          availableDimensions: state.availableDimensions,
        ),
      );
    }
  }

  void removeDimensionAssignment(int index) {
    final assignment = state.dimensionAssignments?[index];
    if (assignment != null) {
      final updatedAssignments = List<DimensionAssignments>.from(
        state.dimensionAssignments ?? [],
      );
      updatedAssignments.removeAt(index);

      final List<Dimension> availableDimensions = [
        ...state.availableDimensions ?? [],
        assignment.dimension,
      ];

      emit(
        DimensionState(
          dimensionAssignments: updatedAssignments,
          status: DimensionStateStatus.loaded,
          allDimensions: state.allDimensions,
          availableDimensions: availableDimensions,
        ),
      );
    }
  }
}

enum DimensionStateStatus { initial, loading, loaded, error }

class DimensionState extends Equatable {
  final List<Dimension>? allDimensions;
  final List<Dimension>? availableDimensions;
  final List<DimensionAssignments>? dimensionAssignments;
  final DimensionStateStatus status;
  const DimensionState({
    this.allDimensions,
    this.availableDimensions,
    this.dimensionAssignments,
    required this.status,
  });

  @override
  List<Object?> get props => [
    allDimensions,
    availableDimensions,
    dimensionAssignments,
  ];
}

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:restaukitchen_app/core/components/form/dimensionInput/dimension.dart';
import 'package:restaukitchen_app/core/components/form/dimensionInput/dimension_assignments.dart';
import 'package:restaukitchen_app/core/components/form/dimensionInput/dimension_repo.dart';

class DimensionCubit extends Cubit<DimensionState> {
  DimensionCubit({List<DimensionAssignments>? dimensionAssignments})
    : super(
        DimensionState(
          status: DimensionStateStatus.initial,
          isEmpty: dimensionAssignments == null || dimensionAssignments.isEmpty,
          dimensionAssignments: dimensionAssignments,
        ),
      );

  Future<void> getDimensions() async {
    emit(
      DimensionState(
        status: DimensionStateStatus.loading,
        isEmpty:
            state.dimensionAssignments == null ||
            state.dimensionAssignments!.isEmpty,
        dimensionAssignments: state.dimensionAssignments,
      ),
    );
    try {
      final dimensions = await DimensionRepo().getDimensions();
      emit(
        DimensionState(
          allDimensions: dimensions.dimensions,
          status: DimensionStateStatus.loaded,
          dimensionAssignments: state.dimensionAssignments,
          availableDimensions: dimensions.dimensions,
          isEmpty:
              state.dimensionAssignments == null ||
              state.dimensionAssignments!.isEmpty,
        ),
      );
    } catch (e) {
      emit(
        DimensionState(
          status: DimensionStateStatus.error,
          isEmpty:
              state.dimensionAssignments == null ||
              state.dimensionAssignments!.isEmpty,
          dimensionAssignments: state.dimensionAssignments,
        ),
      );
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
        isEmpty: true,
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
          isEmpty: updatedAssignments.any(
            (dimensionAssignment) => dimensionAssignment.price?.isEmpty ?? true,
          ),
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
          isEmpty: !updatedAssignments.any(
            (dimensionAssignment) => dimensionAssignment.price == null,
          ),
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
  final bool isEmpty;
  const DimensionState({
    this.allDimensions,
    this.availableDimensions,
    this.dimensionAssignments,
    required this.status,
    required this.isEmpty,
  });

  @override
  List<Object?> get props => [
    allDimensions,
    availableDimensions,
    dimensionAssignments,
    isEmpty,
  ];
}

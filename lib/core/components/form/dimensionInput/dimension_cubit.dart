import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:restaukitchen_app/core/components/form/dimensionInput/dimension.dart';
import 'package:restaukitchen_app/core/components/form/dimensionInput/dimension_assignments.dart';

class DimensionCubit extends Cubit<DimensionState> {
  DimensionCubit()
    : super(
        DimensionState(
          status: DimensionStateStatus.initial,
          isEmpty: true,
          dimensionAssignments: [],
        ),
      );

  Future<void> init(
    List<DimensionAssignments>? dimensionAssignments,
    List<Dimension> allDimensions,
  ) async {
    final Dimension standardDimension = allDimensions.firstWhere(
      (element) => element.standard,
    );
    List<Dimension> availableDimensions = [];
    if (dimensionAssignments == null || dimensionAssignments.isEmpty) {
      dimensionAssignments = [
        DimensionAssignments(dimension: standardDimension),
      ];
      availableDimensions.addAll(
        allDimensions
            .where((element) => element.id != standardDimension.id)
            .toList(),
      );
    } else {
      availableDimensions = allDimensions
          .where(
            (element) => !dimensionAssignments!.any(
              (assignment) => assignment.dimension.id != element.id,
            ),
          )
          .toList();
    }
    emit(
      DimensionState(
        allDimensions: allDimensions,
        availableDimensions: availableDimensions,
        status: DimensionStateStatus.loaded,
        isEmpty: dimensionAssignments.isEmpty,
        dimensionAssignments: dimensionAssignments,
      ),
    );
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

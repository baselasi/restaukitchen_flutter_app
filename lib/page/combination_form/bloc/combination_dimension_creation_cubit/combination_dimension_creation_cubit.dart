import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restaukitchen_app/core/components/form/dimensionInput/dimension.dart';
import 'package:restaukitchen_app/core/models/dimesnion_assignment.dart';
import 'package:restaukitchen_app/page/combination_page/models/combination.dart';

/// Key is dimension [Dimension.id] when present, otherwise [Dimension.name].
class DimensionWithPrice extends Equatable {
  final Dimension dimension;
  final String price;

  const DimensionWithPrice({required this.dimension, this.price = ''});

  factory DimensionWithPrice.fromCombinationDimension(
    DimensionAssignment dimensionAssignment,
  ) {
    return DimensionWithPrice(
      dimension: dimensionAssignment.dimension,
      price: dimensionAssignment.price.toString(),
    );
  }

  DimensionWithPrice copyWith({Dimension? dimension, String? price}) {
    return DimensionWithPrice(
      dimension: dimension ?? this.dimension,
      price: price ?? this.price,
    );
  }

  @override
  List<Object?> get props => [dimension, price];
}

class CombinationDimensionCreationCubit
    extends Cubit<CombinationDimensionCreationState> {
  CombinationDimensionCreationCubit()
    : super(CombinationDimensionCreationState.initial());

  void createStateFromCombination(Combination combination) {
    final dimensionsById = <String, DimensionWithPrice>{};
    for (final dimensionAssignment in combination.dimensionAssignments) {
      dimensionsById[dimensionAssignment.dimension.id!] =
          DimensionWithPrice.fromCombinationDimension(dimensionAssignment);
    }
    emit(
      CombinationDimensionCreationState(
        dimensionsById: dimensionsById,
        combinationName: combination.name,
        formHasChanged: false,
      ),
    );
  }

  void setCombinationName(String? name) {
    emit(state.copyWith(combinationName: name, formHasChanged: true));
  }

  /// [id] should match [dimension.id] ?? [dimension.name] for stable keys.
  void setDimensionEntry(String id, Dimension dimension, {String? price}) {
    emit(
      state.copyWith(
        dimensionsById: Map.from(state.dimensionsById)
          ..[id] = DimensionWithPrice(dimension: dimension, price: price ?? ''),
        formHasChanged: true,
      ),
    );
  }

  void removeDimensionEntry(String id) {
    emit(
      state.copyWith(
        dimensionsById: Map.from(state.dimensionsById)..remove(id),
        formHasChanged: true,
      ),
    );
  }

  void updatePrice(String id, String price) {
    final entry = state.dimensionsById[id];
    if (entry == null) return;
    final next = Map<String, DimensionWithPrice>.from(state.dimensionsById);
    next[id] = entry.copyWith(price: price);
    emit(state.copyWith(dimensionsById: next, formHasChanged: true));
  }
}

class CombinationDimensionCreationState extends Equatable {
  final Map<String, DimensionWithPrice> dimensionsById;
  final String? combinationName;
  final bool? formHasChanged;

  const CombinationDimensionCreationState({
    required this.dimensionsById,
    this.combinationName,
    this.formHasChanged = false,
  });

  factory CombinationDimensionCreationState.initial() {
    return const CombinationDimensionCreationState(
      dimensionsById: {},
      combinationName: null,
    );
  }

  CombinationDimensionCreationState copyWith({
    Map<String, DimensionWithPrice>? dimensionsById,
    String? combinationName,
    bool? formHasChanged,
  }) {
    return CombinationDimensionCreationState(
      dimensionsById: dimensionsById ?? this.dimensionsById,
      combinationName: combinationName ?? this.combinationName,
      formHasChanged: formHasChanged ?? this.formHasChanged,
    );
  }

  bool get isValid {
    if (combinationName == null || combinationName!.trim().isEmpty) {
      return false;
    }
    if (dimensionsById.isEmpty) return false;
    for (final entry in dimensionsById.values) {
      final dimensionId = entry.dimension.id;
      if (dimensionId == null || dimensionId.trim().isEmpty) {
        return false;
      }
      if (double.tryParse(entry.price.trim()) == null) {
        return false;
      }
    }
    return true;
  }

  @override
  List<Object?> get props => [dimensionsById, combinationName];
}

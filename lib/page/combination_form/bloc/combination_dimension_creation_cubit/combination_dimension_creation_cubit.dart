import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restaukitchen_app/core/components/form/dimensionInput/dimension.dart';

/// Key is dimension [Dimension.id] when present, otherwise [Dimension.name].
class DimensionWithPrice extends Equatable {
  final Dimension dimension;
  final String price;

  const DimensionWithPrice({required this.dimension, this.price = ''});

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

  void setCombinationName(String? name) {
    emit(state.copyWith(combinationName: name));
  }

  /// [id] should match [dimension.id] ?? [dimension.name] for stable keys.
  void setDimensionEntry(String id, Dimension dimension, {String? price}) {
    emit(
      state.copyWith(
        dimensionsById: Map.from(state.dimensionsById)
          ..[id] = DimensionWithPrice(dimension: dimension, price: price ?? ''),
      ),
    );
  }

  void removeDimensionEntry(String id) {
    emit(
      state.copyWith(
        dimensionsById: Map.from(state.dimensionsById)..remove(id),
      ),
    );
  }

  void updatePrice(String id, String price) {
    final entry = state.dimensionsById[id];
    if (entry == null) return;
    final next = Map<String, DimensionWithPrice>.from(state.dimensionsById);
    next[id] = entry.copyWith(price: price);
    emit(state.copyWith(dimensionsById: next));
  }
}

class CombinationDimensionCreationState extends Equatable {
  final Map<String, DimensionWithPrice> dimensionsById;
  final String? combinationName;

  const CombinationDimensionCreationState({
    required this.dimensionsById,
    this.combinationName,
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
  }) {
    return CombinationDimensionCreationState(
      dimensionsById: dimensionsById ?? this.dimensionsById,
      combinationName: combinationName ?? this.combinationName,
    );
  }

  @override
  List<Object?> get props => [dimensionsById, combinationName];
}

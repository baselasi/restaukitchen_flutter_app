import 'package:equatable/equatable.dart';
import 'package:restaukitchen_app/page/combination_form/bloc/combination_dimension_creation_cubit/combination_dimension_creation_cubit.dart';

class CreateCombinationRequest extends Equatable {
  final String name;
  final List<String> menuIds;
  final List<CombinationDimensionPayload> dimensions;

  const CreateCombinationRequest({
    required this.name,
    required this.menuIds,
    required this.dimensions,
  });

  factory CreateCombinationRequest.fromFormState(
    CombinationDimensionCreationState formState,
  ) {
    return CreateCombinationRequest(
      name: formState.combinationName!,
      menuIds: [],
      dimensions: formState.dimensionsById.values
          .map(
            (e) => CombinationDimensionPayload(
              dimensionId: e.dimension.id!,
              price: double.parse(e.price),
            ),
          )
          .toList(),
    );
  }

  factory CreateCombinationRequest.fromJson(Map<String, dynamic> json) {
    return CreateCombinationRequest(
      name: json['name'] as String? ?? '',
      menuIds: (json['menuIds'] as List<dynamic>? ?? [])
          .map((e) => e.toString())
          .toList(),
      dimensions: (json['dimensions'] as List<dynamic>? ?? [])
          .map(
            (e) =>
                CombinationDimensionPayload.fromJson(e as Map<String, dynamic>),
          )
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'menuIds': menuIds,
      'dimensions': dimensions.map((e) => e.toJson()).toList(),
    };
  }

  @override
  List<Object?> get props => [name, menuIds, dimensions];
}

class CombinationDimensionPayload extends Equatable {
  final String dimensionId;
  final double price;

  const CombinationDimensionPayload({
    required this.dimensionId,
    required this.price,
  });

  factory CombinationDimensionPayload.fromJson(Map<String, dynamic> json) {
    return CombinationDimensionPayload(
      dimensionId: json['dimensionId'] as String,
      price: (json['price'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {'dimensionId': dimensionId, 'price': price};
  }

  @override
  List<Object?> get props => [dimensionId, price];
}

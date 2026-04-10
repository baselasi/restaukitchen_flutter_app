import 'package:equatable/equatable.dart';
import 'package:restaukitchen_app/page/ingredients_list/bloc/new_ingredient_form_cubit.dart';

class IngredientPostRequest {
  final String name;
  final List<DimensionPayload> dimensions;

  const IngredientPostRequest({required this.name, required this.dimensions});

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'dimensions': dimensions.map((e) => e.toJson()).toList(),
    };
  }

  factory IngredientPostRequest.fromFormState(
    NewIngredientFormState formState,
  ) {
    return IngredientPostRequest(
      name: formState.name,
      dimensions: formState.dimensionsById.values
          .map(
            (e) => DimensionPayload(
              dimensionId: e.dimension.id!,
              price: e.price,
              name: e.dimension.name,
            ),
          )
          .toList(),
    );
  }
}

class DimensionPayload extends Equatable {
  final String dimensionId;
  final String price;
  final String name;
  const DimensionPayload({
    required this.dimensionId,
    required this.price,
    required this.name,
  });

  Map<String, dynamic> toJson() {
    return {'dimensionId': dimensionId, 'price': price, 'name': name};
  }

  @override
  List<Object?> get props => [dimensionId, price, name];
}

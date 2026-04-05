import 'package:restaukitchen_app/core/models/base_post_response.dart';

/// Parsed body returned after creating a combination (POST success).
class CreateCombinationResponse extends BasePostResponse {
  const CreateCombinationResponse({
    required super.id,
    required super.name,
    required super.restaurant,
    required super.deleted,
  });

  factory CreateCombinationResponse.fromJson(Map<String, dynamic> json) {
    final base = BasePostResponse.fromJson(json);
    return CreateCombinationResponse(
      id: base.id,
      name: base.name,
      restaurant: base.restaurant,
      deleted: base.deleted,
    );
  }
}

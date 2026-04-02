import 'package:equatable/equatable.dart';

/// Parsed body returned after creating a combination (POST success).
class CreateCombinationResponse extends Equatable {
  final String id;
  final String name;
  final String restaurant;
  final bool deleted;

  const CreateCombinationResponse({
    required this.id,
    required this.name,
    required this.restaurant,
    required this.deleted,
  });

  factory CreateCombinationResponse.fromJson(Map<String, dynamic> json) {
    return CreateCombinationResponse(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      restaurant: json['restaurant'] as String? ?? '',
      deleted: json['deleted'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'restaurant': restaurant,
      'deleted': deleted,
    };
  }

  @override
  List<Object?> get props => [id, name, restaurant, deleted];
}

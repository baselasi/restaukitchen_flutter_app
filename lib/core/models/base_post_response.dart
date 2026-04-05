import 'package:equatable/equatable.dart';

/// Shared shape for successful POST responses: entity id, name, restaurant id, soft-delete flag.
class BasePostResponse extends Equatable {
  final String id;
  final String name;
  final String restaurant;
  final bool deleted;

  const BasePostResponse({
    required this.id,
    required this.name,
    required this.restaurant,
    required this.deleted,
  });

  factory BasePostResponse.fromJson(Map<String, dynamic> json) {
    return BasePostResponse(
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

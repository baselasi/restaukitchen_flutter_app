import 'package:equatable/equatable.dart';
import 'package:restaukitchen_app/core/models/dish.dart';

class SilverwareResponse extends Equatable {
  final List<Dish> silverwares;
  final String? id;
  final String? name;
  final String? restaurant;
  const SilverwareResponse({
    required this.silverwares,
    required this.id,
    required this.name,
    required this.restaurant,
  });

  factory SilverwareResponse.fromJson(Map<String, dynamic> json) {
    return SilverwareResponse(
      silverwares:
          (json['utensils'] as List<dynamic>?)
              ?.map((e) => Dish.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      id: json['id'] as String?,
      name: json['name'] as String?,
      restaurant: json['restaurant'] as String?,
    );
  }

  @override
  List<Object?> get props => [id, name, restaurant, silverwares];
}

import 'package:equatable/equatable.dart';

class Restaurant extends Equatable {
  final String id;
  final String name;
  final String street;
  final String city;
  final String country;
  final String cityId;
  final String description;
  final String currency;
  final List<String> restaurantImage;

  const Restaurant({
    required this.id,
    required this.name,
    required this.street,
    required this.city,
    required this.country,
    required this.cityId,
    required this.description,
    required this.currency,
    required this.restaurantImage,
  });

  factory Restaurant.fromJson(Map<String, dynamic> json) {
    return Restaurant(
      id: json['id'] as String,
      name: json['name'] as String,
      street: json['street'] as String,
      city: json['city'] as String,
      country: json['country'] as String,
      cityId: json['cityId'] as String,
      description: json['description'] as String,
      currency: json['currency'] as String,
      restaurantImage: (json['restaurantImage'] as List<dynamic>? ?? [])
          .map((e) => e as String)
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'street': street,
      'city': city,
      'country': country,
      'cityId': cityId,
      'description': description,
      'currency': currency,
      'restaurantImage': restaurantImage,
    };
  }

  @override
  List<Object?> get props => [
    id,
    name,
    street,
    city,
    country,
    cityId,
    description,
    currency,
    restaurantImage,
  ];
}

class RestaurantResponse extends Equatable {
  final Restaurant restaurant;

  const RestaurantResponse({required this.restaurant});

  factory RestaurantResponse.fromJson(Map<String, dynamic> json) {
    return RestaurantResponse(restaurant: Restaurant.fromJson(json));
  }

  @override
  List<Object?> get props => [restaurant];
}

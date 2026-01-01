import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:restaukitchen_app/core/models/dish.dart';

class Menu extends Equatable {
  final String id;
  final String name;
  final bool combination;
  final List<Dish> dishes;

  const Menu({
    required this.id,
    required this.name,
    required this.combination,
    required this.dishes,
  });

  factory Menu.fromJson(Map<String, dynamic> json) {
    return Menu(
      id: json['id'] as String,
      name: json['name'] as String,
      combination: json['combination'] as bool,
      dishes: json['dishes'] != null
          ? (jsonDecode(json['dishes']) as List)
                .map((dish) => Dish.fromJson(jsonDecode(dish)))
                .toList()
          : [],
    );
  }

  // Convert Menu to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'combination': combination,
      'dishes': dishes.map((dish) => dish.toJson()).toList(),
    };
  }

  @override
  List<Object?> get props => [id, name, combination, dishes];
}


class MenuResponse extends Equatable {
  final List<Menu> menus;

  const MenuResponse({
    required this.menus,
  });

  // Factory constructor to create MenuResponse from JSON array
  factory MenuResponse.fromJson(List<dynamic> json) {
    return MenuResponse(
      menus: json
          .map((menu) => Menu.fromJson(menu as Map<String, dynamic>))
          .toList(),
    );
  }

  // Convert MenuResponse to JSON array
  List<Map<String, dynamic>> toJson() {
    return menus.map((menu) => menu.toJson()).toList();
  }

  // Copy with method for immutable updates
  MenuResponse copyWith({
    List<Menu>? menus,
  }) {
    return MenuResponse(
      menus: menus ?? this.menus,
    );
  }

  @override
  List<Object?> get props => [menus];
}

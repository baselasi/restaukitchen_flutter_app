import 'package:equatable/equatable.dart';
import 'package:restaukitchen_app/core/models/dish.dart';
import 'package:restaukitchen_app/core/models/ingredients.dart';
import 'package:restaukitchen_app/page/menusPage/models/menu_scroll_bar_item.dart';

class Menu extends Equatable {
  final String id;
  final String name;
  final bool combination;
  final List<Dish> dishes;
  final List<Ingredient> ingredients;

  const Menu({
    required this.id,
    required this.name,
    required this.combination,
    required this.dishes,
    required this.ingredients,
  });

  factory Menu.fromJson(Map<String, dynamic> json) {
    return Menu(
      id: json['id'] as String,
      name: json['name'] as String,
      combination: json['combination'] as bool,
      dishes: json['dish'] != null
          ? (json['dish'] as List).map((dish) => Dish.fromJson(dish)).toList()
          : [],
      ingredients: json['ingredients'] != null
          ? (json['ingredients'] as List)
                .map((ingredient) => Ingredient.fromJson(ingredient))
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
      'dish': dishes.map((dish) => dish.toJson()).toList(),
      // 'ingredients': ingredients.map((ingredient) => ingredient.toJson()).toList(),
    };
  }

  MenuScrollBarItem toMenuScrollBarItem() {
    return MenuScrollBarItem(id: id, name: name, isCombination: false);
  }

  @override
  List<Object?> get props => [id, name, combination, dishes, ingredients];
}

class MenuResponse extends Equatable {
  final List<Menu> menus;

  const MenuResponse({required this.menus});

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
  MenuResponse copyWith({List<Menu>? menus}) {
    return MenuResponse(menus: menus ?? this.menus);
  }

  @override
  List<Object?> get props => [menus];
}

class CreateMenuRequest extends Equatable {
  final String name;
  final String? id;
  const CreateMenuRequest({required this.name,  this.id});

  factory CreateMenuRequest.fromJson(Map<String, dynamic> json) {
    return CreateMenuRequest(
      name: json['name'] as String,
      id: json['id'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {'name': name, if (id != null) 'id': id};
  }

  @override
  List<Object?> get props => [name];
}

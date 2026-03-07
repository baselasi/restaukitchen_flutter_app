import 'package:equatable/equatable.dart';
import 'package:restaukitchen_app/page/combination_page/models/menu_combination.dart';
import 'package:restaukitchen_app/page/menusPage/models/menu.dart';

class Combination extends Equatable {
  final String id;
  final String name;
  final int limits;
  final String restaurant;
  final List<DimensionAssignment> dimensionAssignments;
  final List<Menu> menuList;

  const Combination({
    required this.id,
    required this.name,
    required this.limits,
    required this.restaurant,
    required this.dimensionAssignments,
    required this.menuList,
  });

  factory Combination.fromJson(Map<String, dynamic> json) {
    return Combination(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      limits: json['limits'] as int? ?? 0,
      restaurant: json['restaurant'] as String? ?? '',
      dimensionAssignments:
          (json['dimensionAssignments'] as List<dynamic>? ?? [])
              .map(
                (item) =>
                    DimensionAssignment.fromJson(item as Map<String, dynamic>),
              )
              .toList(),
      menuList: (json['menuList'] as List<dynamic>)
          .map((menu) => Menu.fromJson(menu as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'limits': limits,
      'restaurant': restaurant,
      'dimensionAssignments': dimensionAssignments
          .map((item) => item.toJson())
          .toList(),
      'menuList': menuList,
    };
  }

  @override
  List<Object?> get props => [
    id,
    name,
    limits,
    restaurant,
    dimensionAssignments,
    menuList,
  ];
}

class CombinationResponse extends Equatable {
  final Combination combination;

  const CombinationResponse({required this.combination});

  factory CombinationResponse.fromJson(Map<String, dynamic> json) {
    return CombinationResponse(combination: Combination.fromJson(json));
  }
  @override
  List<Object?> get props => [combination];
}

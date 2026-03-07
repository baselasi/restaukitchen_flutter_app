import 'package:equatable/equatable.dart';
import 'package:restaukitchen_app/page/menusPage/models/menu_scroll_bar_item.dart';

class MenuCombination extends Equatable {
  final String id;
  final String name;
  final List<DimensionAssignment> dimensionAssignments;
  final List<String> combinationImageIds;

  const MenuCombination({
    required this.id,
    required this.name,
    required this.dimensionAssignments,
    required this.combinationImageIds,
  });

  factory MenuCombination.fromJson(Map<String, dynamic> json) {
    return MenuCombination(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      dimensionAssignments:
          (json['dimensionAssignments'] as List<dynamic>? ?? [])
              .map(
                (assignment) => DimensionAssignment.fromJson(
                  assignment as Map<String, dynamic>,
                ),
              )
              .toList(),
      combinationImageIds: (json['combinationImageIds'] as List<dynamic>? ?? [])
          .map((imageId) => imageId.toString())
          .toList(),
    );
  }

  MenuScrollBarItem toMenuScrollBarItem() {
    return MenuScrollBarItem(id: id, name: name, isCombination: true);
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'dimensionAssignments': dimensionAssignments
          .map((assignment) => assignment.toJson())
          .toList(),
      'combinationImageIds': combinationImageIds,
    };
  }

  @override
  List<Object?> get props => [
    id,
    name,
    dimensionAssignments,
    combinationImageIds,
  ];
}

class DimensionAssignment extends Equatable {
  final String id;
  final Dimension dimension;
  final double price;
  final bool isDeleted;

  const DimensionAssignment({
    required this.id,
    required this.dimension,
    required this.price,
    required this.isDeleted,
  });

  factory DimensionAssignment.fromJson(Map<String, dynamic> json) {
    return DimensionAssignment(
      id: json['id'] as String? ?? '',
      dimension: Dimension.fromJson(
        json['dimension'] as Map<String, dynamic>? ?? <String, dynamic>{},
      ),
      price: (json['price'] as num?)?.toDouble() ?? 0,
      isDeleted: json['isDeleted'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'dimension': dimension.toJson(),
      'price': price,
      'isDeleted': isDeleted,
    };
  }

  @override
  List<Object?> get props => [id, dimension, price, isDeleted];
}

class Dimension extends Equatable {
  final String id;
  final String name;
  final bool standard;
  final bool deleted;

  const Dimension({
    required this.id,
    required this.name,
    required this.standard,
    required this.deleted,
  });

  factory Dimension.fromJson(Map<String, dynamic> json) {
    return Dimension(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      standard: json['standard'] as bool? ?? false,
      deleted: json['deleted'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name, 'standard': standard, 'deleted': deleted};
  }

  @override
  List<Object?> get props => [id, name, standard, deleted];
}

class MenuCombinationResponse extends Equatable {
  final List<MenuCombination> combinations;

  const MenuCombinationResponse({required this.combinations});

  factory MenuCombinationResponse.fromJson(List<dynamic> json) {
    return MenuCombinationResponse(
      combinations: json
          .map((e) => MenuCombination.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  @override
  List<Object?> get props => [combinations];
}

import 'package:equatable/equatable.dart';
import 'package:restaukitchen_app/core/models/dimesnion_assignment.dart';
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

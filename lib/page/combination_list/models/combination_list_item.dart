import 'package:equatable/equatable.dart';
import 'package:restaukitchen_app/core/models/dimesnion_assignment.dart';

class CombinationListItem extends Equatable {
  final String id;
  final String name;
  final List<DimensionAssignment> dimensionAssignments;
  final List<String> combinationImageIds;

  const CombinationListItem({
    required this.id,
    required this.name,
    required this.dimensionAssignments,
    required this.combinationImageIds,
  });

  factory CombinationListItem.fromJson(Map<String, dynamic> json) {
    return CombinationListItem(
      id: json['id'] as String,
      name: json['name'] as String,
      dimensionAssignments:
          (json['dimensionAssignments'] as List<dynamic>? ?? [])
              .map(
                (e) => DimensionAssignment.fromJson(e as Map<String, dynamic>),
              )
              .toList(),
      combinationImageIds: (json['combinationImageIds'] as List<dynamic>? ?? [])
          .map((e) => e as String)
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'dimensionAssignments': dimensionAssignments
          .map(
            (a) => {
              'id': a.id,
              'price': a.price,
              'dimension': a.dimension.toJson(),
              'isDeleted': a.isDeleted,
            },
          )
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

class CombinationListItemResponse extends Equatable {
  final List<CombinationListItem> combinations;

  const CombinationListItemResponse({required this.combinations});

  factory CombinationListItemResponse.fromJson(List<dynamic> json) {
    return CombinationListItemResponse(
      combinations: json.map((e) => CombinationListItem.fromJson(e)).toList(),
    );
  }

  @override
  List<Object?> get props => [combinations];
}

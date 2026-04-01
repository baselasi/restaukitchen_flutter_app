import 'package:equatable/equatable.dart';
import 'package:restaukitchen_app/core/components/form/dimensionInput/dimension_assignments.dart';

class Ingredient extends Equatable {
  final String? id;
  final String name;
  final List<DimensionAssignments> dimensionAssignments;

  const Ingredient({
    this.id,
    required this.name,
    this.dimensionAssignments = const [],
  });

  factory Ingredient.fromJson(Map<String, dynamic> json) {
    return Ingredient(
      id: json['id'] as String?,
      name: json['name'] as String? ?? '',
      dimensionAssignments:
          (json['dimensionAssignments'] as List<dynamic>?)
              ?.map(
                (e) => DimensionAssignments.fromJson(e as Map<String, dynamic>),
              )
              .toList() ??
          [],
    );
  }


  bool hasDimensionId(String dimensionId) {
    return dimensionAssignments.any(
      (assignment) => assignment.dimension.id == dimensionId,
    );
  }

  Ingredient copyWith({
    String? id,
    String? name,
    List<DimensionAssignments>? dimensionAssignments,
  }) {
    return Ingredient(
      id: id ?? this.id,
      name: name ?? this.name,
      dimensionAssignments: dimensionAssignments ?? this.dimensionAssignments,
    );
  }

  @override
  List<Object?> get props => [id, name, dimensionAssignments];
}

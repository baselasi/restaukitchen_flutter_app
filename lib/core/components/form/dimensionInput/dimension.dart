import 'package:equatable/equatable.dart';

class Dimension extends Equatable {
  final String? id;
  final String name;
  final bool standard;
  final bool? deleted;

  const Dimension({
    this.id,
    required this.name,
    required this.standard,
    this.deleted,
  });

  factory Dimension.fromJson(Map<String, dynamic> json) {
    return Dimension(
      id: json['id'] as String?,
      name: json['name'] as String,
      standard: json['standard'] as bool,
      deleted: json['deleted'] as bool?,
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name, 'standard': standard, 'deleted': deleted};
  }

  @override
  List<Object?> get props => [id, name, standard, deleted];
}

class DimensionResponse extends Equatable {
  final List<Dimension> dimensions;

  const DimensionResponse({required this.dimensions});

  factory DimensionResponse.fromJson(List<dynamic> json) {
    return DimensionResponse(
      dimensions: json
          .map(
            (dimension) =>
                Dimension.fromJson(dimension as Map<String, dynamic>),
          )
          .toList(),
    );
  }
  @override
  List<Object?> get props => [dimensions];
}

import 'package:equatable/equatable.dart';
import 'package:restaukitchen_app/core/components/form/dimensionInput/dimension.dart';

class DimensionAssignments extends Equatable {
  final String? id;
  final String? price;
  final Dimension dimension;
  final bool? deleted;

  const DimensionAssignments({
    this.id,
    this.price,
    required this.dimension,
    this.deleted,
  });

  factory DimensionAssignments.fromJson(Map<String, dynamic> json) {
    return DimensionAssignments(
      id: json['id'] as String?,
      price: json['price'].toString(),
      dimension: Dimension.fromJson(json['dimension'] as Map<String, dynamic>),
      deleted: json['deleted'] as bool?,
    );
  }

  @override
  List<Object?> get props => [id, price, dimension, deleted];
}

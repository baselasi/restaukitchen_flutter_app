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
  

  @override
  List<Object?> get props => [id, price, dimension, deleted];
}

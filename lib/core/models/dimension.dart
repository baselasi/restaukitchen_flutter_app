import 'package:equatable/equatable.dart';
import 'package:restaukitchen_app/core/models/dimesnion_assignment.dart';

class Dimension extends Equatable {
  final String dimensionId;
  final double price;

  const Dimension({required this.dimensionId, required this.price});

  Map<String, dynamic> toJson() {
    return {'dimensionId': dimensionId, 'price': price};
  }

  factory Dimension.formDimensionAssignment(
    DimensionAssignment dimensionAssignment,
  ) {
    return Dimension(
      dimensionId: dimensionAssignment.id,
      price: dimensionAssignment.price,
    );
  }

  @override
  List<Object?> get props => [dimensionId, price];
}

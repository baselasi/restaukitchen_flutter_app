import 'package:equatable/equatable.dart';
import 'package:restaukitchen_app/core/components/form/dimensionInput/dimension.dart';

class DimensionAssignment extends Equatable {
  final String id;
  final double price;
  final Dimension dimension;

  const DimensionAssignment({
    required this.id,
    required this.price,
    required this.dimension,
  });

  factory DimensionAssignment.fromJson(Map<String, dynamic> json) {
    return DimensionAssignment(
      id: json['id'] as String,
      price: json['price'] as double,
      dimension: Dimension.fromJson(json['dimension'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'price': price};
  }

  @override
  List<Object?> get props => [id, price];
}

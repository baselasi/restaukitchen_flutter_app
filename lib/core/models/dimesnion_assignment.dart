import 'package:equatable/equatable.dart';

class DimensionAssignment extends Equatable {
  final String id;
  final double price;

  const DimensionAssignment({required this.id, required this.price});

  factory DimensionAssignment.fromJson(Map<String, dynamic> json) {
    return DimensionAssignment(
      id: json['id'] as String,
      price: json['price'] as double,
    );
  }

  @override
  List<Object?> get props => [id, price];
}

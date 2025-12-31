import 'package:equatable/equatable.dart';

class DimensionAssignment extends Equatable {
  final String id;
  final int price;

  const DimensionAssignment({required this.id, required this.price});

  factory DimensionAssignment.fromJson(Map<String, dynamic> json) {
    return DimensionAssignment(
      id: json['id'] as String,
      price: json['price'] as int,
    );
  }

  @override
  List<Object?> get props => [id, price];
}

import 'package:equatable/equatable.dart';

class Dimension extends Equatable {
  final String dimensionId;
  final double price;

  const Dimension({required this.dimensionId, required this.price});

  Map<String, dynamic> toJson() {
    return {'dimensionId': dimensionId, 'price': price};
  }

  @override
  List<Object?> get props => [dimensionId, price];
}

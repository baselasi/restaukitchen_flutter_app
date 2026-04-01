import 'package:equatable/equatable.dart';

class MenuScrollBarItem extends Equatable {
  final String id;
  final String name;
  final bool isCombination;
  const MenuScrollBarItem({required this.id, required this.name, this.isCombination = false});

  @override
  List<Object?> get props => [id, name, isCombination];
}

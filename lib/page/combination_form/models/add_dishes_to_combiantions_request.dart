import 'package:equatable/equatable.dart';

class AddDishesToCombiantionsRequest extends Equatable {
  final String menuId;
  final List<String> dishIds;

  const AddDishesToCombiantionsRequest({
    required this.menuId,
    required this.dishIds,
  });

  Map<String, dynamic> toJson() {
    return {'menuId': menuId, 'dishListIds': dishIds};
  }

  @override
  List<Object?> get props => [menuId, dishIds];
}

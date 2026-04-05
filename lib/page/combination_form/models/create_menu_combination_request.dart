import 'package:equatable/equatable.dart';

class CreateMenuCombinationRequest extends Equatable {
  final String combinationId;
  final String name;

  const CreateMenuCombinationRequest({
    required this.combinationId,
    required this.name,
  });

  factory CreateMenuCombinationRequest.fromJson(Map<String, dynamic> json) {
    return CreateMenuCombinationRequest(
      combinationId: json['combinationId'] as String? ?? '',
      name: json['name'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'combinationId': combinationId,
      'name': name,
    };
  }

  @override
  List<Object?> get props => [combinationId, name];
}

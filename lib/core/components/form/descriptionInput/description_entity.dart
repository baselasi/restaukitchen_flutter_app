import 'package:equatable/equatable.dart';

class DescriptionEntity extends Equatable {
  final String id;
  final String language;
  final String value;

  const DescriptionEntity({
    required this.id,
    required this.language,
    this.value = '',
  });

  // Create a copyWith to update the value without mutating the object
  DescriptionEntity copyWith({String? value}) {
    return DescriptionEntity(
      id: id,
      language: language,
      value: value ?? this.value,
    );
  }

  @override
  List<Object?> get props => [id, language, value];
}

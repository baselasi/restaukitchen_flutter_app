import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restaukitchen_app/core/components/form/descriptionInput/description_entity.dart';

class DescriptionCubit extends Cubit<DescriptionState> {
  List<String> availableLanguages = ['English', 'Spanish', 'French'];
  DescriptionCubit()
    : super(
        DescriptionState(
          descriptions: [],
          availableLanguages: ['English', 'Spanish', 'French'],
        ),
      );

  // Add a new language entry from the dropdown
  void addLanguage(String language) {
    final newEntry = DescriptionEntity(
      id: DateTime.now().toString(), // Unique ID for Flutter keys
      language: language,
    );
    final newAvailableLanguages = state.availableLanguages
        .where((lang) => lang != language)
        .toList();
    emit(
      DescriptionState(
        descriptions: [...state.descriptions, newEntry],
        availableLanguages: newAvailableLanguages,
      ),
    );
  }

  // Update the text value for a specific entry
  void updateText(String id, String newValue) {
    final updatedList = state.descriptions.map((entry) {
      return entry.id == id ? entry.copyWith(value: newValue) : entry;
    }).toList();
    emit(
      DescriptionState(
        descriptions: updatedList,
        availableLanguages: state.availableLanguages,
      ),
    );
  }

  // Optional: Remove an entry
  void removeLanguage(String id, String language) {
    emit(
      DescriptionState(
        descriptions: state.descriptions
            .where((entry) => entry.id != id)
            .toList(),
        availableLanguages: [...state.availableLanguages, language],
      ),
    );
  }
}

class DescriptionState extends Equatable {
  final List<DescriptionEntity> descriptions;
  final List<String> availableLanguages;
  const DescriptionState({
    required this.descriptions,
    required this.availableLanguages,
  });

  @override
  List<Object?> get props => [descriptions, availableLanguages];
}

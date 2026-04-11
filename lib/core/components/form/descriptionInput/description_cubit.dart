import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restaukitchen_app/core/components/form/descriptionInput/description_entity.dart';

class DescriptionCubit extends Cubit<DescriptionState> {
  List<String> availableLanguages = ['English', 'Spanish', 'French'];
  DescriptionCubit({List<DescriptionEntity>? descriptions})
    : super(
        DescriptionState(
          descriptions: descriptions ?? [],
          availableLanguages: ['English', 'Spanish', 'French'],
        ),
      );

  void init(List<DescriptionEntity> descriptions) {
    emit(
      DescriptionState(
        descriptions: descriptions,
        availableLanguages: availableLanguages,
      ),
    );
  }

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
  void updateText(String language, String newValue) {
    final entry = [...state.descriptions];
    List<DescriptionEntity> updatedEntry = [];
    if (entry.any((entry) => entry.language == language)) {
      // updatedEntry
      //     .firstWhere((entry) => entry.language == language)
      //     .copyWith(value: newValue);
      updatedEntry = entry
          .map(
            (entry) => entry.language == language
                ? entry.copyWith(value: newValue)
                : entry,
          )
          .toList();
    } else {
      updatedEntry = [...entry];
      updatedEntry.add(
        DescriptionEntity(
          id: DateTime.now().toString(),
          language: language,
          value: newValue,
        ),
      );
    }
    emit(
      DescriptionState(
        descriptions: updatedEntry,
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

  void initDescriptions({
    String? description,
    String? descriptionIt,
    String? descriptionFr,
    String? descriptionEs,
    String? descriptionAr,
  }) {
    List<DescriptionEntity> descriptions = [];
    List<String> languages = [
      'English',
      'Spanish',
      'French',
      'Italian',
      'Arabic',
    ];
    if (description != null && description.isNotEmpty) {
      languages.remove('English');
      descriptions.add(
        DescriptionEntity(
          id: DateTime.now().toString(),
          language: 'English',
          value: description,
        ),
      );
    }
    if (descriptionIt != null && descriptionIt.isNotEmpty) {
      languages.remove('Italian');
      descriptions.add(
        DescriptionEntity(
          id: DateTime.now().toString(),
          language: 'Italian',
          value: descriptionIt,
        ),
      );
    }
    if (descriptionFr != null && descriptionFr.isNotEmpty) {
      languages.remove('French');
      descriptions.add(
        DescriptionEntity(
          id: DateTime.now().toString(),
          language: 'French',
          value: descriptionFr,
        ),
      );
    }
    if (descriptionEs != null && descriptionEs.isNotEmpty) {
      languages.remove('Spanish');
      descriptions.add(
        DescriptionEntity(
          id: DateTime.now().toString(),
          language: 'Spanish',
          value: descriptionEs,
        ),
      );
    }
    if (descriptionAr != null && descriptionAr.isNotEmpty) {
      languages.remove('Arabic');
      descriptions.add(
        DescriptionEntity(
          id: DateTime.now().toString(),
          language: 'Arabic',
          value: descriptionAr,
        ),
      );
    }
    emit(
      DescriptionState(
        descriptions: descriptions,
        availableLanguages: languages,
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

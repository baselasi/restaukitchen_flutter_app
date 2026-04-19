import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:restaukitchen_app/l10n/app_localizations.dart';

class LanguageCubit extends HydratedCubit<LanguageState> {
  LanguageCubit() : super(LanguageState.initial());

  @override
  LanguageState? fromJson(Map<String, dynamic> json) {
    final languageCode = json['languageCode'] as String?;
    if (languageCode == null) {
      return null;
    }

    final countryCode = json['countryCode'] as String?;
    return LanguageState(
      locale: Locale.fromSubtags(
        languageCode: languageCode,
        countryCode: countryCode,
      ),
    );
  }

  void setLanguage(Locale locale) {
    emit(LanguageState(locale: locale));
  }

  @override
  Map<String, dynamic>? toJson(LanguageState state) {
    return {
      'languageCode': state.locale.languageCode,
      'countryCode': state.locale.countryCode,
    };
  }
}

class LanguageState extends Equatable {
  final Locale locale;
  const LanguageState({required this.locale});

  factory LanguageState.initial() {
    final deviceLocale = WidgetsBinding.instance.platformDispatcher.locale;
    final supportedLocale = AppLocalizations.supportedLocales.firstWhere(
      (locale) => locale.languageCode == deviceLocale.languageCode,
      orElse: () => const Locale('en'),
    );

    return LanguageState(locale: supportedLocale);
  }

  @override
  List<Object?> get props => [locale];
}

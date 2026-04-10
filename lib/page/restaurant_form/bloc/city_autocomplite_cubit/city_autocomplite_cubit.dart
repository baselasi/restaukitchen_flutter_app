import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restaukitchen_app/page/restaurant_form/model/city_model.dart';
import 'package:restaukitchen_app/page/settings_page/respository/restaurant_repo.dart';

class CityAutocompliteCubit extends Cubit<CityAutocompliteState> {
  CityAutocompliteCubit({required RestaurantRepo restaurantRepo})
    : _restaurantRepo = restaurantRepo,
      super(
        CityAutocompliteState(
          cities: const [],
          status: CityAutocompliteStatus.initial,
        ),
      );

  final RestaurantRepo _restaurantRepo;

  Future<void> searchCities({
    required String country,
    required String search,
  }) async {
    final trimmedCountry = country.trim();
    final trimmedSearch = search.trim();

    if (trimmedCountry.isEmpty || trimmedSearch.isEmpty) {
      clear();
      return;
    }

    emit(
      CityAutocompliteState(
        cities: const [],
        status: CityAutocompliteStatus.loading,
      ),
    );

    try {
      final result = await _restaurantRepo.getCities(trimmedCountry, trimmedSearch);
      emit(
        CityAutocompliteState(
          cities: result.cities,
          status: CityAutocompliteStatus.loaded,
        ),
      );
    } catch (e) {
      emit(
        CityAutocompliteState(
          cities: const [],
          error: e.toString(),
          status: CityAutocompliteStatus.error,
        ),
      );
    }
  }

  void clear() {
    emit(
      CityAutocompliteState(
        cities: const [],
        status: CityAutocompliteStatus.initial,
      ),
    );
  }
}

class CityAutocompliteState {
  final List<CityModel> cities;
  final String? error;
  final CityAutocompliteStatus status;
  const CityAutocompliteState({
    required this.cities,
    this.error,
    required this.status,
  });
}

enum CityAutocompliteStatus { initial, loading, loaded, error }

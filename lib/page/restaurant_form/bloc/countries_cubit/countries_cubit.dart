import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restaukitchen_app/page/settings_page/respository/restaurant_repo.dart';

class CountriesState {
  final List<String> countries;
  final String? error;
  final CountriesStatus status;
  CountriesState({required this.countries, this.error, required this.status});
}

enum CountriesStatus { initial, loading, loaded, error }

class CountriesCubit extends Cubit<CountriesState> {
  final RestaurantRepo _restaurantRepo;
  CountriesCubit({required RestaurantRepo restaurantRepo})
    : _restaurantRepo = restaurantRepo,
      super(CountriesState(countries: [], status: CountriesStatus.initial));

  Future<void> getCountries() async {
    emit(CountriesState(countries: [], status: CountriesStatus.loading));
    try {
      final countries = await _restaurantRepo.getCountries();
      if (!isClosed) {
        emit(
          CountriesState(countries: countries, status: CountriesStatus.loaded),
        );
      }
    } catch (e) {
      if (!isClosed) {
        emit(
          CountriesState(
            countries: [],
            error: e.toString(),
            status: CountriesStatus.error,
          ),
        );
      }
    }
  }
}

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restaukitchen_app/page/settings_page/models/restaurant.dart';
import 'package:restaukitchen_app/page/settings_page/respository/restaurant_repo.dart';

class RestaurantFormCubit extends Cubit<RestaurantFormState> {
  final RestaurantRepo _restaurantRepo;

  RestaurantFormCubit({required RestaurantRepo restaurantRepo})
    : _restaurantRepo = restaurantRepo,
      super(RestaurantFormState(status: RestaurantFormStatus.initial));

  Future<void> patchRestaurant(Restaurant restaurant) async {
    emit(RestaurantFormState(status: RestaurantFormStatus.loading));
    try {
      await _restaurantRepo.updateRestaurant(restaurant);
      emit(RestaurantFormState(status: RestaurantFormStatus.loaded));
    } catch (e) {
      emit(RestaurantFormState(status: RestaurantFormStatus.error));
    }
  }
}

class RestaurantFormState {
  final RestaurantFormStatus status;
  RestaurantFormState({required this.status});
}

enum RestaurantFormStatus { initial, loading, loaded, error }

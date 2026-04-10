import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restaukitchen_app/page/settings_page/models/restaurant.dart';
import 'package:restaukitchen_app/page/settings_page/respository/restaurant_repo.dart';

class RestaurantInfoCubit extends Cubit<RestaurantInfoState> {
  final RestaurantRepo _restaurantRepo;
  RestaurantInfoCubit({required RestaurantRepo restaurantRepo})
    : _restaurantRepo = restaurantRepo,
      super(RestaurantInfoState.initial());

  Future<void> getRestaurantInfo(String restaurantId) async {
    emit(RestaurantInfoState.loading());
    try {
      final restaurant = await _restaurantRepo.getRestaurant(restaurantId);
      emit(RestaurantInfoState.loaded(restaurant.restaurant));
    } catch (e) {
      emit(RestaurantInfoState.error(e.toString()));
    }
  }
}

enum RestaurantInfoStatus { initial, loading, loaded, error }

class RestaurantInfoState extends Equatable {
  final Restaurant? restaurant;
  final RestaurantInfoStatus status;
  final String? errorMessage;
  const RestaurantInfoState({
    this.restaurant,
    required this.status,
    this.errorMessage,
  });
  factory RestaurantInfoState.initial() {
    return const RestaurantInfoState(status: RestaurantInfoStatus.initial);
  }
  factory RestaurantInfoState.loading() {
    return const RestaurantInfoState(status: RestaurantInfoStatus.loading);
  }

  factory RestaurantInfoState.loaded(Restaurant restaurant) {
    return RestaurantInfoState(
      restaurant: restaurant,
      status: RestaurantInfoStatus.loaded,
    );
  }
  factory RestaurantInfoState.error(String errorMessage) {
    return RestaurantInfoState(
      errorMessage: errorMessage,
      status: RestaurantInfoStatus.error,
    );
  }

  @override
  List<Object?> get props => [status, errorMessage];
}

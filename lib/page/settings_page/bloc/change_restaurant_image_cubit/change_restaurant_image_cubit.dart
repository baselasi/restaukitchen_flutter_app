import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restaukitchen_app/page/menusPage/models/image.dart';
import 'package:restaukitchen_app/page/menusPage/repository/menus_page_repo.dart';

class ChangeRestaurantImageCubit extends Cubit<ChangeRestaurantImageState> {
  ChangeRestaurantImageCubit()
    : super(ChangeRestaurantImageState(status: ChangeRestaurantImageStatus.init));

  Future<void> uploadDishImage(
    String dishId,
    File image, {
    bool isUpdate = false,
  }) async {
    emit(ChangeRestaurantImageState(status: ChangeRestaurantImageStatus.loading));
    try {
      final imageResponse = await MenusPageRepo().uploadDishImage(
        dishId,
        image,
      );
      emit(
        ChangeRestaurantImageState(
          status: ChangeRestaurantImageStatus.success,
          imageResponse: imageResponse,
        ),
      );
    } catch (e) {
      emit(ChangeRestaurantImageState(status: ChangeRestaurantImageStatus.error));
    }
  }

  void emitError(String error) {
    emit(ChangeRestaurantImageState(status: ChangeRestaurantImageStatus.error));
  }
}

enum ChangeRestaurantImageStatus { init, loading, error, success }

class ChangeRestaurantImageState extends Equatable {
  final ChangeRestaurantImageStatus status;
  final ImageResponse? imageResponse;
  const ChangeRestaurantImageState({required this.status, this.imageResponse});

  @override
  List<Object?> get props => [status];
}

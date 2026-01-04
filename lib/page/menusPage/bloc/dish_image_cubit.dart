import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restaukitchen_app/page/menusPage/models/image.dart';
import 'package:restaukitchen_app/page/menusPage/repository/menus_page_repo.dart';

class DishImageCubit extends Cubit<DishImageUploadState> {
  DishImageCubit()
    : super(DishImageUploadState(status: DishImageUploadStatus.init));

  Future<void> uploadDishImage(
    String dishId,
    File image, {
    bool isUpdate = false,
  }) async {
    emit(DishImageUploadState(status: DishImageUploadStatus.loading));
    try {
      final imageResponse = await MenusPageRepo().uploadDishImage(
        dishId,
        image,
      );
      emit(
        DishImageUploadState(
          status: DishImageUploadStatus.success,
          imageResponse: imageResponse,
        ),
      );
    } catch (e) {
      emit(DishImageUploadState(status: DishImageUploadStatus.error));
    }
  }

  void emitError(String error) {
    emit(DishImageUploadState(status: DishImageUploadStatus.error));
  }
}

enum DishImageUploadStatus { init, loading, error, success }

class DishImageUploadState extends Equatable {
  final DishImageUploadStatus status;
  final ImageResponse? imageResponse;
  const DishImageUploadState({required this.status, this.imageResponse});

  @override
  List<Object?> get props => [status];
}

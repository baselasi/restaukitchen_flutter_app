import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restaukitchen_app/page/dimension_list/repository/dimensions_repo.dart';

class DeleteDimensionsCubit extends Cubit<DeleteDimensionsState> {
  final DimensionsRepo _dimensionsRepo;
  DeleteDimensionsCubit({required DimensionsRepo dimensionsRepo})
    : _dimensionsRepo = dimensionsRepo,
      super(DeleteDimensionsState.initial());

  Future<void> deleteDimensions(String id) async {
    emit(DeleteDimensionsState.loading());
    try {
      await _dimensionsRepo.deleteDimensions(id);
      emit(DeleteDimensionsState.success());
    } catch (e) {
      emit(DeleteDimensionsState.error(e.toString()));
    }
  }
}

enum DeleteDimensionsStatus { initial, loading, success, error }

class DeleteDimensionsState extends Equatable {
  final String? errorMessage;
  final DeleteDimensionsStatus status;

  const DeleteDimensionsState({required this.status, this.errorMessage});

  factory DeleteDimensionsState.initial() {
    return const DeleteDimensionsState(status: DeleteDimensionsStatus.initial);
  }
  factory DeleteDimensionsState.loading() {
    return const DeleteDimensionsState(status: DeleteDimensionsStatus.loading);
  }
  factory DeleteDimensionsState.success() {
    return const DeleteDimensionsState(status: DeleteDimensionsStatus.success);
  }
  factory DeleteDimensionsState.error(String errorMessage) {
    return DeleteDimensionsState(
      status: DeleteDimensionsStatus.error,
      errorMessage: errorMessage,
    );
  }
  @override
  List<Object?> get props => [errorMessage, status];
}

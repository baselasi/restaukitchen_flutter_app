import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restaukitchen_app/core/components/form/dimensionInput/dimension.dart';
import 'package:restaukitchen_app/page/dimension_list/repository/dimensions_repo.dart';

class PostDimensionsCubit extends Cubit<PostDimensionsState> {
  final DimensionsRepo _dimensionsRepo;
  PostDimensionsCubit({required DimensionsRepo dimensionsRepo})
    : _dimensionsRepo = dimensionsRepo,
      super(PostDimensionsState.initial());

  Future<void> postDimensions(String name, String? id) async {
    emit(PostDimensionsState.loading());
    try {
      DimensionResponse? response;
      if (id != null) {
        response = await _dimensionsRepo.updateDimensions(id, name);
      } else {
        response = await _dimensionsRepo.postDimensions(name);
      }
      emit(PostDimensionsState.loaded(response.dimensions.first));
    } catch (e) {
      emit(PostDimensionsState.error(e.toString()));
    }
  }
}

class PostDimensionsState extends Equatable {
  final Dimension? dimension;
  final PostDimensionsStatus status;
  final String? errorMessage;
  const PostDimensionsState({
    this.dimension,
    required this.status,
    this.errorMessage,
  });
  factory PostDimensionsState.initial() {
    return const PostDimensionsState(
      dimension: null,
      status: PostDimensionsStatus.initial,
    );
  }
  factory PostDimensionsState.loading() {
    return const PostDimensionsState(status: PostDimensionsStatus.loading);
  }
  factory PostDimensionsState.loaded(Dimension dimension) {
    return PostDimensionsState(
      dimension: dimension,
      status: PostDimensionsStatus.loaded,
    );
  }

  factory PostDimensionsState.error(String errorMessage) {
    return PostDimensionsState(
      status: PostDimensionsStatus.error,
      errorMessage: errorMessage,
    );
  }
  @override
  List<Object?> get props => [dimension, status, errorMessage];
}

enum PostDimensionsStatus { initial, loading, loaded, error }

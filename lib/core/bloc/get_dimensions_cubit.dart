import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:restaukitchen_app/core/components/form/dimensionInput/dimension.dart';
import 'package:restaukitchen_app/core/repository/dimensions_repo.dart';

class GetDimensionsCubit extends Cubit<GetDimensionsState> {
  final DimensionsRepo _dimensionsRepo;
  GetDimensionsCubit({required DimensionsRepo dimensionsRepo})
    : _dimensionsRepo = dimensionsRepo,
      super(GetDimensionsState.initial());

  Future<void> getDimensions() async {
    emit(GetDimensionsState.loading());
    try {
      final dimensions = await _dimensionsRepo.getDimensions();
      if (!isClosed) emit(GetDimensionsState.loaded(dimensions.dimensions));
    } catch (e) {
      if (!isClosed) emit(GetDimensionsState.error(e.toString()));
    }
  }
}

class GetDimensionsState extends Equatable {
  final List<Dimension>? dimensions;
  final GetDimensionsStatus status;
  final String? errorMessage;
  const GetDimensionsState({
    this.dimensions,
    required this.status,
    this.errorMessage,
  });

  factory GetDimensionsState.initial() {
    return const GetDimensionsState(status: GetDimensionsStatus.initial);
  }

  factory GetDimensionsState.loading() {
    return const GetDimensionsState(status: GetDimensionsStatus.loading);
  }

  factory GetDimensionsState.loaded(List<Dimension> dimensions) {
    return GetDimensionsState(
      dimensions: dimensions,
      status: GetDimensionsStatus.loaded,
    );
  }

  factory GetDimensionsState.error(String error) {
    return GetDimensionsState(
      status: GetDimensionsStatus.error,
      errorMessage: error,
    );
  }

  @override
  List<Object?> get props => [dimensions, status, errorMessage];
}

enum GetDimensionsStatus { initial, loading, loaded, error }

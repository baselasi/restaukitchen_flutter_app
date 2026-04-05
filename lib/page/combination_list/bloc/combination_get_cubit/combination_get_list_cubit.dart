import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restaukitchen_app/page/combination_list/models/combination_list_item.dart';
import 'package:restaukitchen_app/page/combination_list/repository/combination_list_repo.dart';

class CombinationGetListCubit extends Cubit<CombinationGetListState> {
  final CombinationListRepo _combinationListRepo;
  CombinationGetListCubit({required CombinationListRepo combinationListRepo})
    : _combinationListRepo = combinationListRepo,
      super(CombinationGetListState.initial());

  Future<void> getCombinations(String restaurantId) async {
    emit(CombinationGetListState.loading());
    try {
      final combinations = await _combinationListRepo.getCombinations(
        restaurantId,
      );
      if (!isClosed) {
        emit(CombinationGetListState.loaded(combinations.combinations));
      }
    } catch (e) {
      if (!isClosed) emit(CombinationGetListState.error(e.toString()));
    }
  }

  @override
  Future<void> close() {
    emit(CombinationGetListState.initial());
    return super.close();
  }
}

class CombinationGetListState extends Equatable {
  final List<CombinationListItem>? combinations;
  final String? errorMessage;
  final CombinationGetListStatus status;
  const CombinationGetListState({
    required this.combinations,
    required this.status,
    this.errorMessage,
  });

  factory CombinationGetListState.initial() {
    return const CombinationGetListState(
      combinations: [],
      status: CombinationGetListStatus.initial,
    );
  }

  factory CombinationGetListState.loading() {
    return const CombinationGetListState(
      combinations: [],
      status: CombinationGetListStatus.loading,
    );
  }

  factory CombinationGetListState.loaded(List<CombinationListItem> combinations) {
    return CombinationGetListState(
      combinations: combinations,
      status: CombinationGetListStatus.loaded,
    );
  }

  factory CombinationGetListState.error(String errorMessage) {
    return CombinationGetListState(
      combinations: [],
      status: CombinationGetListStatus.error,
      errorMessage: errorMessage,
    );
  }
  @override
  List<Object?> get props => [combinations, errorMessage, status];
}

enum CombinationGetListStatus { initial, loading, loaded, error }

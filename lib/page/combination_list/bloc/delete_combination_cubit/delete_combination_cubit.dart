import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restaukitchen_app/page/combination_list/repository/combination_list_repo.dart';

class DeleteCombinationCubit extends Cubit<DeleteCombinationState> {
  final CombinationListRepo _combinationListRepo;
  DeleteCombinationCubit({required CombinationListRepo combinationListRepo})
    : _combinationListRepo = combinationListRepo,
      super(DeleteCombinationState.initial());

  Future<void> deleteCombination(String combinationId) async {
    emit(DeleteCombinationState.loading());
    try {
      await _combinationListRepo.deleteCombination(combinationId);
      if (!isClosed) {
        emit(DeleteCombinationState.success());
      }
    } catch (e) {
      if (!isClosed) {
        emit(DeleteCombinationState.error(e.toString()));
      }
    }
  }
}

class DeleteCombinationState extends Equatable {
  final DeleteCombinationStatus status;
  final String? errorMessage;
  const DeleteCombinationState({required this.status, this.errorMessage});

  factory DeleteCombinationState.initial() {
    return const DeleteCombinationState(
      status: DeleteCombinationStatus.initial,
    );
  }
  factory DeleteCombinationState.loading() {
    return const DeleteCombinationState(
      status: DeleteCombinationStatus.loading,
    );
  }
  factory DeleteCombinationState.success() {
    return const DeleteCombinationState(
      status: DeleteCombinationStatus.success,
    );
  }
  factory DeleteCombinationState.error(String errorMessage) {
    return DeleteCombinationState(
      status: DeleteCombinationStatus.error,
      errorMessage: errorMessage,
    );
  }
  @override
  List<Object?> get props => [status, errorMessage];
}

enum DeleteCombinationStatus { initial, loading, success, error }

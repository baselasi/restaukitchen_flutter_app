import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:equatable/equatable.dart';
import 'package:restaukitchen_app/page/combination_page/models/combination.dart';
import 'package:restaukitchen_app/page/combination_page/repository/combination_page_repo.dart';

class CombinationGetCubit extends Cubit<CombinationGetState> {
  final CombinationPageRepo combinationPageRepo;
  CombinationGetCubit({required this.combinationPageRepo})
    : super(CombinationGetState.initial());

  void _safeEmit(CombinationGetState state) {
    if (!isClosed) emit(state);
  }

  Future<void> getCombination(String combinationId) async {
    _safeEmit(CombinationGetState.loading());
    try {
      final combinationResponse = await combinationPageRepo.getCombination(
        combinationId,
      );
      _safeEmit(CombinationGetState.loaded(combinationResponse.combination));
    } catch (e, stackTrace) {
      debugPrint('CombinationGetCubit.getCombination failed: $e');
      debugPrintStack(stackTrace: stackTrace);
      _safeEmit(CombinationGetState.error(e.toString()));
    }
  }
}

enum CombinationGetStatus { initial, loading, loaded, error }

class CombinationGetState extends Equatable {
  final Combination? combination;
  final String? errorMessage;
  final CombinationGetStatus status;
  const CombinationGetState({
    this.combination,
    this.errorMessage,
    required this.status,
  });

  factory CombinationGetState.initial() {
    return const CombinationGetState(
      combination: null,
      errorMessage: null,
      status: CombinationGetStatus.initial,
    );
  }

  factory CombinationGetState.loading() {
    return const CombinationGetState(
      combination: null,
      errorMessage: null,
      status: CombinationGetStatus.loading,
    );
  }

  factory CombinationGetState.loaded(Combination combination) {
    return CombinationGetState(
      combination: combination,
      errorMessage: null,
      status: CombinationGetStatus.loaded,
    );
  }

  factory CombinationGetState.error(String errorMessage) {
    return CombinationGetState(
      combination: null,
      errorMessage: errorMessage,
      status: CombinationGetStatus.error,
    );
  }

  @override
  List<Object?> get props => [combination, errorMessage, status];
}

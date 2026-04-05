import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restaukitchen_app/page/combination_form/models/create_combination_request.dart';
import 'package:restaukitchen_app/page/combination_form/models/create_combination_response.dart';
import 'package:restaukitchen_app/page/combination_form/repository/combination_form_repo.dart';

class CombinationPostCubit extends Cubit<CombinationPostState> {
  final CombinationFormRepo _combinationFormRepo;
  CombinationPostCubit({required CombinationFormRepo combinationFormRepo})
    : _combinationFormRepo = combinationFormRepo,
      super(CombinationPostState.initial());

  Future<void> createCombination(CreateCombinationRequest payload) async {
    emit(CombinationPostState.loading());
    try {
      final response = await _combinationFormRepo.createCombination(payload);
      if (!isClosed) emit(CombinationPostState.success(response));
    } catch (e) {
      if (!isClosed) emit(CombinationPostState.error(e.toString()));
    }
  }

  Future<void> updateCombination(CreateCombinationRequest payload, String combinationId) async {
    emit(CombinationPostState.loading());
    try {
      final response = await _combinationFormRepo.updateCombination(payload, combinationId);
      if (!isClosed) emit(CombinationPostState.success(response));
    } catch (e) {
      if (!isClosed) emit(CombinationPostState.error(e.toString()));
    }
  }
}

enum CombinationPostStatus { initial, loading, success, error }

class CombinationPostState extends Equatable {
  final CreateCombinationResponse? combinationResponse;
  final CombinationPostStatus status;

  const CombinationPostState({this.combinationResponse, required this.status});

  factory CombinationPostState.initial() {
    return const CombinationPostState(
      combinationResponse: null,
      status: CombinationPostStatus.initial,
    );
  }

  factory CombinationPostState.loading() {
    return const CombinationPostState(
      combinationResponse: null,
      status: CombinationPostStatus.loading,
    );
  }

  factory CombinationPostState.success(
    CreateCombinationResponse combinationResponse,
  ) {
    return CombinationPostState(
      combinationResponse: combinationResponse,
      status: CombinationPostStatus.success,
    );
  }

  factory CombinationPostState.error(String error) {
    return CombinationPostState(
      combinationResponse: null,
      status: CombinationPostStatus.error,
    );
  }

  @override
  List<Object?> get props => [combinationResponse, status];
}

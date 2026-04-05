import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restaukitchen_app/core/models/base_post_response.dart';
import 'package:restaukitchen_app/page/combination_form/models/create_menu_combination_request.dart';
import 'package:restaukitchen_app/page/combination_form/repository/combination_form_repo.dart';

class CreateCombinationMenuCubit extends Cubit<CreateCombinationMenuState> {
  final CombinationFormRepo _combinationFormRepo;
  CreateCombinationMenuCubit({required CombinationFormRepo combinationFormRepo})
    : _combinationFormRepo = combinationFormRepo,
      super(
        CreateCombinationMenuState(status: CreateCombinationMenuStatus.initial),
      );

  Future<void> createMenuCombination(
    CreateMenuCombinationRequest payload,
  ) async {
    emit(CreateCombinationMenuState.loading());
    try {
      final response = await _combinationFormRepo.createMenuCombination(
        payload,
      );
      emit(CreateCombinationMenuState.success(response));
    } catch (e) {
      emit(CreateCombinationMenuState.error(e.toString()));
    }
  }
}

enum CreateCombinationMenuStatus { initial, loading, success, error }

class CreateCombinationMenuState extends Equatable {
  final CreateCombinationMenuStatus status;
  final BasePostResponse? combinationMenuResponse;
  final String? errorMessage;
  const CreateCombinationMenuState({
    required this.status,
    this.combinationMenuResponse,
    this.errorMessage,
  });

  factory CreateCombinationMenuState.initial() {
    return const CreateCombinationMenuState(
      status: CreateCombinationMenuStatus.initial,
    );
  }

  factory CreateCombinationMenuState.loading() {
    return const CreateCombinationMenuState(
      status: CreateCombinationMenuStatus.loading,
    );
  }
  factory CreateCombinationMenuState.success(
    BasePostResponse combinationMenuResponse,
  ) {
    return CreateCombinationMenuState(
      status: CreateCombinationMenuStatus.success,
      combinationMenuResponse: combinationMenuResponse,
    );
  }
  factory CreateCombinationMenuState.error(String errorMessage) {
    return CreateCombinationMenuState(
      status: CreateCombinationMenuStatus.error,
      errorMessage: errorMessage,
    );
  }
  @override
  List<Object?> get props => [status, combinationMenuResponse];
}

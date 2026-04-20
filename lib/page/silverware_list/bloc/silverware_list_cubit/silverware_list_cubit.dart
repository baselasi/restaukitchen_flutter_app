import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restaukitchen_app/page/silverware_list/models/silverware_response.dart';
import 'package:restaukitchen_app/page/silverware_list/repository/silverware_repo.dart';

class SilverwareListCubit extends Cubit<SilverwareListState> {
  final SilverwareRepo _silverwareRepo;
  SilverwareListCubit({required SilverwareRepo silverwareRepo})
    : _silverwareRepo = silverwareRepo,
      super(SilverwareListState.initial());
  Future<void> getSilverware() async {
    emit(SilverwareListState.loading());
    try {
      final silverware = await _silverwareRepo.getSilverware();
      if (!isClosed) {
        emit(SilverwareListState.loaded(silverware));
      }
    } catch (e) {
      if (!isClosed) {
        emit(SilverwareListState.error(e.toString()));
      }
    }
  }
}

enum SilverwareListStatus { initial, loading, loaded, error }

class SilverwareListState extends Equatable {
  final SilverwareListStatus status;
  final SilverwareResponse? silverware;
  final String? errorMessage;
  const SilverwareListState({
    required this.status,
    this.silverware,
    this.errorMessage,
  });

  factory SilverwareListState.initial() {
    return const SilverwareListState(
      status: SilverwareListStatus.initial,
      silverware: SilverwareResponse(
        silverwares: [],
        id: null,
        name: null,
        restaurant: null,
      ),
    );
  }

  factory SilverwareListState.loading() {
    return const SilverwareListState(
      status: SilverwareListStatus.loading,
      silverware: SilverwareResponse(
        silverwares: [],
        id: null,
        name: null,
        restaurant: null,
      ),
    );
  }

  factory SilverwareListState.loaded(SilverwareResponse silverware) {
    return SilverwareListState(
      status: SilverwareListStatus.loaded,
      silverware: silverware,
    );
  }

  factory SilverwareListState.error(String errorMessage) {
    return SilverwareListState(
      status: SilverwareListStatus.error,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, silverware, errorMessage];
}

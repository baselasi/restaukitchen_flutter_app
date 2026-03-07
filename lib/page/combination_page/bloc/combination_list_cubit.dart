import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

class CombinationListCubit extends Cubit<CombinationListState> {
  CombinationListCubit() : super(CombinationListState.initial());
}

enum CombinationListStatus { initial, loading, loaded, error }

class CombinationListState extends Equatable {
  final String? errorMessage;
  final CombinationListStatus status;
  const CombinationListState({required this.status, this.errorMessage});

  factory CombinationListState.initial() {
    return const CombinationListState(status: CombinationListStatus.initial);
  }

  factory CombinationListState.loading() {
    return const CombinationListState(status: CombinationListStatus.loading);
  }

  // factory CombinationListState.loaded(List<Combination> combinations) {
  //   return CombinationListState(status: CombinationListStatus.loaded, combinations: combinations);
  // }

  factory CombinationListState.error(String errorMessage) {
    return CombinationListState(
      status: CombinationListStatus.error,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, errorMessage];
}

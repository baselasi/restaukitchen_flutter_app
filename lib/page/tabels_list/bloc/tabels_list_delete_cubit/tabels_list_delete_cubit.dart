import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restaukitchen_app/page/tabels_list/repository/tables_repo.dart';

class TabelsListDeleteCubit extends Cubit<TabelsListDeleteState> {
  final TablesRepo _tablesRepo;
  TabelsListDeleteCubit({required TablesRepo tablesRepo})
    : _tablesRepo = tablesRepo,
      super(TabelsListDeleteState.initial());

  Future<void> deleteTabel(String tabelId) async {
    emit(TabelsListDeleteState.loading());
    try {
      await _tablesRepo.deleteTabel(tabelId);
      emit(TabelsListDeleteState.success());
    } catch (e) {
      emit(TabelsListDeleteState.error(e.toString()));
    }
  }
}

class TabelsListDeleteState extends Equatable {
  final TabelsListDeleteStatus status;
  final String? errorMessage;
  const TabelsListDeleteState({required this.status, this.errorMessage});

  factory TabelsListDeleteState.initial() {
    return const TabelsListDeleteState(
      status: TabelsListDeleteStatus.initial,
      errorMessage: null,
    );
  }

  factory TabelsListDeleteState.loading() {
    return const TabelsListDeleteState(
      status: TabelsListDeleteStatus.loading,
      errorMessage: null,
    );
  }

  factory TabelsListDeleteState.success() {
    return const TabelsListDeleteState(
      status: TabelsListDeleteStatus.success,
      errorMessage: null,
    );
  }

  factory TabelsListDeleteState.error(String error) {
    return TabelsListDeleteState(
      status: TabelsListDeleteStatus.error,
      errorMessage: error,
    );
  }
  @override
  List<Object?> get props => [status, errorMessage];
}

enum TabelsListDeleteStatus { initial, loading, success, error }

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restaukitchen_app/page/tabels_list/models/tabel.dart';
import 'package:restaukitchen_app/page/tabels_list/repository/tables_repo.dart';

class TabelsListCubit extends Cubit<TabelsListState> {
  final TablesRepo _tablesRepo;
  TabelsListCubit({required TablesRepo tablesRepo})
    : _tablesRepo = tablesRepo,
      super(TabelsListState(status: TabelsListStatus.initial));

  Future<void> getTabelsList() async {
    emit(TabelsListState(status: TabelsListStatus.loading));
    try {
      final response = await _tablesRepo.getTables();
      final tabels = response.tabels;
      emit(TabelsListState.loaded(tabels));
    } catch (e) {
      emit(TabelsListState.error(e.toString()));
    }
  }

  void removeTabel(String tabelId) {
    final List<Tabel> tabels = [...(state).tabels ?? []];
    tabels.removeWhere((tabel) => tabel.id == tabelId);
    emit(TabelsListState(status: TabelsListStatus.loaded, tabels: tabels));
  }
}

enum TabelsListStatus { initial, loading, loaded, error }

class TabelsListState extends Equatable {
  final TabelsListStatus status;
  final List<Tabel>? tabels;
  final String? errorMessage;
  const TabelsListState({required this.status, this.tabels, this.errorMessage});

  factory TabelsListState.initial() {
    return const TabelsListState(status: TabelsListStatus.initial);
  }

  factory TabelsListState.loading() {
    return const TabelsListState(status: TabelsListStatus.loading);
  }

  factory TabelsListState.error(String message) {
    return TabelsListState(
      status: TabelsListStatus.error,
      errorMessage: message,
    );
  }

  factory TabelsListState.loaded(List<Tabel> tabels) {
    return TabelsListState(status: TabelsListStatus.loaded, tabels: tabels);
  }

  @override
  List<Object?> get props => [status, tabels, errorMessage];
}

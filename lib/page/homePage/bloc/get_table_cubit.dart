import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restaukitchen_app/page/tabels_list/models/tabel.dart';
import 'package:restaukitchen_app/page/tabels_list/repository/tables_repo.dart';

class GetTableCubit extends Cubit<GetTableState> {
  final TablesRepo _tablesRepo;
  GetTableCubit({required TablesRepo tablesRepo})
    : _tablesRepo = tablesRepo,
      super(GetTableState(status: GetTableStatus.initial));

  Future<void> getTable(int tableNumber) async {
    emit(GetTableState(status: GetTableStatus.loading));
    try {
      final table = await _tablesRepo.getTableByTableNumber(tableNumber);
      if (!isClosed) {
        emit(GetTableState.loaded(table));
      }
    } catch (e) {
      if (!isClosed) {
        emit(GetTableState.error(e.toString()));
      }
    }
  }
}

enum GetTableStatus { initial, loading, loaded, error }

class GetTableState extends Equatable {
  final GetTableStatus status;
  final Tabel? table;
  final String? errorMessage;
  const GetTableState({required this.status, this.table, this.errorMessage});

  factory GetTableState.initial() {
    return const GetTableState(status: GetTableStatus.initial);
  }
  factory GetTableState.loading() {
    return const GetTableState(status: GetTableStatus.loading);
  }
  factory GetTableState.loaded(Tabel table) {
    return GetTableState(status: GetTableStatus.loaded, table: table);
  }

  factory GetTableState.error(String errorMessage) {
    return GetTableState(
      status: GetTableStatus.error,
      errorMessage: errorMessage,
    );
  }
  @override
  List<Object?> get props => [status, table, errorMessage];
}

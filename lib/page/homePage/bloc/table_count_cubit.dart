import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restaukitchen_app/page/homePage/repository/home_page_repo.dart';

class TableCountCubit extends Cubit<TableCountState> {
  TableCountCubit() : super(TableCountState(status: TableCountStatus.initial));

  Future<void> getTableCount() async {
    try {
      emit(TableCountState(status: TableCountStatus.loading));
      final response = await HomePageRepo().getTablesCount();
      TableCount count = TableCount.fromJson(response);
      emit(TableCountState(status: TableCountStatus.loaded, tableCount: count));
    } catch (e) {
      emit(TableCountState(status: TableCountStatus.error));
    }
  }
}

class TableCountState extends Equatable {
  final TableCount? tableCount;
  final TableCountStatus status;
  const TableCountState({this.tableCount, required this.status});

  @override
  List<Object?> get props => [tableCount,status];
}

enum TableCountStatus { initial, loading, loaded, error }

class TableCount extends Equatable {
  final int totalTables;
  final int occupiedTable;
  final int reservedTable;
  final int freeTable;
  const TableCount({
    required this.totalTables,
    required this.occupiedTable,
    required this.reservedTable,
    required this.freeTable,
  });

  factory TableCount.fromJson(Map<String, dynamic> json) {
    return TableCount(
      totalTables: json['totalTables'],
      occupiedTable: json['occupiedTable'],
      reservedTable: json['reservedTable'],
      freeTable: json['freeTable'],
    );
  }

  @override
  List<Object?> get props => [
    totalTables,
    occupiedTable,
    reservedTable,
    freeTable,
  ];
}

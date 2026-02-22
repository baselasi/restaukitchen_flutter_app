import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restaukitchen_app/page/table_form/table_form_repo/table_form_repo.dart';

class TableFormCubit extends Cubit<TableFormState> {
  final TableFormRepo _tableFormRepo;
  TableFormCubit({required TableFormRepo tableFormRepo})
    : _tableFormRepo = tableFormRepo,
      super(TableFormState(status: TableFormStatus.initial));

  Future<void> createTable({
    required String number,
    required String numberOfSeats,
    required String status,
  }) async {
    emit(TableFormState(status: TableFormStatus.loading));
    try {
      await _tableFormRepo.createTable({
        'number': number,
        'numberOfSeats': numberOfSeats,
        'status': getStatusLabel(status),
      });
      emit(TableFormState(status: TableFormStatus.success));
    } catch (e) {
      emit(TableFormState(status: TableFormStatus.error));
    }
  }

  Future<void> updateTable({
    required String tableId,
    required String number,
    required String numberOfSeats,
    required String status,
  }) async {
    emit(TableFormState(status: TableFormStatus.loading));
    try {
      await _tableFormRepo.updateTable({
        'id': tableId,
        'number': number,
        'numberOfSeats': numberOfSeats,
        'status': getStatusLabel(status),
      });
      emit(TableFormState(status: TableFormStatus.success));
    } catch (e) {
      emit(TableFormState(status: TableFormStatus.error));
    }
  }

  String getStatusLabel(String status) {
    switch (status) {
      case 'available':
        return 'STATUS_FREE';
      case 'reserved':
        return 'STATUS_RESERVED';
      case 'occupied':
        return 'STATUS_OCCUPIED';
      default:
        return 'STATUS_FREE';
    }
  }
}

class TableFormState extends Equatable {
  final TableFormStatus status;
  final String? errorMessage;
  const TableFormState({required this.status, this.errorMessage});

  @override
  List<Object?> get props => [status, errorMessage];
}

enum TableFormStatus { initial, loading, success, error }

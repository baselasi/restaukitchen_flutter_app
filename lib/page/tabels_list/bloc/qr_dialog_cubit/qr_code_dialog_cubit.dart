import 'dart:typed_data';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restaukitchen_app/page/tabels_list/repository/tables_repo.dart';

class QrCodeDialogCubit extends Cubit<QrCodeDialogState> {
  final TablesRepo _tablesRepo;
  QrCodeDialogCubit({required TablesRepo tablesRepo})
    : _tablesRepo = tablesRepo,
      super(QrCodeDialogState.initial());

  Future<void> getTabelQrCode(String tabelId) async {
    emit(QrCodeDialogState.loading());
    try {
      final imageBytes = await _tablesRepo.getTabelQrCode(tabelId);
      if (!isClosed) {
        emit(QrCodeDialogState.success(imageBytes));
      }
    } catch (e) {
      if (!isClosed) {
        emit(QrCodeDialogState.error(e.toString()));
      }
    }
  }
}

enum QrCodeDialogStatus { initial, loading, success, error }

class QrCodeDialogState extends Equatable {
  final QrCodeDialogStatus status;
  final Uint8List? imageBytes;
  final String? errorMessage;
  const QrCodeDialogState({
    required this.status,
    this.imageBytes,
    this.errorMessage,
  });

  factory QrCodeDialogState.initial() {
    return const QrCodeDialogState(status: QrCodeDialogStatus.initial);
  }

  factory QrCodeDialogState.loading() {
    return const QrCodeDialogState(status: QrCodeDialogStatus.loading);
  }

  factory QrCodeDialogState.success(Uint8List imageBytes) {
    return QrCodeDialogState(
      status: QrCodeDialogStatus.success,
      imageBytes: imageBytes,
    );
  }

  factory QrCodeDialogState.error(String errorMessage) {
    return QrCodeDialogState(
      status: QrCodeDialogStatus.error,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, imageBytes, errorMessage];
}

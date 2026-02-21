import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restaukitchen_app/page/tabels_list/bloc/qr_dialog_cubit/qr_code_dialog_cubit.dart';
import 'package:restaukitchen_app/page/tabels_list/repository/tables_repo.dart';

class QrCodeDialog extends StatefulWidget {
  final String tableId;
  final int tableNumber;

  const QrCodeDialog({super.key, required this.tableId, required this.tableNumber});

  static Future<void> show(BuildContext context, String tableId, int tableNumber) {
    return showDialog(
      context: context,
      builder: (_) => BlocProvider(
        create: (context) => QrCodeDialogCubit(tablesRepo: TablesRepo()),
        child: QrCodeDialog(tableId: tableId, tableNumber: tableNumber),
      ),
    );
  }

  @override
  State<QrCodeDialog> createState() => _QrCodeDialogState();
}

class _QrCodeDialogState extends State<QrCodeDialog> {
  @override
  void initState() {
    super.initState();
    context.read<QrCodeDialogCubit>().getTabelQrCode(widget.tableId);
  }

  Widget _buildQrContent(QrCodeDialogState state, double qrSize) {
    switch (state.status) {
      case QrCodeDialogStatus.loading:
      case QrCodeDialogStatus.initial:
        return const Center(child: CircularProgressIndicator());
      case QrCodeDialogStatus.error:
        return Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.error_outline, size: 48, color: Colors.red.shade400),
              const SizedBox(height: 8),
              Text(
                state.errorMessage ?? 'Failed to load QR code',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.red.shade600),
              ),
            ],
          ),
        );
      case QrCodeDialogStatus.success:
        return ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Image.memory(
            state.imageBytes!,
            width: qrSize,
            height: qrSize,
            fit: BoxFit.contain,
          ),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final qrSize = size.shortestSide * 0.75;

    return Dialog(
      insetPadding: const EdgeInsets.all(24),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: SizedBox(
        width: size.width * 0.85,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Table ${widget.tableNumber}',
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              BlocBuilder<QrCodeDialogCubit, QrCodeDialogState>(
                builder: (context, state) {
                  return Container(
                    width: qrSize,
                    height: qrSize,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: _buildQrContent(state, qrSize),
                  );
                },
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Close'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

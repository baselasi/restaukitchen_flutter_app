import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restaukitchen_app/core/components/form/input_field.dart';
import 'package:restaukitchen_app/core/dialogs/snack_bar.dart';
import 'package:restaukitchen_app/page/homePage/bloc/get_table_cubit.dart';
import 'package:restaukitchen_app/page/tabels_list/bloc/qr_dialog_cubit/qr_code_dialog_cubit.dart';
import 'package:restaukitchen_app/page/tabels_list/repository/tables_repo.dart';

class TableQrCodeDialog extends StatefulWidget {
  const TableQrCodeDialog({super.key});

  static Future<void> show(BuildContext context) {
    return showDialog(
      context: context,
      builder: (_) => MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => GetTableCubit(tablesRepo: TablesRepo()),
          ),
          BlocProvider(
            create: (context) => QrCodeDialogCubit(tablesRepo: TablesRepo()),
          ),
        ],
        child: TableQrCodeDialog(),
      ),
    );
  }

  @override
  State<TableQrCodeDialog> createState() => _TableQrCodeDialogState();
}

class _TableQrCodeDialogState extends State<TableQrCodeDialog> {
  final TextEditingController _tableNumberController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _tableNumberController.dispose();
    super.dispose();
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
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Generate QR Code',
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: InputField(
                      controller: _tableNumberController,
                      keyboardType: TextInputType.number,
                      label: 'Table number',
                      isNumeric: true,
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      if (_tableNumberController.text.isNotEmpty) {
                        context.read<GetTableCubit>().getTable(
                          int.parse(_tableNumberController.text),
                        );
                      }
                    },
                    icon: const Icon(Icons.search),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              BlocConsumer<GetTableCubit, GetTableState>(
                listener: (context, state) {
                  if (state.status == GetTableStatus.loaded) {
                    context.read<QrCodeDialogCubit>().getTabelQrCode(
                      state.table?.id ?? '',
                    );
                  }
                  if (state.status == GetTableStatus.error) {
                    AppSnackBar.showError(
                      context,
                      state.errorMessage ?? 'Error loading table',
                    );
                  }
                },
                builder: (context, state) {
                  if (state.status == GetTableStatus.loading) {
                    return Container(
                      width: qrSize,
                      height: qrSize,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: const Center(child: CircularProgressIndicator()),
                    );
                  }
                  return BlocBuilder<QrCodeDialogCubit, QrCodeDialogState>(
                    builder: (context, state) {
                      if (state.status == QrCodeDialogStatus.loading) {
                        return Container(
                          width: qrSize,
                          height: qrSize,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: Colors.grey.shade300),
                          ),
                          child: const Center(
                            child: CircularProgressIndicator(),
                          ),
                        );
                      }

                      if (state.status == QrCodeDialogStatus.success) {
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
                      }
                      return Container(
                        width: qrSize,
                        height: qrSize,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.qr_code_2,
                              size: 72,
                              color: Colors.grey.shade500,
                            ),
                            const SizedBox(height: 12),
                            Text(
                              'QR preview placeholder',
                              style: TextStyle(color: Colors.grey.shade700),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
              // Container(
              //   width: qrSize,
              //   height: qrSize,
              //   decoration: BoxDecoration(
              //     color: Colors.grey.shade100,
              //     borderRadius: BorderRadius.circular(16),
              //     border: Border.all(color: Colors.grey.shade300),
              //   ),
              //   child: Column(
              //     mainAxisAlignment: MainAxisAlignment.center,
              //     children: [
              //       Icon(
              //         Icons.qr_code_2,
              //         size: 72,
              //         color: Colors.grey.shade500,
              //       ),
              //       const SizedBox(height: 12),
              //       Text(
              //         'QR preview placeholder',
              //         style: TextStyle(color: Colors.grey.shade700),
              //       ),
              //     ],
              //   ),
              // ),
              const SizedBox(height: 16),
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

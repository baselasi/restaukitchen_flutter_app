import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restaukitchen_app/core/components/appBar/details_app_bar.dart';
import 'package:restaukitchen_app/core/components/form/input_field.dart';
import 'package:restaukitchen_app/core/components/form/primary_button.dart';
import 'package:restaukitchen_app/core/dialogs/snack_bar.dart';
import 'package:restaukitchen_app/l10n/l10n.dart';
import 'package:restaukitchen_app/page/tabels_list/models/tabel.dart';
import 'package:restaukitchen_app/page/table_form/bloc/table_form_cubit.dart';

class TableForm extends StatefulWidget {
  final Tabel? table;
  const TableForm({super.key, this.table});

  @override
  State<TableForm> createState() => _TableFormState();
}

class _TableFormState extends State<TableForm> {
  TabelStatus _selectedStatus = TabelStatus.available;
  final TextEditingController _tableNumberController = TextEditingController();
  final TextEditingController _tableNumberOfSeatsController =
      TextEditingController();
  static const _statusOptions = [
    TabelStatus.available,
    TabelStatus.reserved,
    TabelStatus.occupied,
  ];

  @override
  void initState() {
    if (widget.table != null) {
      _tableNumberController.text = widget.table!.number.toString();
      _tableNumberOfSeatsController.text = widget.table!.numberOfSeats
          .toString();
      _selectedStatus = widget.table!.status;
    }

    super.initState();
  }

  String _statusLabel(TabelStatus status) {
    final l10n = context.l10n;
    switch (status) {
      case TabelStatus.available:
        return l10n.commonFree;
      case TabelStatus.reserved:
        return l10n.commonReserved;
      case TabelStatus.occupied:
        return l10n.commonOccupied;
      default:
        return l10n.commonFree;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Scaffold(
      appBar: DetailsAppBar(pageTitle: l10n.tablesNewTable),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: BlocConsumer<TableFormCubit, TableFormState>(
          builder: (context, state) {
            if (state.status == TableFormStatus.error ||
                state.status == TableFormStatus.initial) {
              return Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          SizedBox(height: 16),
                          InputField(
                            isNumeric: true,
                            controller: _tableNumberController,
                            label: l10n.tablesTableNumberLabel,
                            isRequired: true,
                          ),
                          SizedBox(height: 16),
                          InputField(
                            isNumeric: true,
                            controller: _tableNumberOfSeatsController,
                            label: l10n.tablesTableSeatsLabel,
                            isRequired: true,
                          ),
                          SizedBox(height: 16),
                          DropdownButtonFormField<TabelStatus>(
                            initialValue: _selectedStatus,
                            decoration: InputDecoration(
                              labelText: '${l10n.tablesStatusLabel} *',
                              labelStyle: Theme.of(
                                context,
                              ).textTheme.bodyMedium,
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 8,
                              ),
                            ),
                            items: _statusOptions.map((status) {
                              return DropdownMenuItem<TabelStatus>(
                                value: status,
                                child: Text(_statusLabel(status)),
                              );
                            }).toList(),
                            onChanged: (value) {
                              if (value != null) {
                                setState(() {
                                  _selectedStatus = value;
                                });
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: PrimaryButton(
                        text: l10n.commonSave,
                        onPressed: () {
                          if (widget.table != null) {
                            context.read<TableFormCubit>().updateTable(
                              tableId: widget.table?.id ?? '',
                              number: _tableNumberController.text,
                              numberOfSeats: _tableNumberOfSeatsController.text,
                              status: _selectedStatus.value,
                            );
                          } else {
                            context.read<TableFormCubit>().createTable(
                              number: _tableNumberController.text,
                              numberOfSeats: _tableNumberOfSeatsController.text,
                              status: _selectedStatus.value,
                            );
                          }
                        },
                      ),
                    ),
                  ),
                ],
              );
            }
            if (state.status == TableFormStatus.loading) {
              return const Center(child: CircularProgressIndicator());
            }
            return const SizedBox.shrink();
          },
          listener: (context, state) {
            if (state.status == TableFormStatus.success) {
              Navigator.of(context).pop(true);
            }
            if (state.status == TableFormStatus.error) {
              AppSnackBar.showError(
                context,
                state.errorMessage ?? l10n.commonError,
              );
            }
          },
        ),
      ),
    );
  }
}

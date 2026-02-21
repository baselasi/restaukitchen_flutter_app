import 'package:flutter/material.dart';
import 'package:restaukitchen_app/core/components/appBar/details_app_bar.dart';
import 'package:restaukitchen_app/core/components/form/input_field.dart';
import 'package:restaukitchen_app/core/components/form/primary_button.dart';
import 'package:restaukitchen_app/page/tabels_list/models/tabel.dart';

class TableForm extends StatefulWidget {
  const TableForm({super.key});

  @override
  State<TableForm> createState() => _TableFormState();
}

class _TableFormState extends State<TableForm> {
  TabelStatus _selectedStatus = TabelStatus.available;

  static const _statusOptions = [
    TabelStatus.available,
    TabelStatus.reserved,
    TabelStatus.occupied,
  ];

  String _statusLabel(TabelStatus status) {
    switch (status) {
      case TabelStatus.available:
        return 'Free';
      case TabelStatus.reserved:
        return 'Reserved';
      case TabelStatus.occupied:
        return 'Occupied';
      default:
        return 'Free';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DetailsAppBar(pageTitle: "New Table"),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(height: 16),
                    InputField(
                      isNumeric: true,
                      controller: TextEditingController(),
                      label: "Table Number",
                      isRequired: true,
                    ),
                    SizedBox(height: 16),
                    InputField(
                      isNumeric: true,
                      controller: TextEditingController(),
                      label: "Table Number of Seats",
                      isRequired: true,
                    ),
                    SizedBox(height: 16),
                    DropdownButtonFormField<TabelStatus>(
                      initialValue: _selectedStatus,
                      decoration: InputDecoration(
                        labelText: 'Status *',
                        labelStyle: Theme.of(context).textTheme.bodyMedium,
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
                child: PrimaryButton(text: "Save", onPressed: () {}),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

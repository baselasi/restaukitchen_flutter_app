import 'package:flutter/material.dart';
import 'package:restaukitchen_app/core/components/appBar/details_app_bar.dart';
import 'package:restaukitchen_app/core/components/form/input_field.dart';
import 'package:restaukitchen_app/core/components/form/primary_button.dart';
import 'package:restaukitchen_app/page/restaurant_form/component/countries_select.dart';
import 'package:restaukitchen_app/page/settings_page/models/restaurant.dart';

class RestaurantFormResult {
  final String name;
  final String country;
  final String currency;
  final String address;
  final String description;

  const RestaurantFormResult({
    required this.name,
    required this.country,
    required this.currency,
    required this.address,
    required this.description,
  });
}

class RestaurantForm extends StatefulWidget {
  const RestaurantForm({super.key, this.restaurant});

  final Restaurant? restaurant;

  @override
  State<RestaurantForm> createState() => _RestaurantFormState();
}

class _RestaurantFormState extends State<RestaurantForm> {
  static const List<String> _currencyOptions = ['\$', 'L.L.', 'Euro'];

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  String? _selectedCountry;
  late String _selectedCurrency;

  bool get _isEditing => widget.restaurant != null;

  @override
  void initState() {
    super.initState();

    _nameController.text = widget.restaurant?.name ?? '';
    _addressController.text = widget.restaurant?.street ?? '';
    _descriptionController.text = widget.restaurant?.description ?? '';

    _selectedCountry = widget.restaurant?.country;

    _selectedCurrency = _currencyOptions.firstWhere(
      (currency) =>
          currency.toLowerCase() == widget.restaurant?.currency.toLowerCase(),
      orElse: () => _currencyOptions.last,
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _addressController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    Navigator.of(context).pop(
      RestaurantFormResult(
        name: _nameController.text.trim(),
        country: _selectedCountry!,
        currency: _selectedCurrency,
        address: _addressController.text.trim(),
        description: _descriptionController.text.trim(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DetailsAppBar(
        pageTitle: _isEditing ? 'Edit Restaurant' : 'New Restaurant',
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        const SizedBox(height: 16),
                        InputField(
                          controller: _nameController,
                          label: 'Restaurant Name',
                          hint: 'Enter restaurant name',
                          isRequired: true,
                          textInputAction: TextInputAction.next,
                        ),
                        const SizedBox(height: 16),
                        CountriesSelect(
                          value: _selectedCountry,
                          onChanged: (value) {
                            setState(() {
                              _selectedCountry = value;
                            });
                          },
                        ),
                        const SizedBox(height: 16),
                        DropdownButtonFormField<String>(
                          initialValue: _selectedCurrency,
                          decoration: InputDecoration(
                            labelText: 'Currency *',
                            labelStyle: Theme.of(context).textTheme.bodyMedium,
                          ),
                          items: _currencyOptions.map((currency) {
                            return DropdownMenuItem<String>(
                              value: currency,
                              child: Text(currency),
                            );
                          }).toList(),
                          onChanged: (value) {
                            if (value == null) return;
                            setState(() {
                              _selectedCurrency = value;
                            });
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please select a currency';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        InputField(
                          controller: _addressController,
                          label: 'Address',
                          hint: 'Enter address',
                          isRequired: true,
                          textInputAction: TextInputAction.next,
                        ),
                        const SizedBox(height: 16),
                        InputField(
                          controller: _descriptionController,
                          label: 'Description',
                          hint: 'Enter description',
                          isRequired: true,
                          maxLines: 5,
                        ),
                      ],
                    ),
                  ),
                ),
                SafeArea(
                  top: false,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 16, bottom: 8),
                    child: PrimaryButton(
                      text: _isEditing ? 'Update' : 'Save',
                      onPressed: _submit,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

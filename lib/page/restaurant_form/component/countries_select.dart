import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restaukitchen_app/l10n/l10n.dart';
import 'package:restaukitchen_app/page/restaurant_form/bloc/countries_cubit/countries_cubit.dart';
import 'package:restaukitchen_app/page/settings_page/respository/restaurant_repo.dart';

class CountriesSelect extends StatefulWidget {
  const CountriesSelect({
    super.key,
    this.value,
    required this.onChanged,
  });

  final String? value;
  final ValueChanged<String?> onChanged;

  @override
  State<CountriesSelect> createState() => _CountriesSelectState();
}

class _CountriesSelectState extends State<CountriesSelect> {
  late final CountriesCubit _countriesCubit;

  @override
  void initState() {
    super.initState();
    _countriesCubit = CountriesCubit(
      restaurantRepo: RestaurantRepo(),
    )..getCountries();
  }

  @override
  void dispose() {
    _countriesCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _countriesCubit,
      child: BlocBuilder<CountriesCubit, CountriesState>(
        builder: (context, state) {
          final l10n = context.l10n;
          final countries = [...state.countries];
          final selectedValue = widget.value;

          if (selectedValue != null &&
              selectedValue.isNotEmpty &&
              !countries.contains(selectedValue)) {
            countries.insert(0, selectedValue);
          }

          return DropdownButtonFormField<String>(
            initialValue: selectedValue,
            decoration: InputDecoration(
              labelText: '${l10n.restaurantCountryLabel} *',
              labelStyle: Theme.of(context).textTheme.bodyMedium,
              errorText: state.status == CountriesStatus.error
                  ? state.error ?? l10n.restaurantFailedLoadCountries
                  : null,
            ),
            items: countries.map((country) {
              return DropdownMenuItem<String>(
                value: country,
                child: Text(country),
              );
            }).toList(),
            onChanged: state.status == CountriesStatus.loading
                ? null
                : widget.onChanged,
            hint: Text(
              state.status == CountriesStatus.loading
                  ? l10n.restaurantLoadingCountries
                  : l10n.restaurantSelectCountry,
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return l10n.restaurantSelectCountryRequired;
              }
              return null;
            },
          );
        },
      ),
    );
  }
}

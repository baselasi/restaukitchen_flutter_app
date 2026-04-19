import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restaukitchen_app/l10n/l10n.dart';
import 'package:restaukitchen_app/page/restaurant_form/bloc/city_autocomplite_cubit/city_autocomplite_cubit.dart';
import 'package:restaukitchen_app/page/restaurant_form/model/city_model.dart';
import 'package:restaukitchen_app/page/settings_page/respository/restaurant_repo.dart';

class CityAutocomplite extends StatefulWidget {
  const CityAutocomplite({
    super.key,
    required this.country,
    this.value,
    required this.onSelected,
  });

  final String? country;
  final CityModel? value;
  final ValueChanged<CityModel?> onSelected;

  @override
  State<CityAutocomplite> createState() => _CityAutocompliteState();
}

class _CityAutocompliteState extends State<CityAutocomplite> {
  late final CityAutocompliteCubit _cityAutocompliteCubit;
  Timer? _debounce;
  CityModel? _selectedCity;
  late String _fieldText;

  bool get _isCountrySelected =>
      widget.country != null && widget.country!.trim().isNotEmpty;

  @override
  void initState() {
    super.initState();
    _cityAutocompliteCubit = CityAutocompliteCubit(
      restaurantRepo: RestaurantRepo(),
    );
    _selectedCity = widget.value;
    _fieldText = widget.value?.name ?? '';
  }

  @override
  void didUpdateWidget(covariant CityAutocomplite oldWidget) {
    super.didUpdateWidget(oldWidget);

    final countryChanged = oldWidget.country != widget.country;
    final valueChanged = oldWidget.value != widget.value;

    if (countryChanged) {
      _selectedCity = null;
      _fieldText = '';
      _debounce?.cancel();
      _cityAutocompliteCubit.clear();
      widget.onSelected(null);
      return;
    }

    if (valueChanged) {
      _selectedCity = widget.value;
      _fieldText = widget.value?.name ?? '';
    }
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _cityAutocompliteCubit.close();
    super.dispose();
  }

  void _onSearchChanged(String value) {
    _fieldText = value;

    if (!_isCountrySelected) {
      _cityAutocompliteCubit.clear();
      return;
    }

    if (_selectedCity?.name != value) {
      _selectedCity = null;
      widget.onSelected(null);
    }

    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () {
      _cityAutocompliteCubit.searchCities(
        country: widget.country!,
        search: value,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _cityAutocompliteCubit,
      child: BlocBuilder<CityAutocompliteCubit, CityAutocompliteState>(
        builder: (context, state) {
          final l10n = context.l10n;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Autocomplete<CityModel>(
                key: ValueKey('${widget.country}-${widget.value?.id ?? ''}'),
                initialValue: TextEditingValue(text: _fieldText),
                displayStringForOption: (option) => option.name,
                optionsBuilder: (textEditingValue) {
                  if (!_isCountrySelected ||
                      textEditingValue.text.trim().isEmpty ||
                      state.status == CityAutocompliteStatus.error) {
                    return const Iterable<CityModel>.empty();
                  }
                  return state.cities.where(
                    (city) => city.name.toLowerCase().contains(
                      textEditingValue.text.trim().toLowerCase(),
                    ),
                  );
                },
                onSelected: (city) {
                  _selectedCity = city;
                  _fieldText = city.name;
                  widget.onSelected(city);
                  FocusScope.of(context).unfocus();
                },
                fieldViewBuilder:
                    (context, controller, focusNode, onFieldSubmitted) {
                      return TextFormField(
                        controller: controller,
                        focusNode: focusNode,
                        enabled: _isCountrySelected,
                        textInputAction: TextInputAction.next,
                        decoration: InputDecoration(
                          labelText: '${l10n.restaurantCityLabel} *',
                          labelStyle: Theme.of(context).textTheme.bodyMedium,
                          hintText: _isCountrySelected
                              ? l10n.restaurantSearchCity
                              : l10n.restaurantSelectCountryFirstHint,
                          suffixIcon:
                              state.status == CityAutocompliteStatus.loading
                              ? const Padding(
                                  padding: EdgeInsets.all(12),
                                  child: SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                    ),
                                  ),
                                )
                              : const Icon(Icons.location_city_outlined),
                        ),
                        onChanged: _onSearchChanged,
                        validator: (value) {
                          if (!_isCountrySelected) {
                            return l10n.restaurantSelectCountryFirstError;
                          }

                          if (value == null || value.trim().isEmpty) {
                            return l10n.restaurantSelectCityRequired;
                          }

                          if (_selectedCity == null ||
                              _selectedCity!.name != value.trim()) {
                            return l10n.restaurantChooseCityFromList;
                          }

                          return null;
                        },
                      );
                    },
                optionsViewBuilder: (context, onSelected, options) {
                  return Align(
                    alignment: Alignment.topLeft,
                    child: Material(
                      elevation: 4,
                      borderRadius: BorderRadius.circular(12),
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(
                          maxHeight: 240,
                          minWidth: 280,
                        ),
                        child: ListView.separated(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          shrinkWrap: true,
                          itemCount: options.length,
                          separatorBuilder: (_, __) => const Divider(height: 1),
                          itemBuilder: (context, index) {
                            final city = options.elementAt(index);
                            return ListTile(
                              dense: true,
                              title: Text(city.name),
                              onTap: () => onSelected(city),
                            );
                          },
                        ),
                      ),
                    ),
                  );
                },
              ),
              if (state.status == CityAutocompliteStatus.error)
                Padding(
                  padding: const EdgeInsets.only(top: 8, left: 12),
                  child: Text(
                    state.error ?? l10n.restaurantFailedLoadCities,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.error,
                      fontSize: 12,
                    ),
                  ),
                ),
              if (_isCountrySelected &&
                  _fieldText.trim().isNotEmpty &&
                  state.status == CityAutocompliteStatus.loaded &&
                  state.cities.isEmpty)
                Padding(
                  padding: EdgeInsets.only(top: 8, left: 12),
                  child: Text(
                    l10n.restaurantNoCitiesFound,
                    style: TextStyle(fontSize: 12),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}

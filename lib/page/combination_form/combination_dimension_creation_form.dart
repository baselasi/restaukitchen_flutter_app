import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:page_transition/page_transition.dart';
import 'package:restaukitchen_app/core/bloc/get_dimensions_cubit.dart';
import 'package:restaukitchen_app/core/components/appBar/details_app_bar.dart';
import 'package:restaukitchen_app/core/components/form/primary_button.dart';
import 'package:restaukitchen_app/page/combination_form/combination_menu_creation_form.dart';
import 'package:restaukitchen_app/page/combination_form/components/dimension_with_price_card.dart';

class CombinationDimensionCreationForm extends StatefulWidget {
  const CombinationDimensionCreationForm({super.key});

  @override
  State<CombinationDimensionCreationForm> createState() =>
      _CombinationDimensionCreationFormState();
}

class _CombinationDimensionCreationFormState
    extends State<CombinationDimensionCreationForm> {
  /// Stable key per dimension for selection and price map (id when present, else name).
  String _dimensionKey(String? id, String name) => id ?? name;

  final TextEditingController _combinationNameController =
      TextEditingController();

  String? _selectedKey;
  final Map<String, String> _priceByDimensionKey = {};

  @override
  void initState() {
    super.initState();
    context.read<GetDimensionsCubit>().getDimensions();
  }

  @override
  void dispose() {
    _combinationNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F3FF),
      appBar: DetailsAppBar(pageTitle: 'Add Dimension'),
      bottomNavigationBar: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
          child: PrimaryButton(
            text: 'Next',
            onPressed: () {
              Navigator.of(context).push(
                PageTransition(
                  type: PageTransitionType.rightToLeft,
                  child: CombinationMenuCreationForm(),
                ),
              );
            },
          ),
        ),
      ),
      body: BlocConsumer<GetDimensionsCubit, GetDimensionsState>(
        builder: (context, state) {
          if (state.status == GetDimensionsStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state.status == GetDimensionsStatus.error) {
            return Center(
              child: Text(state.errorMessage ?? 'Error loading dimensions'),
            );
          }
          if (state.status == GetDimensionsStatus.loaded) {
            final dimensions = state.dimensions ?? [];
            return ListView(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
              children: [
                TextField(
                  controller: _combinationNameController,
                  textCapitalization: TextCapitalization.words,
                  decoration: const InputDecoration(
                    labelText: 'Combination name',
                    hintText: 'Enter a name for this combination',
                  ),
                ),
                const SizedBox(height: 20),
                for (final d in dimensions)
                  DimensionWithPriceCard(
                    dimension: d,
                    isSelected: _selectedKey == _dimensionKey(d.id, d.name),
                    priceText:
                        _priceByDimensionKey[_dimensionKey(d.id, d.name)] ??
                            '',
                    onSelect: () {
                      final key = _dimensionKey(d.id, d.name);
                      setState(() {
                        _selectedKey = key;
                      });
                    },
                    onPriceChanged: (value) {
                      final key = _dimensionKey(d.id, d.name);
                      setState(() {
                        _priceByDimensionKey[key] = value;
                      });
                    },
                  ),
              ],
            );
          }
          return const Center(child: CircularProgressIndicator());
        },
        listener: (context, state) {},
      ),
    );
  }
}

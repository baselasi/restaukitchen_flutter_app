import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:page_transition/page_transition.dart';
import 'package:restaukitchen_app/core/bloc/get_dimensions_cubit.dart';
import 'package:restaukitchen_app/core/bloc/get_ingredients_cubit.dart';
import 'package:restaukitchen_app/core/components/appBar/details_app_bar.dart';
import 'package:restaukitchen_app/core/components/form/primary_button.dart';
import 'package:restaukitchen_app/page/combination_form/bloc/combination_dimension_creation_cubit/combination_dimension_creation_cubit.dart';
import 'package:restaukitchen_app/page/combination_form/bloc/combination_menu_creation_form_cubit/combination_menu_creation_form_cubit.dart';
import 'package:restaukitchen_app/page/combination_form/bloc/combination_post_cubit/combination_post_cubit.dart';
import 'package:restaukitchen_app/page/combination_form/combination_menu_creation_form.dart';
import 'package:restaukitchen_app/page/combination_form/components/dimension_with_price_card.dart';
import 'package:restaukitchen_app/page/combination_form/models/create_combination_request.dart';

class CombinationDimensionCreationForm extends StatefulWidget {
  const CombinationDimensionCreationForm({super.key});

  @override
  State<CombinationDimensionCreationForm> createState() =>
      _CombinationDimensionCreationFormState();
}

class _CombinationDimensionCreationFormState
    extends State<CombinationDimensionCreationForm> {
  final TextEditingController _combinationNameController =
      TextEditingController();
  bool _formHasChanged = false;

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
    final formState = context.watch<CombinationDimensionCreationCubit>().state;
    return Scaffold(
      backgroundColor: const Color(0xFFF5F3FF),
      appBar: DetailsAppBar(pageTitle: 'Add Dimension'),
      bottomNavigationBar: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
          child: PrimaryButton(
            isDisabled: !formState.isValid,
            text: 'Next',
            onPressed: () {
              final postState = context.read<CombinationPostCubit>().state;
              if (postState.status == CombinationPostStatus.success &&
                  !_formHasChanged) {
                Navigator.of(context).push(
                  PageTransition(
                    type: PageTransitionType.rightToLeft,
                    child: MultiBlocProvider(
                      providers: [
                        BlocProvider.value(
                          value: context
                              .read<CombinationMenuCreationFormCubit>(),
                        ),
                        BlocProvider(
                          create: (context) => GetIngredientsCubit(),
                        ),
                      ],
                      child: CombinationMenuCreationForm(
                        combinationId: postState.combinationResponse!.id,
                      ),
                    ),
                  ),
                );
                return;
              } else if (postState.status == CombinationPostStatus.success &&
                  _formHasChanged) {
                Navigator.of(context).push(
                  PageTransition(
                    type: PageTransitionType.rightToLeft,
                    child: MultiBlocProvider(
                      providers: [
                        BlocProvider.value(
                          value: context
                              .read<CombinationMenuCreationFormCubit>(),
                        ),
                        BlocProvider(
                          create: (context) => GetIngredientsCubit(),
                        ),
                      ],
                      child: CombinationMenuCreationForm(
                        combinationId: postState.combinationResponse!.id,
                      ),
                    ),
                  ),
                );
              } else {
                if (!formState.isValid) {
                  return;
                }
                context.read<CombinationPostCubit>().createCombination(
                  CreateCombinationRequest.fromFormState(formState),
                );
              }
            },
          ),
        ),
      ),
      body: BlocConsumer<GetDimensionsCubit, GetDimensionsState>(
        builder: (context, dimensionsState) {
          if (dimensionsState.status == GetDimensionsStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (dimensionsState.status == GetDimensionsStatus.error) {
            return Center(
              child: Text(
                dimensionsState.errorMessage ?? 'Error loading dimensions',
              ),
            );
          }
          if (dimensionsState.status == GetDimensionsStatus.loaded) {
            final dimensions = dimensionsState.dimensions ?? [];
            return BlocConsumer<CombinationPostCubit, CombinationPostState>(
              builder: (context, posState) {
                if (posState.status == CombinationPostStatus.loading) {
                  return const Center(child: CircularProgressIndicator());
                }
                return BlocConsumer<
                  CombinationDimensionCreationCubit,
                  CombinationDimensionCreationState
                >(
                  builder: (context, state) {
                    return ListView(
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                      children: [
                        SizedBox(height: 20),
                        TextField(
                          controller: _combinationNameController,
                          textCapitalization: TextCapitalization.words,
                          onChanged: (value) => context
                              .read<CombinationDimensionCreationCubit>()
                              .setCombinationName(value),
                          decoration: const InputDecoration(
                            labelText: 'Combination name',
                            hintText: 'Enter a name for this combination',
                          ),
                        ),
                        const SizedBox(height: 20),
                        for (final d in dimensions)
                          DimensionWithPriceCard(
                            dimension: d,
                            isSelected: state.dimensionsById.containsKey(d.id),
                            priceText: state.dimensionsById[d.id]?.price ?? '',
                            onSelect: () {
                              if (state.dimensionsById.containsKey(d.id)) {
                                context
                                    .read<CombinationDimensionCreationCubit>()
                                    .removeDimensionEntry(d.id!);
                              } else {
                                context
                                    .read<CombinationDimensionCreationCubit>()
                                    .setDimensionEntry(d.id!, d);
                              }
                            },
                            onPriceChanged: (value) => context
                                .read<CombinationDimensionCreationCubit>()
                                .updatePrice(d.id!, value),
                          ),
                      ],
                    );
                  },
                  listener: (context, state) {
                    _formHasChanged = true;
                  },
                );
              },
              listener: (context, state) {
                if (state.status == CombinationPostStatus.success) {
                  _formHasChanged = false;
                  Navigator.of(context).push(
                    PageTransition(
                      type: PageTransitionType.rightToLeft,
                      child: MultiBlocProvider(
                        providers: [
                          BlocProvider.value(
                            value: context
                                .read<CombinationMenuCreationFormCubit>(),
                          ),
                          BlocProvider(
                            create: (context) => GetIngredientsCubit(),
                          ),
                        ],
                        child: CombinationMenuCreationForm(
                          combinationId: state.combinationResponse!.id,
                        ),
                      ),
                    ),
                  );
                }
              },
            );
          }
          return const Center(child: CircularProgressIndicator());
        },
        listener: (context, state) {},
      ),
    );
  }
}

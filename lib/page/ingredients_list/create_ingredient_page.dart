import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restaukitchen_app/core/components/appBar/details_app_bar.dart';
import 'package:restaukitchen_app/core/components/form/input_field.dart';
import 'package:restaukitchen_app/core/components/form/primary_button.dart';
import 'package:restaukitchen_app/core/models/ingredients.dart';
import 'package:restaukitchen_app/page/combination_form/components/dimension_with_price_card.dart';
import 'package:restaukitchen_app/page/dimension_list/bloc/get_dimensions_cubit.dart';
import 'package:restaukitchen_app/page/ingredients_list/bloc/new_ingredient_form_cubit.dart';
import 'package:restaukitchen_app/page/ingredients_list/bloc/post_ingredient_cubit.dart';

class CreateIngredientPage extends StatefulWidget {
  const CreateIngredientPage({super.key, this.ingredient});

  final Ingredient? ingredient;
  @override
  State<CreateIngredientPage> createState() => _CreateIngredientPageState();
}

class _CreateIngredientPageState extends State<CreateIngredientPage> {
  final TextEditingController _nameController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  void _syncNameController(String name) {
    if (_nameController.text == name) return;
    _nameController.value = TextEditingValue(
      text: name,
      selection: TextSelection.collapsed(offset: name.length),
    );
  }

  @override
  void initState() {
    super.initState();
    if (context.read<GetDimensionsCubit>().state.status !=
        GetDimensionsStatus.loaded) {
      context.read<GetDimensionsCubit>().getDimensions();
    }
    if (widget.ingredient != null) {
      context.read<NewIngredientFormCubit>().createStateFromIngredient(
        widget.ingredient!,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final formState = context.watch<NewIngredientFormCubit>().state;
    final postState = context.watch<PostIngredientCubit>().state;
    _syncNameController(formState.name);
    return Scaffold(
      appBar: DetailsAppBar(pageTitle: 'Create Ingredient'),
      bottomNavigationBar: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
          child: PrimaryButton(
            text: 'Save',
            onPressed: () {
              if (widget.ingredient != null) {
                context.read<PostIngredientCubit>().updateIngredient(
                  formState,
                  widget.ingredient!.id!,
                );
              } else {
                context.read<PostIngredientCubit>().postIngredient(formState);
              }
              context.read<PostIngredientCubit>().postIngredient(formState);
            },
            isDisabled:
                !formState.isValid ||
                postState.status == PostIngredientStatus.loading,
          ),
        ),
      ),
      body: BlocBuilder<GetDimensionsCubit, GetDimensionsState>(
        builder: (context, getDimenionsstate) {
          if (getDimenionsstate.status == GetDimensionsStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (getDimenionsstate.status == GetDimensionsStatus.error) {
            return Center(
              child: Text(
                getDimenionsstate.errorMessage ?? 'Error loading dimensions',
              ),
            );
          }
          if (getDimenionsstate.status == GetDimensionsStatus.loaded) {
            return BlocConsumer<PostIngredientCubit, PostIngredientState>(
              builder: (context, postState) {
                if (postState.status == PostIngredientStatus.loading) {
                  return const Center(child: CircularProgressIndicator());
                }
                return BlocBuilder<
                  NewIngredientFormCubit,
                  NewIngredientFormState
                >(
                  builder: (context, formState) {
                    return Padding(
                      padding: const EdgeInsets.all(16),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            InputField(
                              controller: _nameController,
                              label: 'Name',
                              isRequired: true,
                              onChanged: (value) {
                                context.read<NewIngredientFormCubit>().setName(
                                  value,
                                );
                              },
                            ),
                            SizedBox(height: 16),
                            ListView.builder(
                              shrinkWrap: true,
                              itemCount:
                                  getDimenionsstate.dimensions?.length ?? 0,
                              itemBuilder: (context, index) {
                                return DimensionWithPriceCard(
                                  dimension:
                                      getDimenionsstate.dimensions![index],
                                  isSelected: formState.dimensionsById
                                      .containsKey(
                                        getDimenionsstate.dimensions![index].id,
                                      ),
                                  priceText:
                                      formState
                                          .dimensionsById[getDimenionsstate
                                              .dimensions![index]
                                              .id]
                                          ?.price ??
                                      '',
                                  onPriceChanged: (value) {
                                    context
                                        .read<NewIngredientFormCubit>()
                                        .updatePrice(
                                          getDimenionsstate
                                              .dimensions![index]
                                              .id!,
                                          value,
                                        );
                                  },
                                  onSelect: () {
                                    if (formState.dimensionsById.containsKey(
                                      getDimenionsstate.dimensions![index].id,
                                    )) {
                                      context
                                          .read<NewIngredientFormCubit>()
                                          .removeDimensionEntry(
                                            getDimenionsstate
                                                .dimensions![index]
                                                .id!,
                                          );
                                    } else {
                                      context
                                          .read<NewIngredientFormCubit>()
                                          .setDimensionEntry(
                                            getDimenionsstate
                                                .dimensions![index]
                                                .id!,
                                            getDimenionsstate
                                                .dimensions![index],
                                          );
                                    }
                                  },
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
              listener: (context, state) {
                if (state.status == PostIngredientStatus.success) {
                  Navigator.of(context).pop(state.ingredient);
                }
                if (state.status == PostIngredientStatus.error) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(state.errorMessage ?? 'Error')),
                  );
                }
              },
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}

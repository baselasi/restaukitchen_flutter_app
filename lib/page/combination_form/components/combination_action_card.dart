import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restaukitchen_app/core/components/form/input_field.dart';
import 'package:restaukitchen_app/core/dialogs/snack_bar.dart';
import 'package:restaukitchen_app/l10n/l10n.dart';
import 'package:restaukitchen_app/page/combination_form/bloc/combination_menu_creation_form_cubit/combination_menu_creation_form_cubit.dart';
import 'package:restaukitchen_app/page/combination_form/bloc/menu_combination_post_cubit/menu_combination_post_cubit.dart';
import 'package:restaukitchen_app/page/combination_form/models/create_menu_combination_request.dart';

/// Horizontal card: tinted icon box, title + subtitle, trailing primary action.
class CombinationActionCard extends StatelessWidget {
  final IconData icon;
  final String combinationId;

  const CombinationActionCard({
    super.key,
    this.icon = Icons.library_add_outlined,
    required this.combinationId,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;
    final nameController = TextEditingController();
    final FocusNode nameFocusNode = FocusNode();
    final l10n = context.l10n;

    return BlocConsumer<CreateCombinationMenuCubit, CreateCombinationMenuState>(
      builder: (context, state) {
        return Material(
          color: theme.colorScheme.surface,
          elevation: 2,
          shadowColor: Colors.black.withValues(alpha: 0.06),
          borderRadius: BorderRadius.circular(18),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(height: 4),
                      InputField(
                        focusNode: nameFocusNode,
                        controller: nameController,
                        isRequired:
                            state.status == CreateCombinationMenuStatus.loading,
                        onChanged: (value) {},
                        label: l10n.combinationsGroupNameLabel,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                if (state.status == CreateCombinationMenuStatus.loading)
                  const CircularProgressIndicator()
                else
                  FilledButton(
                    onPressed: () {
                      context
                          .read<CreateCombinationMenuCubit>()
                          .createMenuCombination(
                            CreateMenuCombinationRequest(
                              combinationId: combinationId,
                              name: nameController.text,
                            ),
                          );
                    },
                    style: FilledButton.styleFrom(
                      backgroundColor: primary,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text(
                      l10n.commonCreate,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
      listener: (context, state) {
        if (state.status == CreateCombinationMenuStatus.success) {
          nameController.clear();
          nameFocusNode.unfocus();
          final response = state.combinationMenuResponse;
          if (response != null) {
            context.read<CombinationMenuCreationFormCubit>().addMenu(
              CombinationMenuModel(
                id: response.id,
                name: response.name,
                ingredients: const [],
                dishes: const [],
              ),
            );
          }
        }
        if (state.status == CreateCombinationMenuStatus.error) {
          AppSnackBar.showError(
            context,
            state.errorMessage ?? l10n.combinationsErrorCreatingGroup,
          );
        }
      },
    );
  }
}

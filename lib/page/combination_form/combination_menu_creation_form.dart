import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restaukitchen_app/core/components/appBar/details_app_bar.dart';
import 'package:restaukitchen_app/core/components/form/primary_button.dart';
import 'package:restaukitchen_app/l10n/l10n.dart';
import 'package:restaukitchen_app/page/combination_form/bloc/combination_menu_creation_form_cubit/combination_menu_creation_form_cubit.dart';
import 'package:restaukitchen_app/page/combination_form/bloc/menu_combination_post_cubit/menu_combination_post_cubit.dart';
import 'package:restaukitchen_app/page/combination_form/components/combination_action_card.dart';
import 'package:restaukitchen_app/page/combination_form/components/combination_menu_item_card.dart';
import 'package:restaukitchen_app/page/combination_form/repository/combination_form_repo.dart';
import 'package:restaukitchen_app/page/menusPage/bloc/delete_menu_cubit.dart';
import 'package:restaukitchen_app/page/menusPage/repository/menus_page_repo.dart';

class CombinationMenuCreationForm extends StatelessWidget {
  final String combinationId;
  final List<String> combinationDimensionIds;
  const CombinationMenuCreationForm({
    super.key,
    required this.combinationId,
    required this.combinationDimensionIds,
  });
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<
      CombinationMenuCreationFormCubit,
      CombinationMenuCreationFormState
    >(
      builder: (context, state) {
        final l10n = context.l10n;
        return Scaffold(
          appBar: DetailsAppBar(pageTitle: l10n.combinationsAddMenuTitle),
          body: SafeArea(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
              children: [
                BlocProvider(
                  create: (context) => CreateCombinationMenuCubit(
                    combinationFormRepo: CombinationFormRepo(),
                  ),
                  child: CombinationActionCard(combinationId: combinationId),
                ),
                for (final menu in state.combinationMenus) ...[
                  const SizedBox(height: 16),
                  BlocProvider(
                    create: (context) =>
                        DeleteMenuCubit(menusPageRepo: MenusPageRepo()),
                    child: CombinationMenuItemCard(
                      key: ValueKey(menu.id),
                      combinationDimensionIds: combinationDimensionIds,
                      menu: menu,
                    ),
                  ),
                ],
              ],
            ),
          ),
          bottomNavigationBar: SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
              child: PrimaryButton(
                text: l10n.commonDone,
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
              ),
            ),
          ),
        );
      },
    );
  }
}

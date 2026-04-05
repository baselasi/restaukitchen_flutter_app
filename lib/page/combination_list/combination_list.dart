import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:page_transition/page_transition.dart';
import 'package:restaukitchen_app/core/bloc/auth_cubit.dart';
import 'package:restaukitchen_app/core/bloc/get_dimensions_cubit.dart';
import 'package:restaukitchen_app/core/repository/dimensions_repo.dart';
import 'package:restaukitchen_app/page/combination_form/bloc/combination_dimension_creation_cubit/combination_dimension_creation_cubit.dart';
import 'package:restaukitchen_app/page/combination_form/bloc/combination_menu_creation_form_cubit/combination_menu_creation_form_cubit.dart';
import 'package:restaukitchen_app/page/combination_form/bloc/combination_post_cubit/combination_post_cubit.dart';
import 'package:restaukitchen_app/page/combination_form/combination_dimension_creation_form.dart';
import 'package:restaukitchen_app/page/combination_form/repository/combination_form_repo.dart';
import 'package:restaukitchen_app/page/combination_list/bloc/combination_get_cubit/combination_get_list_cubit.dart';
import 'package:restaukitchen_app/page/combination_list/bloc/delete_combination_cubit/delete_combination_cubit.dart';
import 'package:restaukitchen_app/page/combination_list/components/combination_edit_preview_bottom_sheet.dart';
import 'package:restaukitchen_app/page/combination_list/components/combination_list_item_card.dart';
import 'package:restaukitchen_app/page/combination_list/repository/combination_list_repo.dart';

class CombinationList extends StatefulWidget {
  const CombinationList({super.key});

  @override
  State<CombinationList> createState() => _CombinationListState();
}

class _CombinationListState extends State<CombinationList> {
  @override
  void initState() {
    super.initState();
    context.read<CombinationGetListCubit>().getCombinations(
      context.read<AuthCubit>().state.user?.restaurant ?? "",
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            PageTransition(
              type: PageTransitionType.rightToLeft,
              child: MultiBlocProvider(
                providers: [
                  BlocProvider(
                    create: (context) =>
                        GetDimensionsCubit(dimensionsRepo: DimensionsRepo()),
                  ),
                  BlocProvider(
                    create: (context) => CombinationDimensionCreationCubit(),
                  ),
                  BlocProvider(
                    create: (context) => CombinationPostCubit(
                      combinationFormRepo: CombinationFormRepo(),
                    ),
                  ),
                  BlocProvider(
                    create: (context) => CombinationMenuCreationFormCubit(),
                  ),
                ],
                child: CombinationDimensionCreationForm(),
              ),
            ),
          );
        },
        child: Icon(Icons.add),
      ),
      body: BlocConsumer<CombinationGetListCubit, CombinationGetListState>(
        builder: (context, state) {
          if (state.status == CombinationGetListStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state.status == CombinationGetListStatus.error) {
            return Center(child: Text(state.errorMessage ?? 'Error'));
          }
          if (state.status == CombinationGetListStatus.loaded) {
            final list = state.combinations!;

            return RefreshIndicator(
              onRefresh: () async {
                await context.read<CombinationGetListCubit>().getCombinations(
                  context.read<AuthCubit>().state.user?.restaurant ?? '',
                  refresh: true,
                );
              },
              child: list.isEmpty
                  ? ListView(
                      children: [
                        const SizedBox(height: 200),
                        const Center(child: Text('No combinations')),
                      ],
                    )
                  : ListView.builder(
                      clipBehavior: Clip.none,
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 88),
                      itemCount: list.length,
                      itemBuilder: (context, index) {
                        final item = list[index];
                        return BlocProvider(
                          create: (context) => DeleteCombinationCubit(
                            combinationListRepo: CombinationListRepo(),
                          ),
                          child: CombinationListItemCard(
                            item: item,
                            onEdit: () => showCombinationEditPreviewBottomSheet(
                              context,
                              combinationId: item.id,
                            ),
                            onDelete: () => context
                                .read<CombinationGetListCubit>()
                                .removeCombination(item.id),
                          ),
                        );
                      },
                    ),
            );
          }
          return const SizedBox.shrink();
        },
        listener: (context, state) {},
      ),
    );
  }
}

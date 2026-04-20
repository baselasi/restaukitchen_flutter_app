import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restaukitchen_app/core/components/appBar/details_app_bar.dart';
import 'package:restaukitchen_app/core/models/dish.dart';
import 'package:restaukitchen_app/l10n/l10n.dart';
import 'package:restaukitchen_app/page/menusPage/bloc/delete_dish_cubit.dart';
import 'package:restaukitchen_app/page/silverware_list/bloc/silverware_list_cubit/silverware_list_cubit.dart';
import 'package:restaukitchen_app/page/silverware_list/components/add_silverware_sheet.dart';
import 'package:restaukitchen_app/theme/light_theme.dart';

class SilverwareList extends StatefulWidget {
  const SilverwareList({super.key});

  @override
  State<SilverwareList> createState() => _SilverwareListState();
}

class _SilverwareListState extends State<SilverwareList> {
  @override
  void initState() {
    super.initState();
    context.read<SilverwareListCubit>().getSilverware();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showAddSilverwareSheet(context);
        },
        child: const Icon(Icons.add),
      ),
      appBar: DetailsAppBar(pageTitle: l10n.silverwareListTitle),
      body: BlocConsumer<SilverwareListCubit, SilverwareListState>(
        builder: (context, state) {
          if (state.status == SilverwareListStatus.loaded) {
            final silverware = state.silverware?.silverwares ?? [];
            if (silverware.isEmpty) {
              return Center(child: Text(l10n.silverwareEmptyMessage));
            }
            return Center(
              child: ListView.separated(
                shrinkWrap: true,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: silverware.length,
                itemBuilder: (context, index) {
                  final dish = silverware[index];
                  return BlocProvider(
                    create: (context) => DeleteDishCubit(),
                    child: _SilverwareCard(dish: dish),
                  );
                },
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 12),
              ),
            );
          }
          if (state.status == SilverwareListStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state.status == SilverwareListStatus.error) {
            return Center(child: Text(state.errorMessage!));
          }
          return const SizedBox.shrink();
        },
        listener: (context, state) {},
      ),
    );
  }
}

class _SilverwareCard extends StatelessWidget {
  const _SilverwareCard({required this.dish});

  final Dish dish;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
      elevation: 2,
      shadowColor: Colors.black.withValues(alpha: 0.08),
      child: InkWell(
        onTap: () {},
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: LightTheme.primaryColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                alignment: Alignment.center,
                child: const Icon(
                  Icons.flatware_rounded,
                  color: Colors.white,
                  size: 22,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  dish.name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF111827),
                  ),
                ),
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.edit_outlined),
                color: const Color(0xFF1D4ED8),
                tooltip: l10n.commonEdit,
              ),
              BlocConsumer<DeleteDishCubit, DeleteDishState>(
                builder: (context, state) {
                  if (state.status == DeleteDishStatus.isLoading) {
                    return const SizedBox(
                      width: 24,
                      height: 24,
                      child: Padding(
                        padding: EdgeInsets.all(2),
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                    );
                  }
                  return IconButton(
                    onPressed: () {
                      context.read<DeleteDishCubit>().deleteDish(dish.id ?? '');
                    },
                    icon: const Icon(Icons.delete_outline),
                    color: const Color(0xFFDC2626),
                    tooltip: l10n.commonDelete,
                  );
                },
                listener: (context, state) {
                  if (state.status == DeleteDishStatus.isSucess) {
                    context.read<SilverwareListCubit>().getSilverware();
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

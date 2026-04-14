import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restaukitchen_app/page/combination_page/bloc/combination_get_cubit/combination_get_cubit.dart';
import 'package:restaukitchen_app/page/combination_page/models/combination.dart';
import 'package:restaukitchen_app/page/combination_page/repository/combination_page_repo.dart';
import 'package:restaukitchen_app/theme/light_theme.dart';

/// Read-only preview of a combination: menus as sections and dishes as rows.
Future<Combination?> showCombinationEditPreviewBottomSheet(
  BuildContext context, {
  required String combinationId,
}) {
  return showModalBottomSheet<Combination?>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    barrierColor: Colors.black54,
    builder: (sheetContext) {
      return BlocProvider(
        create: (_) {
          final cubit = CombinationGetCubit(
            combinationPageRepo: CombinationPageRepo(),
          );
          cubit.getCombination(combinationId);
          return cubit;
        },
        child: _CombinationEditPreviewSheet(sheetContext: sheetContext),
      );
    },
  );
}

class _CombinationEditPreviewSheet extends StatelessWidget {
  final BuildContext sheetContext;

  const _CombinationEditPreviewSheet({required this.sheetContext});

  static const List<Color> _sectionAccents = [
    Color(0xFF6B8E23),
    LightTheme.primaryColor,
  ];

  static String _priceRangeLabel(Combination c) {
    final prices = c.dimensionAssignments
        .where((a) => !a.isDeleted)
        .map((a) => a.price)
        .toList();
    if (prices.isEmpty) return '—';
    prices.sort();
    final min = prices.first;
    final max = prices.last;
    final a = min.toStringAsFixed(2);
    final b = max.toStringAsFixed(2);
    if (min == max) return '€$a';
    return '€$a – €$b';
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.paddingOf(context).bottom;
    final maxHeight = MediaQuery.sizeOf(context).height * 0.6;
    final navigator = Navigator.of(sheetContext);

    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
      child: Align(
        alignment: Alignment.bottomCenter,
        child: SizedBox(
          height: maxHeight,
          child: Material(
            color: Colors.white,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            clipBehavior: Clip.antiAlias,
            child: BlocBuilder<CombinationGetCubit, CombinationGetState>(
              builder: (context, state) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 10),
                    Center(
                      child: Container(
                        width: 40,
                        height: 4,
                        decoration: BoxDecoration(
                          color: Colors.grey[400],
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 16, 8, 8),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child:
                                state.status == CombinationGetStatus.loaded &&
                                    state.combination != null
                                ? Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        state.combination!.name,
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleLarge
                                            ?.copyWith(
                                              fontWeight: FontWeight.w700,
                                              color: LightTheme.primaryColor,
                                            ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        _priceRangeLabel(state.combination!),
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium
                                            ?.copyWith(color: Colors.grey[600]),
                                      ),
                                    ],
                                  )
                                : const SizedBox.shrink(),
                          ),
                        ],
                      ),
                    ),
                    if (state.status == CombinationGetStatus.error)
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 8,
                        ),
                        child: Text(
                          state.errorMessage ?? 'Failed to load combination',
                          style: TextStyle(color: Colors.red[700]),
                        ),
                      ),
                    Expanded(
                      child:
                          state.status == CombinationGetStatus.loaded &&
                              state.combination != null
                          ? _SheetBody(
                              combination: state.combination!,
                              sectionAccents: _sectionAccents,
                            )
                          : state.status == CombinationGetStatus.loading
                          ? const Center(child: CircularProgressIndicator())
                          : const SizedBox.shrink(),
                    ),
                    if (state.status == CombinationGetStatus.loaded &&
                        state.combination != null)
                      SafeArea(
                        top: false,
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(
                            20,
                            12,
                            20,
                            16 + bottomInset,
                          ),
                          child: SizedBox(
                            width: double.infinity,
                            child: FilledButton.icon(
                              onPressed: () {
                                navigator.pop(state.combination!);
                              },
                              style: FilledButton.styleFrom(
                                backgroundColor: LightTheme.primaryColor,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 16,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              icon: const Icon(Icons.edit_outlined, size: 22),
                              label: const Text(
                                'Edit Combo',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

class _SheetBody extends StatelessWidget {
  final Combination combination;
  final List<Color> sectionAccents;

  const _SheetBody({required this.combination, required this.sectionAccents});

  static const Color _ingredientChipBg = Color(0xFFEDEAF7);

  @override
  Widget build(BuildContext context) {
    final menus = combination.menuList;
    if (menus.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Text('No menus', style: TextStyle(color: Colors.grey[600])),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 8),
      itemCount: menus.length,
      itemBuilder: (context, sectionIndex) {
        final menu = menus[sectionIndex];
        final accent = sectionAccents[sectionIndex % sectionAccents.length];
        return Padding(
          padding: EdgeInsets.only(
            bottom: sectionIndex < menus.length - 1 ? 20 : 0,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 4,
                    height: 18,
                    decoration: BoxDecoration(
                      color: accent,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      menu.name.toUpperCase(),
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        letterSpacing: 0.6,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey[800],
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),
              ...menu.dishes.map(
                (dish) => Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: _DishPreviewRow(title: dish.name),
                ),
              ),
              if (menu.ingredients.any((i) => i.name.trim().isNotEmpty)) ...[
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.only(left: 14),
                  child: Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      for (final ing in menu.ingredients)
                        if (ing.name.trim().isNotEmpty)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: _ingredientChipBg,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              ing.name.trim(),
                              style: Theme.of(context).textTheme.labelMedium
                                  ?.copyWith(
                                    color: const Color(0xFF374151),
                                    fontWeight: FontWeight.w500,
                                  ),
                            ),
                          ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}

class _DishPreviewRow extends StatelessWidget {
  final String title;

  const _DishPreviewRow({required this.title});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: const Color(0xFFEDEAF7),
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF1F2937),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                color: LightTheme.primaryColor,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.check, color: Colors.white, size: 18),
            ),
          ],
        ),
      ),
    );
  }
}

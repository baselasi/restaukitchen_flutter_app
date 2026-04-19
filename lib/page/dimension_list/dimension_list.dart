import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restaukitchen_app/core/dialogs/snack_bar.dart';
import 'package:restaukitchen_app/page/dimension_list/bloc/delete_dimensions_cubit.dart';
import 'package:restaukitchen_app/page/dimension_list/bloc/get_dimensions_cubit.dart';
import 'package:restaukitchen_app/core/components/appBar/details_app_bar.dart';
import 'package:restaukitchen_app/core/components/form/dimensionInput/dimension.dart';
import 'package:restaukitchen_app/l10n/l10n.dart';
import 'package:restaukitchen_app/page/dimension_list/components/add_dimension_sheet.dart';
import 'package:restaukitchen_app/page/dimension_list/repository/dimensions_repo.dart';
import 'package:restaukitchen_app/theme/light_theme.dart';

class DimensionList extends StatefulWidget {
  const DimensionList({super.key});

  @override
  State<DimensionList> createState() => _DimensionListState();
}

class _DimensionListState extends State<DimensionList> {
  @override
  void initState() {
    super.initState();
    context.read<GetDimensionsCubit>().getDimensions();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await showAddDimensionSheet(context);
          if (result != null && context.mounted) {
            context.read<GetDimensionsCubit>().addDimension(result);
          }
        },
        child: const Icon(Icons.add),
      ),
      appBar: DetailsAppBar(pageTitle: l10n.dimensionsListTitle),
      body: BlocConsumer<GetDimensionsCubit, GetDimensionsState>(
        builder: (context, state) {
          if (state.status == GetDimensionsStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state.status == GetDimensionsStatus.error) {
            return Center(
              child: Text(state.errorMessage ?? l10n.commonFailedLoadDimensions),
            );
          }
          if (state.status == GetDimensionsStatus.loaded) {
            final dimensions = state.dimensions ?? [];
            return Center(
              child: ListView.separated(
                shrinkWrap: true,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: dimensions.length,
                separatorBuilder: (_, _) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  if (dimensions[index].deleted == true) {
                    return const SizedBox.shrink();
                  }
                  return BlocProvider(
                    create: (context) =>
                        DeleteDimensionsCubit(dimensionsRepo: DimensionsRepo()),
                    child: _DimensionCard(dimension: dimensions[index]),
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

class _DimensionCard extends StatelessWidget {
  const _DimensionCard({required this.dimension});

  final Dimension dimension;

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
                  Icons.straighten_rounded,
                  color: Colors.white,
                  size: 22,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      dimension.name,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF111827),
                      ),
                    ),
                    Text(
                      dimension.standard
                          ? l10n.dimensionsStandard
                          : l10n.dimensionsCustom,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xFF6B7280),
                      ),
                    ),
                    const SizedBox(height: 2),
                  ],
                ),
              ),
              if (dimension.standard == false)
                IconButton(
                  onPressed: () async {
                    final result = await showAddDimensionSheet(
                      context,
                      name: dimension.name,
                      standard: dimension.standard,
                      id: dimension.id,
                    );
                    if (result != null && context.mounted) {
                      context.read<GetDimensionsCubit>().updateDimension(
                        result,
                      );
                    }
                  },
                  icon: const Icon(Icons.edit_outlined),
                  color: const Color(0xFF1D4ED8),
                  tooltip: l10n.dimensionsEditTooltip,
                ),
              if (dimension.standard == false)
                BlocConsumer<DeleteDimensionsCubit, DeleteDimensionsState>(
                  builder: (context, state) {
                    if (state.status == DeleteDimensionsStatus.loading) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    return IconButton(
                      onPressed: () {
                        context.read<DeleteDimensionsCubit>().deleteDimensions(
                          dimension.id ?? '',
                        );
                      },
                      icon: const Icon(Icons.delete_outline),
                      color: const Color(0xFFDC2626),
                      tooltip: l10n.dimensionsDeleteTooltip,
                    );
                  },
                  listener: (context, state) {
                    if (state.status == DeleteDimensionsStatus.success) {
                      context.read<GetDimensionsCubit>().deleteDimension(
                        dimension.id ?? '',
                      );
                    }
                    if (state.status == DeleteDimensionsStatus.error) {
                      AppSnackBar.showError(
                        context,
                        state.errorMessage ?? l10n.dimensionsErrorDeleting,
                      );
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

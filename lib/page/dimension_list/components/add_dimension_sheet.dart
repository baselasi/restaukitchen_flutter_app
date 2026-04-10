import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restaukitchen_app/core/components/form/dimensionInput/dimension.dart';
import 'package:restaukitchen_app/page/dimension_list/bloc/post_dimesions_cubit.dart';
import 'package:restaukitchen_app/page/dimension_list/repository/dimensions_repo.dart';

Future<Dimension?> showAddDimensionSheet(
  BuildContext context, {
  String? name,
  String? id,
  bool standard = false,
}) {
  return showModalBottomSheet<Dimension>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => BlocProvider(
      create: (context) =>
          PostDimensionsCubit(dimensionsRepo: DimensionsRepo()),
      child: AddDimensionSheet(name: name, standard: standard, id: id),
    ),
  );
}

class AddDimensionSheetResult {
  const AddDimensionSheetResult({required this.name, required this.standard});

  final String name;
  final bool standard;
}

class AddDimensionSheet extends StatefulWidget {
  const AddDimensionSheet({
    super.key,
    this.name,
    this.standard = false,
    this.id,
  });

  final String? name;
  final bool standard;
  final String? id;
  @override
  State<AddDimensionSheet> createState() => _AddDimensionSheetState();
}

class _AddDimensionSheetState extends State<AddDimensionSheet> {
  final TextEditingController _nameController = TextEditingController();
  late bool _isStandard;

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.name ?? '';
    _isStandard = widget.standard;
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    final trimmedName = _nameController.text.trim();

    return Padding(
      padding: EdgeInsets.only(bottom: bottomInset),
      child: BlocConsumer<PostDimensionsCubit, PostDimensionsState>(
        builder: (context, state) {
          if (state.status == PostDimensionsStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          }

          return Container(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(24),
              ),
            ),
            child: SafeArea(
              top: false,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 44,
                      height: 4,
                      decoration: BoxDecoration(
                        color: const Color(0xFFD1D5DB),
                        borderRadius: BorderRadius.circular(999),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    widget.name != null ? 'Edit Dimension' : 'Create Dimension',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    widget.name != null
                        ? 'Edit the name and settings of your dimension.'
                        : 'Add a name for your new dimension.',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: const Color(0xFF6B7280),
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: _nameController,
                    autofocus: true,
                    textInputAction: TextInputAction.done,
                    decoration: const InputDecoration(
                      labelText: 'Dimension name',
                    ),
                    onChanged: (_) => setState(() {}),
                    onSubmitted: (value) {
                      final name = value.trim();
                      if (name.isEmpty) return;
                      Navigator.of(context).pop(
                        AddDimensionSheetResult(
                          name: name,
                          standard: _isStandard,
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: const Text('Cancel'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: FilledButton(
                          onPressed: () {
                            if (trimmedName.isEmpty) return;
                            context.read<PostDimensionsCubit>().postDimensions(
                              trimmedName,
                              widget.id,
                            );
                          },
                          child: Text(
                            widget.name != null
                                ? 'Save Dimension'
                                : 'Create Dimension',
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
        listener: (context, state) {
          if (state.status == PostDimensionsStatus.loaded) {
            Navigator.of(context).pop(state.dimension);
          }
          if (state.status == PostDimensionsStatus.error) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.errorMessage ?? 'Error')),
            );
          }
        },
      ),
    );
  }
}

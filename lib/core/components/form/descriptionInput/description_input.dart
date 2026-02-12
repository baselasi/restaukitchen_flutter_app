import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restaukitchen_app/core/components/form/descriptionInput/description_cubit.dart';
import 'package:restaukitchen_app/core/components/form/input_field.dart';
import 'package:restaukitchen_app/core/models/dish.dart';

class DescriptionInput extends StatefulWidget {
  final Dish? dish;
  const DescriptionInput({super.key, this.dish});

  @override
  State<DescriptionInput> createState() => _DescriptionInputState();
}

class _DescriptionInputState extends State<DescriptionInput> {
  final Map<String, TextEditingController> _controllers = {};

  @override
  void initState() {
    super.initState();
    context.read<DescriptionCubit>().initDescriptions(
      description: widget.dish?.description,
      descriptionIt: widget.dish?.descriptionIt,
      descriptionFr: widget.dish?.descriptionFr,
      descriptionEs: widget.dish?.descriptionEs,
      descriptionAr: widget.dish?.descriptionAr,
    );
  }

  /// Creates controllers for new entries and disposes removed ones.
  void _syncControllers(DescriptionState state) {
    final currentIds = state.descriptions.map((e) => e.id).toSet();

    // Dispose controllers for entries that were removed
    final removedIds =
        _controllers.keys.where((id) => !currentIds.contains(id)).toList();
    for (final id in removedIds) {
      _controllers[id]!.dispose();
      _controllers.remove(id);
    }

    // Create controllers for newly added entries
    for (final entry in state.descriptions) {
      if (!_controllers.containsKey(entry.id)) {
        _controllers[entry.id] = TextEditingController(text: entry.value);
      }
    }
  }

  @override
  void dispose() {
    for (final controller in _controllers.values) {
      controller.dispose();
    }
    _controllers.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DescriptionCubit, DescriptionState>(
      buildWhen: (prev, curr) {
        // Only rebuild when entries are added/removed or available languages change.
        // Text-only changes (from updateText) are handled by the controllers directly.
        final prevIds = prev.descriptions.map((e) => e.id).toSet();
        final currIds = curr.descriptions.map((e) => e.id).toSet();
        return prevIds.length != currIds.length ||
            !prevIds.containsAll(currIds) ||
            prev.availableLanguages != curr.availableLanguages;
      },
      builder: (context, state) {
        _syncControllers(state);

        return Column(
          children: [
            // 1. The Dropdown
            if (state.availableLanguages.isNotEmpty)
              InputDecorator(
                decoration: InputDecoration(
                  hintText: "Select Language",
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.grey[300]!),
                  ),

                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(
                      color: Color(0xFF0047AB),
                      width: 2,
                    ),
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    hint: Text(
                      "Select Language",
                      style: Theme.of(
                        context,
                      ).textTheme.bodyMedium?.copyWith(color: Colors.black),
                    ),
                    isExpanded: true,
                    style: Theme.of(context).textTheme.bodyMedium,
                    icon: Icon(Icons.arrow_drop_down, color: Colors.grey[600]),
                    items: state.availableLanguages.map((String lang) {
                      return DropdownMenuItem(value: lang, child: Text(lang));
                    }).toList(),
                    onChanged: state.availableLanguages.isEmpty
                        ? null
                        : (val) {
                            if (val != null) {
                              context.read<DescriptionCubit>().addLanguage(val);
                            }
                          },
                  ),
                ),
              ),

            const SizedBox(height: 20),

            // 2. The Dynamic List of Inputs
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: state.descriptions.length,
              itemBuilder: (context, index) {
                final entry = state.descriptions[index];

                return Padding(
                  key: ValueKey(entry.id),
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(entry.language),
                          IconButton(
                            icon: Icon(Icons.delete, color: Colors.red),
                            onPressed: () {
                              context.read<DescriptionCubit>().removeLanguage(
                                entry.id,
                                entry.language,
                              );
                            },
                            tooltip: 'Remove ${entry.language}',
                          ),
                        ],
                      ),
                      InputField(
                        maxLines: 5,
                        controller: _controllers[entry.id]!,
                        onChanged: (text) => context
                            .read<DescriptionCubit>()
                            .updateText(entry.id, text),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }
}

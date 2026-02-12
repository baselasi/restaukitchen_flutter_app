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

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DescriptionCubit, DescriptionState>(
      builder: (context, state) {
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
                  key: ValueKey(entry.id), // CRITICAL: Keeps focus/text correct
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

                      // IconButton(
                      //   icon: Icon(Icons.delete, color: Colors.red),
                      //   onPressed: () {
                      //     context.read<DescriptionCubit>().removeLanguage(
                      //       entry.id,
                      //       entry.language,
                      //     );
                      //   },
                      //   tooltip: 'Remove ${entry.language}',
                      // ),
                      InputField(
                        maxLines: 5,
                        controller: TextEditingController(),

                        // label: 'Enter text in ${entry.language}',
                        // hint: 'Enter text in ${entry.language}',
                        // suffixIconButton: IconButton(
                        //   onPressed: () {
                        //     context.read<DescriptionCubit>().removeLanguage(
                        //       entry.id,
                        //       entry.language,
                        //     );
                        //   },
                        //   icon: Icon(Icons.delete, color: Colors.red),
                        // ),
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

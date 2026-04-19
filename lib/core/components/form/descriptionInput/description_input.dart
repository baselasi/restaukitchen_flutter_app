import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restaukitchen_app/core/components/form/descriptionInput/description_cubit.dart';
import 'package:restaukitchen_app/core/components/form/descriptionInput/description_entity.dart';
import 'package:restaukitchen_app/core/components/form/input_field.dart';
import 'package:restaukitchen_app/core/models/dish.dart';
import 'package:restaukitchen_app/l10n/l10n.dart';

class DescriptionInput extends StatefulWidget {
  final Dish? dish;
  final ScrollController scrollController;
  const DescriptionInput({
    super.key,
    this.dish,
    required this.scrollController,
  });

  @override
  State<DescriptionInput> createState() => _DescriptionInputState();
}

class _DescriptionInputState extends State<DescriptionInput> {
  static const List<Map<String, String>> _supportedLanguages = [
    {'name': 'English', 'icon': '🇺🇸'},
    {'name': 'Italian', 'icon': '🇮🇹'},
    {'name': 'French', 'icon': '🇫🇷'},
    {'name': 'Spanish', 'icon': '🇪🇸'},
    {'name': 'Arabic', 'icon': '🇦🇪'},
  ];

  String _selectedLanguage = 'English';
  final FocusNode _descriptionFocusNode = FocusNode();
  final GlobalKey _inputKey = GlobalKey();

  // final Map<String, TextEditingController> _controllers = {};
  final Map<String, TextEditingController> _descriptionControllers = {
    'English': TextEditingController(),
    'Italian': TextEditingController(),
    'French': TextEditingController(),
    'Spanish': TextEditingController(),
    'Arabic': TextEditingController(),
  };

  // final TextEditingController _previewDescriptionController =
  //     TextEditingController();

  @override
  void initState() {
    super.initState();
    _descriptionFocusNode.addListener(() {
      if (_descriptionFocusNode.hasFocus) {
        _scrollToDescriptionField();
      }
    });
    context.read<DescriptionCubit>().initDescriptions(
      description: widget.dish?.description,
      descriptionIt: widget.dish?.descriptionIt,
      descriptionFr: widget.dish?.descriptionFr,
      descriptionEs: widget.dish?.descriptionEs,
      descriptionAr: widget.dish?.descriptionAr,
    );
  }

  // /// Creates controllers for new entries and disposes removed ones.
  // void _syncControllers(DescriptionState state) {
  //   final currentIds = state.descriptions.map((e) => e.id).toSet();

  //   // Dispose controllers for entries that were removed
  //   final removedIds = _controllers.keys
  //       .where((id) => !currentIds.contains(id))
  //       .toList();
  //   for (final id in removedIds) {
  //     _controllers[id]!.dispose();
  //     _controllers.remove(id);
  //   }

  //   // Create controllers for newly added entries
  //   for (final entry in state.descriptions) {
  //     if (!_controllers.containsKey(entry.id)) {
  //       _controllers[entry.id] = TextEditingController(text: entry.value);
  //     }
  //   }
  // }

  Future<void> _scrollToDescriptionField() async {
    Future.delayed(const Duration(milliseconds: 900), () {
      final ctx = _inputKey.currentContext;
      if (ctx == null) return;
      if (!mounted || !context.mounted) return;
      widget.scrollController.animateTo(
        widget.scrollController.offset + 80,
        duration: const Duration(milliseconds: 1000),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void dispose() {
    // for (final controller in _controllers.values) {
    //   controller.dispose();
    // }
    // _controllers.clear();
    for (final controller in _descriptionControllers.values) {
      controller.dispose();
    }
    _descriptionControllers.clear();
    _descriptionFocusNode.dispose();
    // _previewDescriptionController.dispose();
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
        final l10n = context.l10n;
        // _syncControllers(state);

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _supportedLanguages.map((language) {
                final languageName = switch (language['name']!) {
                  'English' => l10n.commonEnglish,
                  'Italian' => l10n.commonItalian,
                  'French' => l10n.commonFrench,
                  'Spanish' => l10n.commonSpanish,
                  'Arabic' => l10n.commonArabic,
                  _ => language['name']!,
                };
                final isSelected = _selectedLanguage == language['name']!;
                return ChoiceChip(
                  selected: false,
                  color: WidgetStatePropertyAll<Color?>(
                    isSelected ? const Color(0xFFE8F0FE) : Colors.grey[100],
                  ),
                  onSelected: (selected) {
                    setState(() {
                      // _descriptionFocusNode.unfocus();
                      _selectedLanguage = language['name']!;
                    });
                  },
                  label: Text(languageName),
                  avatar: Text(language['icon']!),
                  side: BorderSide(
                    color: isSelected
                        ? const Color(0xFF0047AB)
                        : Colors.grey[300]!,
                  ),
                  labelStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: isSelected
                        ? const Color(0xFF0047AB)
                        : Colors.black87,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 16),
            InputField(
              key: _inputKey,
              focusNode: _descriptionFocusNode,
              controller: _descriptionControllers[_selectedLanguage]!,
              label: l10n.commonDescription,
              hint: l10n.commonAddDescription,
              maxLines: 4,
              onChanged: (text) {
                context.read<DescriptionCubit>().updateText(
                  _selectedLanguage,
                  text,
                );
              },
              initialValue: state.descriptions
                  .firstWhere(
                    (entry) => entry.language == _selectedLanguage,
                    orElse: () =>
                        DescriptionEntity(id: "", language: "", value: ""),
                  )
                  .value,
            ),
            const SizedBox(height: 16),
          ],
        );
      },
    );
  }
}

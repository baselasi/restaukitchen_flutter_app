import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restaukitchen_app/core/dialogs/snack_bar.dart';
import 'package:restaukitchen_app/l10n/l10n.dart';
import 'package:restaukitchen_app/page/menusPage/bloc/create_menu_cubit.dart/create_menu_cubit.dart.dart';
import 'package:restaukitchen_app/page/menusPage/repository/menus_page_repo.dart';

Future<bool?> showAddMenuSheet(
  BuildContext context, {
  String? id,
  String? name,
}) {
  return showModalBottomSheet<bool>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => BlocProvider(
      create: (context) => CreateMenuCubit(menusPageRepo: MenusPageRepo()),
      child: AddMenuSheet(id: id, name: name),
    ),
  );
}

class AddMenuSheet extends StatefulWidget {
  const AddMenuSheet({super.key, this.id, this.name});
  final String? id;
  final String? name;

  @override
  State<AddMenuSheet> createState() => _AddMenuSheetState();
}

class _AddMenuSheetState extends State<AddMenuSheet> {
  final TextEditingController _nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.name != null) {
      _nameController.text = widget.name!;
    }
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
    final l10n = context.l10n;

    return BlocConsumer<CreateMenuCubit, CreateMenuState>(
      builder: (context, state) {
        if (state.status == CreateMenuStatus.loading) {
          return const Center(child: CircularProgressIndicator());
        }

        return Padding(
          padding: EdgeInsets.only(bottom: bottomInset),
          child: Container(
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
                    widget.id != null
                        ? l10n.menusEditTitle
                        : l10n.menusCreateTitle,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    widget.id != null
                        ? l10n.menusEditDescription
                        : l10n.menusCreateDescription,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: const Color(0xFF6B7280),
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: _nameController,
                    autofocus: true,
                    textInputAction: TextInputAction.done,
                    decoration: InputDecoration(labelText: l10n.menusNameLabel),
                    onChanged: (_) => setState(() {}),
                    onSubmitted: (value) {
                      final name = value.trim();
                      if (name.isEmpty) return;
                      context.read<CreateMenuCubit>().createMenu(
                        name,
                        widget.id,
                        isInEdi: widget.id != null,
                      );
                    },
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: Text(l10n.commonCancel),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: FilledButton(
                          onPressed: trimmedName.isEmpty
                              ? null
                              : () =>
                                    context.read<CreateMenuCubit>().createMenu(
                                      trimmedName,
                                      widget.id,
                                      isInEdi: widget.id != null,
                                    ),
                          child: Text(
                            widget.id != null
                                ? l10n.menusEditTitle
                                : l10n.menusCreateTitle,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
      listener: (context, state) {
        if (state.status == CreateMenuStatus.success) {
          Navigator.of(context).pop(true);
        }
        if (state.status == CreateMenuStatus.error) {
          AppSnackBar.showError(
            context,
            state.error ?? l10n.menusFailedCreate,
          );
        }
      },
    );
  }
}

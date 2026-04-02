import 'package:flutter/material.dart';
import 'package:restaukitchen_app/core/components/form/input_field.dart';

/// Horizontal card: tinted icon box, title + subtitle, trailing primary action.
class CombinationActionCard extends StatelessWidget {
  final VoidCallback? onAction;
  final IconData icon;


  const CombinationActionCard({
    super.key,
    this.onAction,
    this.icon = Icons.library_add_outlined,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;

    return Material(
      color: theme.colorScheme.surface,
      elevation: 2,
      shadowColor: Colors.black.withValues(alpha: 0.06),
      borderRadius: BorderRadius.circular(18),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Container(
            //   width: 48,
            //   height: 48,
            //   decoration: BoxDecoration(
            //     color: _iconBackground,
            //     borderRadius: BorderRadius.circular(8),
            //   ),
            //   alignment: Alignment.center,
            //   child: Icon(icon, color: primary, size: 26),
            // ),
            // const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
              
                  const SizedBox(height: 4),
                  InputField(
                    controller: TextEditingController(),
                    onChanged: (value) {},
                    label: "Group Name",
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            FilledButton(
              onPressed: onAction,
              style: FilledButton.styleFrom(
                backgroundColor: primary,
                foregroundColor: Colors.white,
                elevation: 0,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text(
                "Create",
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

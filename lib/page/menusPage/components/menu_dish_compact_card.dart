import 'package:flutter/material.dart';
import 'package:restaukitchen_app/theme/light_theme.dart';

/// Horizontal dish row: title, optional description — no image.
/// The whole card is one tap target; the trailing glyph is decorative only.
class MenuDishCompactCard extends StatefulWidget {
  final bool isSelected;
  final String title;
  final String? subtitle;
  final Widget? meta;
  final VoidCallback? onTap;
  final IconData iconWhenSelected;
  final IconData iconWhenUnselected;

  const MenuDishCompactCard({
    super.key,
    this.isSelected = false,
    required this.title,
    this.subtitle,
    this.meta,
    this.onTap,
    this.iconWhenSelected = Icons.check,
    this.iconWhenUnselected = Icons.add,
  });

  @override
  State<MenuDishCompactCard> createState() => _MenuDishCompactCardState();
}

class _MenuDishCompactCardState extends State<MenuDishCompactCard> {
  static const Color _titleColor = Color(0xFF111827);
  static const Color _subtitleColor = Color(0xFF6B7280);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeOutCubic,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: widget.isSelected
              ? LightTheme.primaryColor
              : Colors.grey[300]!,
          width: widget.isSelected ? 2 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: widget.onTap,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 14, 14, 14),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.title,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                            color: _titleColor,
                          ),
                        ),
                        if (widget.subtitle != null &&
                            widget.subtitle!.trim().isNotEmpty) ...[
                          const SizedBox(height: 6),
                          Text(
                            widget.subtitle!,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: _subtitleColor,
                              height: 1.35,
                            ),
                          ),
                        ],
                        if (widget.meta != null) ...[
                          const SizedBox(height: 10),
                          widget.meta!,
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Padding(
                    padding: const EdgeInsets.only(top: 2),
                    child: _TrailingCircle(
                      isSelected: widget.isSelected,
                      iconWhenSelected: widget.iconWhenSelected,
                      iconWhenUnselected: widget.iconWhenUnselected,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Non-interactive circle + icon (selection is expressed visually only).
class _TrailingCircle extends StatelessWidget {
  final bool isSelected;
  final IconData iconWhenSelected;
  final IconData iconWhenUnselected;

  const _TrailingCircle({
    required this.isSelected,
    required this.iconWhenSelected,
    required this.iconWhenUnselected,
  });

  @override
  Widget build(BuildContext context) {
    final icon = isSelected ? iconWhenSelected : iconWhenUnselected;
    final bg = isSelected
        ? LightTheme.primaryColor.withValues(alpha: 0.14)
        : const Color(0xFFE2E8F0);
    final fg = isSelected ? LightTheme.primaryColor : const Color(0xFF64748B);

    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: bg,
        shape: BoxShape.circle,
      ),
      alignment: Alignment.center,
      child: Icon(icon, size: 22, color: fg),
    );
  }
}

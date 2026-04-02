import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:restaukitchen_app/core/components/form/dimensionInput/dimension.dart';
import 'package:restaukitchen_app/theme/light_theme.dart';

/// Selectable dimension row: title, optional subtitle, selection indicator.
/// When selected, expands to show a price entry area (no leading icon, no promo tag).
class DimensionWithPriceCard extends StatelessWidget {
  final Dimension dimension;
  final bool isSelected;
  final String priceText;
  final ValueChanged<String> onPriceChanged;
  final VoidCallback onSelect;
  final String? subtitle;

  const DimensionWithPriceCard({
    super.key,
    required this.dimension,
    required this.isSelected,
    required this.priceText,
    required this.onPriceChanged,
    required this.onSelect,
    this.subtitle,
  });

  static const Color _subtitleColor = Color(0xFF6B7280);
  static const Color _borderUnselected = Color(0xFFE5E7EB);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: Colors.white,
        elevation: isSelected ? 0 : 1,
        shadowColor: Colors.black26,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(
            color: isSelected ? LightTheme.primaryColor : _borderUnselected,
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: InkWell(
          onTap: onSelect,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
            child: AnimatedSize(
              duration: const Duration(milliseconds: 220),
              curve: Curves.easeInOutCubic,
              alignment: Alignment.topCenter,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              dimension.name,
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w700,
                                color: Colors.black87,
                              ),
                            ),
                            if (subtitle != null &&
                                subtitle!.trim().isNotEmpty) ...[
                              const SizedBox(height: 4),
                              Text(
                                subtitle!,
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: _subtitleColor,
                                  height: 1.25,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      _SelectionDot(selected: isSelected),
                    ],
                  ),
                  if (isSelected) ...[
                    const SizedBox(height: 14),
                    _PricePanel(
                      priceText: priceText,
                      onPriceChanged: onPriceChanged,
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _SelectionDot extends StatelessWidget {
  final bool selected;

  const _SelectionDot({required this.selected});

  @override
  Widget build(BuildContext context) {
    if (selected) {
      return Container(
        width: 24,
        height: 24,
        decoration: const BoxDecoration(
          color: LightTheme.primaryColor,
          shape: BoxShape.circle,
        ),
        child: const Icon(Icons.check, size: 16, color: Colors.white),
      );
    }
    return Container(
      width: 24,
      height: 24,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.grey.shade400, width: 1.5),
      ),
    );
  }
}

class _PricePanel extends StatefulWidget {
  final String priceText;
  final ValueChanged<String> onPriceChanged;

  const _PricePanel({
    required this.priceText,
    required this.onPriceChanged,
  });

  @override
  State<_PricePanel> createState() => _PricePanelState();
}

class _PricePanelState extends State<_PricePanel> {
  static const Color _labelColor = Color(0xFF6B7280);
  static const Color _innerFill = Color(0xFFEEF2FF);

  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.priceText);
    _controller.addListener(() {
      widget.onPriceChanged(_controller.text);
    });
  }

  @override
  void didUpdateWidget(covariant _PricePanel oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.priceText != widget.priceText &&
        widget.priceText != _controller.text) {
      _controller.value = TextEditingValue(
        text: widget.priceText,
        selection: TextSelection.collapsed(offset: widget.priceText.length),
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 14),
      decoration: BoxDecoration(
        color: _innerFill,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'ENTER PRICE (\$)',
            style: theme.textTheme.labelSmall?.copyWith(
              letterSpacing: 0.6,
              fontWeight: FontWeight.w600,
              color: _labelColor,
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _controller,
            keyboardType: const TextInputType.numberWithOptions(
              decimal: true,
            ),
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
            ],
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w700,
              color: Colors.black87,
            ),
            decoration: InputDecoration(
              isDense: true,
              contentPadding: EdgeInsets.zero,
              border: InputBorder.none,
              hintText: '0.00',
              hintStyle: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w700,
                color: Colors.black26,
              ),
              prefixText: '\$ ',
              prefixStyle: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

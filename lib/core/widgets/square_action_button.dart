import 'package:flutter/material.dart';

/// Tappable 44×44 control used on horizontal list cards (e.g. dish, combination).
class SquareActionButton extends StatelessWidget {
  final Widget child;
  final VoidCallback? onTap;

  const SquareActionButton({super.key, required this.child, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: SizedBox(width: 44, height: 44, child: Center(child: child)),
      ),
    );
  }
}

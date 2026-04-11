import 'package:flutter/material.dart';
import 'package:restaukitchen_app/core/components/form/dimensionInput/dimension.dart';

class DimensionsDialog extends StatefulWidget {
  final List<Dimension> dimensions;
  final Dimension? initialSelection;

  const DimensionsDialog({
    super.key,
    required this.dimensions,
    this.initialSelection,
  });

  @override
  State<DimensionsDialog> createState() => _DimensionsDialogState();
}

class _DimensionsDialogState extends State<DimensionsDialog> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Select dimension'),
      contentPadding: const EdgeInsets.fromLTRB(0, 12, 0, 0),
      content: SizedBox(
        width: double.maxFinite,
        child: widget.dimensions.isEmpty
            ? const Padding(
                padding: EdgeInsets.fromLTRB(24, 12, 24, 24),
                child: Text('No dimensions available'),
              )
            : ListView.builder(
                padding: const EdgeInsets.all(12),
                shrinkWrap: true,
                itemCount: widget.dimensions.length,
                itemBuilder: (context, index) {
                  final dimension = widget.dimensions[index];
                  return InkWell(
                    onTap: () {
                      setState(() {
                        Navigator.of(context).pop(dimension);
                      });
                    },
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          dimension.name,
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(
                                fontWeight: FontWeight.w400,
                                fontSize: 24,
                              ),
                        ),
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}

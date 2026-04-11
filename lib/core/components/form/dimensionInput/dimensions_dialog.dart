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
  Dimension? _selectedDimension;

  @override
  void initState() {
    super.initState();
    _selectedDimension = widget.initialSelection;
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
                  final isSelected = _selectedDimension?.id == dimension.id;
                  return InkWell(
                    borderRadius: BorderRadius.circular(8),

                    onTap: () {
                      setState(() {
                        _selectedDimension = dimension;
                      });
                    },
                    child: Card(
                      shadowColor: Colors.black.withValues(alpha: 0.2),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                        side: BorderSide(
                          color: isSelected
                              ? Theme.of(context).colorScheme.primary
                              : Colors.grey[300]!,
                          width: 1,
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                dimension.name,
                                style: Theme.of(context).textTheme.bodyMedium
                                    ?.copyWith(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 24,
                                    ),
                              ),
                            ),
                            if (isSelected)
                              Icon(
                                Icons.check,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: _selectedDimension == null
              ? null
              : () => Navigator.of(context).pop(_selectedDimension),
          child: const Text('Add'),
        ),
      ],
    );
  }
}

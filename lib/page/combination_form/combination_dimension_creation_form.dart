import 'package:flutter/material.dart';
import 'package:restaukitchen_app/core/components/appBar/details_app_bar.dart';

class CombinationDimensionCreationForm extends StatelessWidget {
  const CombinationDimensionCreationForm({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DetailsAppBar(pageTitle: 'Add Dimension'),
      body: Column(children: [Text('Combination Dimension Creation Form')]),
    );
  }
}

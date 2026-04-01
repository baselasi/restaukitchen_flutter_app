import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:restaukitchen_app/page/combination_form/combination_dimension_creation_form.dart';

class CombinationList extends StatelessWidget {
  const CombinationList({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            PageTransition(
              type: PageTransitionType.rightToLeft,
              child: CombinationDimensionCreationForm(),
            ),
          );
        },
        child: Icon(Icons.add),
      ),
      body: Column(children: [Text('Combinations')]),
    );
  }
}

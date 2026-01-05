import 'package:flutter/material.dart';
import 'package:restaukitchen_app/core/components/form/appBar/details_app_bar.dart';

class DishForm extends StatefulWidget {
  const DishForm({super.key});

  @override
  State<DishForm> createState() => _DishFormState();
}

class _DishFormState extends State<DishForm> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DetailsAppBar(pageTitle: "New Dish"),
      body: Column(children: [Text('Dish Form')]),
    );
  }
}

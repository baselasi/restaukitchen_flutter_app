import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restaukitchen_app/core/components/appBar/details_app_bar.dart';
import 'package:restaukitchen_app/core/components/form/categorySelector/category_selector_cubit.dart';
import 'package:restaukitchen_app/core/components/form/categorySelector/category_selector_field.dart';

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
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text('Dish Form'),
            BlocProvider(
              create: (context) => CategorySelectorCubit(),
              child: CategorySelectorField(),
            ),
          ],
        ),
      ),
    );
  }
}

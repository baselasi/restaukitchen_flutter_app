import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restaukitchen_app/core/components/appBar/details_app_bar.dart';
import 'package:restaukitchen_app/core/components/form/categorySelector/category_selector_cubit.dart';
import 'package:restaukitchen_app/core/components/form/categorySelector/category_selector_field.dart';
import 'package:restaukitchen_app/core/components/form/descriptionInput/description_cubit.dart';
import 'package:restaukitchen_app/core/components/form/descriptionInput/description_input.dart';
import 'package:restaukitchen_app/core/components/form/input_field.dart';

class DishForm extends StatefulWidget {
  const DishForm({super.key});

  @override
  State<DishForm> createState() => _DishFormState();
}

class _DishFormState extends State<DishForm> {
  final TextEditingController _nameControllere = TextEditingController();
  bool _isAvailable = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DetailsAppBar(pageTitle: "New Dish"),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            SizedBox(height: 16),
            Text('Dish Form'),
            SizedBox(height: 16),
            InputField(
              controller: _nameControllere,
              label: "Name",
              isRequired: true,
            ),
            SizedBox(height: 16),
            BlocProvider(
              create: (context) => CategorySelectorCubit(),
              child: CategorySelectorField(),
            ),
            SizedBox(height: 16),
            BlocProvider(
              create: (context) => DescriptionCubit(),
              child: DescriptionInput(),
            ),
            SizedBox(height: 16),
            Row(
              children: [
                Text(
                  'Available',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
                Spacer(),
                Switch(
                  value: _isAvailable,
                  onChanged: (value) {
                    setState(() {
                      _isAvailable = value;
                    });
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

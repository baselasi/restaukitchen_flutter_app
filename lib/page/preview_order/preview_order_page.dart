import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restaukitchen_app/page/new_order/bloc/new_order_form_bloc/new_order_form_bloc.dart';
import 'package:restaukitchen_app/page/new_order/bloc/new_order_form_bloc/new_order_form_state.dart';
import 'package:restaukitchen_app/page/order_list/models/course.dart';
import 'package:restaukitchen_app/page/preview_order/components/combination_indice_card.dart';
import 'package:restaukitchen_app/page/preview_order/components/dish_indice_card.dart';

class PreviewOrderPage extends StatefulWidget {
  const PreviewOrderPage({super.key});

  @override
  State<PreviewOrderPage> createState() => _PreviewOrderPageState();
}

class _PreviewOrderPageState extends State<PreviewOrderPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Preview Order')),
      body: BlocConsumer<NewOrderFormBloc, NewOrderFormState>(
        builder: (context, state) {
          final indices = state.courses.expand((c) => c.disheIndices).toList();

          if (indices.isEmpty) {
            return Center(
              child: Text(
                'Nothing in this order yet',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: indices.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final item = indices[index];
              if (item is CombinationIndice) {
                return CombinationIndiceCard(combinationIndice: item);
              }
              if (item is DishIndice) {
                return DishIndiceCard(dishIndice: item);
              }
              return const SizedBox.shrink();
            },
          );
        },
        listener: (context, state) {},
      ),
    );
  }
}

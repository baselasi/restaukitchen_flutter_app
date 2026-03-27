import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restaukitchen_app/page/new_order/bloc/new_order_form_bloc/new_order_form_bloc.dart';
import 'package:restaukitchen_app/page/new_order/bloc/new_order_form_bloc/new_order_form_state.dart';
import 'package:restaukitchen_app/page/order_list/models/course.dart';
import 'package:restaukitchen_app/page/preview_order/components/combination_indice_card.dart';

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
          final combinations = state.courses
              .expand((c) => c.disheIndices)
              .whereType<CombinationIndice>()
              .toList();

          if (combinations.isEmpty) {
            return Center(
              child: Text(
                'No combinations in this order',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: combinations.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              return CombinationIndiceCard(
                combinationIndice: combinations[index],
              );
            },
          );
        },
        listener: (context, state) {},
      ),
    );
  }
}

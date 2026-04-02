import 'package:flutter/material.dart';
import 'package:restaukitchen_app/core/components/appBar/details_app_bar.dart';
import 'package:restaukitchen_app/core/components/form/primary_button.dart';
import 'package:restaukitchen_app/page/combination_form/components/combination_action_card.dart';

class CombinationMenuCreationForm extends StatelessWidget {
  final String combinationId;
  const CombinationMenuCreationForm({super.key, required this.combinationId});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F3FF),
      appBar: DetailsAppBar(pageTitle: 'Add Menu'),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
          children: [CombinationActionCard(onAction: () {})],
        ),
      ),
      bottomNavigationBar: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
          child: PrimaryButton(text: 'Create Menu', onPressed: () {}),
        ),
      ),
    );
  }
}

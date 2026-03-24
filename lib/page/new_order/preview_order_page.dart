import 'package:flutter/material.dart';

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
      body: Column(children: [Text('Preview Order')]),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restaukitchen_app/core/routes.dart';
import 'package:restaukitchen_app/page/mainPage/bloc/main_page_cubit.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _MainPageState();
  }
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MainPageCubit, MainPageState>(
      builder: (context, state) {
        return buildPage(state.page);
      },
      listener: (context, state) {},
    );
  }
}

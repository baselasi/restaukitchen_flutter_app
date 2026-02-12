import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restaukitchen_app/core/components/appBar/main_app_bar.dart';
import 'package:restaukitchen_app/core/routes.dart';
import 'package:restaukitchen_app/page/mainPage/bloc/main_page_cubit.dart';
import 'package:restaukitchen_app/page/mainPage/components/main_drawer.dart';

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
        return Scaffold(
          appBar: MainAppBar(page: state.page),
          drawer: const MainDrawer(),
          body: buildPage(state.page),
        );
      },
      listener: (context, state) {},
    );
  }
}

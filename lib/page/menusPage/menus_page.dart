import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restaukitchen_app/page/menusPage/bloc/menus_page_bloc.dart';
import 'package:restaukitchen_app/page/menusPage/bloc/menus_page_events.dart';

class MenusPage extends StatefulWidget {
  const MenusPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _MenusPageState();
  }
}

class _MenusPageState extends State<MenusPage> {
  @override
  void initState() {
    context.read<MenusPageBloc>().add(
      GetMenus(showSucess: false, menuIndex: 0),
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

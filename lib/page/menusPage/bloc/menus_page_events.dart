import 'package:equatable/equatable.dart';
import 'package:restaukitchen_app/page/menusPage/models/menu.dart';

abstract class MenusPageEvent extends Equatable {}

class GetMenus extends MenusPageEvent {
  final bool showSucess;
  final int menuIndex;
  GetMenus({required this.showSucess, required this.menuIndex});
  @override
  List<Object?> get props => [showSucess, menuIndex];
}

class ChangeMenu extends MenusPageEvent {
  final int menuIndex;
  final List<Menu> menus;
  ChangeMenu({required this.menuIndex, required this.menus});
  @override
  List<Object?> get props => [menuIndex, menus];
}

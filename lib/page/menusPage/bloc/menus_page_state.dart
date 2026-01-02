import 'package:equatable/equatable.dart';
import 'package:restaukitchen_app/page/menusPage/models/menu.dart';

abstract class MenusPageState extends Equatable {}

class MenusPageInitial extends MenusPageState {
  MenusPageInitial();
  @override
  List<Object?> get props => [];
}

class MenusPageLoading extends MenusPageState {
  MenusPageLoading();

  @override
  List<Object?> get props => [];
}

class MenusPageLoaded extends MenusPageState {
  MenusPageLoaded({required this.menus, required this.selectedMenu});
  final List<Menu> menus;
  final int selectedMenu;

  @override
  List<Object?> get props => [menus, selectedMenu];
}

class MenusPageError extends MenusPageState {
  final String error;
  MenusPageError({required this.error});
  @override
  List<Object?> get props => [];
}

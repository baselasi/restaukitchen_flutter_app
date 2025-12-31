import 'package:equatable/equatable.dart';

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
  final List<dynamic> menus;
  final int selectedMenu;

  @override
  List<Object?> get props => [menus, selectedMenu];
}

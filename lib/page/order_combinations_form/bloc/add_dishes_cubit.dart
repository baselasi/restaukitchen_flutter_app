import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:restaukitchen_app/core/models/dish.dart';
import 'package:restaukitchen_app/page/menusPage/models/menu.dart';

class AddDishesCubit extends Cubit<AddDishesState> {
  AddDishesCubit()
    : super(AddDishesState(menus: [], selectedDishesMenusIds: []));
}

class AddDishesState extends Equatable {
  final List<Menu>? menus;
  final List<String>?
  selectedDishesMenusIds; // ids of the menus that have selected dishes
  const AddDishesState({
    required this.menus,
    this.selectedDishesMenusIds = const [],
  });
  @override
  List<Object?> get props => [menus];
}

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:restaukitchen_app/page/combination_page/models/combination.dart';
import 'package:restaukitchen_app/page/menusPage/models/menu.dart';

class AddDishesCubit extends Cubit<AddDishesState> {
  final Combination? combination;
  AddDishesCubit({required this.combination})
    : super(
        AddDishesState(menus: combination?.menuList ?? [], activeMenuIds: []),
      );

  void addActiveMenuId(String currentMenuId) {
    final menuIndex = state.menus.indexWhere(
      (menu) => menu.id == currentMenuId,
    );
    if (menuIndex == -1) {
      return;
    }
    if (state.menus.length > menuIndex + 1) {
      final nextMenuId = state.menus[menuIndex + 1].id;
      final activeMenuIds = [...state.activeMenuIds, nextMenuId];
      emit(state.copyWith(activeMenuIds: [...activeMenuIds]));
    }
  }
}

class AddDishesState extends Equatable {
  final List<Menu> menus;
  final List<String>
  activeMenuIds; // ids of the menus that have selected dishes
  const AddDishesState({required this.menus, this.activeMenuIds = const []});

  AddDishesState copyWith({required List<String> activeMenuIds}) {
    return AddDishesState(menus: menus, activeMenuIds: activeMenuIds);
  }

  @override
  List<Object?> get props => [menus, activeMenuIds];
}

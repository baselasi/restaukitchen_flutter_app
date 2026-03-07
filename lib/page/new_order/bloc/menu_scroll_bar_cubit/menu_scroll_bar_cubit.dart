import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:restaukitchen_app/core/services/sevices_loactor.dart';
import 'package:restaukitchen_app/core/services/user_service.dart';
import 'package:restaukitchen_app/page/combination_page/models/combination.dart';
import 'package:restaukitchen_app/page/combination_page/repository/combination_page_repo.dart';
import 'package:restaukitchen_app/page/menusPage/models/menu.dart';
import 'package:restaukitchen_app/page/menusPage/models/menu_scroll_bar_item.dart';
import 'package:restaukitchen_app/page/menusPage/repository/menus_page_repo.dart';

class MenuScrollBarCubit extends Cubit<MenuScrollBarState> {
  MenuScrollBarCubit() : super(MenuScrollBarState.initial()) {
    getMenus();
  }

  Future<void> getMenus() async {
    try {
      emit(
        MenuScrollBarState(
          status: MenuScrollBarStatus.loading,
          menuScrollBarItem: [],
          selectedMenuIndex: 0,
          selectedMenu: null,
          menus: [],
          combinations: [],
          errorMessage: null,
        ),
      );
      final menuResponse = await MenusPageRepo().getMenus(
        getIt<UserService>().user?.restaurant ?? '',
      );

      final combinationsResponse = await CombinationPageRepo().getCombinations(
        getIt<UserService>().user?.restaurant ?? '',
      );
      emit(
        MenuScrollBarState(
          status: MenuScrollBarStatus.success,
          menuScrollBarItem: [
            ...menuResponse.menus.map((menu) => menu.toMenuScrollBarItem()),
            MenuScrollBarItem(
              id: 'combinations',
              name: 'Combinations',
              isCombination: true,
            ),
          ],
          selectedMenuIndex: 0,
          selectedMenu: menuResponse.menus[0],
          menus: menuResponse.menus,
          combinations: combinationsResponse.combinations,
          errorMessage: null,
        ),
      );
    } catch (e) {
      emit(
        MenuScrollBarState(
          status: MenuScrollBarStatus.error,
          menuScrollBarItem: [],
          selectedMenuIndex: 0,
          selectedMenu: null,
          menus: [],
          combinations: [],
          errorMessage: null,
        ),
      );
    }
  }

  void selectMenu(int index) {
    final menu = state.menus?[index];
    emit(
      MenuScrollBarState(
        status: MenuScrollBarStatus.success,
        menuScrollBarItem: state.menuScrollBarItem,
        selectedMenuIndex: index,
        selectedMenu: menu,
        menus: state.menus,
        errorMessage: null,
        combinations: state.combinations,
      ),
    );
  }

  void selectCombination(int index) {
    emit(
      MenuScrollBarState(
        status: MenuScrollBarStatus.success,
        menuScrollBarItem: state.menuScrollBarItem,
        selectedMenuIndex: index,
        selectedMenu: null,
        menus: state.menus,
        errorMessage: null,
        combinations: state.combinations,
      ),
    );
  }
}

enum MenuScrollBarStatus { initial, loading, success, error }

class MenuScrollBarState extends Equatable {
  final MenuScrollBarStatus status;
  final List<MenuScrollBarItem> menuScrollBarItem;
  final int selectedMenuIndex;
  final Menu? selectedMenu;
  final List<Menu>? menus;
  final List<Combination>? combinations;
  final String? errorMessage;

  const MenuScrollBarState({
    required this.status,
    required this.menuScrollBarItem,
    required this.selectedMenuIndex,
    required this.selectedMenu,
    required this.menus,
    required this.combinations,
    required this.errorMessage,
  });

  factory MenuScrollBarState.initial() {
    return MenuScrollBarState(
      status: MenuScrollBarStatus.initial,
      menuScrollBarItem: [],
      selectedMenuIndex: 0,
      selectedMenu: null,
      menus: [],
      combinations: [],
      errorMessage: null,
    );
  }

  @override
  List<Object?> get props => [
    status,
    menuScrollBarItem,
    selectedMenuIndex,
    selectedMenu,
    menus,
    combinations,
    errorMessage,
  ];
}

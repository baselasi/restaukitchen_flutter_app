import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restaukitchen_app/core/services/sevices_loactor.dart';
import 'package:restaukitchen_app/core/services/user_service.dart';
import 'package:restaukitchen_app/page/menusPage/bloc/menus_page_events.dart';
import 'package:restaukitchen_app/page/menusPage/bloc/menus_page_state.dart';
import 'package:restaukitchen_app/page/menusPage/repository/menus_page_repo.dart';

class MenusPageBloc extends Bloc<MenusPageEvent, MenusPageState> {
  MenusPageBloc() : super(MenusPageInitial()) {
    on<GetMenus>(_onGetMenus);
    on<ChangeMenu>(_onChangeMenu);
  }

  void _onGetMenus(GetMenus event, Emitter<MenusPageState> emit) async {
    try {
      emit(MenusPageLoading());
      String? restaurantId = getIt<UserService>().user?.restaurant;
      if (restaurantId == null) {
        emit(MenusPageError(error: "Restaurant not found"));
        return;
      }
      final response = await MenusPageRepo().getMenus(restaurantId);
      emit(
        MenusPageLoaded(menus: response.menus, selectedMenu: event.menuIndex),
      );
    } catch (e) {
      emit(MenusPageError(error: e.toString()));
    }
  }

  void _onChangeMenu(ChangeMenu event, Emitter<MenusPageState> emit) {
    emit(MenusPageLoaded(menus: event.menus, selectedMenu: event.menuIndex));
  }
}

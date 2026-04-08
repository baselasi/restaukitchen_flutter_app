import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restaukitchen_app/page/menusPage/models/menu.dart';
import 'package:restaukitchen_app/page/menusPage/repository/menus_page_repo.dart';

class CreateMenuCubit extends Cubit<CreateMenuState> {
  final MenusPageRepo _menusPageRepo;
  CreateMenuCubit({required MenusPageRepo menusPageRepo})
    : _menusPageRepo = menusPageRepo,
      super(CreateMenuState.initial());

  Future<void> createMenu(
    String name,
    String? id, {
    bool isInEdi = false,
  }) async {
    emit(CreateMenuState.loading());
    try {
      if (isInEdi) {
        await _menusPageRepo.updateMenu(CreateMenuRequest(name: name, id: id));
      } else {
        await _menusPageRepo.createMenu(CreateMenuRequest(name: name));
      }
      if (!isClosed) emit(CreateMenuState.success());
    } catch (e) {
      if (!isClosed) emit(CreateMenuState.error(e.toString()));
    }
  }
}

class CreateMenuState extends Equatable {
  final CreateMenuStatus status;
  final String? error;
  const CreateMenuState({required this.status, this.error});

  factory CreateMenuState.initial() {
    return const CreateMenuState(status: CreateMenuStatus.initial);
  }
  factory CreateMenuState.loading() {
    return const CreateMenuState(status: CreateMenuStatus.loading);
  }
  factory CreateMenuState.success() {
    return const CreateMenuState(status: CreateMenuStatus.success);
  }

  factory CreateMenuState.error(String error) {
    return CreateMenuState(status: CreateMenuStatus.error, error: error);
  }

  @override
  List<Object?> get props => [status];
}

enum CreateMenuStatus { initial, loading, success, error }

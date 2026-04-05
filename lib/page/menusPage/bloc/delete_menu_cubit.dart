import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restaukitchen_app/page/menusPage/repository/menus_page_repo.dart';

class DeleteMenuCubit extends Cubit<DeleteMenuState> {
  final MenusPageRepo _menusPageRepo;
  DeleteMenuCubit({required MenusPageRepo menusPageRepo})
    : _menusPageRepo = menusPageRepo,
      super(DeleteMenuState(status: DeleteMenuStatus.initial));
  Future<void> deleteMenu(String menuId) async {
    try {
      emit(DeleteMenuState(status: DeleteMenuStatus.isLoading));
      await _menusPageRepo.deleteMenu(menuId);
      emit(DeleteMenuState(status: DeleteMenuStatus.isSucess));
    } catch (e) {
      emit(DeleteMenuState(status: DeleteMenuStatus.isError));
    }
  }
}

class DeleteMenuState extends Equatable {
  final DeleteMenuStatus status;
  const DeleteMenuState({required this.status});

  factory DeleteMenuState.initial() {
    return const DeleteMenuState(status: DeleteMenuStatus.initial);
  }

  factory DeleteMenuState.isLoading() {
    return const DeleteMenuState(status: DeleteMenuStatus.isLoading);
  }

  factory DeleteMenuState.isSucess() {
    return const DeleteMenuState(status: DeleteMenuStatus.isSucess);
  }

  factory DeleteMenuState.isError() {
    return const DeleteMenuState(status: DeleteMenuStatus.isError);
  }

  DeleteMenuState copyWith({DeleteMenuStatus? status}) {
    return DeleteMenuState(status: status ?? this.status);
  }

  @override
  List<Object?> get props => [status];
}

enum DeleteMenuStatus { initial, isLoading, isSucess, isError }

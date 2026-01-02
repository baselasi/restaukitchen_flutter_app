import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:restaukitchen_app/page/menusPage/repository/menus_page_repo.dart';

class DeleteDishCubit extends Cubit<DeleteDishState> {
  DeleteDishCubit() : super(DeleteDishState(status: DeleteDishStatus.initial));
  Future<void> deleteDish(String dishId) async {
    try {
      emit(DeleteDishState(status: DeleteDishStatus.isLoading));
      await MenusPageRepo().deleteDish(dishId);
      emit(DeleteDishState(status: DeleteDishStatus.isSucess));
    } catch (e) {
      emit(DeleteDishState(status: DeleteDishStatus.isError));
    }
  }
}

enum DeleteDishStatus { initial, isLoading, isSucess, isError }

class DeleteDishState extends Equatable {
  final DeleteDishStatus status;
  const DeleteDishState({required this.status});
  @override
  List<Object?> get props => [status];
}

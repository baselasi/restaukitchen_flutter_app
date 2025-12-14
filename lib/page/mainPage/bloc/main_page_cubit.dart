import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restaukitchen_app/core/routes.dart';

class MainPageCubit extends Cubit<MainPageState> {
  MainPageCubit() : super(const MainPageState(page: Pages.home));

  void setPage(Pages page) {
    emit(MainPageState(page: page));
  }
}

class MainPageState extends Equatable {
  final Pages page;
  const MainPageState({required this.page});

  @override
  List<Object?> get props => [];
}

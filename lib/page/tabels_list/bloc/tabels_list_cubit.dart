import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TabelsListCubit extends Cubit<TabelsListState> {
  TabelsListCubit() : super(TabelsListState(status: TabelsListStatus.initial));

  Future<void> getTabelsList() async {
    emit(TabelsListState(status: TabelsListStatus.loading));
  }
}

enum TabelsListStatus { initial, loading, loaded, error }

class TabelsListState extends Equatable {
  final TabelsListStatus status;
  const TabelsListState({required this.status});

  factory TabelsListState.initial() {
    return const TabelsListState(status: TabelsListStatus.initial);
  }

  factory TabelsListState.loading() {
    return const TabelsListState(status: TabelsListStatus.loading);
  }

  factory TabelsListState.error(String message) {
    return const TabelsListState(status: TabelsListStatus.error);
  }

  @override
  List<Object?> get props => [status];
}

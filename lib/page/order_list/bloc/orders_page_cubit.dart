import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restaukitchen_app/core/models/category.dart';

sealed class OrderSubPage extends Equatable {
  const OrderSubPage();
}

class KitchenPage extends OrderSubPage {
  const KitchenPage();

  @override
  List<Object?> get props => ['kitchen'];
}

class ArchivePage extends OrderSubPage {
  const ArchivePage();

  @override
  List<Object?> get props => ['archive'];
}

class DeletedPage extends OrderSubPage {
  const DeletedPage();

  @override
  List<Object?> get props => ['deleted'];
}

class CategoryPage extends OrderSubPage {
  final Category category;
  const CategoryPage({required this.category});

  @override
  List<Object?> get props => [category];
}

class OrdersPageCubit extends Cubit<OrdersPageState> {
  OrdersPageCubit() : super(const OrdersPageState(page: KitchenPage()));

  void setPage(OrderSubPage page) {
    emit(OrdersPageState(page: page));
  }
}

class OrdersPageState extends Equatable {
  final OrderSubPage page;
  const OrdersPageState({required this.page});

  @override
  List<Object?> get props => [page];
}

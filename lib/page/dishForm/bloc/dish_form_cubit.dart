import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:restaukitchen_app/core/components/form/descriptionInput/description_entity.dart';
import 'package:restaukitchen_app/core/components/form/dimensionInput/dimension_assignments.dart';
import 'package:restaukitchen_app/page/dishForm/repository/dish_form_repo.dart';

class DishFormCubit extends Cubit<DishFormState> {
  DishFormCubit() : super(DishFormState(status: DishFormStatus.initial));

  Future<void> createDish({
    required String name,
    required String menuId,
    required String categoryId,
    required bool isAvailable,
    required int position,
    required List<DescriptionEntity> descriptions,
    required List<DimensionAssignments> dimensionAssignments,
    required String? dishId,
  }) async {
    if (menuId.isEmpty) {
      emit(DishFormState(status: DishFormStatus.error));
      return;
    }
    Map<String, Object> payload = _buildDishPayload(
      menuId: menuId,
      name: name,
      categoryId: categoryId,
      isAvailable: isAvailable,
      position: position,
      descriptions: descriptions,
      dimensionAssignments: dimensionAssignments,
      dishId: dishId,
    );

    if (dishId != null) {
      await DishFormRepo().updateDish(payload, dishId);
    } else {
      await DishFormRepo().createDish(payload);
    }
    // await DishFormRepo().createDish(payload);
    emit(DishFormState(status: DishFormStatus.loading));
    try {
      await Future.delayed(const Duration(seconds: 2));
      emit(DishFormState(status: DishFormStatus.success));
    } catch (e) {
      emit(DishFormState(status: DishFormStatus.error));
    }
  }

  Map<String, Object> _buildDishPayload({
    required String menuId,
    required String name,
    required String categoryId,
    required bool isAvailable,
    required int position,
    required List<DescriptionEntity> descriptions,
    required List<DimensionAssignments> dimensionAssignments,
    required String? dishId,
  }) {
    return {
      if (dishId != null) 'id': dishId,
      'menuId': menuId,
      'name': name,
      'category': categoryId,
      'isAvailable': isAvailable,
      'position': position,
      'description':
          descriptions
              .where((description) => description.language == "English")
              .firstOrNull
              ?.value ??
          '',
      "descriptionIt":
          descriptions
              .where((description) => description.language == "Italian")
              .firstOrNull
              ?.value ??
          "",
      "descriptionAr":
          descriptions
              .where((description) => description.language == "Arabic")
              .firstOrNull
              ?.value ??
          "",
      "descriptionFr":
          descriptions
              .where((description) => description.language == "French")
              .firstOrNull
              ?.value ??
          "",
      "descriptionEs":
          descriptions
              .where((description) => description.language == "Spanish")
              .firstOrNull
              ?.value ??
          "",
      "dimensions": dimensionAssignments
          .map(
            (dimensionAssignments) => {
              "dimensionId": dimensionAssignments.dimension.id,
              "price": dimensionAssignments.price,
            },
          )
          .toList(),
    };
  }
}

enum DishFormStatus { initial, loading, success, error }

class DishFormState extends Equatable {
  final DishFormStatus status;

  const DishFormState({required this.status});
  @override
  List<Object?> get props => [status];
}

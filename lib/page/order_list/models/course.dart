import 'package:equatable/equatable.dart';

class Course extends Equatable {
  final List<CourseIndice> disheIndices;

  const Course({required this.disheIndices});

  factory Course.fromJson(Map<String, dynamic> json) {
    return Course(
      disheIndices: (json['disheIndices'] as List<dynamic>)
          .map((e) => CourseIndice.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toOrderPayload() {
    return {
      'disheIndices': disheIndices.map((e) => e.toOrderPayload()).toList(),
    };
  }

  @override
  List<Object> get props => [disheIndices];
}

sealed class CourseIndice extends Equatable {
  const CourseIndice();

  static CourseIndice fromJson(Map<String, dynamic> json) {
    if (json.containsKey('combinationId')) {
      return CombinationIndice.fromJson(json);
    }
    return DishIndice.fromJson(json);
  }

  Map<String, dynamic> toOrderPayload() {
    if (this is CombinationIndice) {
      return (this as CombinationIndice).toOrderPayload();
    }
    return (this as DishIndice).toOrderPayload();
  }
}

class DishIndice extends CourseIndice {
  final String? id;
  final String dishId;
  final String dishDimensionId;
  final String? dishDimensionName;
  final double? dishPrice;
  final String? dishName;
  final int course;
  final String? category;
  final List<DishesWithIngredients>? dishesWithIngredients;
  final List<String>? dishIngredientsId;
  final int dishQuantity;
  final String? note;

  const DishIndice({
    this.id,
    required this.dishId,
    required this.dishDimensionId,
    this.dishDimensionName,
    this.dishPrice,
    this.dishName,
    required this.course,
    this.category,
    this.dishesWithIngredients,
    this.dishIngredientsId,
    required this.dishQuantity,
    this.note,
  });

  factory DishIndice.fromJson(Map<String, dynamic> json) {
    return DishIndice(
      id: json['id'] as String,
      dishId: json['dishId'] as String,
      note: json['note'] as String?,
      dishDimensionId: json['dishDimensionId'] as String,
      dishDimensionName: json['dishDimensionName'] as String,
      dishPrice: (json['dishPrice'] as num).toDouble(),
      dishName: json['dishName'] as String,
      course: json['course'] as int,
      category: json['category'] as String,
      dishesWithIngredients:
          (json['dishesWithIngredients'] as List<dynamic>?)
              ?.map(
                (e) =>
                    DishesWithIngredients.fromJson(e as Map<String, dynamic>),
              )
              .toList() ??
          [],
      dishIngredientsId:
          (json['dishIngredientsId'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      dishQuantity: json['dishQuantity'] as int,
    );
  }

  @override
  Map<String, dynamic> toOrderPayload() {
    return {
      'dishId': dishId,
      'dishDimensionId': dishDimensionId,
      "dishQuantity": dishQuantity,
      'course': course,
      'dishIngredientsId': dishIngredientsId,
      "note": note,
    };
  }

  @override
  List<Object?> get props => [
    id,
    dishId,
    dishDimensionId,
    dishDimensionName,
    dishPrice,
    dishName,
    course,
    category,
    dishesWithIngredients,
    dishIngredientsId,
    dishQuantity,
  ];
}

class CombinationIndice extends CourseIndice {
  final String id;
  final int course;
  final String combinationId;
  final List<DishesWithIngredients> dishesWithIngredients;
  final String combinationDimensionId;
  final String combinationDimensionName;
  final double combinationPrice;
  final int combinationQuantity;

  const CombinationIndice({
    required this.id,
    required this.course,
    required this.combinationId,
    required this.dishesWithIngredients,
    required this.combinationDimensionId,
    required this.combinationDimensionName,
    required this.combinationPrice,
    required this.combinationQuantity,
  });

  factory CombinationIndice.fromJson(Map<String, dynamic> json) {
    return CombinationIndice(
      id: json['id'] as String,
      course: json['course'] as int,
      combinationId: json['combinationId'] as String,
      dishesWithIngredients:
          (json['dishesWithIngredients'] as List<dynamic>?)
              ?.map(
                (e) =>
                    DishesWithIngredients.fromJson(e as Map<String, dynamic>),
              )
              .toList() ??
          [],
      combinationDimensionId: json['combinationDimensionId'] as String,
      combinationDimensionName: json['combinationDimensionName'] as String,
      combinationPrice: (json['combinationPrice'] as num).toDouble(),
      combinationQuantity: json['combinationQuantity'] as int,
    );
  }

  @override
  Map<String, dynamic> toOrderPayload() {
    return {
      'id': id,
      'course': course,
      'combinationId': combinationId,
      'dishesWithIngredients': dishesWithIngredients
          .map((e) => e.toJson())
          .toList(),
      'combinationDimensionId': combinationDimensionId,
      'combinationDimensionName': combinationDimensionName,
      'combinationPrice': combinationPrice,
      'combinationQuantity': combinationQuantity,
    };
  }

  @override
  List<Object?> get props => [
    id,
    course,
    combinationId,
    dishesWithIngredients,
    combinationDimensionId,
    combinationDimensionName,
    combinationPrice,
    combinationQuantity,
  ];
}

class DishesWithIngredients extends Equatable {
  final String id;
  final String dishId;
  final String dishName;
  final List<String> ingredientsId;
  final List<String> ingredientsName;

  const DishesWithIngredients({
    required this.id,
    required this.dishId,
    required this.dishName,
    required this.ingredientsId,
    required this.ingredientsName,
  });

  factory DishesWithIngredients.fromJson(Map<String, dynamic> json) {
    return DishesWithIngredients(
      id: json['id'] as String,
      dishId: json['dishId'] as String,
      dishName: json['dishName'] as String,
      ingredientsId:
          (json['ingredientsId'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      ingredientsName:
          (json['ingredientsName'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'dishId': dishId,
      'dishName': dishName,
      'ingredientsId': ingredientsId,
      'ingredientsName': ingredientsName,
    };
  }

  @override
  List<Object?> get props => [
    id,
    dishId,
    dishName,
    ingredientsId,
    ingredientsName,
  ];
}

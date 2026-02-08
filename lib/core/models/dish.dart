import 'package:equatable/equatable.dart';
import 'package:restaukitchen_app/core/models/dimesnion_assignment.dart';

class Dish extends Equatable {
  final String? id;
  final Map<String, dynamic>? ingredients;
  final double? price;
  final String? restaurantId;
  final String? menuId;
  final String? description;
  final List<String>? dishImagesId;
  final bool? isAvailable;
  final String name;
  final String? categoryId;
  final int? position;
  
  final String? descriptionIt;
  final String? descriptionAr;
  final String? descriptionFr;
  final String? descriptionEs;
  final List<DimensionAssignment>? dimensionAssignments;

  const Dish({
    this.id,
    this.ingredients,
    this.price,
    this.restaurantId,
    this.categoryId,
    this.menuId,
    this.description,
    this.dishImagesId,
    this.isAvailable,
    required this.name,
    this.dimensionAssignments,
    required this.position,
    this.descriptionIt,
    this.descriptionAr,
    this.descriptionFr,
    this.descriptionEs,
  });

  // Factory constructor to create Dish from JSON
  factory Dish.fromJson(Map<String, dynamic> json) {
    return Dish(
      id: json['id'] as String?,
      ingredients: json['ingredients'] as Map<String, dynamic>?,
      price: json['price'] != null ? (json['price'] as num).toDouble() : null,
      restaurantId: json['restaurantId'] as String?,
      // menuId: json['menuId'] as String,
      description: json['description'] as String?,
      dishImagesId: json['dishImagesId'] != null
          ? List<String>.from(json['dishImagesId'] as List)
          : null,
      isAvailable: json['isAvailable'] as bool?,
      name: json['name'] as String,
      position: json['position'] as int?,
      descriptionIt: json['descriptionIt'] as String?,
      descriptionAr: json['descriptionAr'] as String?,
      descriptionFr: json['descriptionFr'] as String?,
      descriptionEs: json['descriptionEs'] as String?,
      dimensionAssignments: json['dimensionAssignments'] != null
          ? (json['dimensionAssignments'] as List)
                .map((dimension) => DimensionAssignment.fromJson(dimension))
                .toList()
          : [],
    );
  }

  // Convert Dish to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'ingredients': ingredients,
      'price': price,
      'restaurantId': restaurantId,
      // 'menuId': menuId,
      'description': description,
      'dishImagesId': dishImagesId,
      'isAvailable': isAvailable,
      'name': name,
      'position': position,
      'descriptionIt': descriptionIt ?? '',
      'descriptionAr': descriptionAr ?? '',
      'descriptionFr': descriptionFr ?? '',
      'descriptionEs': descriptionEs ?? '',

      // 'dimensionAssignments': jsonEncode(dimensionAssignments?.map((dimension) => dimension.toJson()).toList()),
    };
  }

  // factory Dish.formFormData(
  //   String name,
  //   String categoryId,
  //   List<DimensionAssignment> dimensionAssignments,
  //   List<String>? dishImagesId,
  //   List<String>? ingredients,
  //   double price,
  //   bool isAvailable,
  //   int position,
  //   List<DescriptionEntity> descriptions,
  // ) {
  //   return Dish(
  //     name: name,
  //     position: position,
  //     description: descriptions
  //         .where((des) => des.language == "English")
  //         .first
  //         .value,
  //     descriptionAr:descriptions
  //         .where((des) => des.language == "English")
  //         .first
  //         .value,
  //         descriptionEs: descriptions
  //         .where((des) => des.language == "English")
  //         .first
  //         .value,
  //         descriptionFr: descriptions
  //         .where((des) => des.language == "English")
  //         .first
  //         .value,
  //         descriptionIt: descriptions
  //         .where((des) => des.language == "English")
  //         .first
  //         .value,
  //         categoryId: categoryId,
  //         isAvailable:  isAvailable,
  //   );
  // }

  // Copy with method for immutable updates
  Dish copyWith({
    String? id,
    Map<String, dynamic>? ingredients,
    double? price,
    String? restaurantId,
    // String? menuId,
    String? description,
    List<String>? dishImagesId,
    bool? isAvailable,
    String? name,
    int? position,
    String? descriptionIt,
    String? descriptionAr,
    String? descriptionFr,
    String? descriptionEs,
    List<DimensionAssignment>? dimensionAssignments,
  }) {
    return Dish(
      id: id ?? this.id,
      ingredients: ingredients ?? this.ingredients,
      price: price ?? this.price,
      restaurantId: restaurantId ?? this.restaurantId,
      // menuId: menuId ?? this.menuId,
      description: description ?? this.description,
      dishImagesId: dishImagesId ?? this.dishImagesId,
      isAvailable: isAvailable ?? this.isAvailable,
      name: name ?? this.name,
      position: position ?? this.position,
      descriptionIt: descriptionIt ?? this.descriptionIt,
      descriptionAr: descriptionAr ?? this.descriptionAr,
      descriptionFr: descriptionFr ?? this.descriptionFr,
      descriptionEs: descriptionEs ?? this.descriptionEs,
      dimensionAssignments: dimensionAssignments ?? this.dimensionAssignments,
    );
  }

  @override
  List<Object?> get props => [
    id,
    ingredients,
    price,
    restaurantId,
    //  menuId,
    description,
    dishImagesId,
    isAvailable,
    name,
    position,
    descriptionIt,
    descriptionAr,
    descriptionFr,
    descriptionEs,
    dimensionAssignments,
  ];
}

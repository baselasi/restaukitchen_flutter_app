import 'package:equatable/equatable.dart';

class Category extends Equatable {
  final String? id;
  final String name;
  final bool deleted;

  const Category({this.id, required this.name, required this.deleted});

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json["id"] as String?,
      name: json["name"] as String,
      deleted: json["deleted"] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {"id": id, "name": name, "deleted": deleted};
  }

  @override
  List<Object?> get props => [id, name, deleted];
}

class CategoriesResponse extends Equatable {
  final List<Category> categories;

  const CategoriesResponse({required this.categories});

  factory CategoriesResponse.fromJson(List<dynamic> json) {
    return CategoriesResponse(
      categories: json.map((e) => Category.fromJson(e)).toList(),
    );
  }

  @override
  List<Object?> get props => [categories];
}

class CreateCategoryRequest extends Equatable {
  final String name;
  final String? id;
  const CreateCategoryRequest({required this.name, this.id});

  factory CreateCategoryRequest.fromJson(Map<String, dynamic> json) {
    return CreateCategoryRequest(name: json['name'] as String);
  }

  Map<String, dynamic> toJson() {
    return {'name': name, if (id != null) 'id': id};
  }

  @override
  List<Object?> get props => [name, id];
}

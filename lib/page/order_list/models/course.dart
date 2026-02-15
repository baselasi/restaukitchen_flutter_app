import 'package:equatable/equatable.dart';

class Course extends Equatable {
  final List<CourseIndice> disheIndices;

  const Course({required this.disheIndices});



  factory Course.fromJson(Map<String, dynamic> json) {
    return Course(
      disheIndices: json['disheIndices'] as List<CourseIndice>,
    );
  }
  @override
  List<Object> get props => [];
}

sealed class CourseIndice {}

class DishIndice extends CourseIndice {}

class CombinationIndice extends CourseIndice {}

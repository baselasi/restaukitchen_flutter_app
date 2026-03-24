import 'package:equatable/equatable.dart';
import 'package:restaukitchen_app/page/order_list/models/course.dart';

abstract class NewOrderFormEvent extends Equatable {}

class AddCourse extends NewOrderFormEvent {
  final Course course;
  AddCourse({required this.course});
  @override
  List<Object?> get props => [course];
}

class RemoveCourse extends NewOrderFormEvent {
  final Course course;
  RemoveCourse({required this.course});
  @override
  List<Object?> get props => [course];
}

class UpdateCourse extends NewOrderFormEvent {
  final Course course;
  final int index;

  UpdateCourse({required this.course, required this.index});
  @override
  List<Object?> get props => [course];
}

class AddDishIndice extends NewOrderFormEvent {
  final CourseIndice courseIndice;
  final int courseIndex;
  AddDishIndice({required this.courseIndice, required this.courseIndex});
  @override
  List<Object?> get props => [courseIndice, courseIndex];
}

class RemoveDishIndice extends NewOrderFormEvent {
  final CourseIndice dishIndice;
  final int courseIndex;
  RemoveDishIndice({required this.dishIndice, required this.courseIndex});
  @override
  List<Object?> get props => [dishIndice, courseIndex];
}

class DeleteDishIndice extends NewOrderFormEvent {
  final int dishIndiceIndex;
  final int courseIndex;
  DeleteDishIndice({required this.dishIndiceIndex, required this.courseIndex});
  @override
  List<Object?> get props => [dishIndiceIndex, courseIndex];
}

class UpdateDishIndice extends NewOrderFormEvent {
  final int courseIndex;
  final CourseIndice dishIndice;
  UpdateDishIndice({required this.courseIndex, required this.dishIndice});
  @override
  List<Object?> get props => [courseIndex, dishIndice];
}

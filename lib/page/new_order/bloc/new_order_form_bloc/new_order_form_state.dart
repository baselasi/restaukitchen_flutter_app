import 'package:equatable/equatable.dart';
import 'package:restaukitchen_app/page/order_list/models/course.dart';





class NewOrderFormState extends Equatable {
  final List<Course> courses;
  final int tableNumber;
  final int totalCovers;
  final double total;
  final DateTime orderTime;
  final int currentCourseIndex;
  const NewOrderFormState({
    required this.courses,
    required this.tableNumber,
    required this.totalCovers,
    required this.total,
    required this.orderTime,
    required this.currentCourseIndex,
  });

  factory NewOrderFormState.fromJson(Map<String, dynamic> json) {
    return NewOrderFormState(
      courses: json['courses'] as List<Course>,
      tableNumber: json['tableNumber'] as int,
      totalCovers: json['totalCovers'] as int,
      total: json['total'] as double,
      orderTime: json['orderTime'] as DateTime,
      currentCourseIndex: json['currentCourseIndex'] as int,
    );
  }

  NewOrderFormState copyWith({
    List<Course>? courses,
    int? tableNumber,
    int? totalCovers,
    double? total,
    DateTime? orderTime,
    int? currentCourseIndex,
  }) {
    return NewOrderFormState(
      courses: courses ?? this.courses,
      tableNumber: tableNumber ?? this.tableNumber,
      totalCovers: totalCovers ?? this.totalCovers,
      total: total ?? this.total,
      orderTime: orderTime ?? this.orderTime,
      currentCourseIndex: currentCourseIndex ?? this.currentCourseIndex,
    );
  }

  @override
  List<Object?> get props => [courses, tableNumber, totalCovers, total, orderTime, currentCourseIndex];
}

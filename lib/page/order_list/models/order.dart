import 'package:equatable/equatable.dart';
import 'package:restaukitchen_app/page/order_list/models/course.dart';

class Order extends Equatable {
  final List<Course> courses;
  final int? tableNumber;
  final int totalCovers;
  final int? total;
  final CourseStatus courseStatus;

  const Order({
    required this.courses,
    required this.tableNumber,
    required this.totalCovers,
    required this.total,
    required this.courseStatus,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      courses: (json['courses'] as List<dynamic>)
          .map((course) => Course.fromJson(course))
          .toList(),
      tableNumber: json['tableNumber'] as int?,
      totalCovers: json['totalCovers'] as int,
      total: json['total'] as int?,
      courseStatus: CourseStatus.received,
      // courseStatus: json['courseStatus'] as CourseStatus,
    );
  }

  @override
  List<Object?> get props => [
    courses,
    tableNumber,
    totalCovers,
    total,
    courseStatus,
  ];
}

enum CourseStatus { received, onFire, finished }

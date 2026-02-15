import 'package:equatable/equatable.dart';
import 'package:restaukitchen_app/page/order_list/models/course.dart';

class Order extends Equatable {
  final List<Course>? courses;
  final List<CourseIndice>? courseIndices;
  final int? tableNumber;
  final int totalCovers;
  final double? total;
  final CourseStatus courseStatus;

  const Order({
    this.courses,
    this.courseIndices,
    required this.tableNumber,
    required this.totalCovers,
    required this.total,
    required this.courseStatus,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      // courses: (json['courses'] as List<dynamic>)
      //     .map((course) => Course.fromJson(course))
      //     .toList(),
      // courseIndices: json['courseIndices'] as List<CourseIndice>?,
      tableNumber: json['tableNumber'] as int?,
      totalCovers: json['totalCovers'] as int,
      total: json['total'] as double?,
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

class OrderResponse extends Equatable {
  final List<Order> orders;

  const OrderResponse({required this.orders});

  factory OrderResponse.fromJson(List<dynamic> json) {
    return OrderResponse(
      orders: json.map((order) => Order.fromJson(order)).toList(),
    );
  }

  @override
  List<Object?> get props => [];
}

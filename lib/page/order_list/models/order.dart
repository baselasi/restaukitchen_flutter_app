import 'package:equatable/equatable.dart';
import 'package:restaukitchen_app/page/order_list/models/course.dart';

class Order extends Equatable {
  final List<Course>? courses;
  final String? id;
  final List<CourseIndice>? dishIndices;
  final int? tableNumber;
  final int totalCovers;
  final double? total;
  final CourseStatus courseStatus;

  const Order({
    this.courses,
    this.dishIndices,
    this.id,
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
      id: json['id'] as String?,
      dishIndices: (json['dishIndices'] as List<dynamic>?)
          ?.map((course) => CourseIndice.fromJson(course))
          .toList(),

      tableNumber: json['tableNumber'] as int?,
      totalCovers: json['totalCovers'] as int,
      total: json['total'] as double?,
      courseStatus: json['courseStatus'] != null
          ? json['courseStatus'] == "STATUS_RECEIVED"
                ? CourseStatus.received
                : json['courseStatus'] == "STATUS_ON_FIRE"
                ? CourseStatus.onFire
                : CourseStatus.finished
          : CourseStatus.received,
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

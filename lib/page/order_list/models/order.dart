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
  final DateTime? orderTime;

  const Order({
    this.courses,
    this.dishIndices,
    this.id,
    required this.tableNumber,
    required this.totalCovers,
    required this.total,
    required this.courseStatus,
    this.orderTime,
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
      orderTime: json['orderTime'] != null ? DateTime.parse(json['orderTime'] as String) : null,
      tableNumber: json['tableNumber'] as int?,
      totalCovers: json['totalCovers'] as int,
      total: json['total'] as double?,
      courseStatus: CourseStatus.fromString(json['courseStatus'] as String?),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      // if (id != null) "id": id,
      'dishIndices': dishIndices?.map((course) => course.toOrderPayload()).toList(),
      'tableNumber': tableNumber,
      'totalCovers': totalCovers,
      // 'total': total,
      'courseStatus': courseStatus.value,
    };
  }

  Order copyWith({
    CourseStatus? courseStatus,
    List<CourseIndice>? dishIndices,
    int? tableNumber,
    int? totalCovers,
    double? total,
  }) {
    return Order(
      id: id,
      dishIndices: dishIndices ?? this.dishIndices,
      tableNumber: tableNumber ?? this.tableNumber,
      totalCovers: totalCovers ?? this.totalCovers,
      total: total ?? this.total,
      courseStatus: courseStatus ?? this.courseStatus,
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

class CourseStatus extends Equatable {
  final String value;

  const CourseStatus._(this.value);

  static const CourseStatus received = CourseStatus._('STATUS_RECEIVED');
  static const CourseStatus onFire = CourseStatus._('STATUS_ON_FIRE');
  static const CourseStatus finished = CourseStatus._('STATUS_FINISHED');

  static CourseStatus fromString(String? status) {
    switch (status) {
      case 'STATUS_RECEIVED':
        return received;
      case 'STATUS_ON_FIRE':
        return onFire;
      case 'STATUS_FINISHED':
        return finished;
      default:
        return received;
    }
  }

  @override
  List<Object?> get props => [value];

  @override
  String toString() => value;
}

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

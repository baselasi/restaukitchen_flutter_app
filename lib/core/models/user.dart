import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String id;
  final String username;
  final String? dinnerTable;
  final String role;
  final int exp;
  final String? restaurant;
  final String status;

  const User({
    required this.id,
    required this.username,
    this.dinnerTable,
    required this.role,
    required this.exp,
    this.restaurant,
    required this.status,
  });

  // Factory constructor to create User from JSON
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as String,
      username: json['username'] as String,
      dinnerTable: json['dinnerTable'] as String?,
      role: json['role'] as String,
      exp: json['exp'] as int,
      restaurant: json['restaurant'] as String?,
      status: json['status'] as String,
    );
  }

  // Convert User to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'dinnerTable': dinnerTable,
      'role': role,
      'exp': exp,
      'restaurant': restaurant,
      'status': status,
    };
  }

  // Copy with method for immutable updates
  User copyWith({
    String? id,
    String? username,
    String? dinnerTable,
    String? email,
    String? role,
    int? exp,
    String? restaurant,
    String? status,
  }) {
    return User(
      id: id ?? this.id,
      username: username ?? this.username,
      dinnerTable: dinnerTable ?? this.dinnerTable,
      role: role ?? this.role,
      exp: exp ?? this.exp,
      restaurant: restaurant ?? this.restaurant,
      status: status ?? this.status,
    );
  }

  @override
  List<Object?> get props => [
        id,
        username,
        dinnerTable,
        role,
        exp,
        restaurant,
        status,
      ];
}

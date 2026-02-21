import 'package:equatable/equatable.dart';

class Tabel extends Equatable {
  final String? id;
  final int number;
  final TabelStatus status;
  final String? description;
  final int numberOfSeats;
  final int position;
  final List<String> orderIDs;

  const Tabel({
    this.id,
    required this.number,
    required this.status,
    this.description,
    required this.numberOfSeats,
    required this.position,
    this.orderIDs = const [],
  });

  factory Tabel.fromJson(Map<String, dynamic> json) {
    return Tabel(
      id: json['id'] as String?,
      number: json['number'] as int,
      status: TabelStatus.fromString(json['status'] as String?),
      description: json['description'] as String?,
      numberOfSeats: json['numberOfSeats'] as int,
      position: json['position'] as int,
      orderIDs: (json['orderIDs'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'number': number,
      'status': status.value,
      'description': description,
      'numberOfSeats': numberOfSeats,
      'position': position,
      'orderIDs': orderIDs,
    };
  }

  Tabel copyWith({
    String? id,
    int? number,
    TabelStatus? status,
    String? description,
    int? numberOfSeats,
    int? position,
    List<String>? orderIDs,
  }) {
    return Tabel(
      id: id ?? this.id,
      number: number ?? this.number,
      status: status ?? this.status,
      description: description ?? this.description,
      numberOfSeats: numberOfSeats ?? this.numberOfSeats,
      position: position ?? this.position,
      orderIDs: orderIDs ?? this.orderIDs,
    );
  }

  @override
  List<Object?> get props => [
        id,
        number,
        status,
        description,
        numberOfSeats,
        position,
        orderIDs,
      ];
}

class TabelStatus extends Equatable {
  final String value;

  const TabelStatus._(this.value);

  static const TabelStatus available = TabelStatus._('STATUS_AVAILABLE');
  static const TabelStatus occupied = TabelStatus._('STATUS_OCCUPIED');
  static const TabelStatus reserved = TabelStatus._('STATUS_RESERVED');

  static TabelStatus fromString(String? status) {
    switch (status) {
      case 'STATUS_AVAILABLE':
        return available;
      case 'STATUS_OCCUPIED':
        return occupied;
      case 'STATUS_RESERVED':
        return reserved;
      default:
        return available;
    }
  }

  @override
  List<Object?> get props => [value];

  @override
  String toString() => value;
}

class TabelResponse extends Equatable {
  final List<Tabel> tabels;

  const TabelResponse({required this.tabels});

  factory TabelResponse.fromJson(List<dynamic> json) {
    return TabelResponse(
      tabels: json.map((tabel) => Tabel.fromJson(tabel)).toList(),
    );
  }

  @override
  List<Object?> get props => [tabels];
}

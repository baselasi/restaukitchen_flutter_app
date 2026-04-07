import 'package:equatable/equatable.dart';

class CityModel extends Equatable {
  final String id;
  final String name;

  const CityModel({required this.id, required this.name});

  factory CityModel.fromJson(Map<String, dynamic> json) {
    return CityModel(id: json['id'] as String, name: json['name'] as String);
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name};
  }

  @override
  List<Object?> get props => [id, name];
}

class CityResponse extends Equatable {
  final List<CityModel> cities;

  const CityResponse({required this.cities});

  factory CityResponse.fromJson(List<dynamic> json) {
    return CityResponse(
      cities: json.map((e) => CityModel.fromJson(e)).toList(),
    );
  }

  @override
  List<Object?> get props => [cities];
}

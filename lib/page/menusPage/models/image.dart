import 'package:equatable/equatable.dart';

class ImageResponse extends Equatable {
  final String id;
  final String blob;

  const ImageResponse({required this.id, required this.blob});

  factory ImageResponse.fromJson(Map<String, dynamic> json) {
    return ImageResponse(id: json['id'] as String, blob: json['photoBlob'] as String);
  }

  @override
  List<Object?> get props => [id, blob];
}

import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:restaukitchen_app/core/services/api_service.dart';
import 'package:restaukitchen_app/core/services/sevices_loactor.dart';

class PublicImage extends StatelessWidget {
  final String imageUrl;
  final BoxFit? fit;
  final Widget? placeholder;
  final Widget? errorWidget;

  const PublicImage({
    super.key,
    required this.imageUrl,
    this.fit,
    this.placeholder,
    this.errorWidget,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Uint8List?>(
      future: _loadImage(imageUrl),

      builder: (context, snapshot) {
        // if (_isLoading) {
        //   return Center(child: CircularProgressIndicator());
        // }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError || snapshot.data == null) {
          return errorWidget ??
              const Icon(Icons.error_outline, color: Colors.grey);
        }

        return Image.memory(snapshot.data!, fit: fit ?? BoxFit.cover);
      },
    );
  }

  Future<Uint8List?> _loadImage(String url) async {
    try {
      final apiService = getIt<ApiService>();
      final response = await http.get(Uri.parse("${apiService.baseUrl}$url"));
      if (response.statusCode == 200) {
        return response.bodyBytes;
      } else {
        throw Exception('Failed to load image: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error loading image: $e');
    }
  }
}

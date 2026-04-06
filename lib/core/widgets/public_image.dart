import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:restaukitchen_app/core/services/api_service.dart';
import 'package:restaukitchen_app/core/services/sevices_loactor.dart';

class PublicImage extends StatefulWidget {
  final String imageUrl;
  final BoxFit? fit;
  final Widget? placeholder;
  final Widget? errorWidget;
  final ValueChanged<Uint8List>? onImageLoaded;

  const PublicImage({
    super.key,
    required this.imageUrl,
    this.fit,
    this.placeholder,
    this.errorWidget,
    this.onImageLoaded,
  });

  @override
  State<PublicImage> createState() => _PublicImageState();
}

class _PublicImageState extends State<PublicImage> {
  late Future<Uint8List?> _imageFuture;
  bool _hasReportedLoadedImage = false;

  @override
  void initState() {
    super.initState();
    _imageFuture = _loadImage(widget.imageUrl);
  }

  @override
  void didUpdateWidget(covariant PublicImage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.imageUrl != widget.imageUrl) {
      _imageFuture = _loadImage(widget.imageUrl);
      _hasReportedLoadedImage = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Uint8List?>(
      future: _imageFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return widget.placeholder ??
              const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError || snapshot.data == null) {
          return widget.errorWidget ??
              const Icon(Icons.error_outline, color: Colors.grey);
        }

        if (!_hasReportedLoadedImage && widget.onImageLoaded != null) {
          _hasReportedLoadedImage = true;
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) {
              widget.onImageLoaded?.call(snapshot.data!);
            }
          });
        }

        return Image.memory(snapshot.data!, fit: widget.fit ?? BoxFit.cover);
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

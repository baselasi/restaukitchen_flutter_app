import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:restaukitchen_app/core/widgets/public_image.dart';
import 'package:restaukitchen_app/page/settings_page/bloc/change_restaurant_image_cubit/change_restaurant_image_cubit.dart';
import 'package:restaukitchen_app/page/settings_page/models/restaurant.dart';
import 'package:restaukitchen_app/theme/light_theme.dart';

class RestaurantCoverBanner extends StatefulWidget {
  const RestaurantCoverBanner({
    super.key,
    required this.restaurant,
    required this.onEditBackground,
    required this.onEditCornerImage,
  });

  final Restaurant restaurant;
  final VoidCallback onEditBackground;
  final VoidCallback onEditCornerImage;

  static const BorderRadius _bannerRadius = BorderRadius.all(
    Radius.circular(12),
  );

  @override
  State<RestaurantCoverBanner> createState() => _RestaurantCoverBannerState();
}

class _RestaurantCoverBannerState extends State<RestaurantCoverBanner> {
  final ImagePicker _picker = ImagePicker();
  File? _logo;
  File? _image;

  Future<File> _createTempImageFile(
    Uint8List bytes, {
    required String prefix,
  }) async {
    final tempDir = Directory.systemTemp;
    final file = File(
      '${tempDir.path}/${widget.restaurant.id}_$prefix${DateTime.now().millisecondsSinceEpoch}.jpg',
    );
    return file.writeAsBytes(bytes, flush: true);
  }

  Future<void> _storeLoadedImage(
    Uint8List bytes, {
    required bool isLogo,
  }) async {
    final file = await _createTempImageFile(
      bytes,
      prefix: isLogo ? 'logo_' : 'image_',
    );
    if (!mounted) return;
    setState(() {
      if (isLogo) {
        _logo = file;
      } else {
        _image = file;
      }
    });
  }

  Future<void> _pickImage(
    ImageSource source, {
    File? logo,
    File? image,
    bool isLogo = false,
  }) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: source,
        maxWidth: 1500, // Optional: Resizes image to save memory
        maxHeight: 1500,
        imageQuality: 80, // Optional: Compresses image
      );

      if (pickedFile != null && mounted) {
        context.read<ChangeRestaurantImageCubit>().uploadRestaurantImage(
          widget.restaurant.restaurantImage.first,
          isLogo ? File(pickedFile.path) : logo,
          isLogo ? image : File(pickedFile.path),
        );
      }
    } catch (e) {
      print("Error picking image: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.grey[200],
      elevation: 6,
      shadowColor: Colors.black.withValues(alpha: 0.2),
      surfaceTintColor: Colors.transparent,
      shape: const RoundedRectangleBorder(
        borderRadius: RestaurantCoverBanner._bannerRadius,
      ),
      clipBehavior: Clip.antiAlias,
      child: SizedBox(
        height: 168,
        width: double.infinity,
        child: Stack(
          fit: StackFit.expand,
          children: [
            BlocBuilder<ChangeRestaurantImageCubit, ChangeRestaurantImageState>(
              builder: (context, state) {
                if (state.status == ChangeRestaurantImageStatus.loading) {
                  return const Center(child: CircularProgressIndicator());
                }
                return PublicImage(
                  key: Key(widget.restaurant.restaurantImage.first),
                  onImageLoaded: (image) {
                    _storeLoadedImage(image, isLogo: false);
                  },
                  imageUrl:
                      "/api/public/restaurant-image/${widget.restaurant.restaurantImage.first}",
                  fit: BoxFit.fill,
                  placeholder: ColoredBox(
                    color: Colors.grey[200]!,
                    child: Icon(
                      Icons.restaurant_menu,
                      size: 36,
                      color: Colors.grey[400],
                    ),
                  ),
                  errorWidget: ColoredBox(
                    color: Colors.grey[200]!,
                    child: Icon(
                      Icons.restaurant_menu,
                      size: 36,
                      color: Colors.grey[400],
                    ),
                  ),
                );
              },
            ),

            Positioned(
              bottom: 2,
              right: 2,
              child: _EditFab(
                size: 40,
                onTap: () {
                  _pickImage(
                    ImageSource.gallery,
                    logo: _logo,
                    image: _image,
                    isLogo: false,
                  );
                },
              ),
            ),
            Positioned(
              left: 12,
              bottom: 12,
              child:
                  BlocBuilder<
                    ChangeRestaurantImageCubit,
                    ChangeRestaurantImageState
                  >(
                    builder: (context, state) {
                      if (state.status == ChangeRestaurantImageStatus.loading) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      return _CornerImageWithEdit(
                        onEdit: () {
                          _pickImage(
                            ImageSource.gallery,
                            logo: _logo,
                            image: _image,
                            isLogo: true,
                          );
                        },
                        restaurant: widget.restaurant,
                        onImageLoaded: (image) {
                          _storeLoadedImage(image, isLogo: true);
                        },
                      );
                    },
                  ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EditFab extends StatelessWidget {
  const _EditFab({required this.onTap, required this.size});
  final double size;
  final VoidCallback onTap;

  static const BorderRadius _radius = BorderRadius.all(Radius.circular(20));

  @override
  Widget build(BuildContext context) {
    return Material(
      color: LightTheme.primaryColor,
      elevation: 4,
      shadowColor: Colors.black.withValues(alpha: 0.35),
      shape: const RoundedRectangleBorder(borderRadius: _radius),
      child: InkWell(
        onTap: onTap,
        borderRadius: _radius,
        child: SizedBox(
          width: size,
          height: size,
          child: Center(
            child: Icon(Icons.edit_outlined, size: 18, color: Colors.white),
          ),
        ),
      ),
    );
  }
}

class _CornerImageWithEdit extends StatelessWidget {
  const _CornerImageWithEdit({
    required this.onEdit,
    required this.restaurant,
    required this.onImageLoaded,
  });
  final ValueChanged<Uint8List>? onImageLoaded;
  final Restaurant restaurant;
  final VoidCallback onEdit;
  static const double _avatarSize = 90;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: _avatarSize,
      height: _avatarSize,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: LightTheme.primaryColor.withValues(alpha: 0.5),
            blurRadius: 5,
            offset: const Offset(0, 4),
          ),
        ],
        shape: BoxShape.circle,
        border: Border.all(color: LightTheme.primaryColor, width: 3),
      ),
      child: Stack(
        clipBehavior: Clip.antiAliasWithSaveLayer,
        children: [
          ClipOval(
            child: SizedBox.expand(
              child: PublicImage(
                onImageLoaded: onImageLoaded,
                imageUrl:
                    "/api/public/restaurant-logo/${restaurant.restaurantImage.first}",
                fit: BoxFit.cover,
                placeholder: ColoredBox(
                  color: Colors.grey[200]!,
                  child: Icon(
                    Icons.restaurant_menu,
                    size: 36,
                    color: Colors.grey[400],
                  ),
                ),
                errorWidget: ColoredBox(
                  color: Colors.grey[200]!,
                  child: Icon(
                    Icons.restaurant_menu,
                    size: 36,
                    color: Colors.grey[400],
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            right: 0,
            bottom: 0,
            child: _EditFab(onTap: onEdit, size: 30),
          ),
        ],
      ),
    );
  }
}

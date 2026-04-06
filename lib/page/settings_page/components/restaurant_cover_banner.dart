import 'package:flutter/material.dart';
import 'package:restaukitchen_app/core/widgets/public_image.dart';
import 'package:restaukitchen_app/page/settings_page/models/restaurant.dart';
import 'package:restaukitchen_app/theme/light_theme.dart';

class RestaurantCoverBanner extends StatelessWidget {
  const RestaurantCoverBanner({
    super.key,
    required this.restaurant,
    required this.onEditBackground,
    required this.onEditCornerImage,
  });

  final Restaurant restaurant;
  final VoidCallback onEditBackground;
  final VoidCallback onEditCornerImage;

  static const BorderRadius _bannerRadius = BorderRadius.all(Radius.circular(12));

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.grey[200],
      elevation: 6,
      shadowColor: Colors.black.withValues(alpha: 0.2),
      surfaceTintColor: Colors.transparent,
      shape: const RoundedRectangleBorder(borderRadius: _bannerRadius),
      clipBehavior: Clip.antiAlias,
      child: SizedBox(
        height: 168,
        width: double.infinity,
        child: Stack(
          fit: StackFit.expand,
          children: [
            PublicImage(
              imageUrl:
                  "/api/public/restaurant-image/${restaurant.restaurantImage.first}",
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
            ),
            Positioned(
              bottom: 2,
              right: 2,
              child: _EditFab(onTap: onEditBackground),
            ),
            Positioned(
              left: 12,
              bottom: 12,
              child: _CornerImageWithEdit(
                onEdit: onEditCornerImage,
                restaurant: restaurant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EditFab extends StatelessWidget {
  const _EditFab({required this.onTap});

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
        child: const SizedBox(
          width: 40,
          height: 40,
          child: Center(
            child: Icon(Icons.edit_outlined, size: 18, color: Colors.white),
          ),
        ),
      ),
    );
  }
}

class _CornerImageWithEdit extends StatelessWidget {
  const _CornerImageWithEdit({required this.onEdit, required this.restaurant});

  final Restaurant restaurant;
  final VoidCallback onEdit;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 90,
      height: 90,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: LightTheme.primaryColor.withValues(alpha: 0.5),
            blurRadius: 5,
            offset: const Offset(0, 4),
          ),
        ],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: LightTheme.primaryColor, width: 3),
      ),
      child: Stack(
        clipBehavior: Clip.antiAliasWithSaveLayer,
        children: [
          PublicImage(
            imageUrl:
                "/api/public/restaurant-logo/${restaurant.restaurantImage.first}",
            fit: BoxFit.scaleDown,
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
          Positioned(right: 0, bottom: 0, child: _EditFab(onTap: onEdit)),
        ],
      ),
    );
  }
}

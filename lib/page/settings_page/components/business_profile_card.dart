import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restaukitchen_app/page/settings_page/bloc/change_restaurant_image_cubit/change_restaurant_image_cubit.dart';
import 'package:restaukitchen_app/page/settings_page/components/restaurant_cover_banner.dart';
import 'package:restaukitchen_app/page/settings_page/models/restaurant.dart';
import 'package:restaukitchen_app/page/settings_page/respository/restaurant_repo.dart';
import 'package:restaukitchen_app/theme/light_theme.dart';

class BusinessProfileCard extends StatelessWidget {
  const BusinessProfileCard({
    super.key,
    required this.restaurant,
    this.titleColor = const Color(0xFF3F4B8E),
  });

  final Restaurant restaurant;
  final Color titleColor;

  static const BorderRadius _cardRadius = BorderRadius.all(Radius.circular(20));

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      elevation: 8,
      shadowColor: Colors.black.withValues(alpha: 0.18),
      surfaceTintColor: Colors.transparent,
      shape: const RoundedRectangleBorder(borderRadius: _cardRadius),
      clipBehavior: Clip.antiAlias,
      child: SizedBox(
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              BlocProvider(
                create: (context) => ChangeRestaurantImageCubit(
                  restaurantRepo: RestaurantRepo(),
                ),
                child: RestaurantCoverBanner(
                  restaurant: restaurant,
                  onEditBackground: () {},
                  onEditCornerImage: () {},
                ),
              ),
              const SizedBox(height: 20),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          restaurant.name,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: titleColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              _DetailRow(
                icon: Icons.location_on_outlined,
                iconColor: LightTheme.primaryColor,
                textColor: Color(0xFF374151),
                text: restaurant.street,
              ),
              const SizedBox(height: 16),
              _DetailRow(
                icon: Icons.phone_outlined,
                iconColor: LightTheme.primaryColor,
                textColor: Color(0xFF374151),
                text: restaurant.city,
              ),
              const SizedBox(height: 16),
              _DetailRow(
                icon: Icons.payments_outlined,
                iconColor: LightTheme.primaryColor,
                textColor: Color(0xFF374151),
                text: restaurant.currency,
              ),
              const SizedBox(height: 16),
              _DetailRow(
                icon: Icons.language_outlined,
                iconColor: LightTheme.primaryColor,
                textColor: Color(0xFF374151),
                text: restaurant.country,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({
    required this.icon,
    required this.iconColor,
    required this.textColor,
    required this.text,
  });

  final IconData icon;
  final Color iconColor;
  final Color textColor;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 22, color: iconColor),
        const SizedBox(width: 12),
        Expanded(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Flexible(
                child: Text(
                  text,
                  style: TextStyle(
                    fontSize: 15,
                    height: 1.35,
                    color: textColor,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

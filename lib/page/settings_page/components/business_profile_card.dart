import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:page_transition/page_transition.dart';
import 'package:restaukitchen_app/page/restaurant_form/bloc/retaurant_form_cubit/retaurant_form_cubit.dart';
import 'package:restaukitchen_app/page/restaurant_form/restaurant_form.dart';
import 'package:restaukitchen_app/page/settings_page/bloc/change_restaurant_image_cubit/change_restaurant_image_cubit.dart';
import 'package:restaukitchen_app/page/settings_page/bloc/restaurant_info_cubit/restaurant_info_cubit.dart';
import 'package:restaukitchen_app/page/settings_page/components/restaurant_cover_banner.dart';
import 'package:restaukitchen_app/page/settings_page/models/restaurant.dart';
import 'package:restaukitchen_app/page/settings_page/respository/restaurant_repo.dart';
import 'package:restaukitchen_app/theme/light_theme.dart';

class BusinessProfileCard extends StatelessWidget {
  const BusinessProfileCard({
    super.key,
    this.titleColor = const Color(0xFF3F4B8E),
  });

  final Color titleColor;

  static const BorderRadius _cardRadius = BorderRadius.all(Radius.circular(20));

  Future<void> _editRestaurant(
    BuildContext context,
    Restaurant restaurant,
  ) async {
    final bool? result = await Navigator.of(context).push(
      PageTransition(
        type: PageTransitionType.rightToLeft,
        child: BlocProvider(
          create: (context) =>
              RestaurantFormCubit(restaurantRepo: RestaurantRepo()),
          child: RestaurantForm(restaurant: restaurant),
        ),
      ),
    );
    if (result == true && context.mounted) {
      context.read<RestaurantInfoCubit>().getRestaurantInfo(restaurant.id);
    }
  }

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
          child: BlocBuilder<RestaurantInfoCubit, RestaurantInfoState>(
            builder: (context, state) {
              if (state.status == RestaurantInfoStatus.loading) {
                return const Center(child: CircularProgressIndicator());
              }
              if (state.status == RestaurantInfoStatus.error) {
                return Center(
                  child: Text(
                    state.errorMessage ?? 'Error loading restaurant info',
                  ),
                );
              }
              if (state.status == RestaurantInfoStatus.loaded) {
                final restaurant = state.restaurant!;
                return Column(
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
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          restaurant.name,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: titleColor,
                          ),
                        ),

                        IconButton(
                          onPressed: () async {
                            _editRestaurant(context, restaurant);
                          },
                          icon: const Icon(Icons.edit),
                          color: LightTheme.primaryColor,
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
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
                );
              }
              return const SizedBox.shrink();
            },
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

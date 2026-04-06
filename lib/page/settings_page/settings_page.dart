import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restaukitchen_app/core/services/sevices_loactor.dart';
import 'package:restaukitchen_app/core/services/user_service.dart';
import 'package:restaukitchen_app/core/widgets/public_image.dart';
import 'package:restaukitchen_app/page/settings_page/bloc/restaurant_info_cubit/restaurant_info_cubit.dart';
import 'package:restaukitchen_app/page/settings_page/models/restaurant.dart';
import 'package:restaukitchen_app/theme/light_theme.dart';

const String _restaurantLogoAsset = 'assets/images/logo.png';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  static const Color _titleColor = Color(0xFF3F4B8E);
  static const Color _subtitleColor = Color(0xFF6B7280);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  void initState() {
    super.initState();
    context.read<RestaurantInfoCubit>().getRestaurantInfo(
      getIt<UserService>().user?.restaurant ?? '',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],

      body: BlocBuilder<RestaurantInfoCubit, RestaurantInfoState>(
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
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: _BusinessProfileCard(
                restaurant: state.restaurant!,
                titleColor: SettingsPage._titleColor,
                subtitleColor: SettingsPage._subtitleColor,
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}

class _BusinessProfileCard extends StatelessWidget {
  const _BusinessProfileCard({
    required this.restaurant,
    required this.titleColor,
    required this.subtitleColor,
  });

  final Restaurant restaurant;
  final Color titleColor;
  final Color subtitleColor;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 28),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.08),
                  blurRadius: 16,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _RestaurantCoverBanner(
                  restaurant: restaurant,
                  onEditBackground: () {},
                  onEditCornerImage: () {},
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
        ],
      ),
    );
  }
}

class _RestaurantCoverBanner extends StatelessWidget {
  const _RestaurantCoverBanner({
    required this.onEditBackground,
    required this.onEditCornerImage,
    required this.restaurant,
  });

  final VoidCallback onEditBackground;
  final VoidCallback onEditCornerImage;
  final Restaurant restaurant;
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
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

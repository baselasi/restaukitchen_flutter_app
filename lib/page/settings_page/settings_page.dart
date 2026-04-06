import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restaukitchen_app/core/services/sevices_loactor.dart';
import 'package:restaukitchen_app/core/services/user_service.dart';
import 'package:restaukitchen_app/page/settings_page/bloc/restaurant_info_cubit/restaurant_info_cubit.dart';
import 'package:restaukitchen_app/page/settings_page/components/business_profile_card.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

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
              child: BusinessProfileCard(restaurant: state.restaurant!),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}

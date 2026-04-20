import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:page_transition/page_transition.dart';
import 'package:restaukitchen_app/core/bloc/auth_cubit.dart';
import 'package:restaukitchen_app/core/bloc/language_cubit.dart';
import 'package:restaukitchen_app/core/bloc/get_category_cubit.dart';
import 'package:restaukitchen_app/core/bloc/get_ingredients_cubit.dart';
import 'package:restaukitchen_app/page/dimension_list/bloc/get_dimensions_cubit.dart';
import 'package:restaukitchen_app/page/dimension_list/repository/dimensions_repo.dart';
import 'package:restaukitchen_app/core/services/sevices_loactor.dart';
import 'package:restaukitchen_app/core/services/user_service.dart';
import 'package:restaukitchen_app/l10n/l10n.dart';
import 'package:restaukitchen_app/page/categories_list/categories_list.dart';
import 'package:restaukitchen_app/page/dimension_list/dimension_list.dart';
import 'package:restaukitchen_app/page/ingredients_list/ingredients_list.dart';
import 'package:restaukitchen_app/page/menusPage/bloc/menus_page_bloc.dart';
import 'package:restaukitchen_app/page/menusPage/bloc/delete_dish_cubit.dart';
import 'package:restaukitchen_app/page/menus_list/menus_list.dart';
import 'package:restaukitchen_app/page/settings_page/bloc/restaurant_info_cubit/restaurant_info_cubit.dart';
import 'package:restaukitchen_app/page/settings_page/components/business_profile_card.dart';
import 'package:restaukitchen_app/page/silverware_list/bloc/silverware_list_cubit/silverware_list_cubit.dart';
import 'package:restaukitchen_app/page/silverware_list/repository/silverware_repo.dart';
import 'package:restaukitchen_app/page/silverware_list/silverware_list.dart';
import 'package:restaukitchen_app/theme/light_theme.dart';

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

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            BusinessProfileCard(),
            const SizedBox(height: 16),
            const _CatalogueSection(),
            const SizedBox(height: 16),
            const _PersonalSettingsSection(),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

class _CatalogueSection extends StatelessWidget {
  const _CatalogueSection();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final items = [
      _CatalogueItem(
        title: l10n.commonMenus,
        subtitle: l10n.settingsMenusSubtitle,
        icon: Icons.restaurant_menu_rounded,
        onTap: (context) {
          Navigator.of(context).push(
            PageTransition(
              type: PageTransitionType.rightToLeft,
              child: MultiBlocProvider(
                providers: [BlocProvider(create: (context) => MenusPageBloc())],
                child: MenusList(),
              ),
            ),
          );
        },
      ),
      _CatalogueItem(
        title: l10n.commonCategories,
        subtitle: l10n.settingsCategoriesSubtitle,
        icon: Icons.category_rounded,
        onTap: (context) {
          Navigator.of(context).push(
            PageTransition(
              type: PageTransitionType.rightToLeft,
              child: BlocProvider(
                create: (context) => GetCategoryCubit(),
                child: const CategoriesList(),
              ),
            ),
          );
        },
      ),
      _CatalogueItem(
        title: l10n.commonIngredients,
        subtitle: l10n.settingsIngredientsSubtitle,
        icon: Icons.scatter_plot_rounded,
        onTap: (context) {
          Navigator.of(context).push(
            PageTransition(
              type: PageTransitionType.rightToLeft,
              child: MultiBlocProvider(
                providers: [
                  BlocProvider(create: (context) => GetIngredientsCubit()),
                  BlocProvider(
                    create: (context) =>
                        GetDimensionsCubit(dimensionsRepo: DimensionsRepo()),
                  ),
                ],
                child: IngredientsList(),
              ),
            ),
          );
        },
      ),
      _CatalogueItem(
        title: l10n.commonDimensions,
        subtitle: l10n.settingsDimensionsSubtitle,
        icon: Icons.straighten_rounded,
        onTap: (context) {
          Navigator.of(context).push(
            PageTransition(
              type: PageTransitionType.rightToLeft,
              child: MultiBlocProvider(
                providers: [
                  BlocProvider(
                    create: (context) =>
                        GetDimensionsCubit(dimensionsRepo: DimensionsRepo()),
                  ),
                ],
                child: const DimensionList(),
              ),
            ),
          );
        },
      ),
      // _CatalogueItem(
      //   title: l10n.commonSilverware,
      //   subtitle: "",
      //   icon: Icons.straighten_rounded,
      //   onTap: (context) {
      //     Navigator.of(context).push(
      //       PageTransition(
      //         type: PageTransitionType.rightToLeft,
      //         child: MultiBlocProvider(
      //           providers: [
      //             BlocProvider(
      //               create: (context) =>
      //                   SilverwareListCubit(silverwareRepo: SilverwareRepo()),
      //             ),
      //             BlocProvider(create: (context) => DeleteDishCubit()),
      //           ],
      //           child: const SilverwareList(),
      //         ),
      //       ),
      //     );
      //   },
      // ),
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.settingsCatalogue,
          style: Theme.of(context).textTheme.labelMedium?.copyWith(
            color: const Color(0xFF9CA3AF),
            letterSpacing: 1.2,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 18,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            children: [
              for (var i = 0; i < items.length; i++) ...[
                _CatalogueTile(item: items[i]),
                if (i != items.length - 1)
                  const Divider(height: 1, indent: 20, endIndent: 20),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _CatalogueTile extends StatelessWidget {
  const _CatalogueTile({required this.item});

  final _CatalogueItem item;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          item.onTap(context);
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: LightTheme.primaryColor.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(
                  item.icon,
                  color: LightTheme.primaryColor,
                  size: 22,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF1F2937),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      item.subtitle,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: const Color(0xFF9CA3AF),
                        fontSize: 12.5,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              const Icon(
                Icons.chevron_right_rounded,
                color: Color(0xFFC7CDD8),
                size: 24,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CatalogueItem {
  const _CatalogueItem({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final Function(BuildContext) onTap;
}

class _PersonalSettingsSection extends StatelessWidget {
  const _PersonalSettingsSection();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          context.l10n.settingsPersonalSettings,
          style: Theme.of(context).textTheme.labelMedium?.copyWith(
            color: const Color(0xFF9CA3AF),
            letterSpacing: 1.2,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 18,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            children: [
              const _LanguageSettingTile(),
              const Divider(height: 1, indent: 20, endIndent: 20),
              Padding(
                padding: const EdgeInsets.all(16),
                child: SizedBox(
                  width: double.infinity,
                  child: FilledButton.icon(
                    onPressed: () async {
                      await context.read<AuthCubit>().logout();
                    },
                    icon: const Icon(Icons.logout),
                    label: Text(context.l10n.settingsLogout),
                    style: FilledButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      backgroundColor: Colors.red.shade600,
                    ),
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

class _LanguageSettingTile extends StatelessWidget {
  const _LanguageSettingTile();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LanguageCubit, LanguageState>(
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: LightTheme.primaryColor.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(
                  Icons.language_rounded,
                  color: LightTheme.primaryColor,
                  size: 22,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      context.l10n.settingsSystemLanguage,
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        color: const Color(0xFF6B7280),
                        letterSpacing: 0.8,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      _languageLabel(state.locale.languageCode),
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF111827),
                      ),
                    ),
                  ],
                ),
              ),
              OutlinedButton(
                onPressed: () {
                  _showLanguagePicker(context, state.locale);
                },
                style: OutlinedButton.styleFrom(
                  foregroundColor: const Color(0xFF4F46E5),
                  side: const BorderSide(color: Color(0xFFD9DCEF)),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: Text(context.l10n.commonChange),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _showLanguagePicker(
    BuildContext context,
    Locale selected,
  ) async {
    final newLocale = await showModalBottomSheet<Locale>(
      context: context,
      showDragHandle: true,
      backgroundColor: Colors.white,
      builder: (context) {
        final locales = [
          const Locale('en'),
          const Locale('it'),
          const Locale('ar'),
        ];
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              for (final locale in locales)
                ListTile(
                  leading: Icon(
                    locale.languageCode == selected.languageCode
                        ? Icons.radio_button_checked_rounded
                        : Icons.radio_button_off_rounded,
                    color: locale.languageCode == selected.languageCode
                        ? LightTheme.primaryColor
                        : const Color(0xFF9CA3AF),
                  ),
                  title: Text(_languageLabel(locale.languageCode)),
                  onTap: () => Navigator.of(context).pop(locale),
                ),
            ],
          ),
        );
      },
    );

    if (newLocale != null && context.mounted) {
      context.read<LanguageCubit>().setLanguage(newLocale);
    }
  }

  String _languageLabel(String languageCode) {
    switch (languageCode) {
      case 'ar':
        return 'عربي';
      case 'it':
        return 'Italiano';
      default:
        return 'English';
    }
  }
}

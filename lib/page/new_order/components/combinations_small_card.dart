import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:page_transition/page_transition.dart';
import 'package:restaukitchen_app/page/combination_page/bloc/combination_get_cubit/combination_get_cubit.dart';
import 'package:restaukitchen_app/page/combination_page/models/menu_combination.dart';
import 'package:restaukitchen_app/page/combination_page/repository/combination_page_repo.dart';
import 'package:restaukitchen_app/page/new_order/bloc/new_order_form_bloc/new_order_form_bloc.dart';
import 'package:restaukitchen_app/page/new_order/bloc/new_order_form_bloc/new_order_from_events.dart';
import 'package:restaukitchen_app/page/order_combinations_form/dimensions_selection_page.dart';
import 'package:restaukitchen_app/page/order_list/models/course.dart';

class CombinationsSmallCard extends StatefulWidget {
  final MenuCombination combination;
  const CombinationsSmallCard({super.key, required this.combination});

  @override
  State<CombinationsSmallCard> createState() => _CombinationsSmallCardState();
}

class _CombinationsSmallCardState extends State<CombinationsSmallCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
      reverseDuration: const Duration(milliseconds: 100),
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _saveCombination(CombinationIndice combinationIndice) async {
    final courseIndex = context
        .read<NewOrderFormBloc>()
        .state
        .currentCourseIndex;
    context.read<NewOrderFormBloc>().add(
      AddDishIndice(courseIndice: combinationIndice, courseIndex: courseIndex),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) =>
          Transform.scale(scale: _scaleAnimation.value, child: child),
      child: Material(
        elevation: 2,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          onTap: () async {
            final result = await Navigator.of(context).push(
              PageTransition(
                type: PageTransitionType.rightToLeft,
                child: BlocProvider(
                  create: (context) => CombinationGetCubit(
                    combinationPageRepo: CombinationPageRepo(),
                  )..getCombination(widget.combination.id),
                  child: DimensionsSelectionPage(),
                ),
              ),
            );
            // final courseIndex = context
            //     .read<NewOrderFormBloc>()
            //     .state
            //     .currentCourseIndex;
            // context.read<NewOrderFormBloc>().add(
            //   AddDishIndice(dishIndice: result, courseIndex: courseIndex),
            // );
            if (result != null) {
              _saveCombination(result);
            }
          },
          borderRadius: BorderRadius.circular(12),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.combination.name,
                      style: textTheme.titleSmall,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              Positioned(
                top: -20,
                right: -20,
                child: IconButton(
                  onPressed: () {
                    PageTransition(
                      type: PageTransitionType.rightToLeft,
                      child: BlocProvider(
                        create: (context) => CombinationGetCubit(
                          combinationPageRepo: CombinationPageRepo(),
                        )..getCombination(widget.combination.id),
                        child: DimensionsSelectionPage(),
                      ),
                    );
                  },
                  icon: Icon(
                    Icons.add_circle,
                    color: colorScheme.primary,
                    size: 36,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

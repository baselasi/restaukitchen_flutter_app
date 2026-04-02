import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:page_transition/page_transition.dart';
import 'package:restaukitchen_app/core/bloc/get_dimensions_cubit.dart';
import 'package:restaukitchen_app/core/repository/dimensions_repo.dart';
import 'package:restaukitchen_app/page/combination_form/bloc/combination_dimension_creation_cubit/combination_dimension_creation_cubit.dart';
import 'package:restaukitchen_app/page/combination_form/bloc/combination_post_cubit/combination_post_cubit.dart';
import 'package:restaukitchen_app/page/combination_form/combination_dimension_creation_form.dart';
import 'package:restaukitchen_app/page/combination_form/repository/combination_form_repo.dart';

class CombinationList extends StatelessWidget {
  const CombinationList({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            PageTransition(
              type: PageTransitionType.rightToLeft,
              child: MultiBlocProvider(
                providers: [
                  BlocProvider(
                    create: (context) =>
                        GetDimensionsCubit(dimensionsRepo: DimensionsRepo()),
                  ),
                  BlocProvider(
                    create: (context) => CombinationDimensionCreationCubit(),
                  ),
                  BlocProvider(
                    create: (context) => CombinationPostCubit(
                      combinationFormRepo: CombinationFormRepo(),
                    ),
                  ),
                ],
                child: CombinationDimensionCreationForm(),
              ),
            ),
          );
        },
        child: Icon(Icons.add),
      ),
      body: Column(children: [Text('Combinations')]),
    );
  }
}

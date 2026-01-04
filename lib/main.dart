import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restaukitchen_app/core/bloc/auth_cubit.dart';
import 'package:restaukitchen_app/core/services/sevices_loactor.dart';
import 'package:restaukitchen_app/page/authentication/bloc/login_cubit.dart';
import 'package:restaukitchen_app/page/authentication/login_page.dart';
import 'package:restaukitchen_app/page/mainPage/bloc/main_page_cubit.dart';
import 'package:restaukitchen_app/page/mainPage/main_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Setup service locator
  await setupServiceLocator();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: MultiBlocProvider(
        providers: [
          BlocProvider<LoginCubit>(create: (context) => LoginCubit()),
          BlocProvider<AuthCubit>(create: (context) => AuthCubit()),
        ],
        child: MaterialApp(
          title: 'Flutter Demo',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          ),
          home: BlocConsumer<AuthCubit, AuthState>(
            builder: (context, state) {
              if (state.status == AuthStatus.unauthenticated) {
                return const LoginPage();
              }
              if (state.status == AuthStatus.authenticated) {
                return BlocProvider<MainPageCubit>(
                  create: (context) => MainPageCubit(),
                  child: const MainPage(),
                );
              }
              return const SizedBox.shrink();
            },
            listener: (context, state) {},
          ),
        ),
      ),
    );
  }
}

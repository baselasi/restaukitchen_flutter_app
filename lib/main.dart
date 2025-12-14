import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restaukitchen_app/core/bloc/auth_cubit.dart';
import 'package:restaukitchen_app/core/services/sevices_loactor.dart';
import 'package:restaukitchen_app/page/authentication/bloc/login_cubit.dart';
import 'package:restaukitchen_app/page/authentication/login_page.dart';

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
    return MultiBlocProvider(
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
              return const Text('Authenticated');
            }
            return const SizedBox.shrink();
          },
          listener: (context, state) {},
        ),
      ),
    );
  }
}

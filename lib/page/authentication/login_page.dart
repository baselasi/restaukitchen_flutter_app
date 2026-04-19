import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restaukitchen_app/core/bloc/auth_cubit.dart';
import 'package:restaukitchen_app/core/components/form/input_field.dart';
import 'package:restaukitchen_app/core/dialogs/snack_bar.dart';
import 'package:restaukitchen_app/page/authentication/bloc/login_cubit.dart';
import 'package:restaukitchen_app/theme/light_theme.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  String? _validateEmail(String? value) {
    if (value != null && value.isNotEmpty) {
      final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
      if (!emailRegex.hasMatch(value)) {
        return 'Please enter a valid email address';
      }
    }
    return null;
  }

  void _handleLogin(LoginCubit loginCubit) {
    if (_formKey.currentState!.validate()) {
      loginCubit.login(
        username: _emailController.text.trim(),
        password: _passwordController.text,
      );
    }
  }

  void _togglePasswordVisibility() {
    setState(() {
      _obscurePassword = !_obscurePassword;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final loginCubit = context.read<LoginCubit>();

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _formKey,
              child: BlocConsumer<LoginCubit, LoginState>(
                listener: (context, state) {
                  if (state.status == LoginStatus.loaded) {
                    context.read<AuthCubit>().login(state.accessToken ?? "");
                    AppSnackBar.showSuccess(context, 'Login successful!');
                  } else if (state.status == LoginStatus.error) {
                    AppSnackBar.showError(context, 'Bad credentials');
                  }
                },
                builder: (context, state) {
                  final isLoading = state.status == LoginStatus.isLoading;

                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Logo
                      Image.asset(
                        'assets/images/logo.png',
                        height: 120,
                        fit: BoxFit.contain,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Welcome Back',
                        style: theme.textTheme.headlineLarge,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Sign in to continue',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurface.withValues(
                            alpha: 0.6,
                          ),
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 48),
                      // Email Field
                      InputField(
                        controller: _emailController,
                        initialValue: 'ziadkhaled_822@hotmail.com',
                        label: 'Email',
                        hint: 'Enter your email',
                        prefixIcon: Icons.email_outlined,
                        isRequired: true,
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next,
                        validator: _validateEmail,
                        isDisabled: isLoading,
                      ),
                      const SizedBox(height: 16),
                      // Password Field
                      InputField(
                        controller: _passwordController,
                        initialValue: 'ziad',
                        label: 'Password',
                        hint: 'Enter your password',
                        prefixIcon: Icons.lock_outlined,
                        isRequired: true,
                        obscureText: _obscurePassword,
                        textInputAction: TextInputAction.done,
                        onSubmitted: isLoading
                            ? null
                            : (_) => _handleLogin(loginCubit),
                        isDisabled: isLoading,
                        suffixIconWidget: IconButton(
                          icon: Icon(
                            _obscurePassword
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined,
                          ),
                          onPressed: isLoading
                              ? null
                              : _togglePasswordVisibility,
                          color: theme.colorScheme.onSurface.withValues(
                            alpha: 0.6,
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      // Login Button
                      ElevatedButton(
                        onPressed: isLoading
                            ? null
                            : () => _handleLogin(loginCubit),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: LightTheme.primaryColor,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          disabledBackgroundColor: LightTheme.primaryColor
                              .withValues(alpha: 0.6),
                        ),
                        child: isLoading
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.white,
                                  ),
                                ),
                              )
                            : const Text(
                                'Login',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                      ),
                      const SizedBox(height: 16),
                      // Forgot Password
                      TextButton(
                        onPressed: isLoading
                            ? null
                            : () {
                                // Handle forgot password
                              },
                        style: TextButton.styleFrom(
                          foregroundColor: LightTheme.primaryColor,
                        ),
                        child: const Text('Forgot Password?'),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}

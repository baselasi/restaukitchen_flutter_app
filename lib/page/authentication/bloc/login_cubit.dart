import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:restaukitchen_app/page/authentication/repository/login_repo.dart';

// Status enum
enum LoginStatus { init, isLoading, loaded, error }

// Login State
class LoginState extends Equatable {
  final LoginStatus status;
  final String? accessToken;
  final String? errorMessage;

  const LoginState({required this.status, this.accessToken, this.errorMessage});

  // Initial state
  factory LoginState.initial() {
    return const LoginState(
      status: LoginStatus.init,
      accessToken: null,
      errorMessage: null,
    );
  }

  // Loading state
  factory LoginState.loading() {
    return const LoginState(
      status: LoginStatus.isLoading,
      accessToken: null,
      errorMessage: null,
    );
  }

  // Loaded state
  factory LoginState.loaded(String accessToken) {
    return LoginState(
      status: LoginStatus.loaded,
      accessToken: accessToken,
      errorMessage: null,
    );
  }

  // Error state
  factory LoginState.error(String errorMessage) {
    return LoginState(
      status: LoginStatus.error,
      accessToken: null,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, accessToken, errorMessage];
}

// Login Cubit
class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(LoginState.initial());

  /// Login method that takes username and password
  Future<void> login({
    required String username,
    required String password,
  }) async {
    // Emit loading state
    emit(LoginState.loading());

    try {
      // Call login repository
      final response = await LoginRepo().login(
        username: username,
        password: password,
      );

      // Extract access token from response
      // Adjust the key based on your API response structure
      final accessToken = response['access_token'];

      if (accessToken.isEmpty) {
        emit(LoginState.error('Access token not found in response'));
        return;
      }

      // Emit loaded state with access token
      emit(LoginState.loaded(accessToken));
    } catch (e) {
      // Emit error state
      emit(LoginState.error(e.toString()));
    }
  }

  /// Reset to initial state
  void reset() {
    emit(LoginState.initial());
  }
}

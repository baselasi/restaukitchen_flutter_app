import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:restaukitchen_app/core/models/user.dart';
import 'package:restaukitchen_app/core/services/sevices_loactor.dart';
import 'package:restaukitchen_app/core/services/user_service.dart';

// Auth Status enum
enum AuthStatus {
  unauthenticated,
  authenticated,
  noRestaurant,
}

// Auth State
class AuthState extends Equatable {
  final AuthStatus status;
  final User? user;

  const AuthState({
    required this.status,
    this.user,
  });

  // Unauthenticated state
  factory AuthState.unauthenticated() {
    return const AuthState(
      status: AuthStatus.unauthenticated,
      user: null,
    );
  }

  // Authenticated state
  factory AuthState.authenticated(User user) {
    return AuthState(
      status: AuthStatus.authenticated,
      user: user,
    );
  }

  // No restaurant state
  factory AuthState.noRestaurant(User user) {
    return AuthState(
      status: AuthStatus.noRestaurant,
      user: user,
    );
  }

  @override
  List<Object?> get props => [status, user];
}

// Auth Cubit
class AuthCubit extends Cubit<AuthState> {
  final UserService _userService;

  AuthCubit() : _userService = getIt<UserService>(), super(AuthState.unauthenticated()) {
    // Check auth status on initialization
    checkAuthStatus();
  }

  /// Check authentication status
  Future<void> checkAuthStatus() async {
    try {
      // Try to load user from saved token
      final user = await _userService.loadUserFromSavedToken();

      if (user == null) {
        // No user found, unauthenticated
        emit(AuthState.unauthenticated());
        return;
      }

      // Check if user has restaurant
      if (user.restaurant == null || user.restaurant!.isEmpty) {
        // User is authenticated but doesn't have a restaurant
        emit(AuthState.noRestaurant(user));
        return;
      }

      // User is authenticated and has restaurant
      emit(AuthState.authenticated(user));
    } catch (e) {
      // Error loading user, consider as unauthenticated
      emit(AuthState.unauthenticated());
    }
  }

  /// Login with token
  Future<void> login(String token) async {
    try {
      // Save token and create user
      await _userService.saveTokenAndUser(token);
      final user = _userService.user;

      if (user == null) {
        emit(AuthState.unauthenticated());
        return;
      }

      // Check if user has restaurant
      if (user.restaurant == null || user.restaurant!.isEmpty) {
        emit(AuthState.noRestaurant(user));
        return;
      }

      // User is authenticated and has restaurant
      emit(AuthState.authenticated(user));
    } catch (e) {
      emit(AuthState.unauthenticated());
    }
  }

  /// Logout
  Future<void> logout() async {
    await _userService.logout();
    emit(AuthState.unauthenticated());
  }

  /// Update user (e.g., after restaurant assignment)
  void updateUser(User user) {
    // Check if user has restaurant
    if (user.restaurant == null || user.restaurant!.isEmpty) {
      emit(AuthState.noRestaurant(user));
      return;
    }

    // User has restaurant
    emit(AuthState.authenticated(user));
  }
}


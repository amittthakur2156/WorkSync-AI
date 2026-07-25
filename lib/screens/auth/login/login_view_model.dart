import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/providers/auth_providers.dart';
import 'login_state.dart';

class LoginViewModel extends Notifier<LoginState> {
  @override
  LoginState build() {
    return LoginState.initial();
  }

  /// Email & Password Login
  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    state = state.copyWith(
      isLoading: true,
      clearUser: true,
      clearError: true,
    );

    try {
      final user = await ref.read(authUseCasesProvider).signIn(
        email: email,
        password: password,
      );

      state = state.copyWith(
        isLoading: false,
        user: user,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
      );
    }
  }

  /// Google Sign-In
  Future<void> signInWithGoogle() async {
    state = state.copyWith(
      isLoading: true,
      clearUser: true,
      clearError: true,
    );

    try {
      final user = await ref.read(authUseCasesProvider).signInWithGoogle();

      state = state.copyWith(
        isLoading: false,
        user: user,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
      );
    }
  }
}

final loginViewModelProvider =
NotifierProvider<LoginViewModel, LoginState>(
  LoginViewModel.new,
);
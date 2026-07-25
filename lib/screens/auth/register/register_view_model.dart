import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/providers/auth_providers.dart';
import 'register_state.dart';

class RegisterViewModel extends Notifier<RegisterState> {
  @override
  RegisterState build() {
    return RegisterState.initial();
  }

  Future<void> register({
    required String name,
    required String email,
    required String password,
  }) async {
    state = state.copyWith(
      isLoading: true,
      clearUser: true,
      clearError: true,
    );

    try {
      final user = await ref.read(authUseCasesProvider).register(
            name: name,
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

final registerViewModelProvider =
    NotifierProvider<RegisterViewModel, RegisterState>(
  RegisterViewModel.new,
);

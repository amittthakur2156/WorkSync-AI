import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/providers/auth_providers.dart';
import 'forgot_password_state.dart';

class ForgotPasswordViewModel extends Notifier<ForgotPasswordState> {
  @override
  ForgotPasswordState build() {
    return ForgotPasswordState.initial();
  }

  Future<void> sendPasswordResetEmail(String email) async {
    state = state.copyWith(
      isLoading: true,
      isSuccess: false,
      clearError: true,
    );

    try {
      await ref.read(authUseCasesProvider).sendPasswordResetEmail(email);

      state = state.copyWith(
        isLoading: false,
        isSuccess: true,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
      );
    }
  }
}

final forgotPasswordViewModelProvider =
    NotifierProvider<ForgotPasswordViewModel, ForgotPasswordState>(
  ForgotPasswordViewModel.new,
);

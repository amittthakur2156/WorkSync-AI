import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/providers/auth_providers.dart';
import 'change_password_state.dart';

class ChangePasswordViewModel extends Notifier<ChangePasswordState> {
  @override
  ChangePasswordState build() {
    return ChangePasswordState.initial();
  }

  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    state = state.copyWith(isLoading: true, clearError: true, isSuccess: false);

    try {
      await ref.read(authUseCasesProvider).changePassword(
            currentPassword: currentPassword,
            newPassword: newPassword,
          );
      state = state.copyWith(isLoading: false, isSuccess: true);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
      );
    }
  }

  Future<void> deleteAccount({required String password}) async {
    state = state.copyWith(isLoading: true, clearError: true, isDeleted: false);

    try {
      await ref.read(authUseCasesProvider).deleteAccount(password: password);
      state = state.copyWith(isLoading: false, isDeleted: true);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
      );
    }
  }
}

final changePasswordViewModelProvider =
    NotifierProvider<ChangePasswordViewModel, ChangePasswordState>(
  ChangePasswordViewModel.new,
);

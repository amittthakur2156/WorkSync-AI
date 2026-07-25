import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/providers/auth_providers.dart';
import 'edit_profile_state.dart';

class EditProfileViewModel extends Notifier<EditProfileState> {
  @override
  EditProfileState build() {
    return EditProfileState.initial();
  }

  Future<void> updateProfile({required String name}) async {
    if (name.length < 3) {
      state = state.copyWith(errorMessage: "Name must be at least 3 characters");
      return;
    }

    state = state.copyWith(isLoading: true, clearError: true, isSuccess: false);

    try {
      await ref.read(authUseCasesProvider).updateProfile(name: name);
      state = state.copyWith(isLoading: false, isSuccess: true);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
      );
    }
  }
}

final editProfileViewModelProvider =
    NotifierProvider<EditProfileViewModel, EditProfileState>(
  EditProfileViewModel.new,
);

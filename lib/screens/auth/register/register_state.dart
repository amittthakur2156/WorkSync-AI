import '../../../domain/entities/app_user_entity.dart';

class RegisterState {
  final bool isLoading;
  final AppUserEntity? user;
  final String? errorMessage;

  const RegisterState({
    this.isLoading = false,
    this.user,
    this.errorMessage,
  });

  RegisterState copyWith({
    bool? isLoading,
    AppUserEntity? user,
    String? errorMessage,
    bool clearUser = false,
    bool clearError = false,
  }) {
    return RegisterState(
      isLoading: isLoading ?? this.isLoading,
      user: clearUser ? null : (user ?? this.user),
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }

  factory RegisterState.initial() {
    return const RegisterState();
  }
}

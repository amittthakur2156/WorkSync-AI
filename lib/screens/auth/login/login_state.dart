import '../../../domain/entities/app_user_entity.dart';

class LoginState {
  final bool isLoading;
  final AppUserEntity? user;
  final String? errorMessage;

  const LoginState({
    this.isLoading = false,
    this.user,
    this.errorMessage,
  });

  LoginState copyWith({
    bool? isLoading,
    AppUserEntity? user,
    String? errorMessage,
    bool clearUser = false,
    bool clearError = false,
  }) {
    return LoginState(
      isLoading: isLoading ?? this.isLoading,
      user: clearUser ? null : (user ?? this.user),
      errorMessage: clearError
          ? null
          : (errorMessage ?? this.errorMessage),
    );
  }

  factory LoginState.initial() {
    return const LoginState();
  }
}
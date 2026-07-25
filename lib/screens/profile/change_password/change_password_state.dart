class ChangePasswordState {
  final bool isLoading;
  final bool isSuccess;
  final bool isDeleted;
  final String? errorMessage;

  const ChangePasswordState({
    this.isLoading = false,
    this.isSuccess = false,
    this.isDeleted = false,
    this.errorMessage,
  });

  ChangePasswordState copyWith({
    bool? isLoading,
    bool? isSuccess,
    bool? isDeleted,
    String? errorMessage,
    bool clearError = false,
  }) {
    return ChangePasswordState(
      isLoading: isLoading ?? this.isLoading,
      isSuccess: isSuccess ?? this.isSuccess,
      isDeleted: isDeleted ?? this.isDeleted,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }

  factory ChangePasswordState.initial() {
    return const ChangePasswordState();
  }
}

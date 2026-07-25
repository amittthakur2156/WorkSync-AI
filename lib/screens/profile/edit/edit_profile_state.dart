class EditProfileState {
  final bool isLoading;
  final bool isSuccess;
  final String? errorMessage;

  const EditProfileState({
    this.isLoading = false,
    this.isSuccess = false,
    this.errorMessage,
  });

  EditProfileState copyWith({
    bool? isLoading,
    bool? isSuccess,
    String? errorMessage,
    bool clearError = false,
  }) {
    return EditProfileState(
      isLoading: isLoading ?? this.isLoading,
      isSuccess: isSuccess ?? this.isSuccess,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }

  factory EditProfileState.initial() {
    return const EditProfileState();
  }
}

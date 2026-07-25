import '../../domain/entities/app_user_entity.dart';

class ProfileState {
  final bool isLoading;
  final AppUserEntity? user;
  final String? errorMessage;
  final double uploadProgress;
  final int projectsCount;
  final int tasksCount;
  final int teamCount;

  const ProfileState({
    this.isLoading = false,
    this.user,
    this.errorMessage,
    this.uploadProgress = 0,
    this.projectsCount = 0,
    this.tasksCount = 0,
    this.teamCount = 0,
  });

  ProfileState copyWith({
    bool? isLoading,
    AppUserEntity? user,
    String? errorMessage,
    double? uploadProgress,
    int? projectsCount,
    int? tasksCount,
    int? teamCount,
    bool clearError = false,
  }) {
    return ProfileState(
      isLoading: isLoading ?? this.isLoading,
      user: user ?? this.user,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      uploadProgress: uploadProgress ?? this.uploadProgress,
      projectsCount: projectsCount ?? this.projectsCount,
      tasksCount: tasksCount ?? this.tasksCount,
      teamCount: teamCount ?? this.teamCount,
    );
  }

  factory ProfileState.initial() {
    return const ProfileState();
  }
}

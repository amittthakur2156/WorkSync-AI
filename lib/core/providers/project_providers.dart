import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repositories/project_repository_impl.dart';
import '../../domain/entities/app_user_entity.dart';
import '../../domain/entities/project_entity.dart';
import '../../domain/repositories/project_repository.dart';
import '../../domain/usecases/project_usecases.dart';
import 'auth_providers.dart';

final projectRepositoryProvider = Provider<ProjectRepository>((ref) {
  return ProjectRepositoryImpl();
});

final projectUsecasesProvider = Provider<ProjectUsecases>((ref) {
  return ProjectUsecases(ref.watch(projectRepositoryProvider));
});

/// Live list of the signed-in user's projects.
final myProjectsProvider = StreamProvider<List<ProjectEntity>>((ref) {
  final authState = ref.watch(authStateProvider);

  return authState.maybeWhen(
    data: (user) {
      if (user == null) return const Stream.empty();
      return ref.watch(projectUsecasesProvider).watchProjects(user.uid);
    },
    orElse: () => const Stream.empty(),
  );
});

/// Single project by id.
final projectByIdProvider = FutureProvider.family<ProjectEntity?, String>((ref, projectId) {
  return ref.watch(projectUsecasesProvider).getProjectById(projectId);
});

/// Fetches real user entities for all project members.
final projectMembersProvider = FutureProvider.family<List<AppUserEntity>, List<String>>((ref, uids) async {
  final authUsecases = ref.watch(authUseCasesProvider);
  final futures = uids.map((uid) => authUsecases.getUserById(uid));
  final results = await Future.wait(futures);
  return results.whereType<AppUserEntity>().toList();
});

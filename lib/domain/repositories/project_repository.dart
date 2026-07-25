import '../entities/project_entity.dart';

abstract class ProjectRepository {
  Stream<List<ProjectEntity>> watchProjects(String ownerId);

  Future<ProjectEntity?> getProjectById(String projectId);

  Future<String> createProject(ProjectEntity project);

  Future<void> updateProject(ProjectEntity project);

  Future<void> deleteProject(String projectId);

  Future<void> updateProgress(String projectId, double progress);

  Future<void> addMemberToProject(String projectId, String userId);

  Future<void> removeMemberFromProject(String projectId, String userId);
}

import '../entities/project_entity.dart';
import '../repositories/project_repository.dart';

class ProjectUsecases {
  final ProjectRepository _repository;

  const ProjectUsecases(this._repository);

  Stream<List<ProjectEntity>> watchProjects(String ownerId) {
    return _repository.watchProjects(ownerId);
  }

  Future<ProjectEntity?> getProjectById(String projectId) {
    return _repository.getProjectById(projectId);
  }

  Future<String> createProject(ProjectEntity project) {
    if (project.title.trim().isEmpty) {
      throw ArgumentError('Project title cannot be empty');
    }
    return _repository.createProject(project);
  }

  Future<void> updateProject(ProjectEntity project) {
    return _repository.updateProject(project);
  }

  Future<void> deleteProject(String projectId) {
    return _repository.deleteProject(projectId);
  }

  Future<void> updateProgress(String projectId, double progress) {
    final clamped = progress.clamp(0.0, 1.0);
    return _repository.updateProgress(projectId, clamped);
  }

  Future<void> addMember(String projectId, String userId) {
    return _repository.addMemberToProject(projectId, userId);
  }

  Future<void> removeMember(String projectId, String userId) {
    return _repository.removeMemberFromProject(projectId, userId);
  }
}

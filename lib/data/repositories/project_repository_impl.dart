import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/project_entity.dart';
import '../../domain/repositories/project_repository.dart';
import '../models/project_model.dart';

class ProjectRepositoryImpl implements ProjectRepository {
  final FirebaseFirestore _firestore;

  ProjectRepositoryImpl({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get _projects => _firestore.collection('projects');

  @override
  Stream<List<ProjectEntity>> watchProjects(String ownerId) {
    return _projects
        .where('memberIds', arrayContains: ownerId)
        .snapshots()
        .map((snap) {
      final projects = snap.docs.map((d) => ProjectModel.fromMap(d.id, d.data())).toList();
      projects.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
      return projects;
    });
  }

  @override
  Future<ProjectEntity?> getProjectById(String projectId) async {
    final doc = await _projects.doc(projectId).get();
    if (!doc.exists) return null;
    return ProjectModel.fromMap(doc.id, doc.data()!);
  }

  @override
  Future<String> createProject(ProjectEntity project) async {
    final docRef = await _projects.add(ProjectModel.toMap(project));
    return docRef.id;
  }

  @override
  Future<void> updateProject(ProjectEntity project) {
    return _projects.doc(project.id).update(ProjectModel.toMap(project));
  }

  @override
  Future<void> deleteProject(String projectId) {
    return _projects.doc(projectId).delete();
  }

  @override
  Future<void> updateProgress(String projectId, double progress) {
    return _projects.doc(projectId).update({
      'progress': progress,
      'updatedAt': DateTime.now().toIso8601String(),
    });
  }

  @override
  Future<void> addMemberToProject(String projectId, String userId) {
    return _projects.doc(projectId).update({
      'memberIds': FieldValue.arrayUnion([userId]),
      'updatedAt': DateTime.now().toIso8601String(),
    });
  }

  @override
  Future<void> removeMemberFromProject(String projectId, String userId) {
    return _projects.doc(projectId).update({
      'memberIds': FieldValue.arrayRemove([userId]),
      'updatedAt': DateTime.now().toIso8601String(),
    });
  }
}

/// Shared enums used across domain entities, repositories, and UI.
/// Keep string values stable — they are persisted in Firestore directly.
enum TaskStatus {
  todo('todo'),
  inProgress('in_progress'),
  done('done');

  final String value;
  const TaskStatus(this.value);

  static TaskStatus fromValue(String value) => TaskStatus.values.firstWhere(
        (e) => e.value == value,
    orElse: () => TaskStatus.todo,
  );
}

enum TaskPriority {
  low('low'),
  medium('medium'),
  high('high');

  final String value;
  const TaskPriority(this.value);

  static TaskPriority fromValue(String value) => TaskPriority.values.firstWhere(
        (e) => e.value == value,
    orElse: () => TaskPriority.medium,
  );
}

enum ProjectStatus {
  active('active'),
  onHold('on_hold'),
  completed('completed'),
  archived('archived');

  final String value;
  const ProjectStatus(this.value);

  static ProjectStatus fromValue(String value) => ProjectStatus.values.firstWhere(
        (e) => e.value == value,
        orElse: () => ProjectStatus.active,
      );
}

enum NotificationType {
  task('task'),
  project('project'),
  meeting('meeting'),
  system('system'),
  comment('comment'),
  member('member'),
  invitation('invitation');

  final String value;
  const NotificationType(this.value);

  static NotificationType fromValue(String value) =>
      NotificationType.values.firstWhere(
        (e) => e.value == value,
        orElse: () => NotificationType.system,
      );
}
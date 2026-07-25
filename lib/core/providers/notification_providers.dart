import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repositories/notification_repository_impl.dart';
import '../../domain/entities/notification_entity.dart';
import '../../domain/repositories/notification_repository.dart';
import '../../domain/usecases/notification_usecases.dart';
import 'auth_providers.dart';

final notificationRepositoryProvider = Provider<NotificationRepository>((ref) {
  return NotificationRepositoryImpl();
});

final notificationUsecasesProvider = Provider<NotificationUsecases>((ref) {
  return NotificationUsecases(ref.watch(notificationRepositoryProvider));
});

final myNotificationsProvider = StreamProvider<List<NotificationEntity>>((ref) {
  final user = ref.watch(authStateProvider).value;
  if (user == null) return const Stream.empty();
  return ref.watch(notificationUsecasesProvider).watchNotifications(user.uid);
});

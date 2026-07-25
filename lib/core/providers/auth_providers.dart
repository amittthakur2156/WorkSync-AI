import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/repositories/auth_repository_impl.dart';
import '../../domain/entities/app_user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/usecases/auth_usecases.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepositoryImpl();
});

final authUseCasesProvider = Provider<AuthUsecases>((ref) {
  return AuthUsecases(ref.watch(authRepositoryProvider));
});

/// Live auth state — null when signed out. Used by the router redirect
/// and anywhere the UI needs to react to sign-in/sign-out in real time.
/// Optimized to return cached user immediately if available.
final authStateProvider = StreamProvider<AppUserEntity?>((ref) {
  return ref.watch(authUseCasesProvider).authStateChanges();
});

/// Listens to the current user's profile document in Firestore for real-time
/// updates to name, photo, etc.
final userProfileProvider = StreamProvider<AppUserEntity?>((ref) {
  final authState = ref.watch(authStateProvider).value;
  if (authState == null) return Stream.value(null);

  return ref.watch(authRepositoryProvider).authStateChanges();
});

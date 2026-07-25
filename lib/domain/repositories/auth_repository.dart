import '../entities/app_user_entity.dart';

abstract class AuthRepository {
  Stream<AppUserEntity?> authStateChanges();

  AppUserEntity? get currentUser;

  Future<AppUserEntity> signIn({
    required String email,
    required String password,
  });

  Future<AppUserEntity> signInWithGoogle();

  Future<AppUserEntity> register({
    required String name,
    required String email,
    required String password,
  });

  Future<void> sendPasswordResetEmail(String email);

  Future<void> updateProfile({required String name});

  Future<void> updateProfilePhoto(String photoUrl);

  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  });

  Future<void> deleteAccount({required String password});

  Future<AppUserEntity?> getUserById(String uid);

  Future<List<AppUserEntity>> searchUsersByEmail(String emailQuery);

  Future<void> signOut();
}

import '../entities/app_user_entity.dart';
import '../repositories/auth_repository.dart';

class AuthUsecases {
  final AuthRepository _repository;

  const AuthUsecases(this._repository);

  Stream<AppUserEntity?> authStateChanges() => _repository.authStateChanges();

  AppUserEntity? get currentUser => _repository.currentUser;
  Future<AppUserEntity> signInWithGoogle() {
    return _repository.signInWithGoogle();
  }

  Future<AppUserEntity> signIn(
      {required String email, required String password}) {
    if (!email.contains('@')) {
      throw ArgumentError('Enter a valid email address');
    }
    return _repository.signIn(email: email, password: password);
  }

  Future<AppUserEntity> register({
    required String name,
    required String email,
    required String password,
  }) {
    if (password.length < 6) {
      throw ArgumentError('Password must be at least 6 characters');
    }
    return _repository.register(name: name, email: email, password: password);
  }

  Future<void> sendPasswordResetEmail(String email) {
    return _repository.sendPasswordResetEmail(email);
  }

  Future<void> updateProfile({required String name}) {
    return _repository.updateProfile(name: name);
  }

  Future<void> updateProfilePhoto(String photoUrl) {
    return _repository.updateProfilePhoto(photoUrl);
  }

  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) {
    return _repository.changePassword(
      currentPassword: currentPassword,
      newPassword: newPassword,
    );
  }

  Future<void> deleteAccount({required String password}) {
    return _repository.deleteAccount(password: password);
  }

  Future<AppUserEntity?> getUserById(String uid) {
    return _repository.getUserById(uid);
  }

  Future<List<AppUserEntity>> searchUsersByEmail(String query) {
    return _repository.searchUsersByEmail(query);
  }

  Future<void> signOut() => _repository.signOut();
}

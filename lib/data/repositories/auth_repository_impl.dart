import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/app_user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../models/user_model.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthRepositoryImpl implements AuthRepository {
  final fb.FirebaseAuth _auth;
  final FirebaseFirestore _firestore;
  final GoogleSignIn _googleSignIn = GoogleSignIn.instance;

  bool _isGoogleSignInInitialized = false;

  Future<void> _ensureGoogleSignInInitialized() async {
    if (_isGoogleSignInInitialized) return;
    await _googleSignIn.initialize(
      serverClientId: '962325598546-q52j7gj9pmik7gcb8d85ihakgemat1fa.apps.googleusercontent.com',
    );
    _isGoogleSignInInitialized = true;
  }

  AuthRepositoryImpl({
    fb.FirebaseAuth? auth,
    FirebaseFirestore? firestore,
  })  : _auth = auth ?? fb.FirebaseAuth.instance,
        _firestore = firestore ?? FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get _users => _firestore.collection('users');

  @override
  Stream<AppUserEntity?> authStateChanges() {
    return _auth.authStateChanges().asyncExpand((fbUser) async* {
      if (fbUser == null) {
        yield null;
        return;
      }
      yield AppUserEntity(
        uid: fbUser.uid,
        name: fbUser.displayName ?? '',
        email: fbUser.email ?? '',
        photoUrl: fbUser.photoURL,
        createdAt: fbUser.metadata.creationTime ?? DateTime.now(),
      );
      yield* _users.doc(fbUser.uid).snapshots().map((doc) {
        if (doc.exists) {
          return UserModel.fromMap(doc.id, doc.data()!);
        }
        return AppUserEntity(
          uid: fbUser.uid,
          name: fbUser.displayName ?? '',
          email: fbUser.email ?? '',
          photoUrl: fbUser.photoURL,
          createdAt: fbUser.metadata.creationTime ?? DateTime.now(),
        );
      });
    });
  }

  @override
  AppUserEntity? get currentUser {
    final fbUser = _auth.currentUser;
    if (fbUser == null) return null;
    return AppUserEntity(
      uid: fbUser.uid,
      name: fbUser.displayName ?? '',
      email: fbUser.email ?? '',
      photoUrl: fbUser.photoURL,
      createdAt: fbUser.metadata.creationTime ?? DateTime.now(),
    );
  }

  @override
  Future<AppUserEntity> signIn({required String email, required String password}) async {
    try {
      final cred = await _auth.signInWithEmailAndPassword(email: email, password: password);
      return _fetchOrCreateProfile(cred.user!);
    } on fb.FirebaseAuthException catch (e) {
      throw AuthFailure(_mapAuthError(e));
    }
  }

  @override
  Future<AppUserEntity> register({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final cred = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      final fbUser = cred.user!;
      await fbUser.updateDisplayName(name);

      final entity = AppUserEntity(
        uid: fbUser.uid,
        name: name,
        email: email,
        createdAt: DateTime.now(),
      );
      await _users.doc(fbUser.uid).set(UserModel.toMap(entity));
      return entity;
    } on fb.FirebaseAuthException catch (e) {
      throw AuthFailure(_mapAuthError(e));
    }
  }

  @override
  Future<AppUserEntity> signInWithGoogle() async {
    try {
      await _ensureGoogleSignInInitialized();
      await _googleSignIn.signOut();
      final GoogleSignInAccount googleUser = await _googleSignIn.authenticate();
      final GoogleSignInAuthentication googleAuth = googleUser.authentication;
      final credential = fb.GoogleAuthProvider.credential(idToken: googleAuth.idToken);
      final result = await _auth.signInWithCredential(credential);
      if (result.user == null) throw const AuthFailure("Firebase Sign-In failed");
      return _fetchOrCreateProfile(result.user!);
    } on fb.FirebaseAuthException catch (e) {
      throw AuthFailure(_mapAuthError(e));
    } on GoogleSignInException catch (e) {
      throw AuthFailure("Google Error: ${e.description ?? e.code}");
    } catch (e) {
      if (e is AuthFailure) rethrow;
      throw AuthFailure(e.toString());
    }
  }

  @override
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on fb.FirebaseAuthException catch (e) {
      throw AuthFailure(_mapAuthError(e));
    }
  }

  @override
  Future<void> updateProfile({required String name}) async {
    try {
      final user = _auth.currentUser;
      if (user == null) throw const AuthFailure("User not authenticated");
      await user.updateDisplayName(name);
      await _users.doc(user.uid).update({'name': name});
    } on fb.FirebaseAuthException catch (e) {
      throw AuthFailure(_mapAuthError(e));
    } catch (e) {
      throw AuthFailure(e.toString());
    }
  }

  @override
  Future<void> updateProfilePhoto(String photoUrl) async {
    try {
      final user = _auth.currentUser;
      if (user == null) throw const AuthFailure("User not authenticated");
      await user.updatePhotoURL(photoUrl);
      await _users.doc(user.uid).update({'photoUrl': photoUrl});
    } on fb.FirebaseAuthException catch (e) {
      throw AuthFailure(_mapAuthError(e));
    } catch (e) {
      throw AuthFailure(e.toString());
    }
  }

  @override
  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    try {
      final user = _auth.currentUser;
      if (user == null) throw const AuthFailure("User not authenticated");
      final cred = fb.EmailAuthProvider.credential(email: user.email!, password: currentPassword);
      await user.reauthenticateWithCredential(cred);
      await user.updatePassword(newPassword);
    } on fb.FirebaseAuthException catch (e) {
      throw AuthFailure(_mapAuthError(e));
    } catch (e) {
      throw AuthFailure(e.toString());
    }
  }

  @override
  Future<void> deleteAccount({required String password}) async {
    try {
      final user = _auth.currentUser;
      if (user == null) throw const AuthFailure("User not authenticated");
      final cred = fb.EmailAuthProvider.credential(email: user.email!, password: password);
      await user.reauthenticateWithCredential(cred);
      final uid = user.uid;
      await _users.doc(uid).delete();
      await user.delete();
    } on fb.FirebaseAuthException catch (e) {
      throw AuthFailure(_mapAuthError(e));
    } catch (e) {
      throw AuthFailure(e.toString());
    }
  }

  @override
  Future<AppUserEntity?> getUserById(String uid) async {
    try {
      final doc = await _users.doc(uid).get();
      if (!doc.exists) return null;
      return UserModel.fromMap(doc.id, doc.data()!);
    } catch (e) {
      throw AuthFailure("Failed to get user: $e");
    }
  }

  @override
  Future<List<AppUserEntity>> searchUsersByEmail(String emailQuery) async {
    try {
      final query = emailQuery.trim().toLowerCase();
      if (query.isEmpty) return [];

      // Use string range for prefix matching in Firestore
      final result = await _users
          .where('email', isGreaterThanOrEqualTo: query)
          .where('email', isLessThan: '$query\uf8ff')
          .limit(5)
          .get();

      return result.docs
          .map((doc) => UserModel.fromMap(doc.id, doc.data()))
          .toList();
    } catch (e) {
      throw AuthFailure("Failed to search users: $e");
    }
  }

  @override
  Future<void> signOut() async {
    await _googleSignIn.signOut();
    await _auth.signOut();
  }

  Future<AppUserEntity> _fetchOrCreateProfile(fb.User fbUser) async {
    final doc = await _users.doc(fbUser.uid).get();
    if (doc.exists) {
      final data = doc.data()!;
      final String currentName = data['name'] as String? ?? '';
      final String currentPhoto = data['photoUrl'] as String? ?? '';
      final String newName = (currentName.isEmpty && fbUser.displayName != null) ? fbUser.displayName! : currentName;
      final String newPhoto = (currentPhoto.isEmpty && fbUser.photoURL != null) ? fbUser.photoURL! : currentPhoto;
      if (newName != currentName || newPhoto != currentPhoto) {
        await _users.doc(fbUser.uid).update({'name': newName, 'photoUrl': newPhoto});
      }
      return UserModel.fromMap(fbUser.uid, {...data, 'name': newName, 'photoUrl': newPhoto});
    }
    final entity = AppUserEntity(
      uid: fbUser.uid,
      name: fbUser.displayName ?? '',
      email: fbUser.email ?? '',
      photoUrl: fbUser.photoURL,
      createdAt: DateTime.now(),
    );
    await _users.doc(fbUser.uid).set(UserModel.toMap(entity));
    return entity;
  }

  String _mapAuthError(fb.FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
      case 'wrong-password':
      case 'invalid-credential':
        return 'Incorrect email or password';
      case 'email-already-in-use':
        return 'An account already exists with this email';
      case 'weak-password':
        return 'Password is too weak';
      case 'invalid-email':
        return 'Enter a valid email address';
      case 'too-many-requests':
        return 'Too many attempts. Try again later';
      default:
        return e.message ?? 'Something went wrong. Please try again';
    }
  }
}

class AuthFailure implements Exception {
  final String message;
  const AuthFailure(this.message);
  @override
  String toString() => message;
}

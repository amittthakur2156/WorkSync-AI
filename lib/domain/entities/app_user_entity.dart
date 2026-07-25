import 'package:flutter/foundation.dart';

/// Pure business object for the signed-in user.
/// Named AppUser (not User) to avoid clashing with firebase_auth's User.
@immutable
class AppUserEntity {
  final String uid;
  final String name;
  final String email;
  final String? photoUrl;
  final String? fcmToken;
  final DateTime createdAt;

  const AppUserEntity({
    required this.uid,
    required this.name,
    required this.email,
    required this.createdAt,
    this.photoUrl,
    this.fcmToken,
  });

  AppUserEntity copyWith({
    String? name,
    String? photoUrl,
    String? fcmToken,
  }) {
    return AppUserEntity(
      uid: uid,
      name: name ?? this.name,
      email: email,
      createdAt: createdAt,
      photoUrl: photoUrl ?? this.photoUrl,
      fcmToken: fcmToken ?? this.fcmToken,
    );
  }
}
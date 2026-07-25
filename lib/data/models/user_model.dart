import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/app_user_entity.dart';

/// Firestore-facing DTO. Converts between Firestore's `Map<String, dynamic>`
/// and the pure AppUserEntity used by the rest of the app.
class UserModel {
  static AppUserEntity fromMap(String uid, Map<String, dynamic> map) {
    return AppUserEntity(
      uid: uid,
      name: map['name'] as String? ?? '',
      email: map['email'] as String? ?? '',
      photoUrl: map['photoUrl'] as String?,
      fcmToken: map['fcmToken'] as String?,
      createdAt: _parseDateTime(map['createdAt']),
    );
  }

  static Map<String, dynamic> toMap(AppUserEntity entity) {
    return {
      'name': entity.name,
      'email': entity.email,
      'photoUrl': entity.photoUrl,
      'fcmToken': entity.fcmToken,
      'createdAt': entity.createdAt.toIso8601String(),
    };
  }

  static DateTime _parseDateTime(dynamic value) {
    if (value is Timestamp) {
      return value.toDate();
    } else if (value is String) {
      return DateTime.tryParse(value) ?? DateTime.now();
    }
    return DateTime.now();
  }
}

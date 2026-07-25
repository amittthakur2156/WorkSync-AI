import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:worksync_ai/core/providers/auth_providers.dart';
import 'package:worksync_ai/domain/repositories/auth_repository.dart';
import 'package:worksync_ai/screens/auth/login/login_screen.dart';
import 'package:worksync_ai/domain/entities/app_user_entity.dart';

// Simple mock for testing without Firebase
class MockAuthRepository implements AuthRepository {
  @override
  AppUserEntity? get currentUser => null;

  @override
  Stream<AppUserEntity?> authStateChanges() => Stream.value(null);

  @override
  Future<AppUserEntity> signIn({required String email, required String password}) async {
    throw UnimplementedError();
  }

  @override
  Future<AppUserEntity> signInWithGoogle() async {
    throw UnimplementedError();
  }

  @override
  Future<AppUserEntity> register({required String name, required String email, required String password}) async {
    throw UnimplementedError();
  }

  @override
  Future<void> sendPasswordResetEmail(String email) async {}

  @override
  Future<void> updateProfile({required String name}) async {}

  @override
  Future<void> updateProfilePhoto(String photoUrl) async {}

  @override
  Future<void> changePassword({required String currentPassword, required String newPassword}) async {}

  @override
  Future<void> deleteAccount({required String password}) async {}

  @override
  Future<AppUserEntity?> getUserById(String uid) async => null;

  @override
  Future<List<AppUserEntity>> searchUsersByEmail(String emailQuery) async => [];

  @override
  Future<void> signOut() async {}
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('LoginScreen initial render', (WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          authRepositoryProvider.overrideWithValue(MockAuthRepository()),
        ],
        child: const MaterialApp(
          home: LoginScreen(),
        ),
      ),
    );

    expect(find.text('Welcome Back'), findsOneWidget);
    expect(find.text('Email'), findsOneWidget);
    expect(find.text('Password'), findsOneWidget);
    expect(find.text('Login'), findsOneWidget);
  });

  testWidgets('LoginScreen validation error on empty fields', (WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          authRepositoryProvider.overrideWithValue(MockAuthRepository()),
        ],
        child: const MaterialApp(
          home: LoginScreen(),
        ),
      ),
    );

    // Tap login button without entering data
    await tester.tap(find.text('Login'));
    await tester.pumpAndSettle();

    expect(find.text('Email is required'), findsOneWidget);
    expect(find.text('Password is required'), findsOneWidget);
  });

  testWidgets('Email and password text entry works', (WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          authRepositoryProvider.overrideWithValue(MockAuthRepository()),
        ],
        child: const MaterialApp(
          home: LoginScreen(),
        ),
      ),
    );

    final emailField = find.widgetWithText(TextFormField, 'Email');
    await tester.enterText(emailField, 'user@example.com');
    await tester.pump();
    expect(find.text('user@example.com'), findsOneWidget);

    final passwordField = find.widgetWithText(TextFormField, 'Password');
    await tester.enterText(passwordField, 'mypassword');
    await tester.pump();
    expect(find.text('mypassword'), findsOneWidget);
  });
}

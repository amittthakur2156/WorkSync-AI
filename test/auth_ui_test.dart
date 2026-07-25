import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:worksync_ai/core/providers/auth_providers.dart';
import 'package:worksync_ai/screens/auth/register/register_screen.dart';
import 'package:worksync_ai/screens/auth/forgot_password/forgot_password_screen.dart';
import 'widget_test.dart'; // To reuse MockAuthRepository

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('RegisterScreen rendering and validation', (WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          authRepositoryProvider.overrideWithValue(MockAuthRepository()),
        ],
        child: const MaterialApp(
          home: RegisterScreen(),
        ),
      ),
    );

    expect(find.text('Create Account'), findsWidgets);
    expect(find.text('Full Name'), findsOneWidget);
    expect(find.text('Email'), findsOneWidget);

    // Trigger validation
    await tester.tap(find.text('Create Account').last);
    await tester.pumpAndSettle();

    expect(find.text('Full name is required'), findsOneWidget);
    expect(find.text('Email is required'), findsOneWidget);
    expect(find.text('Password is required'), findsOneWidget);
  });

  testWidgets('ForgotPasswordScreen rendering', (WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          authRepositoryProvider.overrideWithValue(MockAuthRepository()),
        ],
        child: const MaterialApp(
          home: ForgotPasswordScreen(),
        ),
      ),
    );

    expect(find.text('Reset Your Password'), findsOneWidget);
    expect(find.text('Send Reset Link'), findsOneWidget);

    final emailField = find.widgetWithText(TextFormField, 'Email');
    await tester.enterText(emailField, 'reset@example.com');
    await tester.pump();
    expect(find.text('reset@example.com'), findsOneWidget);
  });
}

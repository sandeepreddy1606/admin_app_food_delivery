// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:foodie_admin_panel/main.dart';

void main() {
  testWidgets('Admin panel smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp()); // CHANGED: FoodieAdminApp → MyApp

    // Since your app starts with login page, test for login page elements
    expect(find.text('Admin Login'), findsOneWidget);
    expect(find.text('Login as Admin'), findsOneWidget);
    
    // Verify login form elements exist
    expect(find.byType(TextFormField), findsNWidgets(2)); // Email and Password fields
    expect(find.text('Login'), findsOneWidget);
  });

  testWidgets('Navigation to register test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp()); // CHANGED: FoodieAdminApp → MyApp

    // Tap on the register navigation link
    await tester.tap(find.text('Don\'t have an account? Register'));
    await tester.pumpAndSettle(); // Wait for navigation to complete

    // Verify that we're now on the Registration page
    expect(find.text('Admin Registration'), findsOneWidget);
    expect(find.text('Register Admin'), findsOneWidget);
  });
}

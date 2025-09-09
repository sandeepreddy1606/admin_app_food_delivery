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
    await tester.pumpWidget(const FoodieAdminApp());

    // Verify that our admin panel loads correctly
    expect(find.text('Foodie Admin'), findsOneWidget);
    expect(find.text('Dashboard'), findsOneWidget);
    expect(find.text('Welcome back, Admin!'), findsOneWidget);
    
    // Verify navigation items exist
    expect(find.text('Restaurants'), findsOneWidget);
    expect(find.text('Menu Items'), findsOneWidget);
    expect(find.text('Orders'), findsOneWidget);
    expect(find.text('Analytics'), findsOneWidget);
  });

  testWidgets('Navigation test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const FoodieAdminApp());

    // Tap on the Restaurants navigation item
    await tester.tap(find.text('Restaurants'));
    await tester.pump();

    // Verify that we're now on the Restaurant Management page
    expect(find.text('Restaurant Management'), findsOneWidget);
  });
}

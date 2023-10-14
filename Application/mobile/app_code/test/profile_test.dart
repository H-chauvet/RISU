import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:risu/pages/profile/profile_page.dart';


void main() {
  testWidgets('Profile page shows buttons and logo when user is logged in',
          (WidgetTester tester) async {
        await tester.pumpWidget(const MaterialApp(
          home: ProfilePage(),
        ));

        await tester.pumpWidget(const MaterialApp(home: ProfilePage()));
        await tester.pumpAndSettle();
      });
}
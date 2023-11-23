import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:front/components/custom_app_bar.dart';
import 'package:front/screens/admin/admin.dart';
import 'package:front/services/storage_service.dart';
import 'package:front/app_routes.dart';

void main() {
  testWidgets('correct data', (WidgetTester tester) async {
    token = "token";
    userMail = "risu.admin@gmail.com";

    await tester.binding.setSurfaceSize(const Size(1920, 1080));
    await tester.pumpWidget(const MaterialApp(home: AdminPage()));

    await tester.pump();

    expect(find.byType(AdminPage), findsOneWidget);

    // Check the presence of certain widgets
    expect(find.text('Administration'), findsOneWidget);
    expect(find.byType(CustomAppBar), findsOneWidget);
        
    // Assuming there are 3 buttons for managing messages, users, and articles
    expect(find.widgetWithText(ElevatedButton, 'Gestion des messages'), findsOneWidget);
    expect(find.widgetWithText(ElevatedButton, 'Gestion des utilisateurs'), findsOneWidget);
    expect(find.widgetWithText(ElevatedButton, 'Gestion des articles'), findsOneWidget);
    
    expect(find.byKey(const Key('btn-messages')), findsOneWidget);
    expect(find.byKey(const Key('btn-user')), findsOneWidget);
    expect(find.byKey(const Key('btn-article')), findsOneWidget);

    await tester.binding.setSurfaceSize(null);
  });
}

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:front/components/custom_app_bar.dart';
import 'package:front/screens/admin/admin.dart';
import 'package:front/services/storage_service.dart';

void main() {
  testWidgets('correct data', (WidgetTester tester) async {
    // tester.binding.window.physicalSizeTestValue = const Size(5000, 5000);
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
    
    await tester.tap(find.byKey(const Key('btn-messages')));
    await tester.tap(find.byKey(const Key('btn-user')));
    await tester.tap(find.byKey(const Key('btn-article')));

    await tester.binding.setSurfaceSize(null);
  });
}

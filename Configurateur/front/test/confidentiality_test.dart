import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:front/app_routes.dart';
import 'package:front/screens/confidentiality/confidentiality.dart';
import 'package:front/services/theme_service.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

void main() {
  testWidgets('ConfidentialityPage widget test', (WidgetTester tester) async {
    await tester.pumpWidget(
      MultiProvider(
          providers: [
            ChangeNotifierProvider<ThemeService>(
              create: (_) => ThemeService(),
            ),
          ],
          child: MaterialApp(
            home: InheritedGoRouter(
              goRouter: AppRouter.router,
              child: const ConfidentialityPage(),
            ),
          )),
    );

    await tester.pump();
    expect(find.text('Dernière mise à jour : 14 Octobre 2023\n\n'),
        findsOneWidget);
    expect(find.text('Informations que nous collectons'), findsOneWidget);
    expect(
        find.text('Comment nous utilisons vos informations'), findsOneWidget);
  });
}

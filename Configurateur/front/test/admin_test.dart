import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:front/components/custom_app_bar.dart';
import 'package:front/screens/admin/admin.dart';
import 'package:front/services/storage_service.dart';
import 'package:front/app_routes.dart';
import 'package:front/services/theme_service.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

void main() {
  testWidgets('correct data', (WidgetTester tester) async {
    await tester.binding.setSurfaceSize(const Size(1920, 1080));
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider<ThemeService>(
            create: (_) => ThemeService(),
          ),
        ],
        child: Sizer(
          builder: (context, orientation, deviceType) {
            return MaterialApp(
              home: InheritedGoRouter(
                goRouter: AppRouter.router,
                child: const AdminPage(),
              ),
            );
          },
        ),
      ),
    );

    await tester.pump();

    expect(find.byType(AdminPage), findsOneWidget);

    // Check the presence of certain widgets
    expect(find.text('Administration de RISU'), findsOneWidget);

    // Assuming there are 3 buttons for managing messages, users, and articles
    expect(find.widgetWithText(ElevatedButton, 'Gestion des messages'),
        findsOneWidget);
    expect(find.widgetWithText(ElevatedButton, 'Gestion des utilisateurs'),
        findsOneWidget);
    expect(find.widgetWithText(ElevatedButton, 'Gestion des conteneurs'),
        findsOneWidget);

    expect(find.byKey(const Key('btn-messages')), findsOneWidget);
    expect(find.byKey(const Key('btn-user')), findsOneWidget);
    expect(find.byKey(const Key('btn-article')), findsOneWidget);

    await tester.binding.setSurfaceSize(null);
  });
}

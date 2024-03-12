import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:front/app_routes.dart';
import 'package:front/components/dialog/save_dialog.dart';
import 'package:front/services/theme_service.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

void main() {
  testWidgets('test unfilled form', (WidgetTester tester) async {
    await tester.binding.setSurfaceSize(const Size(1920, 1080));

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
            child: SaveDialog(
              name: 'test',
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.text('Sauvegarder'));

    await tester.pump();

    expect(find.text('test'), findsOneWidget);
    expect(find.text('Sauvegarde'), findsWidgets);
    expect(find.text('Voulez-vous donner un nom à votre sauvegarde ?'),
        findsWidgets);
  });
}

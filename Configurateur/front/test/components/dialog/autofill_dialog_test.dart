import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:front/app_routes.dart';
import 'package:front/components/dialog/autofill_dialog.dart';
import 'package:front/services/theme_service.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

void main() {
  void blankFunction(String string, bool unitTesting) {}

  testWidgets('test invalid position form', (WidgetTester tester) async {
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
              theme: ThemeData(fontFamily: 'Roboto'),
              home: InheritedGoRouter(
                goRouter: AppRouter.router,
                child: AutoFillDialog(
                  callback: blankFunction,
                ),
              ),
            );
          },
        ),
      ),
    );

    expect(
        find.text(
            'Quelle(s) face(s) du conteneur voulez-vous ranger automatiquement ?'),
        findsOneWidget);
    expect(find.text('Trier'), findsOneWidget);
    expect(find.text('Face du conteneur'), findsNWidgets(2));
    await tester.tap(find.byKey(const Key('face')));

    await tester.pump();

    await tester.tap(find.text('Devant').last);

    await tester.pump();

    await tester.tap(find.text('Trier'));
  });
}

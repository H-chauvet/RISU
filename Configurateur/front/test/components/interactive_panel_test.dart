import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:front/app_routes.dart';
import 'package:front/components/interactive_panel.dart';
import 'package:front/services/locker_service.dart';
import 'package:front/services/theme_service.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

void main() {
  void blankFunction(LockerCoordinates coordinates, bool unitTesting) {}
  void blankRotateFunction() {}

  testWidgets('test interactive panel', (WidgetTester tester) async {
    await tester.binding.setSurfaceSize(const Size(1920, 1080));

    await tester.pumpWidget(MultiProvider(
      providers: [
        ChangeNotifierProvider<ThemeService>(
          create: (_) => ThemeService(),
        ),
      ],
      child: MaterialApp(
        home: InheritedGoRouter(
          goRouter: AppRouter.router,
          child: InteractivePanel(
            callback: blankFunction,
            rotateBackCallback: blankRotateFunction,
            rotateFrontCallback: blankRotateFunction,
            rotateRightCallback: blankRotateFunction,
            rotateLeftCallback: blankRotateFunction,
            width: 12,
            height: 5,
          ),
        ),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        locale: const Locale('fr'),
      ),
    ));

    expect(find.image(const AssetImage("assets/cube.png")), findsWidgets);
  });
}

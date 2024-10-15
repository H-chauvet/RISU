// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:front/app_routes.dart';
import 'package:front/components/custom_footer.dart';
import 'package:front/screens/register-confirmation/confirmed_user.dart';
import 'package:front/services/storage_service.dart';
import 'package:front/services/theme_service.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

void main() {
  // Widget createWidgetForTesting({required Widget child}) {
  //   return MaterialApp(
  //     home: child,
  //     localizationsDelegates: AppLocalizations.localizationsDelegates,
  //     supportedLocales: AppLocalizations.supportedLocales,
  //     locale: const Locale('fr'),
  //   );
  // }

  // setUp(() async {
  //   final roboto = rootBundle.load('assets/roboto/Roboto-Medium.ttf');
  //   final fontLoader = FontLoader('Roboto')..addFont(roboto);
  //   await fontLoader.load();
  // });

  // testWidgets('Confirmed user screen', (WidgetTester tester) async {
  //   TestWidgetsFlutterBinding.ensureInitialized();

  //   SharedPreferences.setMockInitialValues({});

  //   storageService.writeStorage('token', 'test-token');
  //   await tester.binding.setSurfaceSize(const Size(6000, 5000));


  //   await tester.pumpWidget(
  //     MultiProvider(
  //       providers: [
  //         ChangeNotifierProvider<ThemeService>(
  //           create: (_) => ThemeService(),
  //         ),
  //       ],
  //       child: Sizer(
  //         builder: (context, orientation, deviceType) {
  //           return MaterialApp(
  //             theme: ThemeData(fontFamily: 'Roboto'),
  //             home: InheritedGoRouter(
  //               goRouter: AppRouter.router,
  //               child: createWidgetForTesting(
  //                 child: const ConfirmedUser(params: 'uuid'),
  //               ),
  //             ),
  //           );
  //         },
  //       ),
  //     ),
  //   );

  //   await tester.pumpAndSettle(const Duration(seconds: 2));

  //   await tester.pumpAndSettle();
  // });

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() async {
    final roboto = rootBundle.load('assets/roboto/Roboto-Medium.ttf');
    final fontLoader = FontLoader('Roboto')..addFont(roboto);
    await fontLoader.load();
  });

  testWidgets('Register screen', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    tester.binding.window.physicalSizeTestValue = const Size(5000, 5000);
    tester.binding.window.devicePixelRatioTestValue = 1.0;

    TestWidgetsFlutterBinding.ensureInitialized();

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
                child: const ConfirmedUser(params: 'uuid'),
              ),
              localizationsDelegates: AppLocalizations.localizationsDelegates,
              supportedLocales: AppLocalizations.supportedLocales,
              locale: const Locale('fr'),
            );
          },
        ),
      ),
    );

    await tester.pumpAndSettle(const Duration(seconds: 2));
    expect(find.byType(CustomFooter), findsOneWidget);

    expect(
        find.text(
            'Votre inscription a bien été confirmée, vous pouvez maintenant vous connecter et profiter de notre application'),
        findsOneWidget);

    await tester.tap(find.byKey(const Key('go-home')));
    await tester.pumpAndSettle();
  });
}

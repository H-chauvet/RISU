import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:front/components/tickets_page.dart';
import 'package:front/screens/messages/messages.dart';
import 'package:front/services/theme_service.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:front/app_routes.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late MockSharedPreferences sharedPreferences;

  setUp(() async {
    sharedPreferences = MockSharedPreferences();
    final roboto = rootBundle.load('assets/roboto/Roboto-Medium.ttf');
    final fontLoader = FontLoader('Roboto')..addFont(roboto);
    await fontLoader.load();
  });

  testWidgets('MessagePage should display correctly for admin',
      (WidgetTester tester) async {
    when(sharedPreferences.getString('token')).thenReturn('test-token');
    when(sharedPreferences.getString('tokenExpiration')).thenReturn(
        DateTime.now().add(const Duration(minutes: 30)).toIso8601String());

    await tester.binding.setSurfaceSize(const Size(5000, 5000));

    // Define the widget with providers and Sizer
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
                child: const MessagePage(),
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

    await tester.tap(find.byTooltip('Authentification'));
    await tester.pumpAndSettle();
    expect(find.text("Connexion"), findsOneWidget);
    expect(find.text("Inscription"), findsOneWidget);

    expect(find.byType(TicketsPage), findsOneWidget);
    expect(
        find.byWidgetPredicate(
            (widget) => widget is TicketsPage && widget.isAdmin == true),
        findsOneWidget);
  });
}

class MockSharedPreferences extends Mock implements SharedPreferences {}

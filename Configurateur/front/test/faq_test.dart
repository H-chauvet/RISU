import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:front/app_routes.dart';
import 'package:front/components/custom_app_bar.dart';
import 'package:front/components/custom_footer.dart';
import 'package:front/components/custom_header.dart';
import 'package:front/components/dialog/rating_dialog_content/rating_dialog_content.dart';
import 'package:front/screens/faq/faq.dart';
import 'package:front/screens/feedbacks/feedbacks.dart';
import 'package:flutter/material.dart';
import 'package:front/services/theme_service.dart';
import 'package:go_router/go_router.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late MockSharedPreferences sharedPreferences;

  setUp(() async {
    sharedPreferences = MockSharedPreferences();
    final roboto = rootBundle.load('assets/roboto/Roboto-Medium.ttf');
    final fontLoader = FontLoader('Roboto')..addFont(roboto);
    await fontLoader.load();
  });

  testWidgets(
      'FeedbacksPage displays feedbacks and allows posting new feedback',
      (WidgetTester tester) async {
    when(sharedPreferences.getString('token')).thenReturn('test-token');
    when(sharedPreferences.getString('tokenExpiration')).thenReturn(
        DateTime.now().add(const Duration(minutes: 30)).toIso8601String());

    await tester.binding.setSurfaceSize(const Size(5000, 5000));

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
                child: const FaqPage(),
              ),
              localizationsDelegates: AppLocalizations.localizationsDelegates,
              supportedLocales: AppLocalizations.supportedLocales,
            );
          },
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.byType(LandingAppBar), findsOneWidget);
    expect(find.byType(CustomFooter), findsOneWidget);

    expect(find.text("Comment créer un compte ?"), findsOneWidget);
    expect(
        find.text("Comment réinitialiser mon mot de passe ?"), findsOneWidget);
    expect(find.text("Comment contacter le support ?"), findsOneWidget);
    expect(find.text("Comment créer un conteneur ?"), findsOneWidget);
  });
}

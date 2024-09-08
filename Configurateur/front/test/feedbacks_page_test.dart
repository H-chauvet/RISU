import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:front/app_routes.dart';
import 'package:front/components/custom_app_bar.dart';
import 'package:front/components/custom_footer.dart';
import 'package:front/components/custom_header.dart';
import 'package:front/components/dialog/rating_dialog_content/rating_dialog_content.dart';
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
    // Préchargez la police 'Roboto'
    final roboto = rootBundle.load('assets/roboto/Roboto-Medium.ttf');
    final fontLoader = FontLoader('Roboto')..addFont(roboto);
    await fontLoader.load();
  });

  testWidgets(
      'FeedbacksPage displays feedbacks and allows posting new feedback',
      (WidgetTester tester) async {
    // Simulez le retour de SharedPreferences
    when(sharedPreferences.getString('token')).thenReturn('test-token');

    // Réduisez la taille de la surface pour un test plus réaliste
    await tester.binding.setSurfaceSize(const Size(5000, 5000));

    // Initialisez le widget
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
                child: const FeedbacksPage(),
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

    await tester.tap(find.text('Poster un avis'));
    await tester.pumpAndSettle();

    expect(find.byType(RatingDialogContent), findsOneWidget);
  });
}

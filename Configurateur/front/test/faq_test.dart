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

// class MockSharedPreferences extends Mock implements SharedPreferences {}

// void main() {
//   TestWidgetsFlutterBinding.ensureInitialized();

//   late MockSharedPreferences sharedPreferences;

//   setUp(() async {
//     sharedPreferences = MockSharedPreferences();
//     final roboto = rootBundle.load('assets/roboto/Roboto-Medium.ttf');
//     final fontLoader = FontLoader('Roboto')..addFont(roboto);
//     await fontLoader.load();
//   });

//   testWidgets(
//       'FeedbacksPage displays feedbacks and allows posting new feedback',
//       (WidgetTester tester) async {
//     when(sharedPreferences.getString('token')).thenReturn('test-token');
//     when(sharedPreferences.getString('tokenExpiration')).thenReturn(
//         DateTime.now().add(const Duration(minutes: 30)).toIso8601String());

//     await tester.binding.setSurfaceSize(const Size(5000, 5000));

//     await tester.pumpWidget(
//       MultiProvider(
//         providers: [
//           ChangeNotifierProvider<ThemeService>(
//             create: (_) => ThemeService(),
//           ),
//         ],
//         child: Sizer(
//           builder: (context, orientation, deviceType) {
//             return MaterialApp(
//               theme: ThemeData(fontFamily: 'Roboto'),
//               home: InheritedGoRouter(
//                 goRouter: AppRouter.router,
//                 child: const FaqPage(),
//               ),
//               localizationsDelegates: AppLocalizations.localizationsDelegates,
//               supportedLocales: AppLocalizations.supportedLocales,
//             );
//           },
//         ),
//       ),
//     );

//     await tester.pumpAndSettle();

//     expect(find.byType(LandingAppBar), findsOneWidget);
//     expect(find.byType(CustomFooter), findsOneWidget);

//     // expect(find.text("Comment créer un compte ?"), findsOneWidget);
//     expect(
//         find.text("Comment réinitialiser mon mot de passe ?"), findsOneWidget);
//     expect(find.text("Comment contacter le support ?"), findsOneWidget);
//     expect(find.text("Comment créer un conteneur ?"), findsOneWidget);
//   });
// }

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late MockSharedPreferences sharedPreferences;

  setUp(() async {
    sharedPreferences = MockSharedPreferences();
    final roboto = rootBundle.load('assets/roboto/Roboto-Medium.ttf');
    final fontLoader = FontLoader('Roboto')..addFont(roboto);
    await fontLoader.load();
  });

  testWidgets('Object creation screen', (WidgetTester tester) async {
    tester.binding.window.physicalSizeTestValue = const Size(5000, 5000);
    tester.binding.window.devicePixelRatioTestValue = 1.0;

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
              locale: const Locale('fr'),
            );
          },
        ),
      ),
    );

    await tester.pumpAndSettle(const Duration(seconds: 2));

    expect(find.text("Vous avez des questions ?"), findsOneWidget);
    expect(find.text("Vous pourrez trouver vos réponses ici."), findsOneWidget);

    expect(find.text("Comment créer un compte ?"), findsOneWidget);
    expect(
        find.text(
            "Pour créer un compte c'est très simple. Cliquez sur le lien en dessous pour rejoindre la page création de compte. Une fois sur cette page, renseignez les différents champs proposés. Une fois que ce sera fait, vous devez cliquer sur s'inscrire et un mail vous sera envoyez. Une fois la validation du compte fait vous pourrez utilisez votre compte sur notre application"),
        findsOneWidget);

    expect(
        find.text("Comment réinitialiser mon mot de passe ?"), findsOneWidget);
    expect(
        find.text(
            "Vous avez oubliez votre mot de passe ? Cliquez sur le lien en dessous pour pouvoir le réinitialiser facilement !"),
        findsOneWidget);

    expect(find.text("Comment contacter le support ?"), findsOneWidget);
    expect(
        find.text(
            "Vous avez une question et la réponse n'est pas sur cette page ? Contactez le support pour être directement en relation avec un employé de Risu"),
        findsOneWidget);

    expect(find.text("Comment créer un conteneur ?"), findsOneWidget);
    expect(
        find.text(
            "Vous venez d'arriver sur l'application et ne savez pas comment créer votre conteneur ? Cliquez sur le lien en dessous et vous serez rediriger vers la page création de conteneur. Faites les différentes étapes en choissisant la taille, la forme, le nombre de casiers ou encore le design de conteneur. Une fois toutes les étapes de création finis, vous n'avez plus qu'à payer et le tour est joué !"),
        findsOneWidget);

    await tester.pumpAndSettle();
  });
}

class MockSharedPreferences extends Mock implements SharedPreferences {}

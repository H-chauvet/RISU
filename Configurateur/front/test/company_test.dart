import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:front/app_routes.dart';
import 'package:front/components/custom_footer.dart';
import 'package:front/components/custom_header.dart';
import 'package:front/screens/company/company.dart';
import 'package:front/services/theme_service.dart';
import 'package:go_router/go_router.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late MockSharedPreferences sharedPreferences;

  setUp(() async {
    sharedPreferences = MockSharedPreferences();
    final roboto = rootBundle.load('assets/roboto/Roboto-Medium.ttf');
    final fontLoader = FontLoader('Roboto')..addFont(roboto);
    await fontLoader.load();
  });

  testWidgets('CompanyPage should render without error',
      (WidgetTester tester) async {

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
                child: const CompanyPage(),
              ),
              localizationsDelegates: AppLocalizations.localizationsDelegates,
              supportedLocales: AppLocalizations.supportedLocales,
              locale: Locale('fr'),
            );
          },
        ),
      ),
    );

    expect(find.byType(CompanyPage), findsOneWidget);

    await tester.pumpAndSettle();

    expect(find.byType(LandingAppBar), findsOneWidget);

    expect(
        find.text(
            "Risu révolutionne l'accès aux objets du quotidien grâce à ses conteneurs et casiers connectés..."),
        findsOneWidget);
    expect(find.text("Membres de l’équipe RISU"), findsOneWidget);
    expect(find.text("Notre Solution"), findsOneWidget);
    expect(
        find.text(
            "Chez Risu, nous croyons en des solutions durables qui répondent à des besoins environnementaux et sociaux. Notre solution se divise en deux parties innovantes"),
        findsOneWidget);
    expect(find.text("Conteneurs et Casiers Connectés"), findsOneWidget);
    expect(
        find.text(
            "Nous créons des conteneurs et des casiers connectés grâce à un configurateur 3D avancé. Ce configurateur permet aux particuliers de personnaliser la taille et le design de leurs casiers, facilitant ainsi l'intégration dans divers environnements."),
        findsOneWidget);
    expect(find.text("Avantages"), findsOneWidget);
    expect(find.text("La Personnalisation:"), findsOneWidget);
    expect(
        find.text("Modéliser votre conteneur à votre guise"), findsOneWidget);
    expect(find.text("Facilité d'installation :"), findsOneWidget);
    expect(
        find.text(
            "Disposez vos conteneurs où vous le souhaitez grâce à une conception modulable."),
        findsOneWidget);
    expect(find.text("Application Mobile Risu"), findsOneWidget);
    expect(
        find.text(
            "Notre application mobile, fournie avec chaque conteneur, révolutionne la manière de louer et de partager des objets. Elle permet de localiser et de louer des objets en quelques clics grâce à une carte interactive des conteneurs Risu disponibles à proximité."),
        findsOneWidget);
    expect(find.text("Fonctionnalité"), findsOneWidget);
    expect(find.text("Impact Environnemental et Social"), findsOneWidget);
    expect(
        find.text(
            "Notre solution Risu a été conçue pour avoir un impact positif sur l'environnement et la société"),
        findsOneWidget);
    expect(find.text("Réduction des Déplacements"), findsOneWidget);
    expect(
        find.text(
            "En facilitant l'accès aux objets nécessaires, nous contribuons à réduire l'empreinte carbone liée aux déplacements."),
        findsOneWidget);
    expect(find.text("Partage d'Objets"), findsOneWidget);
    expect(
        find.text(
            "Favoriser la location et le partage réduit la production excessive d'objets et encourage une consommation plus responsable."),
        findsOneWidget);
    expect(find.text("Accessibilité"), findsOneWidget);
    expect(
        find.text(
            "Nos conteneurs et l'application rendent les objets accessibles à tous, renforçant la communauté et soutenant l'économie circulaire."),
        findsOneWidget);
  });
}

class MockSharedPreferences extends Mock implements SharedPreferences {}

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:front/app_routes.dart';
import 'package:front/screens/container-creation/payment_screen.dart';
import 'package:front/services/theme_service.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

void main() {
  testWidgets('PaymentScreen', (WidgetTester tester) async {
    tester.binding.window.physicalSizeTestValue = const Size(5000, 5000);
    tester.binding.window.devicePixelRatioTestValue = 1.0;

    await tester.pumpWidget(MultiProvider(
      providers: [
        ChangeNotifierProvider<ThemeService>(
          create: (_) => ThemeService(),
        ),
      ],
      child: MaterialApp(
        home: InheritedGoRouter(
          goRouter: AppRouter.router,
          child: const PaymentScreen(
            amount: 100,
          ),
        ),
      ),
    ));

    expect(find.text('Informations de livraison'), findsOneWidget);
    expect(find.text('Coordonnées bancaires'), findsOneWidget);
    expect(find.text('Des demandes supplémentaires à nous faire parvenir ?'),
        findsOneWidget);
    expect(find.text('Payer'), findsOneWidget);

    await tester.enterText(find.byKey(const Key('adress')), '1 rue de la paix');
    await tester.enterText(find.byKey(const Key('city')), 'Nantes');
    await tester.enterText(
        find.byKey(const Key('informations')), 'some random informations');

    await tester.pump();
  });
}

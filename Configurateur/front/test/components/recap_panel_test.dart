import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:front/app_routes.dart';
import 'package:front/components/recap_panel.dart';
import 'package:front/services/theme_service.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

void main() {
  void blankSaved() {}
  testWidgets('test sum price', (WidgetTester tester) async {
    await tester.binding.setSurfaceSize(const Size(1920, 1080));

    List<Locker> list = List.filled(2, Locker('locker', 100));

    await tester.pumpWidget(MultiProvider(
      providers: [
        ChangeNotifierProvider<ThemeService>(
          create: (_) => ThemeService(),
        ),
      ],
      child: MaterialApp(
        home: InheritedGoRouter(
          goRouter: AppRouter.router,
          child: RecapPanel(
            articles: list,
            onSaved: blankSaved,
          ),
        ),
      ),
    ));

    expect(find.text('Total: 200€'), findsOneWidget);
  });

  testWidgets('test locker list display', (WidgetTester tester) async {
    await tester.binding.setSurfaceSize(const Size(1920, 1080));

    List<Locker> list = List.filled(2, Locker('Petit casier', 50));

    await tester.pumpWidget(MultiProvider(
      providers: [
        ChangeNotifierProvider<ThemeService>(
          create: (_) => ThemeService(),
        ),
      ],
      child: MaterialApp(
        home: InheritedGoRouter(
          goRouter: AppRouter.router,
          child: RecapPanel(
            articles: list,
            onSaved: blankSaved,
          ),
        ),
      ),
    ));

    expect(find.text('Petit Casier'), findsNWidgets(1));
    expect(find.text('200€'), findsNWidgets(0));
    expect(find.text('100€'), findsNWidgets(1));
  });
}

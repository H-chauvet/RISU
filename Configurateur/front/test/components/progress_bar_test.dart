import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:front/app_routes.dart';
import 'package:front/components/progress_bar.dart';
import 'package:front/services/theme_service.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

void voidFunc() {}

void main() {
  testWidgets('test progress bar', (WidgetTester tester) async {
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
          child: const ProgressBar(
            length: 5,
            progress: 1,
            next: 'Suivant',
            previous: 'Précédent',
            previousFunc: voidFunc,
            nextFunc: voidFunc,
          ),
        ),
      ),
    ));

    expect(find.byKey(const Key("circleShape_0")), findsOneWidget);
    expect(find.byKey(const Key("circleShape_1")), findsOneWidget);
    expect(find.byKey(const Key("circleShape_2")), findsOneWidget);
    expect(find.byKey(const Key("circleShape_3")), findsOneWidget);
    expect(find.byKey(const Key("circleShape_4")), findsOneWidget);
  });
}

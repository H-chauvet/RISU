import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:risu/components/burger_drawer.dart';
import 'package:risu/globals.dart';

import 'globals.dart';

void main() {
  setUpAll(() async {
    // This code runs once before all the tests.
    WidgetsFlutterBinding.ensureInitialized();
    WidgetController.hitTestWarningShouldBeFatal = true;
  });

  tearDown(() {
    // This code runs after each test case.
  });

  testWidgets('Burger Menu Test logged in', (WidgetTester tester) async {
    final scaffoldKey = GlobalKey<ScaffoldState>();
    userInformation = initExampleUser();

    await tester.pumpWidget(
      initPage(
        Scaffold(
          key: scaffoldKey,
          resizeToAvoidBottomInset: true,
          drawer: const BurgerDrawer(),
          body: Container(),
        ),
      ),
    );

    final ScaffoldState state = tester.firstState(find.byType(Scaffold));
    state.openDrawer();
    await tester.pumpAndSettle();
    expect(find.byType(BurgerDrawer), findsOneWidget);
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('burgerdrawer-logout')), findsOneWidget);
  });

  testWidgets('Burger Menu Test not logged in', (WidgetTester tester) async {
    final scaffoldKey = GlobalKey<ScaffoldState>();
    userInformation = null;

    await tester.pumpWidget(
      initPage(
        Scaffold(
          key: scaffoldKey,
          resizeToAvoidBottomInset: true,
          drawer: const BurgerDrawer(),
          body: Container(),
        ),
      ),
    );

    final ScaffoldState state = tester.firstState(find.byType(Scaffold));
    state.openDrawer();
    await tester.pumpAndSettle();
    expect(find.byType(BurgerDrawer), findsOneWidget);
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('burgerdrawer-logout')), findsNothing);
  });
}

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:risu/utils/validators.dart';

// MockBuildContext class
class MockBuildContext extends Mock implements BuildContext {
  @override
  T? dependOnInheritedWidgetOfExactType<T extends InheritedWidget>(
      {Object? aspect}) {
    if (T == AppLocalizations) {
      return MockAppLocalizations() as T;
    }
    return null;
  }
}

// MockAppLocalizations class
class MockAppLocalizations extends Mock implements AppLocalizations {
  @override
  String get fieldRequired =>
      AppLocalizations.of(MockBuildContext())!.fieldRequired;

  @override
  String get emailInvalid =>
      AppLocalizations.of(MockBuildContext())!.emailInvalid;
}

void main() {
  group('Validators Test', () {
    setUpAll(() {
      TestWidgetsFlutterBinding.ensureInitialized();
      WidgetController.hitTestWarningShouldBeFatal = true;
    });

    testWidgets('User info complete', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(builder: (BuildContext context) {
            return Container();
          }),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
        ),
      );
      BuildContext context = tester.element(find.byType(Container));

      expect(Validators().email(context, null),
          AppLocalizations.of(context)!.fieldRequired);
      expect(Validators().email(context, ''),
          AppLocalizations.of(context)!.fieldRequired);

      expect(Validators().email(context, 'invalid_email'),
          AppLocalizations.of(context)!.emailInvalid);

      expect(Validators().email(context, 'test@example.com'), null);

      expect(Validators().notEmpty(context, null),
          AppLocalizations.of(context)!.fieldRequired);
      expect(Validators().notEmpty(context, ''),
          AppLocalizations.of(context)!.fieldRequired);

      expect(Validators().notEmpty(context, 'not empty'), null);
    });
  });
}

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:risu/utils/validators.dart';

import 'globals.dart';

void main() {
  group('Validators Test', () {
    setUpAll(() {
      TestWidgetsFlutterBinding.ensureInitialized();
      WidgetController.hitTestWarningShouldBeFatal = true;
    });

    testWidgets('Check Validators email', (WidgetTester tester) async {
      await tester.pumpWidget(initPage(Container()));
      BuildContext context = tester.element(find.byType(Container));

      expect(Validators().email(context, null),
          AppLocalizations.of(context)!.fieldRequired);
      expect(Validators().email(context, ''),
          AppLocalizations.of(context)!.fieldRequired);

      expect(Validators().email(context, 'invalid_email'),
          AppLocalizations.of(context)!.emailInvalid);

      expect(Validators().email(context, 'test@example.com'), null);
    });

    testWidgets('Check Validators field', (WidgetTester tester) async {
      await tester.pumpWidget(initPage(Container()));
      BuildContext context = tester.element(find.byType(Container));

      expect(Validators().notEmpty(context, null),
          AppLocalizations.of(context)!.fieldRequired);
      expect(Validators().notEmpty(context, ''),
          AppLocalizations.of(context)!.fieldRequired);

      expect(Validators().notEmpty(context, 'not empty'), null);
    });
  });
}

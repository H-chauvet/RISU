import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:front/app_routes.dart';
import 'package:front/components/dialog/confirmation_dialog.dart';
import 'package:front/components/dialog/container_dialog.dart';
import 'package:front/components/dialog/handle_member/handle_member.dart';
import 'package:front/services/locker_service.dart';
import 'package:front/services/theme_service.dart';
import 'package:go_router/go_router.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

void main() {
  late MockSharedPreferences sharedPreferences;

  setUp(() {
    sharedPreferences = MockSharedPreferences();
  });

  testWidgets('test confirmation dialog', (WidgetTester tester) async {
    await tester.binding.setSurfaceSize(const Size(1920, 1080));

    when(sharedPreferences.getString('token')).thenReturn('test-token');

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
              home: InheritedGoRouter(
                goRouter: AppRouter.router,
                child: HandleMember(),
              ),
              localizationsDelegates: AppLocalizations.localizationsDelegates,
              supportedLocales: AppLocalizations.supportedLocales,
              locale: Locale('fr'),
            );
          },
        ),
      ),
    );

    expect(find.text('Membres actuels'), findsOneWidget);
    expect(find.text('Ajouter un membre'), findsOneWidget);

    await tester.enterText(
        find.byKey(const Key('collaboratorContact')), 'test');

    await tester.tap(find.byKey(const Key('send-button')));

    await tester.pump();
  });

  testWidgets('deleteUser', (WidgetTester tester) async {
    HandleMemberState handleMemberState = HandleMemberState();
    var user = {'id': 0, 'email': 'test'};
    handleMemberState.collaboratorList.add(user);

    handleMemberState.deleteUser(0);
  });
}

class MockSharedPreferences extends Mock implements SharedPreferences {}

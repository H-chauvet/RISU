import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:front/app_routes.dart';
import 'package:front/components/custom_app_bar.dart';
import 'package:front/components/dialog/rating_dialog_content/rating_dialog_content.dart';
import 'package:front/components/footer.dart';
import 'package:front/screens/feedbacks/feedbacks.dart';
import 'package:flutter/material.dart';
import 'package:front/screens/feedbacks/feedbacks_card.dart';
import 'package:front/services/storage_service.dart';
import 'package:front/services/theme_service.dart';
import 'package:go_router/go_router.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late MockSharedPreferences sharedPreferences;

  setUp(() async {
    sharedPreferences = MockSharedPreferences();
    final roboto = rootBundle.load('assets/roboto/Roboto-Medium.ttf');
    final fontLoader = FontLoader('Roboto')..addFont(roboto);
    await fontLoader.load();
  });
  testWidgets(
      'FeedbacksPage displays feedbacks and allows posting new feedback',
      (WidgetTester tester) async {
    TestWidgetsFlutterBinding.ensureInitialized();

    when(sharedPreferences.getString('token')).thenReturn('test-token');

    await tester.binding.setSurfaceSize(const Size(1920, 1080));

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
            );
          },
        ),
      ),
    );
    await tester.pumpAndSettle(const Duration(seconds: 2));

    await tester.tap(find.text('Poster un avis'));
    await tester.pump();

    expect(find.byType(RatingDialogContent), findsOneWidget);
    expect(find.byType(CustomAppBar), findsOneWidget);
    expect(find.byType(CustomBottomNavigationBar), findsOneWidget);
  });
}

class MockSharedPreferences extends Mock implements SharedPreferences {}

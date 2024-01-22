import 'package:flutter_test/flutter_test.dart';
import 'package:front/app_routes.dart';
import 'package:front/components/custom_app_bar.dart';
import 'package:front/components/dialog/rating_dialog_content.dart';
import 'package:front/components/footer.dart';
import 'package:front/screens/feedbacks/feedbacks.dart';
import 'package:flutter/material.dart';
import 'package:front/screens/messages/messages.dart';
import 'package:front/services/storage_service.dart';
import 'package:front/services/theme_service.dart';
import 'package:go_router/go_router.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late MockSharedPreferences sharedPreferences;

  setUp(() {
    sharedPreferences = MockSharedPreferences();
  });
  testWidgets('MessagePage', (WidgetTester tester) async {
    TestWidgetsFlutterBinding.ensureInitialized();

    when(sharedPreferences.getString('token')).thenReturn('test-token');

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
          child: const MessagePage(),
        ),
      ),
    ));
    await tester.pumpAndSettle(const Duration(seconds: 2));

    expect(find.text("Gestion des messages"), findsOneWidget);

    expect(find.byType(CustomAppBar), findsOneWidget);
    expect(find.byType(CustomBottomNavigationBar), findsOneWidget);
    expect(find.byType(ListView), findsOneWidget);
  });
}

class MockSharedPreferences extends Mock implements SharedPreferences {}

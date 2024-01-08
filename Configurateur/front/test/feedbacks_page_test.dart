import 'package:flutter_test/flutter_test.dart';
import 'package:front/app_routes.dart';
import 'package:front/components/custom_app_bar.dart';
import 'package:front/components/dialog/rating_dialog_content.dart';
import 'package:front/components/footer.dart';
import 'package:front/screens/feedbacks/feedbacks.dart';
import 'package:flutter/material.dart';
import 'package:front/screens/feedbacks/feedbacks_card.dart';
import 'package:front/services/storage_service.dart';
import 'package:front/services/theme_service.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  testWidgets('FeedbacksPage displays feedbacks and allows posting new feedback', (WidgetTester tester) async {
    token = "token";

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
          child: const FeedbacksPage(),
        ),
      ),
    ));
    await tester.pumpAndSettle(const Duration(seconds: 2));
    
    await tester.tap(find.text('Poster un avis'));
    await tester.pump();

    expect(find.byType(RatingDialogContent), findsOneWidget);
    expect(find.byType(CustomAppBar), findsOneWidget);
    expect(find.byType(CustomBottomNavigationBar), findsOneWidget);
  });
}

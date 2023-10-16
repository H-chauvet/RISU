import 'package:flutter_test/flutter_test.dart';
import 'package:front/app_routes.dart';

void main() {
  test(
    'check if router is valid',
    () {
      expect(AppRouter.router, isNotNull);
    },
  );
}

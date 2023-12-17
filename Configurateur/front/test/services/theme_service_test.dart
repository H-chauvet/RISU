import 'package:flutter_test/flutter_test.dart';
import 'package:front/services/theme_service.dart';

void main() {
  test('test getter theme_service', () {
    ThemeService themeService = ThemeService();

    expect(themeService.isDark, false);

    themeService.switchTheme();
    expect(themeService.isDark, true);
  });
}

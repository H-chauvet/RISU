import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:risu/utils/theme.dart';

class LoaderManager {
  bool _isLoading = false;

  bool getIsLoading() {
    return _isLoading;
  }

  void setIsLoading(bool status) {
    _isLoading = status;
  }

  Widget getLoader() {
    return const Loader();
  }
}

class Loader extends StatelessWidget {
  const Loader({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return CircularProgressIndicator(
      color: themeProvider
          .currentTheme.inputDecorationTheme.floatingLabelStyle!.color,
    );
  }
}

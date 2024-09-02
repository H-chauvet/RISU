import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:risu/utils/providers/theme.dart';

/// LoaderManager class to manage the loader
/// This class is used to manage the loader state
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

/// Loader class to show the loader
/// This class is used to show the loader
class Loader extends StatelessWidget {
  const Loader({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return CircularProgressIndicator(
      color: themeProvider.currentTheme.primaryColor,
    );
  }
}

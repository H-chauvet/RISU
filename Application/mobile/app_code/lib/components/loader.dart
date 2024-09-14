import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:risu/utils/providers/theme.dart';

/// LoaderManager class to manage the loader.
/// This class is used to manage the loader state.
/// The loader manager is user to show the loader when data is being fetched.
/// When the request is completed, the loader is hidden.
class LoaderManager {
  bool _isLoading = false;

  /// getIsLoading method.
  /// This method is used to get the loader status.
  bool getIsLoading() {
    return _isLoading;
  }

  /// setIsLoading method.
  /// This method is used to set the loader status.
  /// params:
  /// [status] - is the status of the loader.
  void setIsLoading(bool status) {
    _isLoading = status;
  }

  /// getLoader method.
  /// This method is used to get the loader widget.
  Widget getLoader() {
    return const Loader();
  }
}

/// Loader class to show the loader.
/// This class is used to show the loader.
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

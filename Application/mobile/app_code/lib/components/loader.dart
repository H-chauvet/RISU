import 'package:flutter/material.dart';

class LoaderManager {
  static Future<bool> yourAsyncFunction({
    Key? key,
    required bool activation,
  }) async {
    await Future.delayed(Duration(seconds: 1));
    return activation;
  }
}

class CustomLoader extends StatelessWidget {
  final Future<bool> loadingFuture;

  CustomLoader({required this.loadingFuture});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: loadingFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting ||
            !snapshot.hasData) { // La modif est ici
          return _buildLoader();
        } else {
          return Container();
        }
      },
    );
  }

  Widget _buildLoader() {
    return Center(
      child: CircularProgressIndicator(),
    );
  }
}
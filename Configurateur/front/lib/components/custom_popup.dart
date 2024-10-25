// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:front/services/theme_service.dart';
import 'package:front/styles/themes.dart';
import 'package:provider/provider.dart';

class CustomPopup extends StatelessWidget {
  final Widget content;
  final String title;

  const CustomPopup({super.key, required this.title, required this.content});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Provider.of<ThemeService>(context).isDark
                        ? customPopupBackgroundDarkTheme
                        : customPopupBackgroundLightTheme,
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black,
                        blurRadius: 10,
                        offset: Offset(0, 10),
                      ),
                    ],
                  ),
                  width: constraints.maxWidth * 0.55,
                  height: constraints.maxHeight * 0.55,
                  child: Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: Center(
                          child: Image.asset(
                            'assets/logonew.png',
                            width: 300,
                            height: 300,
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 20),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const SizedBox(height: 50),
                              Text(
                                title,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 30,
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.bold,
                                  color:
                                      Provider.of<ThemeService>(context).isDark
                                          ? darkTheme.secondaryHeaderColor
                                          : lightTheme.secondaryHeaderColor,
                                  shadows: [
                                    Shadow(
                                      color: Provider.of<ThemeService>(context)
                                              .isDark
                                          ? darkTheme.secondaryHeaderColor
                                          : lightTheme.secondaryHeaderColor,
                                      offset: const Offset(0.75, 0.75),
                                      blurRadius: 1.5,
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 10),
                              Expanded(child: content),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  right: 10,
                  top: 10,
                  child: MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: GestureDetector(
                      key: const Key("close-popup"),
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        child: const Icon(Icons.close, color: Colors.grey),
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

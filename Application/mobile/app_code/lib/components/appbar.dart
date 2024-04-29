import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:risu/utils/providers/theme.dart';

class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  final bool showBackButton;
  final Color curveColor;
  final String textTitle;
  final Widget? action;
  late void Function()? onBackButtonPressed;

  MyAppBar({
    super.key,
    required this.curveColor,
    this.showBackButton = true,
    this.textTitle = "",
    this.action,
    this.onBackButtonPressed,
  });

  @override
  Widget build(BuildContext context) {
    onBackButtonPressed ??= () {
      Navigator.pop(context);
    };
    return CustomPaint(
      painter: CurvePainter(curveColor),
      child: AppBar(
        leading: showBackButton
            ? BackButton(
                key: const Key('appbar-button_back'),
                onPressed: onBackButtonPressed!,
              )
            : null,
        title: textTitle == ""
            ? Image.asset(
                key: const Key('appbar-image_logo'),
                'assets/logo.png',
                height: 192,
              )
            : Text(
                textTitle,
                key: const Key('appbar-text_title'),
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: context.select((ThemeProvider themeProvider) =>
                      themeProvider.currentTheme.primaryColor),
                ),
              ),
        actions: <Widget>[
          if (action != null) ...[
            action!,
          ]
        ],
        centerTitle: true,
        toolbarHeight: preferredSize.height,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 16);
}

class CurvePainter extends CustomPainter {
  final Color curveColor;

  CurvePainter(this.curveColor);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = curveColor
      ..style = PaintingStyle.fill;

    final path = Path();

    final centerX = size.width / 2;
    final centerY = size.height;

    path.moveTo(0, centerY);
    path.quadraticBezierTo(centerX, centerY + 48, size.width, centerY);
    path.lineTo(size.width, 0);
    path.lineTo(0, 0);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

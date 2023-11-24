import 'package:flutter/material.dart';

class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  final bool showBackButton;
  final bool showLogo;
  final bool showBurgerMenu;
  final Color curveColor;

  const MyAppBar({
    Key? key,
    required this.curveColor,
    this.showBackButton = true,
    this.showLogo = true,
    this.showBurgerMenu = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: CurvePainter(curveColor),
      child: AppBar(
        leading: showBackButton
            ? BackButton(
                key: const Key('appbar-button_back'),
                onPressed: () {
                  Navigator.pop(context);
                },
              )
            : null,
        title: showLogo
            ? Image.asset(
                key: const Key('appbar-image_logo'),
                'assets/logo_noir.png',
                height: 64,
              )
            : null,
        centerTitle: true,
        actions: showBurgerMenu
            ? [
                IconButton(
                  key: const Key('appbar-button_burgermenu'),
                  icon: const Icon(Icons.menu),
                  onPressed: () {},
                ),
              ]
            : null,
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

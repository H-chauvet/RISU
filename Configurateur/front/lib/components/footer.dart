import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  const CustomBottomNavigationBar({super.key});

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      child: Wrap(
        alignment: WrapAlignment.center,
        children: [
          TextButton(
            onPressed: () {
              context.go("/");
            },
            child: const Text(
              'Accueil',
              style: TextStyle(
                fontSize: 16,
                color: Colors.white,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              context.go("/confidentiality");
            },
            child: const Text(
              'Politique de confidentialité',
              style: TextStyle(
                fontSize: 16,
                color: Colors.white,
              ),
            ),
          ),
          TextButton(
            onPressed: () {},
            child: const Text(
              'Conditions générales d\'utilisation',
              style: TextStyle(
                fontSize: 16,
                color: Colors.white,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              context.go("/contact");
            },
            child: const Text(
              'Contact',
              style: TextStyle(
                fontSize: 16,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

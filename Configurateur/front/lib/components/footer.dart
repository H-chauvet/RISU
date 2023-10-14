import 'package:flutter/material.dart';
import 'package:front/screens/contact/contact.dart';
import 'package:go_router/go_router.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  const CustomBottomNavigationBar({super.key});

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      color: const Color.fromRGBO(70, 130, 180, 1),
      child: SizedBox(
        height: 45.0,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
      ),
    );
  }
}

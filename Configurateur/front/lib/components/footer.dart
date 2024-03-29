import 'package:flutter/material.dart';
import 'package:front/main.dart';
import 'package:go_router/go_router.dart';
import 'package:front/services/storage_service.dart';
import 'package:path/path.dart';

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
          const SizedBox(width: 20),
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
          const SizedBox(width: 20),
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
          const SizedBox(width: 20),
          TextButton(
            onPressed: () async {
              if (await storageService.readStorage('token') == '') {
                context.go("/login");
              } else {
                context.go("/feedbacks");
              }
            },
            child: const Text(
              'Avis',
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

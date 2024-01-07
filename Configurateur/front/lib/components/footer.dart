import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:front/services/storage_service.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  const CustomBottomNavigationBar({super.key});

  void goToFeedbacks() {
    if (token == '') {
      context.go("/login");
    } else {
      context.go("/feedbacks");
    }
  }

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
            onPressed: () => goToFeedbacks(),
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

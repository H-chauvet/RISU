import 'package:flutter/material.dart';
import 'package:front/components/custom_app_bar.dart';
import 'package:front/components/footer.dart';
import 'package:front/services/storage_service.dart';
import 'package:go_router/go_router.dart';

class AdminPage extends StatefulWidget {
  const AdminPage({Key? key}) : super(key: key);

  @override
  _AdminPageState createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  @override
  void initState() {
    super.initState();
    _checkToken();
  }
  Future<void> _checkToken() async {

    if (token.isNotEmpty && userMail == "risu.admin@gmail.com") {
      // Si le token est présent, faites ce que vous devez faire avec le token
      // Par exemple, attribuez-le à jwtToken
      setState(() {
        print(token);
      });
    } else {
      // Si le token est absent, redirigez vers la page de connexion
      context.go('/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(255, 255, 255, 1),
      appBar: CustomAppBar(
        'Administration',
        context: context,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                const Color.fromARGB(255, 190, 189, 189),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 25, vertical: 15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  20.0), // Définit le rayon du bouton arrondi
                            ),
                          ),
                          onPressed: () {
                          },
                          child: const Text(
                            'Gestion des messages',
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                        const SizedBox(height: 30),
                        const Text(
                          "Cet onglet permet d'accéder à la liste\ndes messages envoyés par les utilisateurs",
                          softWrap: true,
                          maxLines: 3,
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                    Container(
                      height: 200,
                      child: const VerticalDivider(
                        thickness: 2,
                        width: 100,
                        color: Colors.black,
                      ),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                const Color.fromARGB(255, 190, 189, 189),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 25, vertical: 15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  20.0), // Définit le rayon du bouton arrondi
                            ),
                          ),
                          onPressed: () {},
                          child: const Text(
                            'Gestion des utilisateurs',
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                        const SizedBox(height: 30),
                        const Text(
                          "Cet onglet permet d'accéder à la liste\ndes utilisateurs.",
                          softWrap: true,
                          maxLines: 3,
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                    Container(
                      height: 200,
                      child: const VerticalDivider(
                        thickness: 2,
                        width: 100,
                        color: Colors.black,
                      ),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                const Color.fromARGB(255, 190, 189, 189),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 25, vertical: 15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  20.0), // Définit le rayon du bouton arrondi
                            ),
                          ),
                          onPressed: () {},
                          child: const Text(
                            'Gestion des articles',
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                        const SizedBox(height: 30),
                        const Text(
                          "Cet onglet permet d'accéder à la liste\ndes conteneurs ayant été créés.",
                          softWrap: true,
                          maxLines: 3,
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const CustomBottomNavigationBar(),
    );
  }
}

      
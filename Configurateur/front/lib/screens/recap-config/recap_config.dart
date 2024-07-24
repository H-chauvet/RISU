import 'package:flutter/material.dart';
import 'package:front/components/alert_dialog.dart';
import 'package:front/components/custom_toast.dart';
import 'package:front/components/footer.dart';
import 'package:front/services/storage_service.dart';
import 'package:go_router/go_router.dart';

/// RecapConfigPage
///
/// The Page show all the informations of the container created by the user
class RecapConfigPage extends StatefulWidget {
  const RecapConfigPage({Key? key}) : super(key: key);

  @override
  _RecapConfigPageState createState() => _RecapConfigPageState();
}

/// _RecapConfigPageState
///
class _RecapConfigPageState extends State<RecapConfigPage> {
  @override
  void initState() {
    super.initState();

    /// Check if the user is connected
    MyAlertTest.checkSignInStatus(context);
  }

  /// [Widget] : Build the recap of the container page
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 16.0),
              child: Image.asset(
                'assets/logo.png',
                width: 150,
                height: 150,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                TextButton(
                  onPressed: () {},
                  child: const Text('Accueil'),
                ),
                TextButton(
                  onPressed: () {},
                  child: const Text('Créer un conteneur'),
                ),
                TextButton(
                  onPressed: () {},
                  child: const Text('Nos offres'),
                ),
                TextButton(
                  onPressed: () {},
                  child: const Text('Nous contacter'),
                ),
              ],
            ),
            Row(
              children: [
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                  ),
                  child: const Text(
                    'Mon profil',
                  ),
                ),
                const SizedBox(width: 16.0),
                ElevatedButton(
                  onPressed: () {
                    storageService.removeStorage('token');
                    storageService.removeStorage('tokenExpiration');
                    showCustomToast(
                        context, "Vous êtes bien déconnecté !", true);
                    context.go("/");
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                  ),
                  child: const Text('Déconnexion',
                      style: TextStyle(color: Color.fromRGBO(143, 47, 47, 1))),
                ),
              ],
            ),
          ],
        ),
      ),
      body: Center(
        child: Stack(
          alignment: Alignment.bottomRight,
          children: [
            Container(
              width: 800,
              height: 450,
              decoration: BoxDecoration(
                border: Border.all(
                  color: Theme.of(context).primaryColor,
                  width: 4.0,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Récapitulatif de commande',
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                    const SizedBox(height: 50),
                    Text(
                      'Nom du produit:',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                    const Text(
                      'Conteneur classique',
                      style: TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Options:',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                    const Text(
                      'Flocage(Oui) - Logo(Oui) - Couleur personnalisée(Non)',
                      style: TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Taille:',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                    const Text(
                      '8m x 4.50m x 2.50m',
                      style: TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Prix:',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                    const Text(
                      '6500.00 €',
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              top: 10,
              left: 20,
              child: Image.asset(
                'assets/container.png',
                width: 125,
                height: 125,
              ),
            ),
            Positioned(
              bottom: 10,
              left: 10,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                ),
                child: const Text(
                  'Retour',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),
            Positioned(
              bottom: 10,
              right: 10,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                ),
                child: const Text(
                  'Payer',
                  style: TextStyle(fontSize: 18),
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

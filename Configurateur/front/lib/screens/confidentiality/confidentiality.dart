import 'package:flutter/material.dart';
import 'package:front/components/custom_app_bar.dart';
import 'package:front/components/footer.dart';

/// Page de confidentialité
class ConfidentialityPage extends StatelessWidget {
  const ConfidentialityPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        'Politique de confidentialité',
        context: context,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(
                height: 100,
              ),
              _buildSection("Dernière mise à jour : 14 Octobre 2023\n\n",
                  "Chez RISU, nous accordons une grande importance à la confidentialité de nos utilisateurs. Cette politique de confidentialité décrit comment nous collectons, utilisons et protégeons vos informations lorsque vous utilisez notre site web. En utilisant notre site web, vous consentez aux pratiques décrites dans cette politique.\n\n"),
              _buildSection(
                  "Informations que nous collectons",
                  "Lorsque vous utilisez notre site web, nous pouvons collecter des informations personnelles telles que votre nom, adresse e-mail, numéro de téléphone, et toute autre information que vous choisissez de nous fournir.\n\n"
                      "Nous pouvons également collecter des informations non personnelles, telles que des données démographiques, des préférences, des données d'utilisation du site, des cookies, des journaux de serveur, et d'autres informations techniques permettant d'améliorer l'expérience de nos utilisateurs.\n\n"),
              _buildSection(
                  "Comment nous utilisons vos informations",
                  "Nous utilisons les informations que nous collectons pour :\n\n"
                      "- Fournir, maintenir et améliorer notre site web.\n"
                      "- Personnaliser votre expérience et afficher un contenu pertinent.\n"
                      "- Vous contacter pour des informations, des offres, des mises à jour et des annonces.\n"
                      "- Répondre à vos questions et commentaires.\n"
                      "- Respecter les lois et réglementations en vigueur.\n\n"),
              _buildSection("Comment nous protégeons vos informations",
                  "Nous prenons des mesures raisonnables pour protéger vos informations personnelles contre la perte, l'accès non autorisé, la divulgation, l'altération ou la destruction. Cependant, aucune méthode de transmission sur Internet ni de stockage électronique n'est totalement sécurisée, et nous ne pouvons garantir la sécurité absolue de vos informations.\n\n"),
              _buildSection(
                  "Partage d'informations",
                  "Nous ne vendons ni ne louons vos informations personnelles à des tiers. Cependant, nous pouvons partager vos informations avec des tiers dans les circonstances suivantes :\n\n"
                      "- Avec votre consentement.\n"
                      "- Pour satisfaire aux exigences légales.\n"
                      "- Dans le cadre de transactions commerciales, telles que des fusions ou des acquisitions.\n"
                      "- Avec des fournisseurs de services tiers qui nous aident à exploiter notre site web.\n\n"),
              _buildSection("Cookies",
                  "Notre site web peut utiliser des cookies pour collecter des informations non personnelles. Vous pouvez choisir de désactiver les cookies dans les paramètres de votre navigateur, mais cela peut affecter votre expérience de navigation.\n\n"),
              _buildSection("Liens vers des sites tiers",
                  "Notre site web peut contenir des liens vers des sites web tiers. Cette politique de confidentialité ne s'applique qu'à notre site web, et nous ne sommes pas responsables des pratiques de confidentialité des sites tiers. Nous vous encourageons à lire les politiques de confidentialité de ces sites.\n\n"),
              _buildSection("Modifications de cette politique",
                  "Nous nous réservons le droit de modifier cette politique de confidentialité à tout moment. Toute modification sera publiée sur cette page avec la date de la dernière mise à jour.\n\n"),
              _buildSection("Contactez-nous",
                  "Si vous avez des questions concernant cette politique de confidentialité, veuillez nous contacter à risu.epitech@gmail.com.\n\n"),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const CustomBottomNavigationBar(),
    );
  }

  Widget _buildSection(String title, String content) {
    return Column(
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            content,
            textAlign: TextAlign.justify,
          ),
        ),
      ],
    );
  }
}

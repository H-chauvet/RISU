import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:footer/footer.dart';
import 'package:footer/footer_view.dart';
import 'package:front/components/custom_app_bar.dart';
import 'package:front/components/custom_footer.dart';
import 'package:front/components/custom_header.dart';
import 'package:front/components/custom_toast.dart';
import 'package:front/components/footer.dart';
import 'package:front/network/informations.dart';
import 'package:front/screens/company/company_style.dart';
import 'package:front/services/http_service.dart';
import 'package:front/services/size_service.dart';
import 'package:front/services/storage_service.dart';
import 'package:front/services/theme_service.dart';
import 'package:front/styles/globalStyle.dart';
import 'package:front/styles/themes.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:flutter/material.dart';

class TeamMembersGrid extends StatefulWidget {
  final List<Map<String, String>> teamMembers;

  TeamMembersGrid({required this.teamMembers});

  @override
  _TeamMembersGridState createState() => _TeamMembersGridState();
}

class _TeamMembersGridState extends State<TeamMembersGrid>
    with SingleTickerProviderStateMixin {
  int _expandedIndex = -1;
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Stack(
      children: [
        Container(
          width: double.infinity,
          child: Column(
            children: [
              Wrap(
                spacing: 20,
                runSpacing: 20,
                children: List.generate(4, (index) {
                  return _buildMemberCard(index);
                }),
              ),
              const SizedBox(
                height: 20,
              ),
              Wrap(
                spacing: 20,
                runSpacing: 20,
                children: List.generate(3, (index) {
                  final realIndex = 4 + index;
                  return _buildMemberCard(realIndex);
                }),
              ),
            ],
          ),
        ),
        if (_expandedIndex != -1)
          Positioned(
            top: _calculatePositionY(_expandedIndex),
            left: _calculatePositionX(_expandedIndex, screenWidth),
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: Container(
                width: 300,
                height: 200,
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    const BoxShadow(
                      color: Colors.black26,
                      blurRadius: 10,
                      offset: Offset(2, 2),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(15),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        widget.teamMembers[_expandedIndex]['name'] ??
                            'Nom du Membre',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 20),
                      Expanded(
                        child: SingleChildScrollView(
                          child: Center(
                            child: Text(
                              widget.teamMembers[_expandedIndex]
                                      ['description'] ??
                                  'companyPosition longue du poste et des responsabilités...',
                              style: const TextStyle(
                                  fontSize: 14, color: Colors.black),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildMemberCard(int index) {
    final member = widget.teamMembers[index];
    final isExpanded = _expandedIndex == index;

    return GestureDetector(
      onTap: () {
        setState(() {
          if (isExpanded) {
            _expandedIndex = -1;
            _controller.reverse();
          } else {
            _expandedIndex = index;
            _controller.forward();
          }
        });
      },
      child: Container(
        key: ValueKey(index),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          width: 150,
          constraints: const BoxConstraints(
            minHeight: 200,
          ),
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Flexible(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      image: DecorationImage(
                        image: AssetImage(member['image']!),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Flexible(
                child: Text(
                  member['name']!,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 5),
              Flexible(
                child: Text(
                  member['companyPosition']!,
                  style: const TextStyle(
                    fontSize: 15,
                    color: Colors.grey,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  double _calculatePositionX(int index, double screenWidth) {
    const cardWidth = 150;
    const spacing = 20;
    final totalWidth;

    if (index < 4) {
      totalWidth = (cardWidth * 4) + (spacing * 3);
    } else {
      totalWidth = (cardWidth * 3) + (spacing * 2);
    }

    final lineStartX = (screenWidth - totalWidth) / 2;
    final cardPositionX;

    if (index < 4) {
      cardPositionX = lineStartX + (cardWidth + spacing) * index;
    } else {
      cardPositionX = lineStartX + (cardWidth + spacing) * (index - 4);
    }
    return cardPositionX + cardWidth;
  }

  double _calculatePositionY(int index) {
    final rowIndex = index ~/ 4;
    final cardHeight = 200 + 20;
    double baseY = rowIndex.toDouble() * cardHeight;
    return baseY;
  }
}

/// [StatefulWidget] : CompanyPage
///
/// Page of the Risu Company and the containers created with the configurator
class CompanyPage extends StatefulWidget {
  const CompanyPage({Key? key}) : super(key: key);

  @override
  State<CompanyPage> createState() => CompanyPageState();
}

/// CompanyPageState
///
class CompanyPageState extends State<CompanyPage> {
  final List<Map<String, String>> teamMembers = [
    {
      "name": "Henri",
      "companyPosition": "Chef de projet",
      "image": 'assets/Henri.png',
      "description":
          "Chef de projet de l’équipe Risu. Il s’occupe du devéloppement de la partie Web de la solution. Il s’occupe aussi des documents relatifs à l’entreprise et aux rendus exigés."
    },
    {
      "name": "Hugo",
      "companyPosition": "Développeur mobile",
      "image": 'assets/Hugo.png',
      "description":
          "Développeur full stack pour la partie mobile. Il s'occupe d'ajouter de nouvelles fonctionnalités, régler de bugs ou encore proposer de nouvelles tâches à réalisées pour les prochains sprints"
    },
    {
      "name": "Cédric",
      "companyPosition": "Responsable Web",
      "image": 'assets/Cédric.png',
      "description":
          "Responsable et développeur full stack pour la partie web. Il s'occupe d'ajouter de nouvelles fonctionnalités, régler de bugs ou encore proposer de nouvelles tâches à réalisées pour les prochains sprints",
    },
    {
      "name": "Louis",
      "companyPosition": "Développeur web",
      "image": 'assets/Louis.png',
      "description":
          "Développeur full stack pour la partie web. Il s'occupe d'ajouter de nouvelles fonctionnalités, régler de bugs ou encore proposer de nouvelles tâches à réalisées pour les prochains sprints"
    },
    {
      "name": "Quentin",
      "companyPosition": "Développeur mobile",
      "image": 'assets/Quentin.png',
      "description":
          "Développeur full stack pour la partie mobile. Il s'occupe d'ajouter de nouvelles fonctionnalités, régler de bugs ou encore proposer de nouvelles tâches à réalisées pour les prochains sprints"
    },
    {
      "name": "Tanguy",
      "companyPosition": "Responsable mobile",
      "image": 'assets/Tanguy.png',
      "description":
          "Développeur full stack pour la partie mobile. Il s'occupe d'ajouter de nouvelles fonctionnalités, régler de bugs ou encore proposer de nouvelles tâches à réalisées pour les prochains sprints"
    },
    {
      "name": "Nathan",
      "companyPosition": "Développeur mobile",
      "image": 'assets/Nathan.png',
      "description":
          "Développeur full stack pour la partie mobile. Il s'occupe d'ajouter de nouvelles fonctionnalités, régler de bugs ou encore proposer de nouvelles tâches à réalisées pour les prochains sprints"
    },
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FooterView(
        flex: 10,
        footer: Footer(
          padding: EdgeInsets.zero,
          child: const CustomFooter(),
        ),
        children: [
          LandingAppBar(context: context),
          SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  color: Provider.of<ThemeService>(context).isDark
                      ? darkTheme.appBarTheme.backgroundColor
                      : lightTheme.appBarTheme.backgroundColor,
                  child: Column(
                    children: [
                      Image.asset(
                        'assets/logo.png',
                        height: 250,
                        width: 250,
                      ),
                      Center(
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(
                            maxWidth: 600,
                          ),
                          child: Text(
                            "Risu révolutionne l'accès aux objets du quotidien grâce à ses conteneurs et casiers connectés...",
                            style: TextStyle(
                              fontSize: 18,
                              color: Provider.of<ThemeService>(context).isDark
                                  ? darkTheme.primaryColor
                                  : lightTheme.colorScheme.background,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(30),
                  child: Text(
                    "Membres de l’équipe RISU",
                    style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      color: Provider.of<ThemeService>(context).isDark
                          ? darkTheme.primaryColor
                          : lightTheme.primaryColor,
                    ),
                  ),
                ),
                TeamMembersGrid(
                  teamMembers: teamMembers,
                ),
                const SizedBox(height: 40),
                Container(
                  padding: const EdgeInsets.all(30),
                  width: double.infinity,
                  color: Provider.of<ThemeService>(context).isDark
                      ? darkTheme.appBarTheme.backgroundColor
                      : lightTheme.appBarTheme.backgroundColor,
                  child: Column(
                    children: [
                      Text(
                        "Notre Solution",
                        style: TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                          color: Provider.of<ThemeService>(context).isDark
                              ? darkTheme.primaryColor
                              : lightTheme.primaryColor,
                        ),
                      ),
                      const SizedBox(height: 35),
                      ConstrainedBox(
                        constraints: const BoxConstraints(
                          maxWidth: 600,
                        ),
                        child: Text(
                          "Chez Risu, nous croyons en des solutions durables qui répondent à des besoins environnementaux et sociaux. Notre solution se divise en deux parties innovantes",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 20,
                            color: Provider.of<ThemeService>(context).isDark
                                ? darkTheme.primaryColor
                                : lightTheme.primaryColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 35),
                Center(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        radius: 35,
                        backgroundColor:
                            Provider.of<ThemeService>(context).isDark
                                ? darkTheme.primaryColor
                                : lightTheme.primaryColor,
                        child: Text(
                          "1",
                          style: TextStyle(
                            fontSize: 30,
                            color: Provider.of<ThemeService>(context).isDark
                                ? darkTheme.appBarTheme.backgroundColor
                                : lightTheme.appBarTheme.backgroundColor,
                          ),
                        ),
                      ),
                      const SizedBox(width: 80),
                      Text(
                        "Conteneurs et Casiers Connectés",
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: Provider.of<ThemeService>(context).isDark
                              ? darkTheme.primaryColor
                              : lightTheme.primaryColor,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 80),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ConstrainedBox(
                      constraints: const BoxConstraints(
                        maxWidth: 700,
                      ),
                      child: Text(
                        "Nous créons des conteneurs et des casiers connectés grâce à un configurateur 3D avancé. Ce configurateur permet aux particuliers de personnaliser la taille et le design de leurs casiers, facilitant ainsi l'intégration dans divers environnements.",
                        style: TextStyle(
                          fontSize: 18,
                          color: Provider.of<ThemeService>(context).isDark
                              ? darkTheme.primaryColor
                              : lightTheme.primaryColor,
                        ),
                        textAlign: TextAlign.justify,
                      ),
                    ),
                    const SizedBox(width: 150),
                    Container(
                      padding: const EdgeInsets.all(20),
                      width: 200,
                      color: Provider.of<ThemeService>(context).isDark
                          ? darkTheme.primaryColor
                          : lightTheme.primaryColor,
                      child: Column(
                        children: [
                          Text(
                            "Avantages",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              color: Provider.of<ThemeService>(context).isDark
                                  ? darkTheme.appBarTheme.backgroundColor
                                  : lightTheme.appBarTheme.backgroundColor,
                            ),
                            textAlign: TextAlign.justify,
                          ),
                          const SizedBox(height: 15),
                          Text(
                            "La Personnalisation:",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                              color: Provider.of<ThemeService>(context).isDark
                                  ? darkTheme.appBarTheme.backgroundColor
                                  : lightTheme.appBarTheme.backgroundColor,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 5),
                          Text(
                            "Modéliser votre conteneur à votre guise",
                            style: TextStyle(
                              fontSize: 13,
                              color: Provider.of<ThemeService>(context).isDark
                                  ? darkTheme.appBarTheme.backgroundColor
                                  : lightTheme.appBarTheme.backgroundColor,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 20),
                          Text(
                            "Facilité d'installation :",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                              color: Provider.of<ThemeService>(context).isDark
                                  ? darkTheme.appBarTheme.backgroundColor
                                  : lightTheme.appBarTheme.backgroundColor,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 5),
                          Text(
                            "Disposez vos conteneurs où vous le souhaitez grâce à une conception modulable.",
                            style: TextStyle(
                              fontSize: 13,
                              color: Provider.of<ThemeService>(context).isDark
                                  ? darkTheme.appBarTheme.backgroundColor
                                  : lightTheme.appBarTheme.backgroundColor,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 60),
                Center(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        radius: 35,
                        backgroundColor:
                            Provider.of<ThemeService>(context).isDark
                                ? darkTheme.primaryColor
                                : lightTheme.primaryColor,
                        child: Text(
                          "2",
                          style: TextStyle(
                            fontSize: 30,
                            color: Provider.of<ThemeService>(context).isDark
                                ? darkTheme.appBarTheme.backgroundColor
                                : lightTheme.appBarTheme.backgroundColor,
                          ),
                        ),
                      ),
                      const SizedBox(width: 80),
                      Text(
                        "Application Mobile Risu",
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: Provider.of<ThemeService>(context).isDark
                              ? darkTheme.primaryColor
                              : lightTheme.primaryColor,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ConstrainedBox(
                          constraints: const BoxConstraints(
                            maxWidth: 600,
                          ),
                          child: Text(
                            "Notre application mobile, fournie avec chaque conteneur, révolutionne la manière de louer et de partager des objets. Elle permet de localiser et de louer des objets en quelques clics grâce à une carte interactive des conteneurs Risu disponibles à proximité.",
                            style: TextStyle(
                              fontSize: 18,
                              color: Provider.of<ThemeService>(context).isDark
                                  ? darkTheme.primaryColor
                                  : lightTheme.primaryColor,
                            ),
                            textAlign: TextAlign.justify,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          "Fonctionnalité",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 25,
                            color: Provider.of<ThemeService>(context).isDark
                                ? darkTheme.primaryColor
                                : lightTheme.primaryColor,
                          ),
                          textAlign: TextAlign.left,
                        ),
                        const SizedBox(height: 20),
                        RichText(
                          textAlign: TextAlign.left,
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: "Carte connectée: ",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                  color:
                                      Provider.of<ThemeService>(context).isDark
                                          ? darkTheme.primaryColor
                                          : lightTheme.primaryColor,
                                ),
                              ),
                              TextSpan(
                                text:
                                    "Trouvez facilement nos conteneneurs proche de vous !",
                                style: TextStyle(
                                  fontSize: 18,
                                  color:
                                      Provider.of<ThemeService>(context).isDark
                                          ? darkTheme.primaryColor
                                          : lightTheme.primaryColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10),
                        ConstrainedBox(
                          constraints: const BoxConstraints(
                            maxWidth: 600,
                          ),
                          child: RichText(
                            textAlign: TextAlign.left,
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: "Simple d’utilisation: ",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                    color: Provider.of<ThemeService>(context)
                                            .isDark
                                        ? darkTheme.primaryColor
                                        : lightTheme.primaryColor,
                                  ),
                                ),
                                TextSpan(
                                  text:
                                      "Cliquez sur le conteneur proche de vous et louer un des objets en 1 clic",
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Provider.of<ThemeService>(context)
                                            .isDark
                                        ? darkTheme.primaryColor
                                        : lightTheme.primaryColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    Image.asset(
                      'assets/iphone.png',
                      height: 450,
                      width: 450,
                    ),
                  ],
                ),
                const SizedBox(height: 60),
                Text(
                  "Impact Environnemental et Social",
                  style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    color: Provider.of<ThemeService>(context).isDark
                        ? darkTheme.primaryColor
                        : lightTheme.primaryColor,
                  ),
                ),
                const SizedBox(height: 10),
                ConstrainedBox(
                  constraints: const BoxConstraints(
                    maxWidth: 600,
                  ),
                  child: Text(
                    "Notre solution Risu a été conçue pour avoir un impact positif sur l'environnement et la société",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20,
                      color: Provider.of<ThemeService>(context).isDark
                          ? darkTheme.primaryColor
                          : lightTheme.primaryColor,
                    ),
                  ),
                ),
                const SizedBox(height: 80),
                Center(
                  child: Container(
                      width: 800,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              CircleAvatar(
                                radius: 20,
                                backgroundColor:
                                    Provider.of<ThemeService>(context).isDark
                                        ? darkTheme.primaryColor
                                        : lightTheme.primaryColor,
                                child: Text(
                                  "1",
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: Provider.of<ThemeService>(context)
                                            .isDark
                                        ? darkTheme.appBarTheme.backgroundColor
                                        : lightTheme
                                            .appBarTheme.backgroundColor,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 30),
                              Text(
                                "Réduction des Déplacements",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color:
                                      Provider.of<ThemeService>(context).isDark
                                          ? darkTheme.primaryColor
                                          : lightTheme.primaryColor,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 30),
                          ConstrainedBox(
                            constraints: const BoxConstraints(
                              maxWidth: 450,
                            ),
                            child: Text(
                              "En facilitant l'accès aux objets nécessaires, nous contribuons à réduire l'empreinte carbone liée aux déplacements.",
                              textAlign: TextAlign.justify,
                              style: TextStyle(
                                fontSize: 18,
                                color: Provider.of<ThemeService>(context).isDark
                                    ? darkTheme.primaryColor
                                    : lightTheme.primaryColor,
                              ),
                            ),
                          ),
                          const SizedBox(height: 30),
                          Row(
                            children: [
                              CircleAvatar(
                                radius: 20,
                                backgroundColor:
                                    Provider.of<ThemeService>(context).isDark
                                        ? darkTheme.primaryColor
                                        : lightTheme.primaryColor,
                                child: Text(
                                  "2",
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: Provider.of<ThemeService>(context)
                                            .isDark
                                        ? darkTheme.appBarTheme.backgroundColor
                                        : lightTheme
                                            .appBarTheme.backgroundColor,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 30),
                              Text(
                                "Partage d'Objets",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color:
                                      Provider.of<ThemeService>(context).isDark
                                          ? darkTheme.primaryColor
                                          : lightTheme.primaryColor,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 30),
                          ConstrainedBox(
                            constraints: const BoxConstraints(
                              maxWidth: 450,
                            ),
                            child: Text(
                              "Favoriser la location et le partage réduit la production excessive d'objets et encourage une consommation plus responsable.",
                              textAlign: TextAlign.justify,
                              style: TextStyle(
                                fontSize: 18,
                                color: Provider.of<ThemeService>(context).isDark
                                    ? darkTheme.primaryColor
                                    : lightTheme.primaryColor,
                              ),
                            ),
                          ),
                          const SizedBox(height: 30),
                          Row(
                            children: [
                              CircleAvatar(
                                radius: 20,
                                backgroundColor:
                                    Provider.of<ThemeService>(context).isDark
                                        ? darkTheme.primaryColor
                                        : lightTheme.primaryColor,
                                child: Text(
                                  "3",
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: Provider.of<ThemeService>(context)
                                            .isDark
                                        ? darkTheme.appBarTheme.backgroundColor
                                        : lightTheme
                                            .appBarTheme.backgroundColor,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 30),
                              Text(
                                "Accessibilité",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color:
                                      Provider.of<ThemeService>(context).isDark
                                          ? darkTheme.primaryColor
                                          : lightTheme.primaryColor,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 30),
                          ConstrainedBox(
                            constraints: const BoxConstraints(
                              maxWidth: 450,
                            ),
                            child: Text(
                              "Nos conteneurs et l'application rendent les objets accessibles à tous, renforçant la communauté et soutenant l'économie circulaire.",
                              textAlign: TextAlign.justify,
                              style: TextStyle(
                                fontSize: 18,
                                color: Provider.of<ThemeService>(context).isDark
                                    ? darkTheme.primaryColor
                                    : lightTheme.primaryColor,
                              ),
                            ),
                          ),
                          const SizedBox(height: 30),
                        ],
                      )),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

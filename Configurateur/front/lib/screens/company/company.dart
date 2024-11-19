import 'package:flutter/material.dart';
import 'package:footer/footer.dart';
import 'package:footer/footer_view.dart';
import 'package:front/components/custom_footer.dart';
import 'package:front/components/custom_header.dart';
import 'package:front/services/theme_service.dart';
import 'package:front/styles/themes.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
  List<Map<String, String>> getCompanyData(BuildContext context) {
    return [
      {
        "name": "Henri",
        "companyPosition": AppLocalizations.of(context)!.henriPosition,
        "image": 'assets/Henri.png',
        "description": AppLocalizations.of(context)!.henriDescription
      },
      {
        "name": "Hugo",
        "companyPosition": AppLocalizations.of(context)!.hugoPosition,
        "image": 'assets/Hugo.png',
        "description": AppLocalizations.of(context)!.hugoDescription
      },
      {
        "name": "Cédric",
        "companyPosition": AppLocalizations.of(context)!.cedricPosition,
        "image": 'assets/Cédric.png',
        "description": AppLocalizations.of(context)!.cedricDescription
      },
      {
        "name": "Louis",
        "companyPosition": AppLocalizations.of(context)!.louisPosition,
        "image": 'assets/Louis.png',
        "description": AppLocalizations.of(context)!.louisDescription
      },
      {
        "name": "Quentin",
        "companyPosition": AppLocalizations.of(context)!.quentinPosition,
        "image": 'assets/Quentin.png',
        "description": AppLocalizations.of(context)!.quentinDescription
      },
      {
        "name": "Tanguy",
        "companyPosition": AppLocalizations.of(context)!.tanguyPosition,
        "image": 'assets/Tanguy.png',
        "description": AppLocalizations.of(context)!.tanguyDescription
      },
      {
        "name": "Nathan",
        "companyPosition": AppLocalizations.of(context)!.nathanPosition,
        "image": 'assets/Nathan.png',
        "description": AppLocalizations.of(context)!.nathanDescription
      },
    ];
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final teamMembers = getCompanyData(context);
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
                            AppLocalizations.of(context)!.risuDescription,
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
                    AppLocalizations.of(context)!.risuMembers,
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
                        AppLocalizations.of(context)!.solution,
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
                          AppLocalizations.of(context)!.solutionDescription,
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
                        AppLocalizations.of(context)!.containerAndLocker,
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
                        AppLocalizations.of(context)!
                            .containerAndLockerDescription,
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
                            AppLocalizations.of(context)!.benefits,
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
                            AppLocalizations.of(context)!.personalization,
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
                            AppLocalizations.of(context)!
                                .personalizationDescription,
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
                            AppLocalizations.of(context)!.installation,
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
                            AppLocalizations.of(context)!
                                .installationDescription,
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
                        AppLocalizations.of(context)!.mobileApplication,
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
                            AppLocalizations.of(context)!
                                .mobileApplicationDescription,
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
                          AppLocalizations.of(context)!.functionality,
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
                                text:
                                    AppLocalizations.of(context)!.connectedMap,
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
                                text: AppLocalizations.of(context)!
                                    .connectedMapDescription,
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
                                  text: AppLocalizations.of(context)!.easyToUse,
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
                                  text: AppLocalizations.of(context)!
                                      .easyToUseDescription,
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
                  AppLocalizations.of(context)!.environmentalAndSocial,
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
                    AppLocalizations.of(context)!
                        .environmentalAndSocialDescription,
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
                                AppLocalizations.of(context)!.travelReduction,
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
                              AppLocalizations.of(context)!
                                  .travelReductionDescription,
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
                                AppLocalizations.of(context)!.objectSharing,
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
                              AppLocalizations.of(context)!
                                  .objectSharingDescription,
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
                                AppLocalizations.of(context)!.accessibility,
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
                              AppLocalizations.of(context)!
                                  .accessibilityDescription,
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

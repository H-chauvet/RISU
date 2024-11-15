import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:risu/components/appbar.dart';
import 'package:risu/utils/providers/theme.dart';

import 'team_page.dart';

class TeamPageState extends State<TeamPage> {
  final CarouselSliderController _carouselController =
      CarouselSliderController();

  final List<String> imagesPath = [
    'assets/Cédric.png',
    'assets/Henri.png',
    'assets/Hugo.png',
    'assets/Louis.png',
    'assets/Quentin.png',
    'assets/Nathan.png',
    'assets/Tanguy.png'
  ];

  final List<String> names = [
    'Cédric',
    'Henri',
    'Hugo',
    'Louis',
    'Quentin',
    'Nathan',
    'Tanguy'
  ];

  int indexName = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: MyAppBar(
        curveColor: context.select((ThemeProvider themeProvider) =>
            themeProvider.currentTheme.secondaryHeaderColor),
        showBackButton: false,
        textTitle: AppLocalizations.of(context)!.team,
      ),
      resizeToAvoidBottomInset: false,
      backgroundColor: context.select((ThemeProvider themeProvider) =>
          themeProvider.currentTheme.colorScheme.surface),
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 30),
              Align(
                alignment: Alignment.center,
                child: Text(
                  AppLocalizations.of(context)!.teamRentText,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: themeProvider.currentTheme.primaryColor,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                AppLocalizations.of(context)!.teamMembers,
                textAlign: TextAlign.center,
                style: TextStyle(
                  decoration: TextDecoration.underline,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: themeProvider.currentTheme.primaryColor,
                ),
              ),
              const SizedBox(height: 20),
              CarouselSlider(
                carouselController: _carouselController,
                options: CarouselOptions(
                  initialPage: 0,
                  autoPlay: true,
                  viewportFraction: 1.0,
                  onPageChanged: (index, reason) {
                    setState(() {
                      indexName = index;
                    });
                  },
                ),
                items: imagesPath.map<Widget>((imagePath) {
                  return CircleAvatar(
                    radius: 96,
                    backgroundImage: AssetImage(imagePath),
                  );
                }).toList(),
              ),
              const SizedBox(height: 8),
              Text(
                names[indexName],
                style: TextStyle(
                  fontSize: 24,
                  color: themeProvider.currentTheme.primaryColor,
                ),
              ),
              SizedBox(
                width: 200,
                height: 200,
                child: Image.asset('assets/logo.png'),
              ),
              Text(
                AppLocalizations.of(context)!.teamFindRentText,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: themeProvider.currentTheme.primaryColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

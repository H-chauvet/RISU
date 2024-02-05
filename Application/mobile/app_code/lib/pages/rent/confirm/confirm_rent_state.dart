import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:risu/components/appbar.dart';
import 'package:risu/components/burger_drawer.dart';
import 'package:risu/components/outlined_button.dart';
import 'package:risu/pages/article/article_list_data.dart';
import 'package:risu/pages/home/home_page.dart';
import 'package:risu/pages/rent/confirm/confirm_rent_page.dart';
import 'package:risu/utils/theme.dart';

class ConfirmRentState extends State<ConfirmRentPage> {
  late int hours;
  late ArticleData data;

  @override
  void initState() {
    super.initState();
    hours = widget.hours;
    data = widget.data;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: context.select((ThemeProvider themeProvider) =>
          themeProvider.currentTheme.colorScheme.background),
      appBar: MyAppBar(
        curveColor: context.select((ThemeProvider themeProvider) =>
            themeProvider.currentTheme.secondaryHeaderColor),
        showBackButton: false,
        showLogo: true,
      ),
      endDrawer: const BurgerDrawer(),
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Column(
                  children: [
                    Text(
                      'Confirmation de location:',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.underline,
                        color: context.select((ThemeProvider themeProvider) =>
                            themeProvider.currentTheme.secondaryHeaderColor),
                      ),
                    ),
                    Text(
                      data.name,
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: context.select((ThemeProvider themeProvider) =>
                            themeProvider.currentTheme.primaryColor),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              Text(
                'Résumé:',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: context.select((ThemeProvider themeProvider) =>
                      themeProvider.currentTheme.secondaryHeaderColor),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '- Prix par heure: ${data.price} euros',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: context.select((ThemeProvider themeProvider) =>
                      themeProvider.currentTheme.primaryColor),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '- Nombre d\'heure${hours > 1 ? 's' : ''}: $hours',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: context.select((ThemeProvider themeProvider) =>
                      themeProvider.currentTheme.primaryColor),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Total: ${hours * data.price} euros',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: context.select((ThemeProvider themeProvider) =>
                      themeProvider.currentTheme.secondaryHeaderColor),
                ),
              ),
              const SizedBox(height: 64),
              Center(
                child: Column(
                  children: [
                    Text(
                      'Merci pour votre location !\nN\'oubliez pas de rendre l\'article dans $hours heure${hours > 1 ? 's' : ''} !',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: context.select((ThemeProvider themeProvider) =>
                            themeProvider.currentTheme.secondaryHeaderColor),
                      ),
                    ),
                    const SizedBox(height: 32),
                    SizedBox(
                      width: double.infinity,
                      child: MyOutlinedButton(
                        key: const Key('confirm_rent-button-back_home'),
                        text: 'Retour à l\'accueil',
                        onPressed: () {
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return const HomePage();
                              },
                            ),
                            (route) => false,
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

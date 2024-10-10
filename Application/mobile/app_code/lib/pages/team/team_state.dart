import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:risu/components/appbar.dart';
import 'package:risu/components/loader.dart';
import 'package:risu/globals.dart';
import 'package:risu/pages/contact/contact_page.dart';
import 'package:risu/utils/providers/theme.dart';

import 'team_page.dart';

class TeamPageState extends State<TeamPage> {
  final LoaderManager _loaderManager = LoaderManager();

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
        textTitle: AppLocalizations.of(context)!.faq,
      ),
      resizeToAvoidBottomInset: false,
      backgroundColor: context.select((ThemeProvider themeProvider) =>
          themeProvider.currentTheme.colorScheme.surface),
      body: (_loaderManager.getIsLoading())
          ? Center(child: _loaderManager.getLoader())
          : Container(
              margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 30),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const SizedBox(height: 10),
                  Text(
                    key: const Key('need-to-join-us-text'),
                    AppLocalizations.of(context)!.needToJoinUs,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: themeProvider.currentTheme.primaryColor,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    key: const Key('some-questions-faq-text'),
                    AppLocalizations.of(context)!.someQuestionsFaq,
                    style: TextStyle(
                      fontSize: 18,
                      color: themeProvider.currentTheme.primaryColor,
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}

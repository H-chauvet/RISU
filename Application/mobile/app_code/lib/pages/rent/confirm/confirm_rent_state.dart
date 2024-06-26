import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:risu/components/alert_dialog.dart';
import 'package:risu/components/appbar.dart';
import 'package:risu/components/burger_drawer.dart';
import 'package:risu/components/loader.dart';
import 'package:risu/components/outlined_button.dart';
import 'package:risu/globals.dart';
import 'package:risu/pages/article/article_list_data.dart';
import 'package:risu/pages/home/home_page.dart';
import 'package:risu/pages/rent/confirm/confirm_rent_page.dart';
import 'package:risu/utils/errors.dart';
import 'package:risu/utils/providers/theme.dart';

class ConfirmRentState extends State<ConfirmRentPage> {
  late int hours;
  late ArticleData data;
  late int locationId;
  final LoaderManager _loaderManager = LoaderManager();

  void sendInvoice() async {
    try {
      setState(() {
        _loaderManager.setIsLoading(true);
      });
      final response = await http.post(
        Uri.parse(
            'http://$serverIp:3000/api/mobile/rent/${locationId}/invoice'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer ${userInformation?.token}',
        },
      );
      setState(() {
        _loaderManager.setIsLoading(false);
      });
      if (response.statusCode == 201) {
        if (mounted) {
          await MyAlertDialog.showInfoAlertDialog(
            context: context,
            title: AppLocalizations.of(context)!.invoiceSent,
            message: AppLocalizations.of(context)!.invoiceSentMessage,
          );
        }
      } else {
        if (mounted) {
          printServerResponse(context, response, 'sendInvoice',
              message: AppLocalizations.of(context)!
                  .errorOccurredDuringSendingInvoice);
        }
      }
    } catch (err, stacktrace) {
      if (mounted) {
        setState(() {
          _loaderManager.setIsLoading(false);
        });
        printCatchError(context, err, stacktrace,
            message:
                AppLocalizations.of(context)!.errorOccurredDuringGettingRent);
        return;
      }
    }
  }

  @override
  void initState() {
    super.initState();
    hours = widget.hours;
    data = widget.data;
    locationId = widget.locationId;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: context.select((ThemeProvider themeProvider) =>
          themeProvider.currentTheme.colorScheme.surface),
      appBar: MyAppBar(
        curveColor: context.select((ThemeProvider themeProvider) =>
            themeProvider.currentTheme.secondaryHeaderColor),
        showBackButton: false,
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
                      "${AppLocalizations.of(context)!.rentConfirmationOf}:",
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.underline,
                        color: context.select((ThemeProvider themeProvider) =>
                            themeProvider.currentTheme.primaryColor),
                      ),
                    ),
                    Text(
                      data.name,
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: context.select((ThemeProvider themeProvider) =>
                            themeProvider.currentTheme.bottomNavigationBarTheme
                                .selectedItemColor),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              Text(
                "${AppLocalizations.of(context)!.summary}:",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: context.select((ThemeProvider themeProvider) =>
                      themeProvider.currentTheme.primaryColor),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "- ${AppLocalizations.of(context)!.priceXPerHour(data.price)}",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: context.select((ThemeProvider themeProvider) =>
                      themeProvider.currentTheme.bottomNavigationBarTheme
                          .selectedItemColor),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "- ${AppLocalizations.of(context)!.hoursNumberOfHours(hours)}: $hours",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: context.select((ThemeProvider themeProvider) =>
                      themeProvider.currentTheme.bottomNavigationBarTheme
                          .selectedItemColor),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                "${AppLocalizations.of(context)!.total}: ${hours * data.price}€",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: context.select((ThemeProvider themeProvider) =>
                      themeProvider.currentTheme.primaryColor),
                ),
              ),
              const SizedBox(height: 64),
              Center(
                child: Column(
                  children: [
                    Text(
                      AppLocalizations.of(context)!.rentsThanking(hours),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: context.select((ThemeProvider themeProvider) =>
                            themeProvider.currentTheme.primaryColor),
                      ),
                    ),
                    const SizedBox(height: 32),
                    SizedBox(
                      width: double.infinity,
                      child: MyOutlinedButton(
                        text: AppLocalizations.of(context)!.receiveInvoice,
                        key: const Key('return_rent-button-receive_invoice'),
                        onPressed: () async {
                          sendInvoice();
                        },
                      ),
                    ),
                    const SizedBox(height: 32),
                    SizedBox(
                      width: double.infinity,
                      child: MyOutlinedButton(
                        key: const Key('confirm_rent-button-back_home'),
                        text: AppLocalizations.of(context)!.homeGoBack,
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

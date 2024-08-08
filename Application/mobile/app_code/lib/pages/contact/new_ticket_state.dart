import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:risu/components/appbar.dart';
import 'package:risu/components/loader.dart';
import 'package:risu/components/outlined_button.dart';
import 'package:risu/components/pop_scope_parent.dart';
import 'package:risu/components/text_input.dart';
import 'package:risu/globals.dart';
import 'package:risu/pages/contact/contact_page.dart';
import 'package:risu/utils/check_signin.dart';
import 'package:risu/utils/errors.dart';
import 'package:risu/utils/providers/theme.dart';

import 'new_ticket_page.dart';

class NewTicketState extends State<NewTicketPage> {
  String _subject = "";
  String _content = "";
  final LoaderManager _loaderManager = LoaderManager();

  @override
  void initState() {
    super.initState();
  }

  Future<bool> createTicket() async {
    late http.Response response;

    try {
      setState(() {
        _loaderManager.setIsLoading(true);
      });
      response = await http.post(Uri.parse('$baseUrl/api/mobile/ticket/'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Bearer ${userInformation?.token}',
          },
          body: jsonEncode(<String, String>{
            'content': _content,
            'title': _subject,
            'createdAt': DateTime.now().toString(),
          }));
      setState(() {
        _loaderManager.setIsLoading(false);
      });
      switch (response.statusCode) {
        case 201:
          return true;
        case 401:
          await tokenExpiredShowDialog(context);
          return false;
        default:
          if (context.mounted) {
            printServerResponse(context, response, 'createTicket',
                message: AppLocalizations.of(context)!
                    .errorOccurredDuringPostTicket);
          }
          return false;
      }
    } catch (err, stacktrace) {
      if (context.mounted) {
        setState(() {
          _loaderManager.setIsLoading(false);
        });
        printCatchError(context, err, stacktrace,
            message:
                AppLocalizations.of(context)!.errorOccurredDuringPostTicket);
        return false;
      }
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return MyPopScope(
      child: Scaffold(
        appBar: MyAppBar(
          curveColor: context.select((ThemeProvider themeProvider) =>
              themeProvider.currentTheme.secondaryHeaderColor),
          showBackButton: false,
          textTitle: AppLocalizations.of(context)!.newTicket,
        ),
        resizeToAvoidBottomInset: false,
        backgroundColor: context.select((ThemeProvider themeProvider) =>
            themeProvider.currentTheme.colorScheme.surface),
        body: (_loaderManager.getIsLoading())
            ? Center(child: _loaderManager.getLoader())
            : SingleChildScrollView(
                child: Center(
                  child: Container(
                    margin: const EdgeInsets.symmetric(
                        horizontal: 30, vertical: 30),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(height: 30),
                        const SizedBox(height: 32),
                        MyTextInput(
                          key: const Key('new-ticket-text_input-input-title'),
                          labelText: AppLocalizations.of(context)!.subject,
                          icon: Icons.subject,
                          onChanged: (value) => _subject = value,
                        ),
                        const SizedBox(height: 16),
                        MyTextInput(
                          key: const Key('new-ticket-text_input-input_message'),
                          labelText: AppLocalizations.of(context)!.message,
                          keyboardType: TextInputType.multiline,
                          onChanged: (value) => _content = value,
                          maxLines: null,
                          height: 384,
                        ),
                        const SizedBox(height: 36),
                        MyOutlinedButton(
                          text: AppLocalizations.of(context)!.send,
                          key: const Key('new-ticket-button-send_message'),
                          onPressed: () async {
                            bool success = await createTicket();
                            if (success && context.mounted) {
                              Navigator.pop(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const ContactPage(),
                                ),
                              );
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
      ),
    );
  }
}

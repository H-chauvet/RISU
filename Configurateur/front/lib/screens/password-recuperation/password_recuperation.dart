import 'package:flutter/material.dart';
import 'package:front/network/informations.dart';
import 'package:front/services/size_service.dart';
import 'package:front/styles/globalStyle.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:local_captcha/local_captcha.dart';
import 'package:front/components/custom_app_bar.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:convert';

import 'password_recuperation_style.dart';

class PasswordRecuperation extends StatefulWidget {
  const PasswordRecuperation({super.key});

  @override
  State<PasswordRecuperation> createState() => PasswordRecuperationState();
}

///
/// Password recuperation screen
///
/// page d'information pour la recuperation de mot de passe
///
class PasswordRecuperationState extends State<PasswordRecuperation> {
  final captchaController = LocalCaptchaController();
  var inputCode = '';

  @override
  void dispose() {
    captchaController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();
    final configFormData = ConfigFormData();

    String mail = '';
    ScreenFormat screenFormat = SizeService().getScreenFormat(context);

    return Scaffold(
        appBar: CustomAppBar(
          'Récupération du mot de passe',
          context: context,
        ),
        body: Center(
            child: FractionallySizedBox(
                widthFactor: screenFormat == ScreenFormat.desktop
                    ? desktopWidthFactor
                    : tabletWidthFactor,
                heightFactor: 0.7,
                child: Form(
                    key: formKey,
                    child: Column(children: <Widget>[
                      const SizedBox(height: 10),
                      SizedBox(
                        child: TextFormField(
                          key: const Key('email'),
                          decoration: InputDecoration(
                            hintText: 'Entrez votre email',
                            labelText: 'Adresse e-mail',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                          ),
                          onChanged: (String? value) {
                            mail = value!;
                          },
                          validator: (String? value) {
                            if (value == null || value.isEmpty) {
                              return 'Veuillez remplir ce champ';
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(height: 20),
                      Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            LocalCaptcha(
                              key: ValueKey(configFormData.toString()),
                              controller: captchaController,
                              height: screenFormat == ScreenFormat.desktop
                                  ? desktopCaptchaHeight
                                  : tabletCaptchaHeight,
                              width: screenFormat == ScreenFormat.desktop
                                  ? desktopCaptchaWidth
                                  : tabletCaptchaWidth,
                              backgroundColor: Colors.grey[100]!,
                              chars: configFormData.chars,
                              length: configFormData.length,
                              caseSensitive: true,
                              codeExpireAfter: const Duration(minutes: 10),
                            ),
                            const SizedBox(width: 10.0),
                            SizedBox(
                              height: 20.0,
                              width: 20.0,
                              child: InkWell(
                                child: const Icon(Icons.refresh, size: 18.0),
                                onTap: () => captchaController.refresh(),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20.0),
                      SizedBox(
                        child: TextFormField(
                          decoration: InputDecoration(
                            labelText: 'Enter code',
                            hintText: 'Enter code',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                          ),
                          validator: (value) {
                            if (value != null && value.isNotEmpty) {
                              if (value.length != configFormData.length) {
                                return '* Code must be length of ${configFormData.length}.';
                              }

                              final validation =
                                  captchaController.validate(value);

                              switch (validation) {
                                case LocalCaptchaValidation.invalidCode:
                                  return '* Invalid code.';
                                case LocalCaptchaValidation.codeExpired:
                                  return '* Code expired.';
                                case LocalCaptchaValidation.valid:
                                default:
                                  return null;
                              }
                            }

                            return '* Required field.';
                          },
                          onSaved: (value) => inputCode = value ?? '',
                        ),
                      ),
                      const SizedBox(height: 20.0),
                      SizedBox(
                        height: 40,
                        width: screenFormat == ScreenFormat.desktop
                            ? desktopSendButtonWidth
                            : tabletSendButtonWidth,
                        child: ElevatedButton(
                          key: const Key('submit'),
                          onPressed: () async {
                            if (formKey.currentState!.validate()) {
                              var response = await http.post(
                                Uri.parse(
                                    'http://$serverIp:3000/api/auth/forgot-password'),
                                headers: <String, String>{
                                  'Content-Type':
                                      'application/json; charset=UTF-8',
                                  'Access-Control-Allow-Origin': '*',
                                },
                                body: jsonEncode(<String, String>{
                                  'email': mail,
                                }),
                              );
                              if (response.statusCode == 200) {
                                Fluttertoast.showToast(
                                  msg: 'Mot de passe récupéré avec succès',
                                  toastLength: Toast.LENGTH_LONG,
                                  gravity: ToastGravity.CENTER,
                                );
                              } else {
                                Fluttertoast.showToast(
                                  msg:
                                      'Echec de la récupération du mot de message',
                                  toastLength: Toast.LENGTH_LONG,
                                  gravity: ToastGravity.CENTER,
                                );
                              }
                              context.go("/");
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                          ),
                          child: Text(
                            "Envoyer l'email de récupération",
                            style: TextStyle(
                                fontSize: screenFormat == ScreenFormat.desktop
                                    ? desktopFontSize
                                    : tabletFontSize),
                          ),
                        ),
                      ),
                    ])))));
  }
}

class ConfigFormData {
  String chars = 'abdefghnryABDEFGHNQRY3468';
  int length = 5;
  double fontSize = 0;
  bool caseSensitive = false;
  Duration codeExpireAfter = const Duration(minutes: 10);

  @override
  String toString() {
    return '$chars$length$caseSensitive${codeExpireAfter.inMinutes}';
  }
}

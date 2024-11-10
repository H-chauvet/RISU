import 'package:flutter/material.dart';
import 'package:flutter_pw_validator/Resource/Strings.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PasswordStrings implements FlutterPwValidatorStrings {
  final BuildContext context;

  @override
  String atLeast = '';

  @override
  String uppercaseLetters = '';

  @override
  String numericCharacters = '';

  @override
  String specialCharacters = '';

  @override
  String lowercaseLetters = '';

  @override
  String normalLetters = '';

  PasswordStrings(this.context) {
    atLeast = AppLocalizations.of(context)!.atLeast;
    uppercaseLetters = AppLocalizations.of(context)!.uppercaseLetters;
    numericCharacters = AppLocalizations.of(context)!.numericCharacters;
    specialCharacters = AppLocalizations.of(context)!.specialCharacters;
    lowercaseLetters = AppLocalizations.of(context)!.lowercaseLetters;
    normalLetters = AppLocalizations.of(context)!.normalLetters;
  }
}

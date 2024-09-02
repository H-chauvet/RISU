import 'package:flutter/cupertino.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:http/http.dart' as http;
import 'package:risu/components/alert_dialog.dart';

/// Print error message and show an alert dialog
void printCatchError(
  BuildContext context,
  dynamic e,
  StackTrace stacktrace, {
  String? message,
}) {
  print('====${e.toString()}====');
  print(stacktrace);
  if (message != null) {
    MyAlertDialog.showErrorAlertDialog(
      context: context,
      title: AppLocalizations.of(context)!.error,
      message: message,
    );
  }
}

/// Print server response and show an alert dialog
void printServerResponse(
  BuildContext context,
  http.Response response,
  String functionName, {
  String? message,
}) {
  print(
      '-------- $functionName(): ${response.body} (${response.statusCode})--------');
  if (message != null) {
    MyAlertDialog.showErrorAlertDialog(
      context: context,
      title: AppLocalizations.of(context)!.error,
      message: message,
    );
  }
}

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:risu/components/alert_dialog.dart';

void printCatchError(
  BuildContext context,
  dynamic e,
  StackTrace stacktrace, {
  String? message,
}) {
  print("====${e.toString()}====");
  print(stacktrace);
  if (message != null && context.mounted) {
    MyAlertDialog.showErrorAlertDialog(
        context: context, title: "Erreur", message: message);
  }
}

void printServerResponse(
  BuildContext context,
  http.Response response,
  String functionName, {
  String? message,
}) {
  print(
      "-------- $functionName(): ${response.body} (${response.statusCode})--------");
  if (message != null && context.mounted) {
    MyAlertDialog.showErrorAlertDialog(
        context: context, title: "Erreur", message: message);
  }
}

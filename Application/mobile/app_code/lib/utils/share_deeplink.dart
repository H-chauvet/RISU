import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:risu/components/toast.dart';

Future<void> createDeeplink(
    {required String path, required BuildContext context}) async {
  await Clipboard.setData(
    ClipboardData(
      text: 'https://deeplink-risu.web.app/$path',
    ),
  );
  if (context.mounted) {
    MyToastMessage.show(
        message: "Lien copié dans le presse-papier", context: context);
  }
}

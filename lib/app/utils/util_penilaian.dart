import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:input_nilai/app/ui/pages/input_nilai/page_input_verify.dart';
import 'package:input_nilai/app/ui/widgets/detail_sidang/widget_penilaian.dart';
import 'package:theme_provider/theme_provider.dart';

Future<bool> verifyUser(
    {@required BuildContext context, @required String message}) {
  return Navigator.push(
    context,
    MaterialPageRoute(
        builder: (context) => ThemeConsumer(
                child: InputVerifyPage(
              message: message,
            ))),
  );
}

tap(
    {@required BuildContext context,
    @required String message,
    @required Function(int) onAction}) async {
  String nilai = await showNilaiInputDialog(context: context);

  if (nilai != null && nilai.isNotEmpty) {
    verifyUser(context: context, message: message).then((isRealUser) {
      if (isRealUser) onAction(int.tryParse(nilai));
    });
  }
}

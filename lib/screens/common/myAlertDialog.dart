import 'package:flutter/material.dart';
import 'package:musify/styles/colors.dart';
import 'package:musify/styles/size.dart';
import '../../generated/l10n.dart';
import '../../util/mycss.dart';
import 'myTextButton.dart';

showMyAlertDialog(BuildContext context, String title, String content) {
  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (context) {
      return AlertDialog(
        titlePadding: EdgeInsets.all(16),
        contentPadding: EdgeInsets.all(16),
        backgroundColor: StyleColor.dialogBackgroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: StyleProperty.borderRadius,
        ),
        title: Text(title),
        titleTextStyle: StyleProperty.normalText,
        content: Text(content),
        contentTextStyle: StyleProperty.normalText,
        actions: <Widget>[
          MyTextButton(
            title: S.of(context).confrim,
            press: () {
              Navigator.of(context).pop();
            },
          )
        ],
      );
    },
  );
}

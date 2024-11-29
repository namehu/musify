// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:musify/services/theme_service.dart';
import 'package:musify/styles/size.dart';
import '../../generated/l10n.dart';

showMyAlertDialog(BuildContext context, String title, String content) {
  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (context) {
      return AlertDialog(
        titlePadding: EdgeInsets.all(16),
        contentPadding: EdgeInsets.all(16),
        backgroundColor: ThemeService.color.dialogBackgroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: StyleProperty.borderRadius,
        ),
        title: Text(title),
        titleTextStyle: TextStyle(
          color: ThemeService.color.textColor,
        ),
        content: Text(content),
        contentTextStyle: TextStyle(
          color: ThemeService.color.textColor,
        ),
        actions: <Widget>[
          InkWell(
            child: Text(S.current.confrim),
            onTap: () {
              Navigator.of(context).pop();
            },
          )
        ],
      );
    },
  );
}

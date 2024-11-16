import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:musify/services/theme_service.dart';
import '../../util/mycss.dart';

/// custom Toast
class MToast {
  static void show(
    String message, {
    int duration = 1000,
    BuildContext? context,
  }) {
    var _ctx = context ?? Get.context;

    assert(_ctx != null);

    OverlayEntry overlayEntry = new OverlayEntry(
      builder: (context) {
        return Positioned(
            bottom: 95,
            child: Container(
              color: Colors.transparent,
              width: MediaQuery.of(context).size.width,
              alignment: Alignment.center,
              child: Card(
                child: Padding(
                  padding: EdgeInsets.all(10),
                  child: Text(
                    message,
                    style: TextStyle(color: ThemeService.color.textColor),
                  ),
                ),
                color: badgeDark,
              ),
            ));
      },
    );

    Overlay.of(_ctx!).insert(overlayEntry);

    Future.delayed(Duration(milliseconds: duration)).then((value) {
      overlayEntry.remove();
    });
  }
}

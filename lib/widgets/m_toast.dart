import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:musify/services/theme_service.dart';
import 'package:musify/styles/colors.dart';

/// custom Toast
class MToast {
  // 显示弹窗
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
                    style: TextStyle(color: gray3),
                  ),
                ),
                color: ThemeService.color.dialogBackgroundColor,
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

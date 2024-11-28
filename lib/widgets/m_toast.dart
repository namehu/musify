import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:musify/services/theme_service.dart';
import 'package:toastification/toastification.dart';

/// custom Toast
class MToast {
  // 显示弹窗
  static void show(
    String message, {
    int duration = 1000,
    BuildContext? context,
  }) {
    var ctx = context ?? Get.context;

    assert(ctx != null);

    OverlayEntry overlayEntry = OverlayEntry(
      builder: (context) {
        return Positioned(
            bottom: 95,
            child: Container(
              // color: Colors.transparent,
              width: MediaQuery.of(context).size.width,
              alignment: Alignment.center,
              child: Card(
                color: ThemeService.color.dialogBackgroundColor,
                child: Padding(
                  padding: EdgeInsets.all(10),
                  child: Text(message),
                ),
              ),
            ));
      },
    );

    Overlay.of(ctx!).insert(overlayEntry);

    Future.delayed(Duration(milliseconds: duration)).then((value) {
      overlayEntry.remove();
    });
  }

  static success(String title, [String? description]) {
    toastification.show(
      context: Get.context,
      type: ToastificationType.success,
      style: ToastificationStyle.flat,
      title: Text(title),
      description: description != null ? Text(description) : null,
      alignment: Alignment.bottomCenter,
      autoCloseDuration: const Duration(seconds: 2),
      showProgressBar: false,
      borderRadius: BorderRadius.circular(12.0),
      closeButtonShowType: CloseButtonShowType.none,
    );
  }
}

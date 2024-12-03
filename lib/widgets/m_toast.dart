import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:musify/services/theme_service.dart';
import 'package:toastification/toastification.dart';

class MToast {
  static ToastificationItem? toastificationInstance;

  static var borderRadius = BorderRadius.circular(12.0);
  static ToastificationAnimationBuilder animationBuilder = (
    context,
    animation,
    alignment,
    child,
  ) {
    return FadeTransition(
      opacity: animation,
      child: child,
    );
  };

  static EdgeInsetsGeometry maring =
      EdgeInsets.symmetric(horizontal: (Get.width - 10) / 2);

  static error(
    String title, {
    String? message,
    Widget? content,
  }) {
    return show(
      title,
      message: message,
      content: content,
      type: ToastificationType.error,
    );
  }

  static info(
    String title, {
    String? message,
    Widget? content,
  }) {
    return show(
      title,
      message: message,
      content: content,
      type: ToastificationType.info,
    );
  }

  static warning(
    String title, {
    String? message,
    Widget? content,
  }) {
    return show(
      title,
      message: message,
      content: content,
      type: ToastificationType.warning,
    );
  }

  static success(
    String title, {
    String? message,
    Widget? content,
  }) {
    return show(
      title,
      message: message,
      content: content,
      type: ToastificationType.success,
    );
  }

  static show(
    String title, {
    String? message,
    Widget? content,
    ToastificationType? type = ToastificationType.info,
  }) {
    late Color primaryColor; // icon color
    switch (type) {
      case ToastificationType.success:
        primaryColor = Colors.green;
        break;
      case ToastificationType.warning:
        primaryColor = Colors.orange;
        break;
      case ToastificationType.error:
        primaryColor = Colors.red;
        break;
      default:
        primaryColor = Colors.blue;
        break;
    }

    if (toastificationInstance != null) {
      toastification.dismiss(toastificationInstance!);
    }

    var iconMargin = type! == ToastificationType.info ? 20 : 90;
    var margin = (375 - (title.length * 18 + iconMargin)) / 2;

    toastificationInstance = toastification.show(
      context: Get.context,
      type: type,
      style: type == ToastificationType.info
          ? ToastificationStyle.simple
          : ToastificationStyle.flat,
      title: Center(child: Text(title)),
      description: content ?? (message != null ? Text(message) : null),
      alignment: Alignment(0, 0.6),
      primaryColor: primaryColor,
      foregroundColor: ThemeService.color.textColor,
      backgroundColor: ThemeService.color.dialogBackgroundColor,
      borderSide: BorderSide(
        color: ThemeService.color.dialogBackgroundColor,
      ),
      borderRadius: borderRadius,
      boxShadow: lowModeShadow,
      closeButtonShowType: CloseButtonShowType.none,
      autoCloseDuration: const Duration(seconds: 2),
      animationBuilder: animationBuilder,
      margin: EdgeInsets.symmetric(horizontal: margin),
      showProgressBar: false,
      callbacks: ToastificationCallbacks(
        onAutoCompleteCompleted: (value) {
          toastificationInstance = null;
        },
        onDismissed: (value) {
          toastificationInstance = null;
        },
      ),
    );

    return toastificationInstance;
  }
}

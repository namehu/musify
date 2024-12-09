import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:musify/services/theme_service.dart';
import 'package:toastification/toastification.dart';

class MNotification {
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

  static EdgeInsetsGeometry maring = EdgeInsets.symmetric(horizontal: 50);

  static error(
    String? title, {
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
    String? title, {
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
    String? title, {
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
    String? title, {
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
    String? title, {
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

    return toastification.show(
      context: Get.context,
      type: type,
      style: ToastificationStyle.flat,
      title: title != null ? Text(title) : null,
      description: content ?? (message != null ? Text(message) : null),
      alignment: Alignment.center,
      primaryColor: primaryColor,
      foregroundColor: ThemeService.color.textColor,
      backgroundColor: ThemeService.color.dialogBackgroundColor,
      borderSide: BorderSide(
        color: ThemeService.color.dialogBackgroundColor,
      ),
      borderRadius: borderRadius,
      boxShadow: lowModeShadow,
      dragToClose: true,
      animationBuilder: animationBuilder,
      margin: maring,
      showProgressBar: false,
    );
  }
}

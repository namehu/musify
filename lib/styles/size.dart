import 'package:flutter/material.dart';

class StyleSize {
  static const double borderRadius = 10;
  static const double space = 15; // 默认间距
  static const double spaceLarge = 25; // 大间距
}

class StyleProperty {
  static const borderRadius =
      BorderRadius.all(Radius.circular(StyleSize.borderRadius));

  static const normalText = TextStyle(
    fontSize: 14,
    color: Colors.white,
  );
}

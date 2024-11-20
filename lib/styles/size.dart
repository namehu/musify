import 'package:flutter/material.dart';

class StyleSize {
  static const double headSize = 30;
  static const double titleSize = 20;
  static const double fontSize = 14;
  static const double borderRadius = 10;

  static const double spaceSmall = 10; // 默认间距
  static const double space = 15; // 默认间距
  static const double spaceLarge = 25; // 大间距

  static const double listItemHeight = 50; // 列表项高度
}

class StyleProperty {
  static const borderRadius = BorderRadius.all(
    Radius.circular(StyleSize.borderRadius),
  );
}

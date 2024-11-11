import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class StyleSize {
  static const double borderRadius = 10;
}

class StyleProperty {
  static const borderRadius =
      BorderRadius.all(Radius.circular(StyleSize.borderRadius));

  static const normalText = TextStyle(
    fontSize: 14,
    color: Colors.white,
  );
}

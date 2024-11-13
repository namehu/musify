import 'package:flutter/material.dart';

const gray1 = Color.fromRGBO(255, 255, 255, 1);
const gray2 = Color.fromRGBO(250, 250, 250, 1);
const gray3 = Color.fromRGBO(245, 245, 245, 1);
const gray4 = Color.fromRGBO(240, 240, 240, 1);
const gray5 = Color.fromRGBO(217, 217, 217, 1);
const gray6 = Color.fromRGBO(191, 191, 191, 1);
const gray7 = Color.fromRGBO(140, 140, 140, 1);
const gray8 = Color.fromRGBO(89, 89, 89, 1);
const gray9 = Color.fromRGBO(67, 67, 67, 1);
const gray10 = Color.fromRGBO(38, 38, 38, 1);
const gray11 = Color.fromRGBO(31, 31, 31, 1);
const gray12 = Color.fromRGBO(20, 20, 20, 1);
const gray13 = Color.fromRGBO(0, 0, 0, 1);

typedef ColorMapType = ({
  /// 背景色
  Color bgColor,
  Color secondBgColor,
  Color dialogBackgroundColor,

  /// 按钮主色
  Color primaryButtonColor,

  /// 卡片背景颜色
  Color cardColor
});

ColorMapType normalColorMap = (
  primaryButtonColor: Color.fromRGBO(234, 21, 57, 1),
  bgColor: gray3,
  secondBgColor: gray11,
  dialogBackgroundColor: gray10,
  cardColor: Colors.white,
);

ColorMapType darkColorMap = (
  primaryButtonColor: Color.fromRGBO(234, 21, 57, 1),
  bgColor: gray12,
  secondBgColor: gray11,
  dialogBackgroundColor: gray10,
  cardColor: gray9
);

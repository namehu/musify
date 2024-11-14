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
  Color titleColor, // 标题文本
  Color textColor, // 一级文本
  Color textSecondColor, // 二级文本
  Color textPrimaryColor, // 文本主色
  Color textDisabledColor, // 禁用字体
  Color borderColor, // 边框颜色
  Color dividerColor, // 分割线颜色
  Color bgColor, // 背景色
  Color secondBgColor, // 次级背景色
  Color dialogBackgroundColor, // 弹窗给背景色
  Color cardColor, // 卡片背景颜色
  Color iconColor, // 图标颜色

  Color primaryButtonColor, // 按钮主色
  Color secondaryButtonColor, // 按钮次色
});

ColorMapType normalColorMap = (
  titleColor: Color.fromRGBO(0, 0, 0, 0.88),
  textColor: Color.fromRGBO(0, 0, 0, 0.88),
  textSecondColor: Color.fromRGBO(0, 0, 0, 0.65),
  textPrimaryColor: Color.fromRGBO(234, 21, 57, 1),
  textDisabledColor: Color.fromRGBO(0, 0, 0, 0.25),
  borderColor: Color.fromRGBO(217, 217, 217, 1),
  dividerColor: Color.fromRGBO(5, 5, 5, 0.06),
  bgColor: gray3,
  secondBgColor: gray11,
  dialogBackgroundColor: gray10,
  cardColor: Colors.white,
  iconColor: gray2,
  primaryButtonColor: Color.fromRGBO(234, 21, 57, 1),
  secondaryButtonColor: Color.fromRGBO(94, 32, 237, 1),
);

ColorMapType darkColorMap = (
  titleColor: Color.fromRGBO(255, 255, 255, 0.85),
  textColor: Color.fromRGBO(255, 255, 255, 0.85),
  textSecondColor: Color.fromRGBO(255, 255, 255, 0.65),
  textPrimaryColor: Color.fromRGBO(234, 21, 57, 1),
  textDisabledColor: Color.fromRGBO(255, 255, 255, 0.25),
  borderColor: Color.fromRGBO(66, 66, 66, 1),
  dividerColor: Color.fromRGBO(253, 253, 253, 0.12),
  bgColor: gray13,
  secondBgColor: gray11,
  dialogBackgroundColor: gray10,
  cardColor: gray9,
  iconColor: gray2,
  primaryButtonColor: Color.fromRGBO(234, 21, 57, 1),
  secondaryButtonColor: Color.fromRGBO(94, 32, 237, 1),
);

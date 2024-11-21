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

const normalTitleColor = Color.fromRGBO(0, 0, 0, 0.88);
const darkTitleColor = Color.fromRGBO(255, 255, 255, 0.85);

const Color normalTextColor = Color.fromRGBO(0, 0, 0, 0.88);
const Color darkTextColor = Color.fromRGBO(255, 255, 255, 0.85);

const dialogBackgroundColor = Color.fromARGB(255, 52, 53, 54);

const primaryColor = MaterialColor(
  -1436359,
  const <int, Color>{
    50: const Color(-1436359),
    100: const Color(-1436359),
    200: const Color(-1436359),
    300: const Color(-1436359),
    400: const Color(-1436359),
    500: const Color(-1436359),
    600: const Color(-1436359),
    700: const Color(-1436359),
    800: const Color(-1436359),
    900: const Color(-1436359),
  },
);

typedef ColorMapType = ({
  Color titleColor, // 标题文本
  MaterialColor primaryColor, // 主色
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

  Color musicBarColor, // 音乐栏背景色
  Color sliderBorderColor // 滑动条边框颜色
});

ColorMapType normalColorMap = (
  titleColor: normalTitleColor,
  primaryColor: primaryColor,
  textColor: normalTextColor,
  textSecondColor: Color.fromRGBO(0, 0, 0, 0.65),
  textPrimaryColor: Color.fromRGBO(234, 21, 57, 1),
  textDisabledColor: Color.fromRGBO(0, 0, 0, 0.25),
  borderColor: Color.fromRGBO(217, 217, 217, 1),
  dividerColor: gray4,
  bgColor: gray2,
  secondBgColor: gray1,
  dialogBackgroundColor: gray1,
  cardColor: Colors.white,
  iconColor: gray6,
  primaryButtonColor: Color.fromRGBO(234, 21, 57, 1),
  secondaryButtonColor: Color.fromRGBO(94, 32, 237, 1),
  musicBarColor: Colors.black,
  sliderBorderColor: Colors.grey,
);

ColorMapType darkColorMap = (
  titleColor: darkTitleColor,
  primaryColor: primaryColor,
  textColor: darkTextColor,
  textSecondColor: Color.fromRGBO(255, 255, 255, 0.65),
  textPrimaryColor: Color.fromRGBO(234, 21, 57, 1),
  textDisabledColor: Color.fromRGBO(255, 255, 255, 0.25),
  borderColor: Color.fromRGBO(66, 66, 66, 1),
  dividerColor: Color.fromRGBO(253, 253, 253, 0.12),
  bgColor: gray13,
  secondBgColor: gray11,
  dialogBackgroundColor: dialogBackgroundColor,
  cardColor: gray9,
  iconColor: gray2,
  primaryButtonColor: Color.fromRGBO(234, 21, 57, 1),
  secondaryButtonColor: Color.fromRGBO(94, 32, 237, 1),
  musicBarColor: dialogBackgroundColor,
  sliderBorderColor: Colors.grey,
);

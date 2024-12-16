import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:musify/constant.dart';
import 'package:musify/styles/colors.dart';
import 'package:musify/styles/size.dart';

ThemeData getThemData() {
  return ThemeData(
    useMaterial3: true,
  );
}

class ThemeService extends GetxService {
  static final mode = ThemeMode.light.obs;

  static const _modeKey = "theme_mode"; // 用于持久化存储的key

  static const Map<int, ThemeMode> modeMap = {
    0: ThemeMode.system,
    1: ThemeMode.light,
    2: ThemeMode.dark,
  };

  static String get modekey {
    var item = ThemeService.modeMap.entries
        .firstWhere(((element) => element.value == ThemeService.mode.value));
    return item.key.toString();
  }

  Future<ThemeService> init() async {
    // mode.value = ThemeService.getThemeMode();
    return this;
  }

  /// 设置主题模式
  static Future setThemeMode(int key) async {
    var themeMode =
        modeMap.entries.firstWhere(((element) => element.key == key));
    mode.value = themeMode.value;

    return await sharedPreferences.setInt(_modeKey, themeMode.key);
  }

  /// 获取主题模式
  static ThemeMode getThemeMode() {
    int? result = sharedPreferences.getInt(_modeKey);
    var mode = modeMap[modeMap.keys.contains(result) ? result : 2]!;
    return mode;
  }

  /// 获取当前主题
  static get theme {
    var primaryColor = ThemeService.color.primaryColor;

    if (ThemeService.mode.value == ThemeMode.dark) {
      var colorSchme = ColorScheme.dark();
      return ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: ThemeService.color.bgColor,
        primaryColor: primaryColor,
        colorScheme: colorSchme.copyWith(primary: primaryColor),
        primarySwatch: primaryColor,
        appBarTheme: AppBarTheme().copyWith(color: ThemeService.color.bgColor),
      );
    }

    var colorSchme = ColorScheme.light();
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: ThemeService.color.bgColor,
      primaryColor: primaryColor,
      colorScheme: colorSchme.copyWith(primary: primaryColor),
      primarySwatch: primaryColor,
      appBarTheme: AppBarTheme().copyWith(
        iconTheme: IconThemeData(color: gray1),
        color: primaryColor,
        titleTextStyle: TextStyle(color: gray1, fontSize: StyleSize.titleSize),
        toolbarTextStyle: TextStyle(color: gray1),
      ),
      tabBarTheme: TabBarTheme(
        labelColor: gray1,
        unselectedLabelColor: ThemeService.color.textSecondColor,
        indicatorColor: gray1,
        indicator: BoxDecoration(
          border: Border(
            bottom: BorderSide(width: 2, color: gray1),
          ),
        ),
      ),
      iconButtonTheme: IconButtonThemeData(
        style: ButtonStyle(
          iconColor: WidgetStateProperty.all(gray1),
        ),
      ),
    );
  }

  static ColorMapType get color {
    return ThemeService.mode.value == ThemeMode.dark
        ? darkColorMap
        : normalColorMap;
  }

  static get subTextStyle {
    return TextStyle(
      fontSize: 12,
      color: ThemeService.color.textSecondColor,
    );
  }
}

///  useMaterial3: true,
// brightness: Brightness.dark, // 应用主题亮度，可选（dark、light）
// VisualDensity visualDensity, // 视觉密度
// MaterialColor primarySwatch, // 主要样式，设置primaryColor后该背景色会被覆盖
// Color primaryColor // 主要部分背景颜色（导航和tabBar等）
// Brightness primaryColorBrightness, // primaryColor的亮度
// Color primaryColorLight, // primaryColor的浅色版
// Color primaryColorDark, // primaryColor的深色版
// Color accentColor, // 前景色（文本，按钮等）
// Brightness accentColorBrightness, // accentColor的亮度
// Color canvasColor, // MaterialType.canvas 的默认颜色
// Color shadowColor, // 阴影颜色
// Color scaffoldBackgroundColor // Scaffold的背景颜色。典型Material应用程序或应用程序内页面的背景颜色
// Color bottomAppBarColor, // BottomAppBar的默认颜色
// Color cardColor, // Card的颜色
// Color dividerColor, // Divider和PopupMenuDivider的颜色，也用于ListTile之间、DataTable的行之间等。
// Color focusColor, // 突出颜色
// Color hoverColor, //  hoverColor
// Color highlightColor, // 高亮颜色,选中在泼墨动画期间使用的突出显示颜色，或用于指示菜单中的项。
// Color splashColor, // 墨水飞溅的颜色。InkWell
// InteractiveInkFeatureFactory splashFactory, // 定义由InkWell和InkResponse反应产生的墨溅的外观。
// Color selectedRowColor, // 用于突出显示选定行的颜色。
// Color unselectedWidgetColor, // 用于处于非活动(但已启用)状态的小部件的颜色。例如，未选中的复选框。通常与accentColor形成对比。也看到disabledColor。
// Color disabledColor, // 禁用状态下部件的颜色，无论其当前状态如何。例如，一个禁用的复选框(可以选中或未选中)。
// Color buttonColor, // RaisedButton按钮中使用的Material 的默认填充颜色。
// ButtonThemeData buttonTheme, // 定义按钮部件的默认配置，
// ToggleButtonsThemeData toggleButtonsTheme, // 切换按钮的主题
// Color secondaryHeaderColor, // 选定行时PaginatedDataTable标题的颜色。
// Color textSelectionColor, // 文本框中文本选择的颜色，如TextField
// Color cursorColor, // 文本框中光标的颜色，如TextField
// Color textSelectionHandleColor, // 调整当前选定的文本部分的句柄的颜色。
// Color backgroundColor, // 与主色形成对比的颜色，例如用作进度条的剩余部分。
// Color dialogBackgroundColor, // Dialog元素的背景颜色
// Color indicatorColor, // 选项卡中选定的选项卡指示器的颜色。
// Color hintColor, // 用于提示文本或占位符文本的颜色，例如在TextField中。
// Color errorColor, // 用于输入验证错误的颜色，例如在TextField中
// Color toggleableActiveColor, // 用于突出显示Switch、Radio和Checkbox等可切换小部件的活动状态的颜色。
// String fontFamily, // 文本字体
// TextTheme textTheme, // 文本的颜色与卡片和画布的颜色形成对比。
// TextTheme primaryTextTheme, // 与primaryColor形成对比的文本主题
// TextTheme accentTextTheme, // 与accentColor形成对比的文本主题。
// InputDecorationTheme inputDecorationTheme, // 基于这个主题的 InputDecorator、TextField和TextFormField的默认InputDecoration值。
// TabBarTheme tabBarTheme, // 用于自定义选项卡栏指示器的大小、形状和颜色的主题。
// TooltipThemeData tooltipTheme, // tooltip主题
// CardTheme cardTheme, // Card的颜色和样式
// AppBarTheme appBarTheme, // appBar主题
// ColorScheme colorScheme, // 拥有13种颜色，可用于配置大多数组件的颜色。
// NavigationRailThemeData navigationRailTheme, // 导航边栏主题
// fontFamily: 'NotoSansSC',
// brightness: Brightness.dark,
///
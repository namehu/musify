import 'package:flutter/widgets.dart';
import 'package:logger/logger.dart';
import 'package:musify/models/database/database.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// app名称
// ignore: constant_identifier_names
const String APP_NAME = 'Musify';

//底部高度
const double bottomHeight = 80;

/// appbar 图标默认宽度
const double appBarActionWith = 56;

/// 全局key
/// 用于全局overlay context获取
GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

/// 全局唯一存储实例
late SharedPreferences sharedPreferences;

late Logger logger;

/// 状态栏高度
late double statusBarHeight;

late final AppDatabase database;

import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

const String APP_NAME = 'Musify';

/// 全局key
/// 用于全局overlay context获取
GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

/// 全局唯一存储实例
late SharedPreferences sharedPreferences;

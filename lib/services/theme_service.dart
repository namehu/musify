import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:musify/services/preferences_service.dart';

class ThemeService extends GetxService {
  static final mode = ThemeMode.dark.obs;

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
    return this;
  }

  /// 设置主题模式
  static Future setThemeMode(int key) async {
    var _themeMode =
        modeMap.entries.firstWhere(((element) => element.key == key));
    mode.value = _themeMode.value;

    return await PreferencesService.instance.setInt(_modeKey, _themeMode.key);
  }

  /// 获取主题模式
  static ThemeMode getThemeMode() {
    int? result = PreferencesService.instance.getInt(_modeKey);
    var mode = modeMap[modeMap.keys.contains(result) ? result : 2]!;
    return mode;
  }
}

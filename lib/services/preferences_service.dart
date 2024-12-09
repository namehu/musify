import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum PreferencesEnum {
  /// 服务器Id
  serverId('serverId', ''),

  /// 服务器类型
  serverType('serverType', '');

  final String key;
  final String description;

  const PreferencesEnum(this.key, this.description);
}

class PreferencesService extends GetxService {
  static late SharedPreferences instance;

  Future<PreferencesService> init(SharedPreferences sharedPreferences) async {
    instance = sharedPreferences;
    return this;
  }

  static String getString(PreferencesEnum key, [String defaultValue = '']) {
    return PreferencesService.instance.getString(key.key) ?? defaultValue;
  }

  static bool getBool(PreferencesEnum key) {
    return PreferencesService.instance.getBool(key.key) ?? false;
  }

  static int getInt(PreferencesEnum key) {
    return PreferencesService.instance.getInt(key.key) ?? 0;
  }

  static double getDouble(PreferencesEnum key) {
    return PreferencesService.instance.getDouble(key.key) ?? 0.0;
  }

  static List<String> getStringList(PreferencesEnum key) {
    return PreferencesService.instance.getStringList(key.key) ?? [];
  }

  static remove(PreferencesEnum key) {
    PreferencesService.instance.remove(key.key);
  }

  static clear() {
    PreferencesService.instance.clear();
  }

  static Future<bool> setString(PreferencesEnum key, String value) async {
    return await PreferencesService.instance.setString(key.key, value);
  }

  static Future<bool> setBool(PreferencesEnum key, bool value) async {
    return await PreferencesService.instance.setBool(key.key, value);
  }

  static Future<bool> setInt(PreferencesEnum key, int value) async {
    return await PreferencesService.instance.setInt(key.key, value);
  }

  static Future<bool> setDouble(PreferencesEnum key, double value) async {
    return await PreferencesService.instance.setDouble(key.key, value);
  }

  static Future<bool> setStringList(
      PreferencesEnum key, List<String> value) async {
    return await PreferencesService.instance.setStringList(key.key, value);
  }
}

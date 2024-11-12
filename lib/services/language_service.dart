import 'dart:ui';

import 'package:get/get.dart';
import 'package:musify/services/preferences_service.dart';

import '../generated/l10n.dart';

class LanguageService extends GetxService {
  var ser = Get.find<PreferencesService>();
  var _languageCode = 'zh'.obs;

  get languageCode => _languageCode.value;
  set languageCode(value) {
    _languageCode.value = value;
  }

  Future<LanguageService> init() async {
    final prefs = PreferencesService.instance;
    languageCode = prefs.getString('languageCode') ?? 'zh';
    return this;
  }

  /// 加载国际化
  loadLanguage(String languageCode) async {
    switch (languageCode) {
      case "en":
        S.load(Locale('en', ''));
        break;
      case "zh":
        S.load(Locale('zh', ''));
        break;
      case "zh_Hans":
        S.load(Locale('zh', 'Hans'));
        break;
      case "zh_Hant":
        S.load(Locale('zh', 'Hant'));
        break;
      default:
        S.load(Locale('zh', ''));
        break;
    }
    print(languageCode);
  }

  /// 修改语言
  changeLanguage(String languageCode) async {
    languageCode = languageCode;
    loadLanguage(languageCode);
    PreferencesService.instance.setString('languageCode', languageCode);
  }
}

import 'dart:ui';
import 'package:get/get.dart';
import '../constant.dart';
import '../generated/l10n.dart';

class LanguageService extends GetxService {
  var languageCode = 'zh'.obs;

  Future<LanguageService> init() async {
    languageCode.value = sharedPreferences.getString('languageCode') ?? 'zh';
    return this;
  }

  /// 加载国际化
  loadLanguage(String code) async {
    switch (code) {
      case "en":
        await S.load(Locale('en', ''));
        break;
      case "zh":
        await S.load(Locale('zh', ''));
        break;
      case "zh_Hans":
        await S.load(Locale('zh', 'Hans'));
        break;
      case "zh_Hant":
        await S.load(Locale('zh', 'Hant'));
        break;
      default:
        await S.load(Locale('zh', ''));
        break;
    }
  }

  /// 修改语言
  changeLanguage(String code) async {
    try {
      await loadLanguage(code);
      await sharedPreferences.setString('languageCode', code);
    } catch (e) {
      logger.e('修改失败');
    } finally {
      languageCode.value = code;
    }
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:musify/generated/l10n.dart';
import 'package:musify/models/database/database.dart';
import 'package:musify/services/language_service.dart';
import 'package:musify/services/server_service.dart';
import 'package:musify/services/theme_service.dart';
import 'package:musify/util/mycss.dart';

class SettingController extends GetxController {
  final serverService = Get.find<ServerService>();
  final languageService = Get.find<LanguageService>();
  final themeService = Get.find<ThemeService>();

  ServerTableData get sever => serverService.serverInfo.value;

  final selectedSort = 'en'.obs;
  final lanMenuItems = <DropdownMenuItem<String>>[].obs;
  final themeMenuItems = <DropdownMenuItem<String>>[].obs;

  Worker? _codeWork;

  @override
  void onInit() {
    super.onInit();
    // print('init setting');
    selectedSort.value = languageService.languageCode.value;
    setMenuItems();
    // print('${selectedSort.value}   ${languageService.languageCode.value}');
    _codeWork = ever(languageService.languageCode, (_) {
      setMenuItems();
    });
  }

  @override
  void onClose() {
    super.onClose();

    if (_codeWork != null) {
      _codeWork!.dispose();
    }
  }

  setMenuItems() {
    lanMenuItems.value = [
      DropdownMenuItem(
          value: "en", child: Text(S.current.english, style: nomalText)),
      DropdownMenuItem(
          value: "zh", child: Text(S.current.chinese, style: nomalText)),
      DropdownMenuItem(
          value: "zh_Hant",
          child: Text(S.current.traditional, style: nomalText))
    ];

    themeMenuItems.value = [
      DropdownMenuItem(value: "2", child: Text('dark', style: nomalText)),
      DropdownMenuItem(value: "1", child: Text('light', style: nomalText)),
    ];
  }
}

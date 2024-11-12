import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:musify/generated/l10n.dart';
import 'package:musify/models/myModel.dart';
import 'package:musify/services/language_service.dart';
import 'package:musify/services/server_service.dart';
import 'package:musify/util/mycss.dart';

class SettingController extends GetxController {
  final serverService = Get.find<ServerService>();
  final languageService = Get.find<LanguageService>();

  ServerInfo get sever => serverService.serverInfo.value;

  final sortItems = <DropdownMenuItem<String>>[].obs;
  final selectedSort = 'en'.obs;

  get title => selectedSort.value == 'en' ? "setting" : '设置';

  Worker? _codeWork;

  @override
  void onInit() {
    super.onInit();
    // print('init setting');
    selectedSort.value = languageService.languageCode.value;
    setSortItems();
    // print('${selectedSort.value}   ${languageService.languageCode.value}');
    _codeWork = ever(languageService.languageCode, (_) {
      setSortItems();
    });
  }

  @override
  void onClose() {
    super.onClose();

    if (_codeWork != null) {
      _codeWork!.dispose();
    }
  }

  setSortItems() {
    sortItems.value = [
      DropdownMenuItem(
          value: "en", child: Text(S.current.english, style: nomalText)),
      DropdownMenuItem(
          value: "zh", child: Text(S.current.chinese, style: nomalText)),
      DropdownMenuItem(
          value: "zh_Hans",
          child: Text(S.current.simplified, style: nomalText)),
      DropdownMenuItem(
          value: "zh_Hant",
          child: Text(S.current.traditional, style: nomalText))
    ];
  }
}

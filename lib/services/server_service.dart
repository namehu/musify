import 'dart:ui';

import 'package:get/get.dart';
import 'package:musify/models/myModel.dart';
import 'package:musify/models/notifierValue.dart';
import 'package:musify/routes/pages.dart';
import 'package:musify/util/dbProvider.dart';

import '../generated/l10n.dart';

class ServerService extends GetxService {
  /// 当前服务器信息
  var serverInfo = ServerInfo(
    baseurl: '',
    hash: '',
    neteaseapi: '',
    salt: '',
    username: '',
    languageCode: '',
  ).obs;

  Future<ServerService> init() async {
    final _serverInfo = await DbProvider.instance.getServerInfo();
    if (_serverInfo != null) {
      // TODO: 移除serversInfo
      serversInfo.value = _serverInfo;
      updateCurrentServerInfo(_serverInfo);
    } else {
      // Get.toNamed(Routes.LOGIN);
    }

    return this;
  }

  /// 更新当前服务器信息
  /// 同时重新加载国际化
  updateCurrentServerInfo(ServerInfo sInfo) {
    serverInfo.value = sInfo;
    switch (serversInfo.value.languageCode) {
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
  }
}

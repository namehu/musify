import 'dart:ui';
import 'package:get/get.dart';
import 'package:musify/models/myModel.dart';
import 'package:musify/models/notifierValue.dart';
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
      updateCurrentServerInfo(_serverInfo);
    }

    return this;
  }

  /// 更新当前服务器信息
  /// 同时重新加载国际化
  updateCurrentServerInfo(ServerInfo sInfo) {
    // TODO: 移除serversInfo
    serversInfo.value = sInfo;
    serverInfo.value = sInfo;
  }
}

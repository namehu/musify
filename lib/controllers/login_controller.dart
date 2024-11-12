import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:musify/models/myModel.dart';
import 'package:musify/models/notifierValue.dart';
import 'package:musify/routes/pages.dart';
import 'package:musify/screens/common/myAlertDialog.dart';
import 'package:musify/services/server_service.dart';
import 'package:musify/util/dbProvider.dart';

import '../generated/l10n.dart';
import '../util/httpclient.dart';
import '../util/util.dart';

class LoginController extends GetxController {
  var serverService = Get.find<ServerService>();

  get serversInfo => serverService.serverInfo;

  final servercontroller = new TextEditingController();
  final usernamecontroller = new TextEditingController();
  final passwordcontroller = new TextEditingController();

  @override
  void onInit() {
    super.onInit();

    // FIXME: 测试用
    servercontroller.text = 'http://namehu.i234.me:4533';
    usernamecontroller.text = 'navidrome';
    passwordcontroller.text = 'Navidrome';
  }

  /// 点击提交按钮
  handleSubmit(BuildContext context) async {
    String serverURL = servercontroller.text.toString().trim();
    String username = usernamecontroller.text.toString().trim();
    String password = passwordcontroller.text.toString().trim();

    if (serverURL.endsWith("/")) {
      serverURL = serverURL.substring(0, serverURL.length - 1);
    }

    if (serverURL == "" || username == "" || password == "") {
      return showMyAlertDialog(context, S.current.notive, S.current.noContent);
    }

    var status = await testServer(serverURL, username, password);

    if (!status) {
      return showMyAlertDialog(context, S.current.notive, S.current.serverErr);
    }

    final _randomNumber = generateRandomString();
    final _randomBytes = utf8.encode(password + _randomNumber);
    final _randomString = md5.convert(_randomBytes).toString();

    ServerInfo _serverInfo = ServerInfo(
      baseurl: serverURL,
      username: usernamecontroller.text.toString(),
      salt: _randomNumber,
      hash: _randomString,
      neteaseapi: "",
      languageCode: '',
    );

    // TODO: 查询数据库是否已经有存在的服务器信息
    await DbProvider.instance.addServerInfo(_serverInfo);
    serverService.updateCurrentServerInfo(_serverInfo);

    indexValue.value = 0;

    Get.offNamed(Routes.HOME);
  }
}

import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:musify/generated/l10n.dart';
import 'package:musify/models/myModel.dart';
import 'package:musify/models/notifierValue.dart';
import 'package:musify/routes/pages.dart';
import 'package:musify/screens/common/myAlertDialog.dart';
import 'package:musify/services/server_service.dart';
import 'package:musify/util/dbProvider.dart';
import 'package:musify/util/httpclient.dart';
import 'package:musify/util/util.dart';

class LoginController extends GetxController {
  var serverService = Get.find<ServerService>();

  get serversInfo => serverService.serverInfo;

  final servercontroller = new TextEditingController();
  final usernamecontroller = new TextEditingController();
  final passwordcontroller = new TextEditingController();

  final loading = false.obs;

  RxInt? editId; // 编辑数据id

  @override
  void onInit() {
    super.onInit();

    if (Get.arguments != null && Get.arguments is ServerInfo) {
      var args = Get.arguments as ServerInfo;
      print(args.toJson());
      editId = args.id!.obs;
      servercontroller.text = args.baseurl;
      usernamecontroller.text = args.username;
    }
  }

  @override
  void onClose() {
    super.onClose();

    servercontroller.dispose();
    usernamecontroller.dispose();
    passwordcontroller.dispose();
  }

  /// 点击提交按钮
  handleSubmit(BuildContext context) async {
    String baseurl = servercontroller.text.toString().trim();
    String username = usernamecontroller.text.toString().trim();
    String password = passwordcontroller.text.toString().trim();

    if (baseurl.endsWith("/")) {
      baseurl = baseurl.substring(0, baseurl.length - 1);
    }

    if (baseurl == "" || username == "" || password == "") {
      return showMyAlertDialog(context, S.current.notive, S.current.noContent);
    }

    loading.value = true;
    try {
      var status = await testServer(baseurl, username, password);

      if (!status) {
        return showMyAlertDialog(
            context, S.current.notive, S.current.serverErr);
      }

      final _randomNumber = generateRandomString();
      final _randomBytes = utf8.encode(password + _randomNumber);
      final _randomString = md5.convert(_randomBytes).toString();

      ServerInfo _serverInfo = ServerInfo(
        baseurl: baseurl,
        username: username,
        salt: _randomNumber,
        hash: _randomString,
        neteaseapi: "",
        languageCode: '',
      );

      if (editId != null) {
        _serverInfo.id = editId!.value;
        await DbProvider.instance.updateServerInfo(_serverInfo);
        Get.back();
      } else {
        await DbProvider.instance.addServerInfo(_serverInfo);
        serverService.updateCurrentServerInfo(_serverInfo);
        indexValue.value = 0;
        Get.offNamed(Routes.HOME);
      }
    } catch (e) {}

    loading.value = false;
  }
}

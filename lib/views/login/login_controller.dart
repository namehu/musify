import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:musify/api/index.dart';
import 'package:musify/enums/serve_type_enum.dart';
import 'package:musify/generated/l10n.dart';
import 'package:musify/models/myModel.dart';
import 'package:musify/routes/pages.dart';
import 'package:musify/services/server_service.dart';
import 'package:musify/util/dbProvider.dart';
import 'package:musify/views/home/home_controller.dart';

import '../../widgets/m_notification.dart';

class LoginController extends GetxController {
  var homeController = Get.find<HomeController>();
  var serverService = Get.find<ServerService>();

  get serversInfo => serverService.serverInfo;

  final servercontroller = TextEditingController();
  final usernamecontroller = TextEditingController();
  final passwordcontroller = TextEditingController();

  final loading = false.obs;
  final serverType = (ServeTypeEnum.navidrome).obs;

  RxInt? editId; // 编辑数据id

  @override
  void onInit() {
    super.onInit();

    if (Get.arguments != null && Get.arguments is ServerInfo) {
      var args = Get.arguments as ServerInfo;
      // print(args.toJson());
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
      return MNotification.warning(
        S.current.notive,
        message: S.current.noContent,
      );
    }

    loading.value = true;

    Map<String, dynamic> res = {};
    MRequest.setApi(serverType.value);
    try {
      res = await MRequest.api.authenticate(baseurl, username, password);
    } catch (e) {
      ///
    }

    if (res['username'] == null) {
      MRequest.resetApi();
      MNotification.error(
        S.current.notive,
        message: S.current.serverErr,
      );
    } else {
      ServerInfo serverInfo = ServerInfo(
        serverType: serverType.value.label,
        baseurl: baseurl,
        userId: res['userId'] ?? '',
        username: username,
        password: password,
        salt: res['salt'] ?? '',
        hash: res['hash'] ?? '',
        ndCredential: res['credential'] ?? '',
        neteaseapi: "",
        languageCode: '',
      );

      try {
        if (editId != null) {
          serverInfo.id = editId!.value;
          await DbProvider.instance.updateServerInfo(serverInfo);
          Get.back();
        } else {
          await DbProvider.instance.addServerInfo(serverInfo);
          serverService.updateCurrentServerInfo(serverInfo);

          homeController.initState();
          Get.offNamed(Routes.HOME);
        }
      } catch (e) {
        ///
      }
    }

    loading.value = false;
  }
}

import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:musify/api/index.dart';
import 'package:musify/constant.dart';
import 'package:musify/enums/serve_type_enum.dart';
import 'package:musify/generated/l10n.dart';
import 'package:musify/models/database/database.dart';
import 'package:musify/models/myModel.dart';
import 'package:musify/routes/pages.dart';
import 'package:musify/services/server_service.dart';
import 'package:musify/views/home/home_controller.dart';

import '../../services/preferences_service.dart';
import '../../widgets/m_notification.dart';

class LoginController extends GetxController {
  var serverService = Get.find<ServerService>();
  var homeController = Get.find<HomeController>();

  final loading = false.obs;
  final serverType = (ServeTypeEnum.navidrome).obs;

  final servercontroller = TextEditingController();
  final usernamecontroller = TextEditingController();
  final passwordcontroller = TextEditingController();

  RxInt? editId; // 编辑数据id

  Rx<ServerTableData> get serversInfo => serverService.serverInfo;

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
      try {
        if (editId != null) {
          ServerTableData data = ServerTableData(
            id: editId!.value,
            serverType: serverType.value.label,
            baseurl: baseurl,
            userId: res['userId'] ?? '',
            username: username,
            password: password,
            salt: res['salt'] ?? '',
            hash: res['hash'] ?? '',
            ndCredential: res['credential'] ?? '',
          );
          final query = (database.update(database.serverTable)
            ..where((fi) => fi.id.equals(editId!.value)));

          await query.replace(data);

          Get.back();
        } else {
          var id = await database.into(database.serverTable).insert(
                ServerTableCompanion.insert(
                  serverType: serverType.value.label,
                  baseurl: baseurl,
                  userId: res['userId'] ?? '',
                  username: username,
                  password: password,
                  salt: res['salt'] ?? '',
                  hash: res['hash'] ?? '',
                  ndCredential: res['credential'] ?? '',
                ),
              );

          PreferencesService.setInt(PreferencesEnum.serverId, id);

          var serverInfo = await (database.select(database.serverTable)
                ..where((fi) => fi.id.equals(id)))
              .getSingle();

          serverService.updateCurrentServerInfo(serverInfo);

          homeController.initState();
          Get.offNamed(Routes.HOME);
        }
      } catch (e) {
        ///
        logger.e(e);
      }
    }

    loading.value = false;
  }
}

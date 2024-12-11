import 'package:get/get.dart';
import 'package:musify/api/index.dart';
import 'package:musify/constant.dart';
import 'package:musify/enums/serve_type_enum.dart';
import 'package:musify/models/database/database.dart';
import 'package:musify/services/preferences_service.dart';

class ServerService extends GetxService {
  /// 当前服务器信息
  var serverInfo = ServerTable.defaults().obs;

  ServeTypeEnum? get serverType {
    var type = serverInfo.value.serverType;
    return ServeTypeEnum.values.firstWhereOrNull((el) => el.label == type);
  }

  Future<ServerService> init() async {
    var id = PreferencesService.getInt(PreferencesEnum.serverId);

    ServerTableData? data = await (database.select(database.serverTable)
          ..where((tbl) {
            if (id.isEqual(0)) {
              return tbl.id.isNotNull();
            }
            return tbl.id.equals(id);
          }))
        .getSingleOrNull();

    if (data != null) {
      updateCurrentServerInfo(data);
    }

    return this;
  }

  /// 更新当前服务器信息
  /// 同时重新加载国际化
  updateCurrentServerInfo(ServerTableData sInfo) {
    serverInfo.value = sInfo;

    // 更新api 请求端口
    // TODO: 这里需要补齐 账号销毁时reset api 的逻辑
    var serveTypeEnum =
        ServeTypeEnum.values.firstWhere((e) => e.label == sInfo.serverType);
    MRequest.setApi(serveTypeEnum);
  }

  //   _saveNetease() async {
  //   if (neteasecontroller.text != "") {
  //     String _serverURL = neteasecontroller.text;
  //     if (_serverURL.endsWith("/")) {
  //       _serverURL = _serverURL.substring(0, _serverURL.length - 1);
  //     }

  //     _myServerInfo.neteaseapi = _serverURL;
  //     await DbProvider.instance.updateServerInfo(_myServerInfo);
  //     //new一个对象触发值的监听
  //     ServerInfo newServerInfo = new ServerInfo(
  //         baseurl: _myServerInfo.baseurl,
  //         hash: _myServerInfo.hash,
  //         languageCode: _myServerInfo.languageCode,
  //         neteaseapi: _myServerInfo.neteaseapi,
  //         salt: _myServerInfo.salt,
  //         username: _myServerInfo.username);
  //     serversInfo.value = newServerInfo;
  //     showMyAlertDialog(
  //         context, S.current.success, S.current.save + S.current.success);
  //   } else {
  //     showMyAlertDialog(context, S.current.notive, S.current.noContent);
  //   }
  // }

  // _deleteServer() async {
  //   await DbProvider.instance.deleteServerInfo();
  //   if (mounted) {
  //     setState(() {
  //       serversInfo.value = ServerInfo(
  //           baseurl: '',
  //           hash: '',
  //           neteaseapi: '',
  //           salt: '',
  //           username: '',
  //           languageCode: '');
  //       servercontroller.text = "";
  //       usernamecontroller.text = "";
  //       passwordcontroller.text = "";
  //       neteasecontroller.text = "";
  //     });
  //   }
  //   showMyAlertDialog(
  //       context, S.current.success, S.current.server + S.current.delete);
  // }
}

import 'package:musify/dao/server_info_dao.dart';
import '../models/myModel.dart';

class ServerInfoRepository {
  final dao = ServerInfoDao();

  /// 新增服务器
  Future<int?> addServerInfo(ServerInfo info) => dao.addServerInfo(info);

  /// 更新服务器
  Future<void> updateServerInfo(ServerInfo info) async {
    return dao.updateServerInfo(info);
  }

  /// 删除服务器
  Future<void> deleteServerInfo(int? id) async {
    await dao.deleteServerInfo(id);

    // TODO: 清理服务器歌词
  }

  /// 获取当前服务器信息
  /// 如果id为null，则返回所有第一个服务器信息
  Future<ServerInfo?> getServerInfo([int? id]) async {
    ServerInfo? data;
    var lists = await dao.getServerInfo(id);

    if (lists.isNotEmpty) {
      if (id != null) {
        data = lists.firstWhere((item) => item.id == id);
      } else {
        data = lists[0];
      }
    }
    return data;
  }

  /// 获取服务器列表
  Future<List<ServerInfo>> getServerList() async {
    return dao.getServerList();
  }
}

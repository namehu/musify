import 'package:musify/dao/database_provider.dart';
import 'package:sqflite/sqflite.dart';
import '../constant.dart';
import '../models/myModel.dart';

class ServerInfoDao {
  final dbProvider = DatabaseProvider.dbProvider;

  /// 新增服务器
  Future<int?> addServerInfo(ServerInfo info) async {
    try {
      final db = await dbProvider.db;
      var res = await db.insert(serverInfoTable, info.toJson());
      return res;
    } catch (err) {
      logger.e('err is 👉 $err');
    }
    return null;
  }

  /// 更新服务器
  Future<void> updateServerInfo(ServerInfo info) async {
    try {
      final db = await dbProvider.db;
      await db.update(
        serverInfoTable,
        info.toJson(),
        where: 'id = ?',
        whereArgs: [info.id],
      );
    } catch (err) {
      logger.e('err is 👉 $err');
    }
  }

  /// 删除服务器
  Future<void> deleteServerInfo(int? id) async {
    try {
      final db = await dbProvider.db;
      Batch batch = db.batch();

      if (id == null) {
        batch.delete(serverInfoTable);
      } else {
        batch.delete(serverInfoTable, where: 'id = ?', whereArgs: [id]);
      }
      await batch.commit(noResult: true);
    } catch (err) {
      logger.e('err is 👉 $err');
    }
  }

  // 获取当前服务器信息
  Future<List<ServerInfo>> getServerInfo(int? id) async {
    List<ServerInfo> data = [];
    try {
      final db = await dbProvider.db;
      var res = await db.query(
        serverInfoTable,
        where: id != null ? 'id = $id' : null,
      );

      if (res.isNotEmpty) {
        data = res.map((e) => ServerInfo.fromJson(e)).toList();
      }
    } catch (err) {
      logger.e('err1 is 👉 $err');
    }

    return data;
  }

  /// 获取服务器列表
  Future<List<ServerInfo>> getServerList() async {
    List<ServerInfo> lists = [];
    try {
      final db = await dbProvider.db;
      var res = await db.query(serverInfoTable);
      if (res.isNotEmpty) {
        lists = res.map((e) => ServerInfo.fromJson(e)).toList();
      }
    } catch (err) {
      logger.e('err1 is 👉 $err');
    }

    return lists;
  }
}

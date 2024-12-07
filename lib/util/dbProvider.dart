import 'dart:io';

import 'package:musify/constant.dart';
import 'package:path/path.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:path_provider/path_provider.dart';

import '../models/myModel.dart';

class DbProvider {
  static final DbProvider instance = DbProvider._init();
  static Database? _db;
  DbProvider._init();

  final String dbName = "musify.db";
  final String serverInfoTable = "serverInfo";
  final String songsAndLyricTable = "songsAndLyric";

  Future<Database> get db async {
    if (_db != null) return _db!;
    _db = await _useDatabase();
    return _db!;
  }

  Future<Database> _useDatabase() async {
    late String dbPath;

    if (Platform.isWindows) {
      databaseFactory = databaseFactoryFfi;
      final appDocumentsDir = await getApplicationDocumentsDirectory();
      dbPath = join(appDocumentsDir.path, "databases");
    } else {
      dbPath = await getDatabasesPath();
    }

    return await openDatabase(
      join(dbPath, dbName),
      version: 1,
      onCreate: _onCreate,
    );
  }

  void _onCreate(Database database, int version) async {
    await database.execute('''
              create table $serverInfoTable (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                serverType TEXT NOT NULL,
                baseurl TEXT NOT NULL,
                userId TEXT NOT NULL,
                username TEXT NOT NULL,
                password TEXT NOT NULL,
                salt TEXT NOT NULL,
                hash TEXT NOT NULL,
                ndCredential TEXT NOT NULL,
                neteaseapi TEXT,
                languageCode TEXT
              )
        ''');

    await database.execute('''
              create table $songsAndLyricTable (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                lyric TEXT NOT NULL,
                songId TEXT NOT NULL
              )
        ''');
  }

  addServerInfo(ServerInfo info) async {
    try {
      final db = await instance.db;
      Batch batch = db.batch();
      batch.insert(serverInfoTable, info.toJson());
      var res = await batch.commit(noResult: true);
      return res;
    } catch (err) {
      logger.e('err is 👉 $err');
    }
  }

  updateServerInfo(ServerInfo info) async {
    try {
      final db = await instance.db;
      var res = await db.update(
        serverInfoTable,
        info.toJson(),
        where: 'id = ?',
        whereArgs: [info.id],
      );
      return res;
    } catch (err) {
      logger.e('err is 👉 $err');
    }
  }

  deleteServerInfo() async {
    try {
      final db = await instance.db;
      Batch batch = db.batch();
      batch.delete(serverInfoTable);
      batch.delete(songsAndLyricTable);
      batch.delete("sqlite_sequence");
      var res = await batch.commit(noResult: true);
      return res;
    } catch (err) {
      logger.e('err is 👉 $err');
    }
  }

  // 获取当前服务器信息
  Future<ServerInfo?> getServerInfo() async {
    ServerInfo? data;
    try {
      final db = await instance.db;
      var res = await db.query(serverInfoTable);
      if (res.isNotEmpty) {
        List<ServerInfo> lists =
            res.map((e) => ServerInfo.fromJson(e)).toList();
        data = lists[0];
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
      final db = await instance.db;
      var res = await db.query(serverInfoTable);
      if (res.isNotEmpty) {
        lists = res.map((e) => ServerInfo.fromJson(e)).toList();
      }
    } catch (err) {
      logger.e('err1 is 👉 $err');
    }

    return lists;
  }

  addSongsAndLyricTable(SongsAndLyric artists) async {
    try {
      final db = await instance.db;
      Batch batch = db.batch();
      batch.delete(songsAndLyricTable,
          where: "songId = ?", whereArgs: [artists.songId]);
      await batch.commit(noResult: true);
      batch.insert(songsAndLyricTable, artists.toJson());
      var res = await batch.commit(noResult: true);
      return res;
    } catch (err) {
      logger.e('err is 👉 $err');
    }
  }

  getLyricById(String songId) async {
    try {
      final db = await instance.db;
      var res = await db
          .query(songsAndLyricTable, where: "songId = ?", whereArgs: [songId]);
      if (res.isEmpty) return null;
      List<SongsAndLyric> lists =
          res.map((e) => SongsAndLyric.fromJson(e)).toList();
      SongsAndLyric result = lists[0];
      return result.lyric;
    } catch (err) {
      logger.e('err is 👉 $err');
    }
  }

  Future close() async {
    final db = await instance.db;
    db.close();
  }
}

// ignore_for_file: avoid_print

import 'dart:io';

import 'package:path/path.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:path_provider/path_provider.dart';

import '../models/myModel.dart';

class DbProvider {
  static final DbProvider instance = DbProvider._init();
  static Database? _db;
  DbProvider._init();

  final String dbName = "musify.db";
  // ignore: non_constant_identifier_names
  final String ServerInfoTable = "serverInfo";
  // ignore: non_constant_identifier_names
  final String SongsAndLyricTable = "songsAndLyric";

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
              create table $ServerInfoTable (
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
              create table $SongsAndLyricTable (
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
      batch.insert(ServerInfoTable, info.toJson());
      var res = await batch.commit(noResult: true);
      return res;
    } catch (err) {
      print('err is 👉 $err');
    }
  }

  updateServerInfo(ServerInfo info) async {
    try {
      final db = await instance.db;
      var res = await db.update(
        ServerInfoTable,
        info.toJson(),
        where: 'id = ?',
        whereArgs: [info.id],
      );
      return res;
    } catch (err) {
      print('err is 👉 $err');
    }
  }

  deleteServerInfo() async {
    try {
      final db = await instance.db;
      Batch batch = db.batch();
      batch.delete(ServerInfoTable);
      batch.delete(SongsAndLyricTable);
      batch.delete("sqlite_sequence");
      var res = await batch.commit(noResult: true);
      return res;
    } catch (err) {
      print('err is 👉 $err');
    }
  }

  // 查
  getServerInfo() async {
    try {
      final db = await instance.db;
      var res = await db.query(ServerInfoTable);
      if (res.length == 0) return null;
      List<ServerInfo> lists = res.map((e) => ServerInfo.fromJson(e)).toList();
      return lists[0];
    } catch (err) {
      print('err1 is 👉 $err');
    }
  }

  Future<List<ServerInfo>> getServerList() async {
    List<ServerInfo> lists = [];
    try {
      final db = await instance.db;
      var res = await db.query(ServerInfoTable);
      if (res.isNotEmpty) {
        lists = res.map((e) => ServerInfo.fromJson(e)).toList();
      }
    } catch (err) {
      print('err1 is 👉 $err');
    }

    return lists;
  }

  addSongsAndLyricTable(SongsAndLyric artists) async {
    try {
      final db = await instance.db;
      Batch batch = db.batch();
      batch.delete(SongsAndLyricTable,
          where: "songId = ?", whereArgs: [artists.songId]);
      await batch.commit(noResult: true);
      batch.insert(SongsAndLyricTable, artists.toJson());
      var res = await batch.commit(noResult: true);
      return res;
    } catch (err) {
      print('err is 👉 $err');
    }
  }

  getLyricById(String songId) async {
    try {
      final db = await instance.db;
      var res = await db
          .query(SongsAndLyricTable, where: "songId = ?", whereArgs: [songId]);
      if (res.isEmpty) return null;
      List<SongsAndLyric> lists =
          res.map((e) => SongsAndLyric.fromJson(e)).toList();
      SongsAndLyric result = lists[0];
      return result.lyric;
    } catch (err) {
      print('err is 👉 $err');
    }
  }

  Future close() async {
    final db = await instance.db;
    db.close();
  }
}

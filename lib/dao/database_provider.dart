import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

const String serverInfoTable = "server_info";
const String songLyricsTable = "song_lyrics";

class DatabaseProvider {
  static Database? _db;
  static final DatabaseProvider dbProvider = DatabaseProvider._init();

  DatabaseProvider._init();

  DatabaseProvider();

  final String dbName = "musify.db";

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
              create table $songLyricsTable (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                lyric TEXT NOT NULL,
                songId TEXT NOT NULL,
                serverId INTEGER NOT NULL
              )
        ''');
  }

  Future close() async {
    final dd = await db;
    dd.close();
  }
}

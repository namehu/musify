import 'package:musify/dao/database_provider.dart';
import '../constant.dart';
import '../models/song_lyric.dart';

class SongLyricDao {
  final dbProvider = DatabaseProvider.dbProvider;

  Future<int?> insert(SongLyric data) async {
    try {
      final db = await dbProvider.db;
      var res = await db.insert(songLyricsTable, data.toJson());
      return res;
    } catch (err) {
      logger.e('err is 👉 $err');
    }
    return null;
  }

  Future<List<SongLyric>> queryBySongId(String songId) async {
    List<SongLyric> data = [];
    try {
      final db = await dbProvider.db;
      var res = await db
          .query(songLyricsTable, where: 'songId = ?', whereArgs: [songId]);
      if (res.isNotEmpty) {
        data = res.map((to) => SongLyric.fromJson(to)).toList();
      }
    } catch (err) {
      logger.e('err is 👉 $err');
    }
    return data;
  }
}

import 'package:musify/dao/song_lyric_dao.dart';
import 'package:musify/models/song_lyric.dart';
import 'package:musify/services/preferences_service.dart';

class SongLyricRepository {
  final dao = SongLyricDao();

  Future<int?> insert(String lyric, String songId) async {
    var serverId = PreferencesService.getInt(PreferencesEnum.serverId);

    SongLyric data = SongLyric(
      lyric: lyric,
      songId: songId,
      serverId: serverId,
    );

    return await dao.insert(data);
  }

  Future<SongLyric?> queryBySongId(String songId) async {
    SongLyric? data;
    var lists = await dao.queryBySongId(songId);

    if (lists.isNotEmpty) {
      var serverId = PreferencesService.getInt(PreferencesEnum.serverId);

      if (serverId != 0) {
        data = lists.firstWhere((item) => item.serverId == serverId);
      } else {
        data = lists[0];
      }
    }

    return data;
  }
}

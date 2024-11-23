import 'package:musify/models/myModel.dart';
import 'package:musify/models/songs.dart';

typedef MusicApi = ({
  /// 登录校验
  Future<Map<String, dynamic>> Function(
      String _baseUrl, String _username, String _password) authenticate,

  /// 查询歌曲详情
  Future<Songs?> Function(String id) getSong,

  /// 查询播放列表
  // Future<List<Playlist>> Function() getPlaylists,
});

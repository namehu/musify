import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:musify/enums/star_type_enum.dart';
import 'package:musify/models/genres.dart';
import 'package:musify/models/myModel.dart';
import 'package:musify/models/play_list.dart';
import 'package:musify/models/songs.dart';

import '../constant.dart';
import '../enums/album_list_type_enum.dart';

typedef MusicApi = ({
  /// 登录校验
  Future<Map<String, dynamic>> Function(
      String baseUrl, String username, String password) authenticate,

  /// 查询歌曲详情
  Future<Songs?> Function(String id) getSong,

  /// 创建播放列表
  Future<dynamic> Function(String songId) createPlaylist,
  Future<dynamic> Function(String id) deletePlaylist,

  /// 查询播放列表
  Future<List<Playlist>> Function() getPlaylists,

  ///  获取专辑列表
  Future<List<Albums>> Function({
    int pageNum,
    int? pageSize,
    AlbumListTypeEnum? type,
  }) getAlbumList,

  /// 查询专辑详情
  Future<Albums?> Function(String id) getAlbum,

  /// 获取专辑详情
  Future<Playlist?> Function(String id) getPlaylist,

  /// 查询歌曲列表
  Future<List<Songs>> Function({
    int pageNum,
    int? pageSize,
    String? query,
  }) getSongs,

  /// 查询流派列表
  Future<List<Genres>> Function() getGenres,

  /// 收藏歌曲/专辑/歌手
  Future<dynamic> Function(String id, StarTypeEnum type) addStar,

  /// 取消收藏歌曲/专辑/歌手
  Future<dynamic> Function(String id, StarTypeEnum type) removeStar,
});

logResponse(Response response) {
  // 打印接口输出
  String logOutPut =
      '[request] ${response.requestOptions.baseUrl}${response.requestOptions.path}';

  var query = response.requestOptions.queryParameters.entries.map((element) {
    return ('${element.key}=${element.value}');
  }).join('&');
  if (query.isNotEmpty) logOutPut += '?$query';

  if (response.requestOptions.data != null) {
    logOutPut += '\n\n[data] ${jsonEncode(response.requestOptions.data)}';
  }

  // logOutPut += '\n\n[response] ${jsonEncode(response.data)}';

  logger.i(logOutPut);
}

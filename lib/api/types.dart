import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:musify/models/myModel.dart';
import 'package:musify/models/play_list.dart';
import 'package:musify/models/songs.dart';

import '../constant.dart';
import '../enums/album_list_type_enum.dart';

typedef MusicApi = ({
  /// 登录校验
  Future<Map<String, dynamic>> Function(
      String _baseUrl, String _username, String _password) authenticate,

  /// 查询专辑详情
  Future<dynamic> Function(String id) getAlbum,

  /// 查询歌曲详情
  Future<Songs?> Function(String id) getSong,

  /// 查询播放列表
  Future<List<Playlist>> Function() getPlaylists,

  ///  获取专辑列表
  Future<List<Albums>> Function({
    int pageNum,
    int? pageSize,
    AlbumListTypeEnum? type,
  }) getAlbumList,
  Future<dynamic> Function({
    int pageNum,
    int? pageSize,
    String? query,
  }) getSongs,
});

logResponse(Response response) {
  // 打印接口输出
  String logOutPut = '[request] ' +
      response.requestOptions.baseUrl +
      response.requestOptions.path;

  var _query = response.requestOptions.queryParameters.entries.map((element) {
    return (element.key + '=' + element.value.toString());
  }).join('&');
  if (_query.isNotEmpty) logOutPut += '?' + _query;

  if (response.requestOptions.data != null) {
    logOutPut += '\n\n[data] ' + jsonEncode(response.requestOptions.data);
  }

  logOutPut += '\n\n[response] ' + jsonEncode(response.data);

  logger.d(logOutPut);
}

import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart' hide Response;
import 'package:musify/enums/album_list_type_enum.dart';
import 'package:musify/models/play_list.dart';
import 'package:musify/models/songs.dart';
import 'package:musify/services/server_service.dart';
import 'package:musify/util/util.dart';
import '../../models/myModel.dart';
import '../../util/mycss.dart';
import '../../util/request/mock_inter.dart';
import '../types.dart';
import 'utils.dart';

Function(Response<dynamic>, ResponseInterceptorHandler) onResponse =
    (Response response, ResponseInterceptorHandler handler) {
  // 如果你想终止请求并触发一个错误，你可以使用 `handler.reject(error)`。
  response.data = _checkResponse(response);

  // 打印接口输出
  logResponse(response);

  return handler.next(response);
};

Interceptor subsonicInterceptor = InterceptorsWrapper(
  onRequest: (RequestOptions options, RequestInterceptorHandler handler) {
    // 如果你想完成请求并返回一些自定义数据，你可以使用 `handler.resolve(response)`。
    // 如果你想终止请求并触发一个错误，你可以使用 `handler.reject(error)`。
    var serverService = Get.find<ServerService>();
    options.baseUrl = serverService.serverInfo.value.baseurl;
    // 添加rest api路径
    options.path = '/rest/' + options.path;

    options.queryParameters = options.queryParameters ?? {};
    var _query = joniAuthQuery();
    options.queryParameters.addAll(_query);

    return handler.next(options);
  },
  onResponse: onResponse,
  onError: (DioException error, ErrorInterceptorHandler handler) {
    // 如果你想完成请求并返回一些自定义数据，你可以使用 `handler.resolve(response)`。
    print('------------reuqest subsonic error---------');
    print(error.message);
    return handler.next(error);
  },
);

Dio _dio = Dio(BaseOptions(responseType: ResponseType.json))
  ..interceptors.add(subsonicInterceptor)
  ..interceptors.add(MyMockInterceptor());

_checkResponse(Response<dynamic> response) {
  if (response.statusCode == 200) {
    if (response.data['subsonic-response'] != null) {
      Map _subsonic = response.data['subsonic-response'];
      String _status = _subsonic['status'];
      if (_status == 'ok') {
        return _subsonic;
      }
    }
  }
  return null;
}

MusicApi subsonicApi = (
  authenticate: (String baseUrl, String username, String password) async {
    Map<String, dynamic> res = {};

    try {
      var _response = await Dio().get(
        baseUrl +
            '/rest/ping?v=$version&c=musify&f=json&u=' +
            username +
            '&p=' +
            password,
      );
      var _subsonic = _checkResponse(_response);
      if (_subsonic != null) {
        final salt = generateRandomString();
        final _randomBytes = utf8.encode(password + salt);
        final hash = md5.convert(_randomBytes).toString();

        res['userId'] = '';
        res['username'] = username;
        res['salt'] = salt;
        res['hash'] = hash;
      }
      ;
    } catch (e) {
      print(e);
    }
    return res;
  },
  getAlbum: (String id) async {
    var _response = await _dio.get('getAlbum', queryParameters: {'id': id});
    if (_response.data == null) return null;
    return _response.data['album'];
  },
  getSong: _getSong,
  getPlaylists: _getPlaylists,
  getPlaylist: _getPlaylist,
  getAlbumList: _getAlbumList,
  getSongs: _getSongs,
);

Future<Songs?> _getSong(String id) async {
  var _response = await _dio.get('getSong', queryParameters: {'id': id});
  if (_response.data == null) return null;

  Map<String, dynamic> _song = _response.data['song'];

  _song["stream"] = getSongStream(_song["id"]);
  _song["coverUrl"] = getCoverArt(_song["id"], size: 800);

  Songs songs = Songs.fromJson(_song);
  return songs;
}

Future<List<Playlist>> _getPlaylists() async {
  var data = <Playlist>[];
  var _response = await _dio.get('getPlaylists');
  Map _playlists = _response.data['playlists'];
  List _playlist = _playlists['playlist'];

  for (var element in _playlist) {
    element["imageUrl"] = getCoverArt(element['id']);
    Playlist _playlist = Playlist.fromJson(element);
    data.add(_playlist);
  }
  return data;
}

Future<Playlist?> _getPlaylist(String id) async {
  Playlist? _playList = null;

  var _response = await _dio.get('getPlaylist', queryParameters: {"id": id});
  var _playlisttem = _response.data['playlist'];

  if (_playlisttem != null) {
    _playlisttem["imageUrl"] = getCoverArt(_playlisttem['id']);
    _playList = Playlist.fromJson(_playlisttem);

    List<Songs> _temsong = [];

    if (_playlisttem["entry"] != null && _playlisttem["entry"].length > 0) {
      for (var _element in _playlisttem["entry"]) {
        _element["stream"] = getSongStream(_element["id"]);
        _element["coverUrl"] = getCoverArt(_element["id"]);
        Songs _song = Songs.fromJson(_element);
        _temsong.add(_song);
      }
    }

    _playList.songs = _temsong;
  }

  return _playList;
}

Future<List<Albums>> _getAlbumList({
  int pageNum = 1,
  int? pageSize = 10,
  AlbumListTypeEnum? type = AlbumListTypeEnum.recent,
}) async {
  var offset = (pageNum - 1) * pageSize!;
  var _response = await _dio.get('getAlbumList2', queryParameters: {
    "size": pageSize,
    "offset": offset,
    'type': type!.value
  });

  Map _albumList = _response.data['albumList2'];
  List _albums = _albumList['album'] ?? [];

  List<Albums> _list = [];
  if (_albums.isNotEmpty) {
    for (var _element in _albums) {
      _element["coverUrl"] = getCoverArt(_element["id"]);
      Albums _album = Albums.fromJson(_element);
      _list.add(_album);
    }
  }
  return _list;
}

Future<List<Songs>> _getSongs({
  int pageNum = 1,
  int? pageSize = 50,
  String? query = '',
}) async {
  List<Songs> _list = [];

  var response = await _dio.get(
    'search3',
    queryParameters: {
      "query": query,
      "artistCount": 0,
      "artistOffset": 0,
      "albumCount": 0,
      "albumOffset": 0,
      "songOffset": (pageNum - 1) * pageSize!,
      "songCount": pageSize
    },
  );

  if (response.data != null && response.data['searchResult3'] != null) {
    List<dynamic> _songs = response.data['searchResult3']['song'] ?? [];
    _songs.forEach((el) {
      el["stream"] = getSongStream(el["id"]);
      el["coverUrl"] = getCoverArt(el["id"]);
      _list.add(Songs.fromJson(el));
    });
  }

  return _list;
}

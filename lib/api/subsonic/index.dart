import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:dio/dio.dart';
import 'package:musify/enums/album_list_type_enum.dart';
import 'package:musify/models/notifierValue.dart';
import 'package:musify/models/play_list.dart';
import 'package:musify/models/songs.dart';
import 'package:musify/util/httpClient.dart';
import 'package:musify/util/util.dart';
import '../../models/myModel.dart';
import '../../util/mycss.dart';
import '../../util/request/mock_inter.dart';
import '../types.dart';

Function(Response<dynamic>, ResponseInterceptorHandler) onResponse =
    (Response response, ResponseInterceptorHandler handler) {
  // 如果你想终止请求并触发一个错误，你可以使用 `handler.reject(error)`。
  var _subsonic = _checkResponse(response);
  response.data = _subsonic;

  // 打印接口输出
  logResponse(response);
  return handler.next(response);
};

Interceptor subsonicInterceptor = InterceptorsWrapper(
  onRequest: (RequestOptions options, RequestInterceptorHandler handler) {
    // 如果你想完成请求并返回一些自定义数据，你可以使用 `handler.resolve(response)`。
    // 如果你想终止请求并触发一个错误，你可以使用 `handler.reject(error)`。
    options.baseUrl = serversInfo.value.baseurl;
    // 添加rest api路径
    options.path = '/rest/' + options.path;

    Map<String, dynamic> _query = {
      'v': '0.0.1',
      'c': 'musify',
      'f': 'json',
      'u': serversInfo.value.username,
      's': serversInfo.value.salt,
      't': serversInfo.value.hash
    };

    options.queryParameters = options.queryParameters ?? {};
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

getServerInfo(String path) {
  String _request = serversInfo.value.baseurl +
      '/rest/$path?v=0.0.1&c=musify&f=json&u=' +
      serversInfo.value.username +
      '&s=' +
      serversInfo.value.salt +
      '&t=' +
      serversInfo.value.hash;
  return _request;
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
  getAlbumList: _getAlbumList,
);

Future<Songs?> _getSong(String id) async {
  var _response = await _dio.get('getSong', queryParameters: {'id': id});
  if (_response.data == null) return null;

  Map<String, dynamic> _song = _response.data['song'];

  String _stream = getServerInfo("stream");
  String _url = getCoverArt(_song["id"], size: 800);
  _song["stream"] = _stream + '&id=' + _song["id"];
  _song["coverUrl"] = _url;

  Songs songs = Songs.fromJson(_song);
  return songs;
}

Future<List<Playlist>> _getPlaylists() async {
  var data = <Playlist>[];
  var _response = await _dio.get('getPlaylists');
  Map _playlists = _response.data['playlists'];
  List _playlist = _playlists['playlist'];

  for (var element in _playlist) {
    String _url = getCoverArt(element['id']);
    element["imageUrl"] = _url;
    Playlist _playlist = Playlist.fromJson(element);
    data.add(_playlist);
  }
  return data;
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
      String _url = getCoverArt(_element["id"]);
      _element["coverUrl"] = _url;
      Albums _album = Albums.fromJson(_element);
      _list.add(_album);
    }
  }
  return _list;
}

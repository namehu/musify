import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:dio/dio.dart';
import 'package:musify/models/notifierValue.dart';
import 'package:musify/models/songs.dart';
import 'package:musify/util/httpClient.dart';
import 'package:musify/util/util.dart';
import '../../util/mycss.dart';
import '../../util/request/mock_inter.dart';
import '../types.dart';

Function(Response<dynamic>, ResponseInterceptorHandler) onResponse =
    (Response response, ResponseInterceptorHandler handler) {
  // 如果你想终止请求并触发一个错误，你可以使用 `handler.reject(error)`。

  print('------------requset---------');
  var _query = response.requestOptions.queryParameters.entries.map((element) {
    return (element.key + '=' + element.value.toString());
  }).join('&');
  var _fullUrl = response.requestOptions.baseUrl + response.requestOptions.path;
  if (_query.isNotEmpty) _fullUrl += '?' + _query;
  print(_fullUrl);
  if (response.requestOptions.data != null) {
    print(jsonEncode(response.requestOptions.data));
  }
  print('------------requset---------');

  var _subsonic = checkResponse(response);
  if (_subsonic == null) return null;

  response.data = _subsonic;
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

checkResponse(Response<dynamic> response) {
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
      var _subsonic = checkResponse(_response);
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
  getSong: (String id) async {
    var _response = await _dio.get('getSong', queryParameters: {'id': id});
    if (_response.data == null) return null;

    Map<String, dynamic> _song = _response.data['song'];

    String _stream = getServerInfo("stream");
    String _url = getCoverArt(_song["id"], size: 800);
    _song["stream"] = _stream + '&id=' + _song["id"];
    _song["coverUrl"] = _url;

    Songs songs = Songs.fromJson(_song);
    return songs;
  },
);

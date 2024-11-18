import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:dio/dio.dart';
import 'package:musify/api/index.dart';
import 'package:musify/models/notifierValue.dart';
import 'package:musify/models/songs.dart';
import 'package:musify/util/httpClient.dart';
import 'package:musify/util/util.dart';
import '../../util/mycss.dart';
import '../types.dart';

Interceptor subsonicInterceptor = InterceptorsWrapper(
  onRequest: (RequestOptions options, RequestInterceptorHandler handler) {
    // 如果你想完成请求并返回一些自定义数据，你可以使用 `handler.resolve(response)`。
    // 如果你想终止请求并触发一个错误，你可以使用 `handler.reject(error)`。

    options.baseUrl = serversInfo.value.baseurl;
    options.responseType = ResponseType.json;

    return handler.next(options);
  },
  onResponse: (Response response, ResponseInterceptorHandler handler) {
    // 如果你想终止请求并触发一个错误，你可以使用 `handler.reject(error)`。
    return handler.next(response);
  },
  onError: (DioException error, ErrorInterceptorHandler handler) {
    // 如果你想完成请求并返回一些自定义数据，你可以使用 `handler.resolve(response)`。
    return handler.next(error);
  },
);

checkResponse(Response<dynamic> _response) {
  if (_response.statusCode == 200) {
    if (_response.data['subsonic-response'] != null) {
      Map _subsonic = _response.data['subsonic-response'];
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

(String path, Map<String, dynamic> query) getRequestParams(String path,
    {Map<String, dynamic>? query}) {
  String requestPath = '/rest/$path';
  Map<String, dynamic> _query = {
    'v': '0.0.1',
    'c': 'musify',
    'f': 'json',
    'u': serversInfo.value.username,
    's': serversInfo.value.salt,
    't': serversInfo.value.hash
  };
  if (query != null) {
    _query.addAll(query);
  }
  return (requestPath, _query);
}

MusicApi subsonicApi = (
  authenticate: (
    String baseUrl,
    String username,
    String password,
  ) async {
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
  getSong: (String id) async {
    print('11111');
    var (path, queryParameters) =
        await getRequestParams("getSong", query: {'id': id});

    try {
      var _response =
          await MRequest.dio.get(path, queryParameters: queryParameters);
      var _subsonic = checkResponse(_response);
      if (_subsonic == null) return null;
      Map<String, dynamic> _song = _subsonic['song'];

      String _stream = getServerInfo("stream");
      String _url = getCoverArt(_song["id"], size: 800);
      _song["stream"] = _stream + '&id=' + _song["id"];
      _song["coverUrl"] = _url;

      Songs songs = Songs.fromJson(_song);
      return songs;
    } catch (e) {
      print(e);
    }
    return null;
  },
);

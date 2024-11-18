import 'package:dio/dio.dart';
import 'package:musify/api/index.dart';
import 'package:musify/models/navidrome/nd_song.dart';
import 'package:musify/models/notifierValue.dart';
import 'package:musify/models/songs.dart';

import '../../util/httpClient.dart';
import '../types.dart';

Interceptor navidromeInterceptor = InterceptorsWrapper(
  onRequest: (RequestOptions options, RequestInterceptorHandler handler) {
    // 如果你想完成请求并返回一些自定义数据，你可以使用 `handler.resolve(response)`。
    // 如果你想终止请求并触发一个错误，你可以使用 `handler.reject(error)`。

    options.baseUrl = serversInfo.value.baseurl;
    options.responseType = ResponseType.json;

    var _ndCredential = serversInfo.value.ndCredential;
    if (_ndCredential.isNotEmpty) {
      options.headers['x-nd-authorization'] = 'Bearer $_ndCredential';
    }

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

(String path, Map<String, dynamic> query) getRequestParams(String path,
    {Map<String, dynamic>? query}) {
  String requestPath = '/api/$path';
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

checkResponse(Response<dynamic> response) {
  if (response.statusCode == 200) {
    if (response.data != null) {
      if (response.statusMessage == 'OK') {
        return response.data;
      }
    }
  }
  return null;
}

MusicApi navidromeApi = (
  authenticate: (
    String baseUrl,
    String username,
    String password,
  ) async {
    Map<String, dynamic> res = {};

    try {
      var _response = await Dio().post(baseUrl + '/auth/login', data: {
        'username': username,
        'password': password,
      });

      var data = checkResponse(_response);
      if (data != null) {
        res['userId'] = data['id'];
        res['username'] = username;
        res['salt'] = data["subsonicSalt"];
        res['hash'] = data["subsonicToken"];
        res['credential'] = data["token"];
      }
    } catch (e) {
      print(e);
    }
    return res;
  },
  getSong: (String id) async {
    var queryParameters = {
      '_end': 15,
      '_order': 'ASC',
      '_sort': 'id',
      '_start': 0,
      'id': id
    };

    try {
      var _response =
          await MRequest.dio.get('/api/song', queryParameters: queryParameters);
      var data = checkResponse(_response);
      if (data != null) {
        var _song = data[0];
        String _stream = getServerInfo("stream");
        String _url = getCoverArt(_song["id"], size: 800);

        NdSong ndSong = NdSong.fromJson(_song);

        Songs songs = Songs.fromNdSong(ndSong);
        songs.coverUrl = _url;
        songs.stream = _stream + '&id=' + _song["id"];
        return songs;
      }
    } catch (e) {
      print(e);
    }
    return null;
  },
);

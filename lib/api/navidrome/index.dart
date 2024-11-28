// ignore_for_file: avoid_print

import 'package:dio/dio.dart';
import 'package:get/get.dart' hide Response;
import 'package:musify/api/subsonic/index.dart';
import 'package:musify/models/navidrome/nd_song.dart';
import 'package:musify/models/notifierValue.dart';
import 'package:musify/models/songs.dart';
import 'package:musify/services/server_service.dart';
import 'package:musify/util/dbProvider.dart';

import '../../util/httpClient.dart';
import '../../util/request/mock_inter.dart';
import '../types.dart';

Function(RequestOptions, RequestInterceptorHandler) onRequest =
    (RequestOptions options, RequestInterceptorHandler handler) {
  // 如果你想完成请求并返回一些自定义数据，你可以使用 `handler.resolve(response)`。
  // 如果你想终止请求并触发一个错误，你可以使用 `handler.reject(error)`。

  options.baseUrl = serversInfo.value.baseurl;

  // 添加rest api路径
  options.path = '/api/${options.path}';

  Map<String, dynamic> query = {};

  options.queryParameters = options.queryParameters;
  options.queryParameters.addAll(query);

  // 携带token
  var ndCredential = serversInfo.value.ndCredential;
  if (ndCredential.isNotEmpty) {
    options.headers['x-nd-authorization'] = 'Bearer $ndCredential';
  }

  return handler.next(options);
};

Function(Response<dynamic>, ResponseInterceptorHandler) onResponse =
    (Response response, ResponseInterceptorHandler handler) {
  // 如果你想终止请求并触发一个错误，你可以使用 `handler.reject(error)`。
  response.data = checkResponse(response);
// 打印接口输出
  logResponse(response);

  return handler.next(response);
};

Interceptor navidromeInterceptor = InterceptorsWrapper(
  onRequest: onRequest,
  onResponse: onResponse,
  onError: (DioException error, ErrorInterceptorHandler handler) async {
    // 如果你想完成请求并返回一些自定义数据，你可以使用 `handler.resolve(response)`。

    // 静默刷新token
    if (error.response?.statusCode == 401 &&
        serversInfo.value.ndCredential.isNotEmpty) {
      var auth = await navidromeApi.authenticate(
        serversInfo.value.baseurl,
        serversInfo.value.username,
        serversInfo.value.password,
      );
      var serverService = Get.find<ServerService>();

      serversInfo.value.ndCredential = auth['credential'];

      serverService.updateCurrentServerInfo(serversInfo.value);
      await DbProvider.instance.updateServerInfo(serversInfo.value);

      var option = error.requestOptions;
      var headers = error.requestOptions.headers;
      headers['x-nd-authorization'] =
          'Bearer ${serversInfo.value.ndCredential}';
      // retry request
      var response = await Dio().request(
        serversInfo.value.baseurl + option.path,
        queryParameters: option.queryParameters,
        data: option.data,
        options: Options().copyWith(
          method: option.method,
          headers: headers,
          responseType: ResponseType.json,
        ),
      );
      return handler.resolve(response);
    }

    print('------------reuqest navidrome error---------');
    print(error.message);

    return handler.next(error);
  },
);

Dio _dio = Dio(BaseOptions(responseType: ResponseType.json))
  ..interceptors.add(navidromeInterceptor)
  ..interceptors.add(MyMockInterceptor());

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
  authenticate: (String baseUrl, String username, String password) async {
    Map<String, dynamic> res = {};

    try {
      var response = await Dio().post('$baseUrl/auth/login', data: {
        'username': username,
        'password': password,
      });

      var data = checkResponse(response);
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
  getAlbum: subsonicApi.getAlbum,
  getSong: (String id) async {
    var queryParameters = {
      '_end': 15,
      '_order': 'ASC',
      '_sort': 'id',
      '_start': 0,
      'id': id
    };

    try {
      var response = await _dio.get('song', queryParameters: queryParameters);
      var data = response.data;
      if (data != null) {
        var song = data[0];
        String stream = getServerInfo("stream");
        String url = getCoverArt(song["id"], size: 800);

        NdSong ndSong = NdSong.fromJson(song);

        Songs songs = Songs.fromNdSong(ndSong);
        songs.coverUrl = url;
        songs.stream = '$stream&id=${song["id"]}';
        return songs;
      }
    } catch (e) {
      print(e);
    }
    return null;
  },
  createPlaylist: subsonicApi.createPlaylist,
  deletePlaylist: subsonicApi.deletePlaylist,
  getPlaylists: subsonicApi.getPlaylists,
  getPlaylist: subsonicApi.getPlaylist,
  getAlbumList: subsonicApi.getAlbumList,
  getSongs: subsonicApi.getSongs,
);

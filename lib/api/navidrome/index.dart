// ignore_for_file: avoid_print

import 'package:dio/dio.dart';
import 'package:get/get.dart' hide Response;
import 'package:musify/api/subsonic/index.dart';
import 'package:musify/dao/server_info_repository.dart';
import 'package:musify/models/navidrome/nd_song.dart';
import 'package:musify/models/songs.dart';
import 'package:musify/services/server_service.dart';
import '../../util/request/mock_inter.dart';
import '../subsonic/utils.dart';
import '../types.dart';

Function(RequestOptions, RequestInterceptorHandler) onRequest =
    (RequestOptions options, RequestInterceptorHandler handler) {
  // 如果你想完成请求并返回一些自定义数据，你可以使用 `handler.resolve(response)`。
  // 如果你想终止请求并触发一个错误，你可以使用 `handler.reject(error)`。
  var serverInfo = Get.find<ServerService>().serverInfo.value;
  options.baseUrl = serverInfo.baseurl;

  // 添加rest api路径
  options.path = '/api/${options.path}';

  Map<String, dynamic> query = {};

  options.queryParameters = options.queryParameters;
  options.queryParameters.addAll(query);

  // 携带token
  var ndCredential = serverInfo.ndCredential;
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
    var serverInfo = Get.find<ServerService>().serverInfo.value;
    // 静默刷新token
    if (error.response?.statusCode == 401 &&
        serverInfo.ndCredential.isNotEmpty) {
      var auth = await navidromeApi.authenticate(
        serverInfo.baseurl,
        serverInfo.username,
        serverInfo.password,
      );
      var serverService = Get.find<ServerService>();

      serverInfo.ndCredential = auth['credential'];

      serverService.updateCurrentServerInfo(serverInfo);
      await ServerInfoRepository().updateServerInfo(serverInfo);

      var option = error.requestOptions;
      var headers = error.requestOptions.headers;
      headers['x-nd-authorization'] = 'Bearer ${serverInfo.ndCredential}';
      // retry request
      var response = await Dio().request(
        serverInfo.baseurl + option.path,
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
      var response = await _dio.get('song', queryParameters: queryParameters);
      var data = response.data;
      if (data != null) {
        var song = data[0];

        NdSong ndSong = NdSong.fromJson(song);
        Songs songs = Songs.fromNdSong(ndSong);
        songs.coverUrl = getCoverArt(song["id"], size: 800);
        songs.stream = getSongStream(song["id"]);
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
  getAlbum: subsonicApi.getAlbum,
  getSongs: subsonicApi.getSongs,
  getGenres: subsonicApi.getGenres,
  addStar: subsonicApi.addStar,
  removeStar: subsonicApi.removeStar,
);

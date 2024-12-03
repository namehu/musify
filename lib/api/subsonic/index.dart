import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart' hide Response;
import 'package:musify/constant.dart';
import 'package:musify/enums/album_list_type_enum.dart';
import 'package:musify/enums/star_type_enum.dart';
import 'package:musify/models/play_list.dart';
import 'package:musify/models/songs.dart';
import 'package:musify/services/server_service.dart';
import 'package:musify/util/util.dart';
import '../../models/genres.dart';
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
    options.path = '/rest/${options.path}';

    options.queryParameters = options.queryParameters;
    var query = joniAuthQuery();
    options.queryParameters.addAll(query);

    return handler.next(options);
  },
  onResponse: onResponse,
  onError: (DioException error, ErrorInterceptorHandler handler) {
    // 如果你想完成请求并返回一些自定义数据，你可以使用 `handler.resolve(response)`。
    logger.e('------------reuqest subsonic error---------');
    logger.e(error.message);
    return handler.next(error);
  },
);

Dio _dio = Dio(BaseOptions(responseType: ResponseType.json))
  ..interceptors.add(subsonicInterceptor)
  ..interceptors.add(MyMockInterceptor());

_checkResponse(Response<dynamic> response) {
  if (response.statusCode == 200) {
    if (response.data['subsonic-response'] != null) {
      Map subsonic = response.data['subsonic-response'];
      String status = subsonic['status'];
      if (status == 'ok') {
        return subsonic;
      }
    }
  }
  return null;
}

MusicApi subsonicApi = (
  authenticate: (String baseUrl, String username, String password) async {
    Map<String, dynamic> res = {};

    var response = await Dio().get(
      '$baseUrl/rest/ping?v=$version&c=musify&f=json&u=$username&p=$password',
    );
    var subsonic = _checkResponse(response);
    if (subsonic != null) {
      final salt = generateRandomString();
      final randomBytes = utf8.encode(password + salt);
      final hash = md5.convert(randomBytes).toString();

      res['userId'] = '';
      res['username'] = username;
      res['salt'] = salt;
      res['hash'] = hash;
    }
    return res;
  },
  getSong: _getSong,
  createPlaylist: _createPlaylist,
  deletePlaylist: _deletePlaylist,
  getPlaylists: _getPlaylists,
  getPlaylist: _getPlaylist,
  getAlbumList: _getAlbumList,
  getAlbum: _getAlbum,
  getSongs: _getSongs,
  getGenres: _getGenres,
  addStar: _addStar,
  removeStar: _removeStar,
);

Future<Songs?> _getSong(String id) async {
  var response = await _dio.get('getSong', queryParameters: {'id': id});
  if (response.data == null) return null;

  Map<String, dynamic> song = response.data['song'];

  song["stream"] = getSongStream(song["id"]);
  song["coverUrl"] = getCoverArt(song["id"], size: 800);

  Songs songs = Songs.fromJson(song);
  return songs;
}

Future<dynamic> _createPlaylist(String name) async {
  var response =
      await _dio.get('createPlaylist', queryParameters: {"name": name});
  return response.data;
}

Future<dynamic> _deletePlaylist(String id) async {
  var response = await _dio.get('deletePlaylist', queryParameters: {"id": id});
  return response.data;
}

Future<List<Playlist>> _getPlaylists() async {
  var data = <Playlist>[];
  var response = await _dio.get('getPlaylists');
  Map playlists = response.data['playlists'];
  List playlist = playlists['playlist'];

  for (var element in playlist) {
    element["imageUrl"] = getCoverArt(element['id']);
    Playlist playlist = Playlist.fromJson(element);
    data.add(playlist);
  }
  return data;
}

Future<Playlist?> _getPlaylist(String id) async {
  Playlist? playList;

  var response = await _dio.get('getPlaylist', queryParameters: {"id": id});
  var playlisttem = response.data['playlist'];

  if (playlisttem != null) {
    playlisttem["imageUrl"] = getCoverArt(playlisttem['id']);
    playList = Playlist.fromJson(playlisttem);

    List<Songs> temsong = [];

    if (playlisttem["entry"] != null && playlisttem["entry"].length > 0) {
      for (var el in playlisttem["entry"]) {
        el["stream"] = getSongStream(el["id"]);
        el["coverUrl"] = getCoverArt(el["id"]);
        Songs song = Songs.fromJson(el);
        temsong.add(song);
      }
    }

    playList.songs = temsong;
  }

  return playList;
}

Future<List<Albums>> _getAlbumList({
  int pageNum = 1,
  int? pageSize = 10,
  AlbumListTypeEnum? type = AlbumListTypeEnum.recent,
}) async {
  var offset = (pageNum - 1) * pageSize!;
  var response = await _dio.get('getAlbumList2', queryParameters: {
    "size": pageSize,
    "offset": offset,
    'type': type!.value
  });

  Map albumList = response.data['albumList2'];
  List albums = albumList['album'] ?? [];

  List<Albums> list = [];
  if (albums.isNotEmpty) {
    for (var el in albums) {
      el["coverUrl"] = getCoverArt(el["id"]);
      Albums album = Albums.fromJson(el);
      list.add(album);
    }
  }
  return list;
}

Future<Albums?> _getAlbum(String id) async {
  var response = await _dio.get('getAlbum', queryParameters: {'id': id});

  if (response.data == null || response.data['album'] == null) return null;

  final albumRes = response.data['album'];
  albumRes["coverUrl"] = getCoverArt(albumRes["id"]);
  albumRes["title"] = albumRes["name"];
  Albums albumsData = Albums.fromJson(albumRes);

  return albumsData;
}

Future<List<Songs>> _getSongs({
  int pageNum = 1,
  int? pageSize = 50,
  String? query = '',
}) async {
  List<Songs> list = [];

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
    List<dynamic> songs = response.data['searchResult3']['song'] ?? [];
    for (var el in songs) {
      el["stream"] = getSongStream(el["id"]);
      el["coverUrl"] = getCoverArt(el["id"]);
      list.add(Songs.fromJson(el));
    }
  }

  return list;
}

Future<List<Genres>> _getGenres() async {
  var response = await _dio.get('getGenres');

  List<Genres> genresList = [];
  if (response.data != null && response.data['genres'] != null) {
    List genreData = response.data['genres']["genre"] ?? [];
    if (genreData.isNotEmpty) {
      for (var element in genreData) {
        Genres genresItem = Genres.fromJson(element);
        genresList.add(genresItem);
      }
    }
  }
  return genresList;
}

Future<dynamic> _addStar(String id, StarTypeEnum type) async {
  var queryParameters = <String, String>{};
  switch (type) {
    case StarTypeEnum.album:
      queryParameters.addAll({'albumId': id});
      break;
    case StarTypeEnum.artist:
      queryParameters.addAll({'artistId': id});
      break;
    default:
      queryParameters.addAll({'id': id});
  }

  var response = await _dio.get('star', queryParameters: queryParameters);
  return response.data;
}

Future<dynamic> _removeStar(String id, StarTypeEnum type) async {
  var queryParameters = <String, String>{};
  switch (type) {
    case StarTypeEnum.album:
      queryParameters.addAll({'albumId': id});
      break;
    case StarTypeEnum.artist:
      queryParameters.addAll({'artistId': id});
      break;
    default:
      queryParameters.addAll({'id': id});
  }

  var response = await _dio.get('unstar', queryParameters: queryParameters);
  return response.data;
}

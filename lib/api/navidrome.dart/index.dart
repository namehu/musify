import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:musify/models/notifierValue.dart';

import '../types.dart';

MusicApi navidromeApi = (
  authenticate: authenticate,
  getSong: 'https://api.music.163.com/api/linux/forward',
);

Interceptor navidromeInterceptor = InterceptorsWrapper(
  onRequest: (RequestOptions options, RequestInterceptorHandler handler) {
    // 如果你想完成请求并返回一些自定义数据，你可以使用 `handler.resolve(response)`。
    // 如果你想终止请求并触发一个错误，你可以使用 `handler.reject(error)`。

    options.baseUrl = serversInfo.value.baseurl;
    options.responseType = ResponseType.json;

    var _ndCredential = serversInfo.value.ndCredential;
    if (_ndCredential.isNotEmpty) {
      options.headers['token'] = 'Bearer $_ndCredential';
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

checkResponse(Response<dynamic> response) {
  if (response.statusCode == 200) {
    if (response.data != null) {
      Map _subsonic = response.data;
      if (response.statusMessage == 'OK') {
        return _subsonic;
      }
    }
  }
  return null;
}

Future<Map<String, dynamic>> authenticate(
    String _baseUrl, String username, String password) async {
  Map<String, dynamic> res = {};

  try {
    var _response = await Dio().post(_baseUrl + '/auth/login', data: {
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
}

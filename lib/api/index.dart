import 'package:dio/dio.dart';
import 'package:musify/models/notifierValue.dart';
import 'package:musify/util/httpclient.dart';
import 'package:musify/util/request/mock_inter.dart';

class MRequest {
  static Dio? _dio;

  static Dio get dio {
    if (_dio == null) {
      _dio = Dio();
      // 自定义拦截器
      dio.interceptors.add(
        InterceptorsWrapper(
          onRequest:
              (RequestOptions options, RequestInterceptorHandler handler) {
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
        ),
      );

      // 添加mock拦截器
      dio.interceptors.add(MyMockInterceptor());
    }
    return _dio!;
  }

  static MusicApi get api => api;
}

typedef MusicApi = ({
  Future<bool> Function(
      String _baseUrl, String _username, String _password) authenticate,
  String getSong,
});

MusicApi api = (
  authenticate: testServer,
  getSong: 'https://api.music.163.com/api/linux/forward',
);

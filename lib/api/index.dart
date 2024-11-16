import 'package:dio/dio.dart';
import 'package:musify/api/navidrome.dart/index.dart';
import 'package:musify/api/subsonic/index.dart';
import 'package:musify/enums/serve_type_enum.dart';
import 'package:musify/models/notifierValue.dart';
import 'package:musify/util/request/mock_inter.dart';
import 'types.dart';

class MRequest {
  // static String? _sverType;
  static Dio? _dio;
  static MusicApi _api = resetApi();

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

  // static String get currentServerType {
  //   if (_sverType == null) {
  //     _sverType =
  //         PreferencesService.getString(PreferencesEnum.serverType, 'subsonic');
  //   }
  //   return _sverType!;
  // }

  // static set currentServerType(String? val) {
  //   _sverType = val;
  //   if (val != null) {
  //     PreferencesService.setString(PreferencesEnum.serverType, val);
  //   } else {
  //     PreferencesService.remove(PreferencesEnum.serverType);
  //   }
  // }

  static MusicApi get api => _api;

  static setApi(ServeTypeEnum serverType) {
    switch (serverType) {
      case ServeTypeEnum.navidrome:
        _api = navidromeApi;
        break;
      default:
        _api = subsonicApi;
        break;
    }
  }

  static resetApi() {
    _api = subsonicApi;
  }
}

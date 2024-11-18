import 'package:dio/dio.dart';
import 'package:musify/api/navidrome/index.dart';
import 'package:musify/api/subsonic/index.dart';
import 'package:musify/enums/serve_type_enum.dart';
import 'package:musify/util/request/mock_inter.dart';
import 'types.dart';

class MRequest {
  static Dio? _dio;
  static MusicApi _api = subsonicApi;

  static Dio get dio {
    if (_dio == null) {
      _dio = Dio();
      dio.interceptors.add(subsonicInterceptor);
      // 添加mock拦截器
      dio.interceptors.add(MyMockInterceptor());
    }
    return _dio!;
  }

  static MusicApi get api => _api;

  static setApi(ServeTypeEnum serverType) {
    dio.interceptors.clear();
    dio.interceptors.add(MyMockInterceptor());

    switch (serverType) {
      case ServeTypeEnum.navidrome:
        _api = navidromeApi;
        dio.interceptors.add(navidromeInterceptor);
        break;
      default:
        _api = subsonicApi;
        dio.interceptors.add(subsonicInterceptor);
        break;
    }
  }

  static resetApi() {
    setApi(ServeTypeEnum.subsnoic);
  }
}

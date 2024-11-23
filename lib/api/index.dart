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
      var option = BaseOptions(
        responseType: ResponseType.json,
      );
      _dio = Dio(option);
      dio.interceptors.add(subsonicInterceptor);

      dio.interceptors.add(MyMockInterceptor()); // 添加mock拦截器
    }
    return _dio!;
  }

  static MusicApi get api => _api;

  static setApi(ServeTypeEnum serverType) {
    dio.interceptors.clear();

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

    dio.interceptors.add(MyMockInterceptor());
  }

  static resetApi() {
    setApi(ServeTypeEnum.subsnoic);
  }
}

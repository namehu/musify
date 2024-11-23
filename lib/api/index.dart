import 'package:musify/api/navidrome/index.dart';
import 'package:musify/api/subsonic/index.dart';
import 'package:musify/enums/serve_type_enum.dart';
import 'types.dart';

class MRequest {
  static MusicApi _api = subsonicApi;

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
    setApi(ServeTypeEnum.subsnoic);
  }
}

import 'package:get/get.dart';
import 'package:musify/models/myModel.dart';
import 'package:musify/util/httpClient.dart';

class ArtistsController extends GetxController {
  RxList<Artists> artists = <Artists>[].obs;
  RxList<bool> star = <bool>[].obs;
  int artistsnum = 0;

  _getArtists() async {
    final _artistsList = await getArtists();
    if (_artistsList != null) {
      List<Artists> _list = [];
      List<bool> _startem = [];
      for (var _element in _artistsList["index"]) {
        var _temp = _element["artist"];
        for (var element in _temp) {
          String _url = getCoverArt(element["id"]);
          element["artistImageUrl"] = _url;
          if (element["starred"] != null) {
            _startem.add(true);
          } else {
            _startem.add(false);
          }
          Artists _artist = Artists.fromJson(element);
          _list.add(_artist);
        }
      }

      artists(_list);
      star(_startem);
    }
  }

  @override
  void onInit() async {
    super.onInit();

    _getArtists();
  }
}

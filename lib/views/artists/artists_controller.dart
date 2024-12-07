import 'package:get/get.dart';
import 'package:musify/models/myModel.dart';
import 'package:musify/services/star_service.dart';
import '../../util/httpclient.dart';

class ArtistsController extends GetxController {
  final StarService starService = Get.find<StarService>();

  RxList<Artists> artists = <Artists>[].obs;
  RxList<bool> star = <bool>[].obs;
  int artistsnum = 0;

  _getArtists() async {
    final artistsList = await getArtists();
    if (artistsList != null) {
      List<Artists> list = [];
      List<bool> startem = [];
      for (var element in artistsList["index"]) {
        var temp = element["artist"];
        for (var element in temp) {
          String url = getCoverArt(element["id"]);
          element["artistImageUrl"] = url;
          if (element["starred"] != null) {
            startem.add(true);
          } else {
            startem.add(false);
          }
          Artists artist = Artists.fromJson(element);
          list.add(artist);
        }
      }

      artists(list);
      star(startem);
    }
  }

  @override
  void onInit() async {
    super.onInit();

    _getArtists();
  }
}

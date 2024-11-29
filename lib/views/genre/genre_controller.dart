import 'package:get/get.dart';
import 'package:musify/models/myModel.dart';
import 'package:musify/util/httpClient.dart';

class GenreController extends GetxController {
  RxList<Genres> genres = <Genres>[].obs;

  String get genresnum => genres.isNotEmpty ? '(${genres.length})' : '';

  @override
  void onInit() {
    super.onInit();
    _getGenres();
  }

  _getGenres() async {
    final genresListRes = await getGenres();

    if (genresListRes != null) {
      List<Genres> genreslist = [];
      for (var element in genresListRes) {
        Genres genresItem = Genres.fromJson(element);
        genreslist.add(genresItem);
      }
      genres(genreslist);
    }
  }
}

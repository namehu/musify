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
    final _genresList = await getGenres();

    if (_genresList != null) {
      List<Genres> _genreslist = [];
      for (var element in _genresList) {
        Genres _genres = Genres.fromJson(element);
        _genreslist.add(_genres);
      }
      genres(_genreslist);
    }
  }
}

import 'package:get/get.dart';
import 'package:musify/api/index.dart';
import 'package:musify/models/genres.dart';

class GenreController extends GetxController {
  RxList<Genres> genres = <Genres>[].obs;

  String get genresnum => genres.isNotEmpty ? '(${genres.length})' : '';

  @override
  void onInit() {
    super.onInit();
    _getGenres();
  }

  _getGenres() async {
    final genresListRes = await MRequest.api.getGenres();
    genres(genresListRes);
  }
}

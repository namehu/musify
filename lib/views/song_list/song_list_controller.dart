import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:musify/api/index.dart';
import 'package:musify/models/songs.dart';

class SongListController extends GetxController {
  static const _pageSize = 100;
  RxList<Songs> songs = <Songs>[].obs;

  final PagingController<int, Songs> pagingController =
      PagingController(firstPageKey: 0);

  @override
  void onInit() {
    super.onInit();

    pagingController.addPageRequestListener((pageKey) {
      _getSongs(pageKey);
    });
  }

  @override
  void onClose() {
    pagingController.dispose();
    super.onClose();
  }

  _getSongs(int pageKey) async {
    var pageNum = ((pageKey / _pageSize) + 1).toInt();
    List<Songs> _list = await MRequest.api.getSongs(
      pageSize: _pageSize,
      pageNum: pageNum,
    );

    final isLastPage = _list.length < _pageSize;
    if (isLastPage) {
      pagingController.appendLastPage(_list);
    } else {
      final nextPageKey = pageKey + _list.length;
      pagingController.appendPage(_list, nextPageKey);
    }
  }
}

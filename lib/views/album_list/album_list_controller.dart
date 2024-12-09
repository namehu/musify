import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:musify/api/index.dart';
import 'package:musify/enums/album_list_type_enum.dart';
import 'package:musify/models/myModel.dart';
import '../../generated/l10n.dart';

class AlbumListController extends GetxController {
  static const _pageSize = 100;

  var selectOrder = AlbumListTypeEnum.recent.obs;

  var sortOrderList = [
    [AlbumListTypeEnum.random, S.current.random], // 随机
    [AlbumListTypeEnum.newest, S.current.last + S.current.add], // 最新
    [AlbumListTypeEnum.recent, S.current.last + S.current.play], // 最近
    [AlbumListTypeEnum.frequent, S.current.most + S.current.play], // 最多
    [AlbumListTypeEnum.starred, S.current.most + S.current.favorite], // 收藏
  ];

  final PagingController<int, Albums> pagingController =
      PagingController(firstPageKey: 0);

  @override
  void onInit() async {
    super.onInit();

    pagingController.addPageRequestListener((pageKey) {
      _getAllAlbums(pageKey);
    });

    ever(selectOrder, (va) {
      pagingController.refresh();
    });
  }

  @override
  void onClose() {
    pagingController.dispose();
    super.onClose();
  }

  _getAllAlbums(int pageKey) async {
    var pageNum = ((pageKey / _pageSize) + 1).toInt();
    List<Albums> albumList = await MRequest.api.getAlbumList(
        pageSize: _pageSize, pageNum: pageNum, type: selectOrder.value);

    final isLastPage = albumList.length < _pageSize;
    if (isLastPage) {
      pagingController.appendLastPage(albumList);
    } else {
      final nextPageKey = pageKey + albumList.length;
      pagingController.appendPage(albumList, nextPageKey);
    }
  }
}

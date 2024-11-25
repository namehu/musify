import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:musify/models/myModel.dart';

import '../../generated/l10n.dart';
import '../../util/httpClient.dart';

class AlbumListController extends GetxController {
  static const _pageSize = 100;
  RxList<Albums> albums = <Albums>[].obs;

  RxString selectOrder = 'random'.obs;
  List<DropdownMenuItem<String>> sortOrder = [];

  final PagingController<int, Albums> pagingController =
      PagingController(firstPageKey: 0);

  @override
  void onInit() async {
    _setSortOrder();
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

  _setSortOrder() {
    List<DropdownMenuItem<String>> _sortOrder = [];
    var data = [
      ['random', S.current.random], // 随机
      ['newest', S.current.last + S.current.add], // 最新
      ['recent', S.current.last + S.current.play], // 最近
      ['frequent', S.current.most + S.current.play], // 最多
      ['starred', S.current.most + S.current.favorite], // 收藏
    ];
    data.forEach((e) {
      _sortOrder.add(DropdownMenuItem(value: e[0], child: Text(e[1])));
    });
    sortOrder = _sortOrder;
  }

  _getAllAlbums(int pageKey) async {
    var _albumsList =
        await getAlbumList(selectOrder.value, "", pageKey, _pageSize);

    List<Albums> _list = [];
    if (_albumsList != null && _albumsList.length > 0) {
      for (var _element in _albumsList) {
        String _url = getCoverArt(_element["id"]);
        _element["coverUrl"] = _url;
        Albums _album = Albums.fromJson(_element);

        _list.add(_album);
      }
    }

    final isLastPage = _albumsList.length < _pageSize;
    if (isLastPage) {
      pagingController.appendLastPage(_list);
    } else {
      final nextPageKey = pageKey + _list.length;
      pagingController.appendPage(_list, nextPageKey);
    }
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:musify/models/myModel.dart';

import '../../util/httpClient.dart';

class AlbumListController extends GetxController {
  RxList<Albums> albums = <Albums>[].obs;

  List<DropdownMenuItem<String>> sortOrder = [];

  static const _pageSize = 20;

  final PagingController<int, Albums> pagingController =
      PagingController(firstPageKey: 0);

  @override
  void onInit() async {
    super.onInit();

    pagingController.addPageRequestListener((pageKey) {
      _getAllAlbums(pageKey);
    });
  }

  @override
  void onClose() {
    pagingController.dispose();
    super.onClose();
  }

  _getAllAlbums(int pageKey) async {
    final _albumsList;
    // if (_selectOrder != null && _selectOrder == "random" ||
    //     _selectOrder == "newest" ||
    //     _selectOrder == "recent" ||
    //     _selectOrder == "frequent") {
    // } else {
    //   _albumsList = await getAlbumList(
    //       "byGenre", _selectOrder!.replaceAll("&", "%26"), _offset, _size);
    // }

    _albumsList = await getAlbumList('recent', "", pageKey, _pageSize);

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

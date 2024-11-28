import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:musify/api/index.dart';
import 'package:musify/models/songs.dart';
import 'package:musify/services/audio_player_service.dart';

class SongListController extends GetxController {
  AudioPlayerService audioPlayerService = Get.find<AudioPlayerService>();
  ScrollController scrollController = ScrollController();

  static const _pageSize = 500;
  RxBool showTitle = false.obs;

  final PagingController<int, Songs> pagingController =
      PagingController(firstPageKey: 0);

  @override
  void onInit() {
    super.onInit();

    pagingController.addPageRequestListener((pageKey) {
      _getSongs(pageKey);
    });

    scrollController.addListener(() {
      showTitle(scrollController.offset > 150);
    });
  }

  @override
  void onClose() {
    pagingController.dispose();
    super.onClose();
  }

  playSong([int? index = 0]) {
    var songs = pagingController.itemList ?? [];
    audioPlayerService.palySongList(songs, index: index);
  }

  _getSongs(int pageKey) async {
    var pageNum = ((pageKey / _pageSize) + 1).toInt();
    List<Songs> list = await MRequest.api.getSongs(
      pageSize: _pageSize,
      pageNum: pageNum,
    );

    final isLastPage = list.length >= _pageSize;
    if (isLastPage) {
      pagingController.appendLastPage(list);
    } else {
      final nextPageKey = pageKey + list.length;
      pagingController.appendPage(list, nextPageKey);
    }
  }
}

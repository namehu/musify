import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:musify/api/index.dart';
import 'package:musify/enums/album_list_type_enum.dart';
import 'package:musify/models/myModel.dart';
import 'package:musify/models/play_list.dart';
import 'package:musify/routes/pages.dart';
import 'package:musify/services/language_service.dart';
import 'package:musify/services/music_bar_service.dart';
import 'package:musify/services/server_service.dart';
import 'package:musify/util/mycss.dart';

import '../../services/play_list_service.dart';

class HomeController extends GetxController
    with GetSingleTickerProviderStateMixin {
  final serverService = Get.find<ServerService>();
  final languageService = Get.find<LanguageService>();
  PlayListService playListService = Get.find<PlayListService>();

  late TabController tabController;
  List<Widget> tabs = [
    Icon(Icons.search),
    Icon(Icons.music_note),
  ];

  RxList<Playlist> get playList => playListService.playList;
  RxList<Albums> randomalbums = <Albums>[].obs;
  RxList<Albums> lastalbums = <Albums>[].obs;
  RxList<Albums> mostalbums = <Albums>[].obs;
  RxList<Albums> recentalbums = <Albums>[].obs;

  bool _initedTabAlbums = false;

  get hasServer => serverService.serverInfo.value.baseurl.isNotEmpty;

  String get serverTypeString => serverService.serverInfo.value.serverType;

  @override
  void onInit() {
    super.onInit();

    tabController =
        TabController(vsync: this, length: tabs.length, initialIndex: 1);

    languageService.loadLanguage(languageService.languageCode.value); // 加载国际化
  }

  @override
  void onReady() {
    super.onReady();

    MusicBarService.show();

    if (!hasServer) {
      Get.toNamed(Routes.LOGIN);
      return;
    } else {
      initState();
    }
  }

  @override
  void onClose() {
    tabController.dispose();
    super.onClose();
  }

  initState() {
    playListService.getPlayList();

    if (isMobile) {
      tabController.addListener(() {
        if (tabController.index == 0 && !_initedTabAlbums) {
          getAllAlbums();
        }
      });
    } else {
      getAllAlbums();
    }
  }

  getAllAlbums() {
    _initedTabAlbums = true;
    getAlbuoms(AlbumListTypeEnum.random);
    getAlbuoms(AlbumListTypeEnum.frequent);
    getAlbuoms(AlbumListTypeEnum.newest);
    getAlbuoms(AlbumListTypeEnum.recent);
  }

  getAlbuoms(AlbumListTypeEnum type) async {
    List<Albums> list =
        await MRequest.api.getAlbumList(pageNum: 1, pageSize: 10, type: type);
    if (list.isNotEmpty) {
      switch (type) {
        case AlbumListTypeEnum.random:
          randomalbums(list);
          break;
        case AlbumListTypeEnum.frequent:
          mostalbums(list);
          break;
        case AlbumListTypeEnum.newest:
          lastalbums(list);
          break;
        case AlbumListTypeEnum.recent:
          recentalbums(list);
          break;
        default:
      }
    }
  }
}

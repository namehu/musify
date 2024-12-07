import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:musify/generated/l10n.dart';
import 'package:musify/models/songs.dart';
import 'package:musify/routes/pages.dart';
import 'package:musify/services/audio_player_service.dart';
import 'package:musify/util/mycss.dart';

class PlayController extends GetxController
    with GetSingleTickerProviderStateMixin {
  final AudioPlayerService audioPlayerService = Get.find<AudioPlayerService>();

  late final TabController tabController;

  List<String> get tabs => [S.current.song, S.current.lyric];

  Songs get currentSong => audioPlayerService.currentSong.value;

  @override
  void onInit() {
    super.onInit();

    tabController = TabController(
      length: tabs.length,
      vsync: this,
      initialIndex: 0,
    );
  }

  @override
  void onClose() {
    super.onClose();
    tabController.dispose();
  }

  navBack() {
    if (isMobile) {
      Get.back();
    } else {
      Navigator.of(Get.context!, rootNavigator: true).pop();
    }
  }

  navToAlubum() {
    if (currentSong.albumId.isNotEmpty) {
      navBack();
      Get.toNamed(Routes.ALBUM, arguments: {"id": currentSong.albumId});
    }
  }

  navToArtist() {
    if (currentSong.artistId.isNotEmpty) {
      navBack();
      Get.toNamed(
        Routes.ARTIST_DETAIL,
        arguments: {"id": currentSong.artistId},
      );
    }
  }
}

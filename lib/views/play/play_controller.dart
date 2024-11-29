import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:musify/generated/l10n.dart';
import 'package:musify/models/songs.dart';
import 'package:musify/services/audio_player_service.dart';

class PlayController extends GetxController
    with GetSingleTickerProviderStateMixin {
  final AudioPlayerService audioPlayerService = Get.find<AudioPlayerService>();

  final player = AudioPlayerService.player;

  late final TabController tabController;

  List<String> get tabs => [S.current.song, S.current.lyric];

  get positionDataStream => audioPlayerService.positionDataStream;

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
}

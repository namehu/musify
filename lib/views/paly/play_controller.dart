import 'package:flutter_lyric/lyric_ui/ui_netease.dart';
import 'package:get/get.dart';
import 'package:musify/services/audio_player_service.dart';

class PlayController extends GetxController {
  final player = AudioPlayerService.player;
  var lyricUI = UINetease();

  @override
  void onInit() {
    super.onInit();

    lyricUI.highlight = true;
  }
}

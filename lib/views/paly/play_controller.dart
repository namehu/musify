import 'package:get/get.dart';
import 'package:musify/services/audio_player_service.dart';
import 'package:musify/util/MUINetease.dart';

class PlayController extends GetxController {
  final player = AudioPlayerService.player;
  var lyricUI = MUINetease();

  @override
  void onInit() {
    super.onInit();

    lyricUI.highlight = true;
  }
}
